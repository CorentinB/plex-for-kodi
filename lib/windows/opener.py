from __future__ import absolute_import

import six
from plexnet import playqueue, plexapp, plexlibrary

from lib import util
from . import busy


_WATCHLIST_UNRESOLVED = object()


def _open_resolved_watchlist_item(obj, kwargs):
    from .mixins import watchlist

    next_kwargs = dict(kwargs)
    choose_source = next_kwargs.pop('choose_watchlist_source', False)
    sources = busy.widthDialog(
        watchlist.find_watchlist_sources,
        None,
        obj,
        delay=True,
    )
    if not sources:
        return _WATCHLIST_UNRESOLVED

    current_server = plexapp.SERVERMANAGER.selectedServer
    if choose_source:
        source = watchlist.prompt_watchlist_source(
            sources,
            next_kwargs.get('dialog_props'),
        )
        if source is None:
            return ''
    else:
        source = watchlist.select_preferred_source(
            sources,
            current_server and current_server.uuid,
        )

    metadata = source[1]
    try:
        server = plexapp.SERVERMANAGER.getServer(metadata["server_uuid"])
    except KeyError:
        server = None
    if server is None:
        return _WATCHLIST_UNRESOLVED

    next_kwargs.pop('from_watchlist', None)
    next_kwargs.pop('external_item', None)
    next_kwargs.pop('watchlist_entry', None)
    next_kwargs.pop('server', None)
    next_kwargs['is_watchlisted'] = True
    next_kwargs['directly_from_watchlist'] = True
    next_kwargs.setdefault('came_from', watchlist.GUIDToRatingKey(obj.guid))

    server_differs = current_server and server.uuid != current_server.uuid
    try:
        if server_differs:
            util.LOG("Temporarily changing server source to: {}", server.name)
            plexapp.util.APP.trigger('change:tempServer', server=server)
        return open(metadata["rating_key"], server=server, **next_kwargs)
    finally:
        if server_differs:
            util.LOG("Reverting to server source: {}", current_server.name)
            plexapp.util.APP.trigger('change:tempServer', server=current_server)


def open(obj, **kwargs):
    if (
        kwargs.get('from_watchlist', False)
        and kwargs.get('external_item', False)
        and kwargs.get('watchlist_entry', False)
    ):
        command = _open_resolved_watchlist_item(obj, kwargs)
        if command is not _WATCHLIST_UNRESOLVED:
            return command

    if isinstance(obj, playqueue.PlayQueue):
        if busy.widthDialog(obj.waitForInitialization, None):
            if obj.type == 'audio':
                from . import musicplayer
                return handleOpen(musicplayer.MusicPlayerWindow, track=obj.current(), playlist=obj)
            elif obj.type == 'photo':
                from . import photos
                return handleOpen(photos.PhotoWindow, play_queue=obj, **kwargs)
            else:
                from . import videoplayer
                videoplayer.play(play_queue=obj, **kwargs)
                return ''
    elif isinstance(obj, six.string_types):
        key = obj
        if not obj.startswith('/'):
            key = '/library/metadata/{0}'.format(obj)

        server = kwargs.pop("server", None) or plexapp.SERVERMANAGER.selectedServer
        return open(server.getObject(key), **kwargs)
    elif obj.TYPE == 'episode':
        return episodeClicked(obj, **kwargs)
    elif obj.TYPE == 'movie':
        return playableClicked(obj, **kwargs)
    elif obj.TYPE in ('show'):
        return showClicked(obj, **kwargs)
    elif obj.TYPE in ('artist'):
        return artistClicked(obj, **kwargs)
    elif obj.TYPE in ('season'):
        return seasonClicked(obj, **kwargs)
    elif obj.TYPE in ('album'):
        return albumClicked(obj, **kwargs)
    elif obj.TYPE in ('photo',):
        return photoClicked(obj, **kwargs)
    elif obj.TYPE in ('photodirectory'):
        return photoDirectoryClicked(obj, **kwargs)
    elif obj.TYPE in ('track'):
        album = obj.album()
        if album:
            return trackClicked(obj, album=album, **kwargs)
        return trackClicked(obj, **kwargs)
    elif obj.TYPE in ('playlist'):
        return playlistClicked(obj, **kwargs)
    elif obj.TYPE in ('clip'):
        from . import videoplayer
        return videoplayer.play(video=obj)
    elif obj.TYPE in ('collection'):
        return collectionClicked(obj, **kwargs)
    elif obj.TYPE in ('Genre'):
        return genreClicked(obj, **kwargs)
    elif obj.TYPE in ('Director'):
        return directorClicked(obj, **kwargs)
    elif obj.TYPE in ('Role'):
        return actorClicked(obj, **kwargs)


def handleOpen(winclass, **kwargs):
    w = None
    try:
        # we might just want the play preparation functionality of a window class to directly play an item or playlist
        # if so, we won't actually open the window, just instantiate it, as to not add it to the kodi window history
        autoPlay = kwargs.pop("auto_play", False)
        autoPlayOpen = kwargs.pop("auto_play_open", False)
        if autoPlay and winclass.supportsAutoPlay:
            # create but don't open window
            w = winclass.create(show=False, **kwargs)
            if autoPlayOpen and w.doAutoPlay(blind=not autoPlayOpen):
                # open window after autoPlay to be able to return to it after playback
                w.modal()
            else:
                # just autoPlay and don't open the window
                w.doAutoPlay()
                w.onBlindClose()
        else:
            w = winclass.open(**kwargs)
        return w.exitCommand or ''
    except AttributeError:
        pass
    except util.NoDataException:
        raise
    except:
        util.ERROR()
    finally:
        del w
        util.garbageCollect()

    return ''


def playableClicked(playable, **kwargs):
    from . import preplay
    if kwargs.get('from_watchlist', False):
        win = preplay.PrePlayWindowWL
    else:
        win = preplay.PrePlayWindow
    return handleOpen(win, video=playable, **kwargs)


def episodeClicked(episode, **kwargs):
    from . import episodes
    return handleOpen(episodes.EpisodesWindow, episode=episode, **kwargs)


def showClicked(show, **kwargs):
    from . import subitems
    return handleOpen(subitems.ShowWindow, media_item=show, **kwargs)


def artistClicked(artist, **kwargs):
    from . import subitems
    return handleOpen(subitems.ArtistWindow, media_item=artist, **kwargs)


def seasonClicked(season, **kwargs):
    from . import episodes
    return handleOpen(episodes.EpisodesWindow, season=season, **kwargs)


def albumClicked(album, **kwargs):
    from . import tracks
    return handleOpen(tracks.AlbumWindow, album=album, **kwargs)


def photoClicked(photo, **kwargs):
    from . import photos
    return handleOpen(photos.PhotoWindow, photo=photo, **kwargs)


def trackClicked(track, **kwargs):
    from . import musicplayer
    return handleOpen(musicplayer.MusicPlayerWindow, track=track, **kwargs)


def photoDirectoryClicked(photodirectory, **kwargs):
    return sectionClicked(photodirectory, **kwargs)


def playlistClicked(pl, **kwargs):
    from . import playlist
    return handleOpen(playlist.PlaylistWindow, playlist=pl, **kwargs)


def collectionClicked(collection, **kwargs):
    return sectionClicked(collection, **kwargs)


def sectionClicked(section, filter_=None, **kwargs):
    from . import library
    library.ITEM_TYPE = section.TYPE
    key = section.key
    if not key.isdigit():
        key = section.getLibrarySectionId()
    viewtype = util.getSetting('viewtype.{0}.{1}'.format(section.server.uuid, key))
    if section.TYPE in ('artist', 'photo', 'photodirectory'):
        default = library.VIEWS_SQUARE.get(viewtype)
        return handleOpen(
            library.LibraryWindow, windows=library.VIEWS_SQUARE.get('all'), default_window=default, section=section, filter_=filter_, **kwargs
        )
    else:
        default = library.VIEWS_POSTER.get(viewtype)
        return handleOpen(
            library.LibraryWindow, windows=library.VIEWS_POSTER.get('all'), default_window=default, section=section, filter_=filter_, **kwargs
        )


def genreClicked(genre, **kwargs):
    section = plexlibrary.LibrarySection.fromFilter(genre)
    filter_ = {'type': genre.FILTER, 'display': 'Genre', 'sub': {'val': genre.id, 'display': genre.tag}}
    return sectionClicked(section, filter_, **kwargs)


def directorClicked(director, **kwargs):
    from . import person as person_window
    return handleOpen(person_window.DirectorWindow, role=director, **kwargs)


def actorClicked(actor, **kwargs):
    from . import person as person_window
    return handleOpen(person_window.ActorWindow, role=actor, **kwargs)
