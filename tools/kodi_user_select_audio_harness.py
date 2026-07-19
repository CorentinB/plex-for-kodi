"""Open the production profile picker with its inert now-playing dock.

The caller supplies a local audio session so ``Player.HasAudio`` is true. The
harness itself never starts, pauses, stops, or advances playback and never
loads or changes a Plex account. It exists only for native rendering and
D-pad inspection of the production user-select XML.
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


HARNESS_PROPERTY = "codex.user_select_audio_harness"


class UserSelectAudioHarness(kodigui.BaseDialog):
    xmlFile = "script-plex-user_select.xml"
    path = util.ADDON.getAddonInfo("path")
    theme = "Main"
    res = "1080i"
    width = 1920
    height = 1080

    def _publish(self, state, focus=None):
        home = xbmcgui.Window(10000)
        home.setProperty(HARNESS_PROPERTY, state)
        if focus is not None:
            home.setProperty(HARNESS_PROPERTY + ".focus", str(focus))

    def onFirstInit(self):
        self._publish("open")
        xbmc.sleep(100)
        self.setFocusId(406)

    def onFocus(self, control_id):
        self._publish("open", control_id)

    def onClick(self, control_id):
        # Transport controls are deliberately inert in this harness.
        self._publish("open", control_id)

    def onClosed(self):
        home = xbmcgui.Window(10000)
        home.clearProperty(HARNESS_PROPERTY)
        home.clearProperty(HARNESS_PROPERTY + ".focus")


def main():
    home = xbmcgui.Window(10000)
    home.setProperty(HARNESS_PROPERTY, "starting")
    try:
        UserSelectAudioHarness.open(aggressive=True)
    except Exception:
        xbmc.log("script.plexmod: user-select audio harness failed", xbmc.LOGERROR)
        raise
    finally:
        home.clearProperty(HARNESS_PROPERTY)
        home.clearProperty(HARNESS_PROPERTY + ".focus")


if __name__ == "__main__":
    main()
