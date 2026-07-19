from __future__ import absolute_import

import os
import datetime

from plexnet.video import Episode, Movie, Clip

from lib import artwork
from lib import util
from lib.util import T
from . import kodigui
from . import search
from . import windowutils
from lib import seamless_branching


def split2len(s, n):
    def _f(s, n):
        while s:
            yield s[:n]
            s = s[n:]
    return list(_f(s, n))


class InfoWindow(kodigui.ControlledWindow, windowutils.UtilMixin):
    xmlFile = 'script-plex-info.xml'
    path = util.ADDON.getAddonInfo('path')
    theme = 'Main'
    res = '1080i'
    width = 1920
    height = 1080

    CLOSE_BUTTON_ID = 150
    HOME_BUTTON_ID = 201
    SEARCH_BUTTON_ID = 202
    PLAYER_STATUS_BUTTON_ID = 204

    THUMB_DIM_POSTER = util.scaleResolution(519, 469)
    THUMB_DIM_SQUARE = util.scaleResolution(519, 519)

    def __init__(self, *args, **kwargs):
        kodigui.ControlledWindow.__init__(self, *args, **kwargs)
        self.title = kwargs.get('title')
        self.subTitle = kwargs.get('sub_title')
        self.thumb = kwargs.get('thumb')
        self.thumb_opts = kwargs.get('thumb_opts', {})
        self.thumbFallback = kwargs.get('thumb_fallback')
        self.info = kwargs.get('info')
        self.background = kwargs.get('background')
        self.isSquare = kwargs.get('is_square')
        self.is16x9 = kwargs.get('is_16x9')
        self.isPoster = not (self.isSquare or self.is16x9)
        self.thumbDim = self.isSquare and self.THUMB_DIM_SQUARE or self.THUMB_DIM_POSTER
        self.video = kwargs.get('video')

    def getVideoInfo(self):
        """
        Append media/part/stream info to summary
        """
        if not isinstance(self.video, (Episode, Movie, Clip)):
            return self.info

        summary = [self.info or '']
        medias = self.video.media()
        if not medias:
            return self.info

        mediaCount = len(medias)
        onlyOneMedia = mediaCount == 1
        partCount = sum(len(m.parts) for m in medias)
        pcInfo = []
        if not onlyOneMedia:
            pcInfo.append("{}: {}".format(T(35045, 'Files'), mediaCount))
        if partCount > 1:
            pcInfo.append("{}: {}".format(T(35046, 'Parts'), partCount))
        pcInfoStr = " • ".join(pcInfo)

        addMedia = ["\n\n{}\n".format(pcInfoStr) if pcInfoStr else "\n\n"]
        for media_ in medias:
            if not media_.isAccessible():
                addMedia.append("{}: {}\n\n".format(
                    T(32312, 'Unavailable'),
                    ", ".join(os.path.basename(pf.file) for pf in media_.parts),
                ))
                continue

            for part in media_.parts:
                if not part:
                    addMedia.append("{}\n".format(T(32312, 'Unavailable')))
                    continue

                pmFolder = part.getPathMappedUrl(return_only_folder=True)
                addMedia.append("{}: ".format(T(35041, 'File')))
                splitFnAt = 74
                fnLen = len(os.path.basename(part.file))
                appended = False
                for s in split2len(os.path.basename(part.file), splitFnAt):
                    if fnLen > splitFnAt and not appended:
                        addMedia.append("{}\n".format(s))
                        appended = True
                        continue
                    addMedia.append("{}\n".format(s))
                if pmFolder:
                    addMedia.append("{}: {}\n".format(T(35044, 'Mapped via'), pmFolder))
                addMedia.append("{}: {}\n".format(T(35042, 'Added'), datetime.datetime.fromtimestamp(
                    self.video.addedAt.asFloat()).strftime("{} {}".format(util.shortDF, util.timeFormat))))
                addMedia.append("{}: {}, {}: {}\n".format(
                    T(32364, 'Duration'),
                    util.durationToShortText(int(part.duration)),
                    T(35043, 'Size'),
                    util.simpleSize(int(part.size)),
                ))

                subs = []
                subsOver = 0
                for stream in part.streams:
                    streamtype = stream.streamType.asInt()
                    # video
                    if streamtype == 1:
                        dovi = ""
                        if stream.DOVIPresent:
                            dovi = "Level: {}, Profile: {}, Version: {}, " \
                                   "BL: {}{}, EL: {}, RPU: {}".format(stream.DOVILevel,
                                                                      stream.DOVIProfile,
                                                                      stream.DOVIVersion,
                                                                      stream.DOVIBLPresent,
                                                                      stream.DOVIBLPresent and
                                                                      " (compat ID: {})".format(stream.DOVIBLCompatID)
                                                                      or "",
                                                                      stream.DOVIELPresent,
                                                                      stream.DOVIRPUPresent)
                        videoParts = [
                            "{} × {}".format(stream.width, stream.height),
                            stream.videoCodecRendering,
                            stream.codec.upper(),
                            "{}-bit".format(stream.bitDepth) if stream.bitDepth else '',
                            stream.chromaSubsampling,
                            stream.colorPrimaries,
                            "{} kbit/s".format(stream.bitrate) if stream.bitrate else '',
                            "{} fps".format(stream.frameRate) if stream.frameRate else '',
                        ]
                        addMedia.append("{}: {}{}\n".format(
                            T(32053, 'Video'),
                            " • ".join(str(value) for value in videoParts if value),
                            dovi and "\nDoVi: {}\n".format(dovi) or ""))
                    # audio
                    elif streamtype == 2:
                        imdb_id = seamless_branching.sbm.get_imdb_id(self.video)
                        is_sb = (seamless_branching.sbm.is_seamless_branching_movie(imdb_id, stream, force_detection=True)
                                 and " (SB!)" or "")
                        audioParts = [
                            "{}{}".format(
                                stream.language,
                                " ({})".format(T(35047, 'Default').lower()) if stream.default else "",
                            ),
                            stream.codec.upper(),
                            "{} ch".format(stream.channels) if stream.channels else '',
                            "{} kbit/s".format(stream.bitrate) if stream.bitrate else '',
                            "{} Hz".format(stream.samplingRate) if stream.samplingRate else '',
                        ]
                        addMedia.append("{}: {}{}\n".format(
                            T(32048, 'Audio'),
                            " • ".join(str(value) for value in audioParts if value),
                            is_sb))
                    # subtitle
                    elif streamtype == 3:
                        if len(subs) > 4:
                            subsOver += 1
                            continue
                        subs.append("{} ({})".format(stream.language, stream.codec.upper()))

                if subs:
                    addMedia.append("{}: {}{}\n".format(
                        T(32396, 'Subtitles'),
                        ", ".join(subs),
                        subsOver and " (+{})".format(subsOver) or '',
                    ))
            if not onlyOneMedia:
                addMedia.append("--------------\n")

        chapters = []
        chOver = 0
        for index, chapter in enumerate(self.video.chapters):
            if len(chapters) > 4:
                chOver += 1
                continue
            chapters.append(chapter.tag or "Chapter #{}".format(str(index+1)))

        if chapters:
            addMedia.append("{}: {}{}\n".format(
                T(33611, 'Chapters'),
                ", ".join(chapters),
                chOver and " (+{})".format(chOver) or '',
            ))

        if self.video.markers:
            addMedia.append("{}: {}".format(
                T(33612, 'Markers'),
                ", ".join(name for off, name in sorted(
                    (int(marker.startTimeOffset), marker.type) for marker in self.video.markers)),
            ))

        return "".join(summary + addMedia)

    def onFirstInit(self):
        self.setProperty('is.poster', self.isPoster and '1' or '')
        self.setProperty('is.square', self.isSquare and '1' or '')
        self.setProperty('is.16x9', self.is16x9 and '1' or '')
        self.setProperty('title.main', self.title or '')
        self.setProperty('title.sub', self.subTitle or '')
        self.setProperty('thumb.fallback', self.thumbFallback or '')

        thumb = ''
        if artwork.is_usable_art(self.thumb):
            try:
                thumb = self.thumb.asTranscodedImageURL(*self.thumbDim, **self.thumb_opts)
            except (AttributeError, TypeError):
                thumb = str(self.thumb)
        self.setProperty('thumb', thumb)

        summary = self.info or ''
        combinedInfo = self.getVideoInfo() or ''
        mediaInfo = ''
        if combinedInfo.startswith(summary):
            mediaInfo = combinedInfo[len(summary):].strip()
        elif not summary:
            mediaInfo = combinedInfo.strip()
        self.setProperty('info.summary', summary)
        self.setProperty('info.media', mediaInfo)
        self.setProperty('info', combinedInfo)
        self.setProperty('background', self.background or '')
        self.setFocusId(self.CLOSE_BUTTON_ID)

    def onClick(self, controlID):
        if controlID == self.CLOSE_BUTTON_ID:
            self.doClose()
        elif controlID == self.HOME_BUTTON_ID:
            self.goHome()
        elif controlID == self.SEARCH_BUTTON_ID:
            sectionID = self.video and self.video.getLibrarySectionId() or None
            self.processCommand(search.dialog(self, section_id=sectionID))
        elif controlID == self.PLAYER_STATUS_BUTTON_ID:
            self.showAudioPlayer()
