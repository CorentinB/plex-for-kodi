"""Open the production photo viewer with isolated local demo images.

The connected Plex account currently exposes video clips in its photo-library
sections, not photo items. This native Kodi QA harness therefore exercises the
real production WindowXML with local add-on artwork. It never talks to Plex,
starts a slideshow, sends a timeline, or begins media playback.
"""

from __future__ import absolute_import

import os
import sys


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from kodi_six import xbmc, xbmcaddon, xbmcgui, xbmcvfs  # noqa: E402
from PIL import Image  # noqa: E402


_kodi_addon = xbmcaddon.Addon
xbmcaddon.Addon = lambda addon_id=None: _kodi_addon(addon_id or "script.plexmod")

from lib.windows import kodigui  # noqa: E402


HARNESS_PROPERTY = "codex.photo_harness"
IMAGE_DIR = os.path.join(
    ROOT, "resources", "skins", "Main", "media", "script.plex", "sign_in"
)


def _image(name):
    return os.path.join(IMAGE_DIR, name)


def _cached_landscape_images(limit=12):
    """Prefer already-local Kodi art while keeping the harness portable."""
    root = xbmcvfs.translatePath("special://profile/Thumbnails")
    candidates = []
    for directory, _, names in os.walk(root):
        for name in names:
            if name.lower().endswith((".jpg", ".jpeg", ".png")):
                path = os.path.join(directory, name)
                try:
                    candidates.append((os.path.getmtime(path), path))
                except OSError:
                    continue

    images = []
    for _, path in sorted(candidates, reverse=True)[:400]:
        try:
            with Image.open(path) as image:
                width, height = image.size
        except (OSError, ValueError):
            continue
        if width >= 900 and width > height:
            images.append(path)
            if len(images) >= limit:
                break
    return images


def _requested_image():
    if len(sys.argv) < 2:
        return None
    path = sys.argv[1]
    if path.startswith("special://"):
        path = xbmcvfs.translatePath(path)
    return path if os.path.exists(path) else None


class DemoPhotoWindow(kodigui.BaseWindow):
    xmlFile = "script-plex-photo.xml"
    path = ROOT
    theme = "Main"
    res = "1080i"
    width = 1920
    height = 1080

    OVERLAY_BUTTON_ID = 250
    PQUEUE_LIST_ID = 500

    def onFirstInit(self):
        self.pqueueList = kodigui.ManagedControlList(self, self.PQUEUE_LIST_ID, 11)
        images = _cached_landscape_images()
        requested = _requested_image()
        if requested:
            images = [requested] + [path for path in images if path != requested]
        if not images:
            images = [_image(name) for name in (
                "pre-signin.jpg",
                "linking-account.jpg",
                "generating-code.jpg",
                "pin-display.jpg",
                "refresh-code.jpg",
                "back.jpg",
            )]
        while len(images) < 12:
            images.extend(images)
        images = images[:12]
        self.pqueueList.addItems(
            [
                kodigui.ManagedListItem(
                    "Photo {}".format(index + 1),
                    thumbnailImage=path,
                    data_source=index,
                )
                for index, path in enumerate(images)
            ]
        )
        self.pqueueList.selectItem(4)

        self.setProperty("dynamic_backgrounds", "1")
        self.setProperty("background", images[0])
        self.setProperty("photo", images[0])
        self.setProperty("photo.title", "Lumière d'été sur la côte")
        self.setProperty("photo.date", "18 juillet 2026")
        self.setProperty("camera.model", "Fujifilm X-T5")
        self.setProperty("camera.lens", "XF 23 mm F1.4 R LM WR")
        self.setProperty("photo.dims", "7728 × 5152  •  24.8 MB")
        self.setProperty("photo.container", "jpeg")
        self.setProperty("camera.settings", "ISO 125  •  f/2.8  •  1/640 s")
        self.setProperty(
            "photo.summary",
            "Une fin d'après-midi calme, entre lumière chaude et horizon brumeux.",
        )
        self.setProperty("OSD", "1")
        xbmcgui.Window(10000).setProperty(HARNESS_PROPERTY, "open")
        self.setFocusId(406)
        self._publishFocus(406)

    def _publishFocus(self, control_id):
        xbmcgui.Window(10000).setProperty(
            HARNESS_PROPERTY + ".focus", str(control_id)
        )

    def onFocus(self, controlID):
        self._publishFocus(controlID)

    def onAction(self, action):
        if action in (
            xbmcgui.ACTION_NAV_BACK,
            xbmcgui.ACTION_PREVIOUS_MENU,
            xbmcgui.ACTION_STOP,
        ):
            self.doClose()
            return
        kodigui.ControlledWindow.onAction(self, action)

    def onClick(self, controlID):
        # All production XML toggles remain active, while playback/rotation and
        # Plex queue mutations are intentionally inert in the visual harness.
        return

    def doClose(self, **kwargs):
        xbmcgui.Window(10000).clearProperty(HARNESS_PROPERTY)
        xbmcgui.Window(10000).clearProperty(HARNESS_PROPERTY + ".focus")
        kodigui.ControlledWindow.doClose(self)


def main():
    home = xbmcgui.Window(10000)
    home.setProperty(HARNESS_PROPERTY, "starting")
    try:
        DemoPhotoWindow.open(aggressive=True)
    except Exception:
        xbmc.log("script.plexmod: photo harness failed", xbmc.LOGERROR)
        raise
    finally:
        home.clearProperty(HARNESS_PROPERTY)


if __name__ == "__main__":
    main()
