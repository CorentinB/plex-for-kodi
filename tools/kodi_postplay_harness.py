"""Open the production post-play window with isolated local demo data.

This native Kodi QA harness never starts playback and never talks to Plex. It
exists so the exact production XML can be inspected with screenshots and the
remote navigation graph can be exercised without changing watch history.
"""

from __future__ import absolute_import

import os
import sys


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from kodi_six import xbmc, xbmcaddon, xbmcgui  # noqa: E402


_kodi_addon = xbmcaddon.Addon
xbmcaddon.Addon = lambda addon_id=None: _kodi_addon(addon_id or "script.plexmod")

from lib.windows import kodigui  # noqa: E402
from lib.windows.videoplayer import VideoPlayerWindow  # noqa: E402


HARNESS_PROPERTY = "codex.postplay_harness"
FOCUS_PROPERTY = "codex.postplay_focus"
IMAGE_DIR = os.path.join(
    ROOT, "resources", "skins", "Main", "media", "script.plex", "sign_in"
)
BACKGROUND = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "media",
    "script.plex",
    "home",
    "background-fallback.png",
)


def _image(name):
    return os.path.join(IMAGE_DIR, name)


def _item(label, label2, image, fallback, progress=""):
    item = kodigui.ManagedListItem(
        label, label2, thumbnailImage=_image(image), data_source=None
    )
    item.setProperty("thumb.fallback", fallback)
    if progress:
        item.setProperty("progress", "script.plex/progress/{}.png".format(progress))
    return item


class DemoPostPlayWindow(VideoPlayerWindow):
    def cacheSpoilerSettings(self):
        self.spoilerSetting = []
        self.noTitles = False
        self.noRatings = False
        self.noImages = False
        self.noResumeImages = False
        self.noSummaries = False
        self.spoilersAllowedFor = False

    def onFirstInit(self):
        self.postPlayMode = True
        self.postPlayInitialized = True
        self.onDeckListControl = kodigui.ManagedControlList(
            self, self.ONDECK_LIST_ID, 4
        )
        self.relatedListControl = kodigui.ManagedControlList(
            self, self.RELATED_LIST_ID, 6
        )
        self.rolesListControl = kodigui.ManagedControlList(
            self, self.ROLES_LIST_ID, 7
        )

        self.setProperty("post.play", "1")
        self.setProperty("post.play.background", BACKGROUND)
        self.setProperty("thumb.fallback", "script.plex/thumb_fallbacks/movie16x9.png")
        self.setProperty("has.next", "1")
        self.setProperty("next.thumb", _image("pre-signin.jpg"))
        self.setProperty("next.title", "Les Jours tranquilles")
        self.setProperty("next.subtitle", "Saison 2  •  Épisode 6")
        self.setProperty("info.title", "Après l'orage")
        self.setProperty("info.duration", "48 min")
        self.setProperty(
            "info.summary",
            "Une dernière énigme rassemble l'équipe avant la traversée du nord.",
        )
        self.setProperty("info.date", "2026")
        self.setProperty("prev.thumb", _image("linking-account.jpg"))
        self.setProperty("prev.title", "Le Secret des dunes")
        self.setProperty("prev.subtitle", "Saison 2  •  Épisode 5")
        self.setProperty("related.header", "Dans le même esprit")

        on_deck = (
            ("L'Odyssée du Nord", "S2  •  E7", "pre-signin.jpg", "62"),
            ("La Dernière Traversée", "S1  •  E4", "linking-account.jpg", ""),
            ("Un été à minuit", "S3  •  E2", "generating-code.jpg", "38"),
            ("Dernier arrêt", "S1  •  E9", "pin-display.jpg", ""),
            ("Les Hautes Terres", "S2  •  E1", "refresh-code.jpg", ""),
        )
        self.onDeckListControl.addItems(
            [
                _item(
                    title,
                    subtitle,
                    image,
                    "script.plex/thumb_fallbacks/show.png",
                    progress,
                )
                for title, subtitle, image, progress in on_deck
            ]
        )

        related = (
            ("Le Passage", "2025", "pre-signin.jpg"),
            ("Après l'orage", "2024", "linking-account.jpg"),
            ("Minuit au nord", "2023", "plexpass.jpg"),
            ("Les Jours calmes", "2022", "generating-code.jpg"),
            ("La Ligne claire", "2021", "pin-display.jpg"),
            ("Dernière lumière", "2020", "refresh-code.jpg"),
            ("L'Écho des montagnes", "2019", "back.jpg"),
        )
        self.relatedListControl.addItems(
            [
                _item(
                    title,
                    year,
                    image,
                    "script.plex/thumb_fallbacks/movie.png",
                )
                for title, year, image in related
            ]
        )

        roles = (
            ("Nora Martin", "Élise", "pre-signin.jpg"),
            ("Malik Dumas", "Jonas", "linking-account.jpg"),
            ("Anna Morel", "Maya", "plexpass.jpg"),
            ("Sami Laurent", "Nils", "generating-code.jpg"),
            ("Lina Costa", "Iris", "pin-display.jpg"),
            ("Hugo Perrin", "Gabriel", "refresh-code.jpg"),
            ("Noémie Vidal", "Réalisatrice", "back.jpg"),
            ("Bastien Roy", "Arthur", "pre-signin.jpg"),
        )
        self.rolesListControl.addItems(
            [
                _item(
                    name,
                    role,
                    image,
                    "script.plex/thumb_fallbacks/role.png",
                )
                for name, role, image in roles
            ]
        )

        xbmcgui.Window(10000).setProperty(HARNESS_PROPERTY, "open")
        self.setFocusId(self.NEXT_BUTTON_ID)

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
        # Selecting demo cards must remain inert: this harness is visual only.
        return

    def onFocus(self, controlID):
        xbmcgui.Window(10000).setProperty(FOCUS_PROPERTY, str(controlID))
        VideoPlayerWindow.onFocus(self, controlID)

    def doClose(self, **kwargs):
        home = xbmcgui.Window(10000)
        home.clearProperty(HARNESS_PROPERTY)
        home.clearProperty(FOCUS_PROPERTY)
        kodigui.ControlledWindow.doClose(self)


def main():
    home = xbmcgui.Window(10000)
    home.setProperty(HARNESS_PROPERTY, "starting")
    try:
        DemoPostPlayWindow.open(aggressive=True)
    except Exception:
        xbmc.log("script.plexmod: post-play harness failed", xbmc.LOGERROR)
        raise
    finally:
        home.clearProperty(HARNESS_PROPERTY)
        home.clearProperty(FOCUS_PROPERTY)


if __name__ == "__main__":
    main()
