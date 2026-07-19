"""Open the production seek overlay with inert marker or OSD controls.

The real skip-intro/credits action only exists during video playback. This
harness exercises the production WindowXML and its focus treatment over Home
without starting media, seeking, or changing Plex state. Passing ``osd`` shows
the complete transport shelf and focuses Play/Pause.
"""

from __future__ import absolute_import

import os
import sys


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from kodi_six import xbmc, xbmcaddon, xbmcgui


_kodi_addon = xbmcaddon.Addon
xbmcaddon.Addon = lambda addon_id=None: _kodi_addon(addon_id or "script.plexmod")

from lib import util  # noqa: E402
from lib.windows import kodigui  # noqa: E402


HARNESS_PROPERTY = "codex.seek_marker_harness"


class SeekMarkerHarness(kodigui.BaseDialog):
    xmlFile = "script-plex-seek_dialog.xml"
    path = util.ADDON.getAddonInfo("path")
    theme = "Main"
    res = "1080i"
    width = 1920
    height = 1080

    def __init__(self, *args, **kwargs):
        self.label = kwargs.pop("label", "")
        self.mode = kwargs.pop("mode", "marker")
        kodigui.BaseDialog.__init__(self, *args, **kwargs)

    def _publish(self, state, focus=None):
        home = xbmcgui.Window(10000)
        home.setProperty(HARNESS_PROPERTY, state)
        if focus is not None:
            home.setProperty(HARNESS_PROPERTY + ".focus", str(focus))

    def onFirstInit(self):
        self.setProperty("initialized", "1")
        if self.mode == "osd":
            self.setProperty("show.OSD", "1")
            self.setProperty("has.playlist", "1")
            self.setProperty("pq.hasprev", "1")
            self.setProperty("pq.hasnext", "1")
            for name in ("repeat", "shuffle", "prevnext", "ffwdrwd", "playlist", "vs10"):
                self.setProperty("nav." + name, "1")
            focus_id = 406
        else:
            self.setProperty("show.markerSkip", "1")
            self.setProperty("skipMarkerName", self.label)
            focus_id = 791
        self._publish("open")
        xbmc.sleep(100)
        self.setFocusId(focus_id)

    def onFocus(self, control_id):
        self._publish("open", control_id)

    def onClick(self, control_id):
        # The production button is deliberately inert in this harness.
        self._publish("open", control_id)

    def onClosed(self):
        home = xbmcgui.Window(10000)
        home.clearProperty(HARNESS_PROPERTY)
        home.clearProperty(HARNESS_PROPERTY + ".focus")


def main():
    home = xbmcgui.Window(10000)
    home.setProperty(HARNESS_PROPERTY, "starting")
    try:
        arguments = {argument.lower() for argument in sys.argv[1:]}
        mode = "osd" if "osd" in arguments else "marker"
        label = "Passer le générique (10)" if "credits" in arguments else "Passer l'intro"
        SeekMarkerHarness.open(label=label, mode=mode, aggressive=True)
    except Exception:
        xbmc.log("script.plexmod: seek marker harness failed", xbmc.LOGERROR)
        raise
    finally:
        home.clearProperty(HARNESS_PROPERTY)
        home.clearProperty(HARNESS_PROPERTY + ".focus")


if __name__ == "__main__":
    main()
