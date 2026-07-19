"""Open the real video-current-queue dialog with isolated local demo data.

This script is intended for native Kodi UI QA. Run it inside Kodi (for example
through the EventServer ``RunScript`` builtin); it never starts playback and
never talks to Plex, so screenshot and D-pad checks cannot alter watch history.
"""

from __future__ import absolute_import

import os
import sys


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from kodi_six import xbmc, xbmcaddon, xbmcgui  # noqa: E402


# Absolute-path RunScript invocations do not carry an add-on execution
# context, while production modules legitimately call xbmcaddon.Addon()
# without an id. Bind that implicit lookup to this add-on for the lifetime of
# the isolated harness interpreter.
_kodi_addon = xbmcaddon.Addon
xbmcaddon.Addon = lambda addon_id=None: _kodi_addon(addon_id or "script.plexmod")

from lib.windows.seekdialog import PlaylistDialog  # noqa: E402


HARNESS_PROPERTY = "codex.video_queue_harness"


class DemoPlaylistDialog(PlaylistDialog):
    def cacheSpoilerSettings(self):
        # A standalone RunScript interpreter does not inherit the main add-on's
        # parsed user-setting cache. Demo rows are movies, so episode spoiler
        # policy is irrelevant; initialize the mixin to its neutral state.
        self.spoilerSetting = []
        self.noTitles = False
        self.noRatings = False
        self.noImages = False
        self.noResumeImages = False
        self.noSummaries = False
        self.spoilersAllowedFor = False


class DemoValue(str):
    def asInt(self, default=0):
        return int(self or default)

    def asFloat(self, default=0):
        return float(self or default)


class DemoImage(object):
    def __init__(self, path):
        self.path = path

    def asTranscodedImageURL(self, width, height, **kwargs):
        return self.path


class DemoMovie(dict):
    type = "movie"

    def __init__(self, rating_key, title, year, duration, art, watched=False):
        duration_value = DemoValue(str(duration))
        super(DemoMovie, self).__init__(
            comment="{}:native-queue-harness".format(rating_key),
            duration=duration_value,
            viewCount=DemoValue("1" if watched else "0"),
            viewOffset=DemoValue("0"),
        )
        self.ratingKey = str(rating_key)
        self.title = title
        self.year = str(year)
        self.duration = duration_value
        self.viewCount = self["viewCount"]
        self.viewOffset = self["viewOffset"]
        self.art = DemoImage(art)
        self.isWatched = watched
        self.isFullyWatched = watched

    def set(self, key, value):
        if key in ("duration", "viewCount", "viewOffset"):
            value = DemoValue(str(value))
        self[key] = value
        setattr(self, key, value)


class DemoPlaylist(object):
    def __init__(self, items):
        self._items = items

    def items(self):
        return list(self._items)


class DemoVideo(object):
    def __init__(self, rating_key):
        self.ratingKey = str(rating_key)


class DemoPlayer(object):
    def __init__(self, playlist, current_index=2):
        self.playlist = playlist
        self.video = DemoVideo(playlist.items()[current_index].ratingKey)
        self._signals = {}

    def on(self, signal_name, callback):
        callbacks = self._signals.setdefault(signal_name, [])
        if callback not in callbacks:
            callbacks.append(callback)

    def off(self, signal_name, callback):
        callbacks = self._signals.get(signal_name, [])
        if callback in callbacks:
            callbacks.remove(callback)

    def _emit(self, signal_name, **kwargs):
        for callback in list(self._signals.get(signal_name, [])):
            callback(**kwargs)

    def trigger(self, signal_name, **kwargs):
        if signal_name == "action" and kwargs.get("action") == "playAt":
            item = self.playlist.items()[kwargs["pos"]]
            self.video.ratingKey = item.ratingKey
            self._emit("playlist.changed")
            return
        self._emit(signal_name, **kwargs)


class DemoHandler(object):
    def __init__(self, items, progress):
        self.playlist = DemoPlaylist(items)
        self.player = DemoPlayer(self.playlist)
        self._progress = progress

    def getProgressForItem(self, rating_key, default=None):
        return self._progress.get(str(rating_key), default)


def _demo_items():
    image_dir = os.path.join(ROOT, "resources", "skins", "Main", "media", "script.plex", "sign_in")
    definitions = (
        ("101", "L'Odyssée du Nord", 2024, 6_840_000, "pre-signin.jpg", False),
        ("102", "Les Jours tranquilles", 2023, 5_940_000, "linking-account.jpg", True),
        ("103", "Après l'orage", 2022, 7_260_000, "plexpass.jpg", False),
        ("104", "La Dernière Traversée", 2021, 6_420_000, "generating-code.jpg", False),
        ("105", "Un été à minuit", 2020, 5_700_000, "pin-display.jpg", True),
        ("106", "Le Secret des dunes", 2019, 6_060_000, "refresh-code.jpg", False),
        ("107", "L'Écho des montagnes", 2018, 6_660_000, "back.jpg", False),
        ("108", "Dernier arrêt", 2017, 5_520_000, "pre-signin.jpg", False),
    )
    return [
        DemoMovie(key, title, year, duration, os.path.join(image_dir, image), watched)
        for key, title, year, duration, image, watched in definitions
    ]


def main():
    home = xbmcgui.Window(10000)
    dialog = None
    home.setProperty(HARNESS_PROPERTY, "starting")
    try:
        items = _demo_items()
        handler = DemoHandler(items, {"101": 1_920_000, "103": 3_540_000, "106": 660_000})
        dialog = DemoPlaylistDialog.create(show=False, handler=handler, item_states={})
        home.setProperty(HARNESS_PROPERTY, "open")
        dialog.doModal()
    except Exception:
        xbmc.log("script.plexmod: video queue harness failed", xbmc.LOGERROR)
        raise
    finally:
        if dialog:
            dialog.doClose()
        home.clearProperty(HARNESS_PROPERTY)


if __name__ == "__main__":
    main()
