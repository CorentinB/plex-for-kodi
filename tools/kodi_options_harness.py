"""Open the production options dialog without invoking a real action.

The shared dialog appears in destructive and account-level flows such as
delete, sign-out, empty-trash and exit. This harness exercises its real
WindowXML and D-pad graph with inert sample buttons, so native visual QA never
changes Plex, account, library, or playback state.
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

from lib.windows import optionsdialog  # noqa: E402


HARNESS_PROPERTY = "codex.options_harness"


class DemoOptionsDialog(optionsdialog.OptionsDialog):
    def onFirstInit(self):
        optionsdialog.OptionsDialog.onFirstInit(self)
        xbmcgui.Window(10000).setProperty(HARNESS_PROPERTY, "open")
        self._publishFocus(self.getFocusId())

    def _publishFocus(self, control_id):
        xbmcgui.Window(10000).setProperty(
            HARNESS_PROPERTY + ".focus", str(control_id)
        )

    def onFocus(self, controlID):
        self._publishFocus(controlID)

    def onClick(self, controlID):
        # The sample choices are deliberately inert.
        self._publishFocus(controlID)

    def doClose(self, **kwargs):
        home = xbmcgui.Window(10000)
        home.clearProperty(HARNESS_PROPERTY)
        home.clearProperty(HARNESS_PROPERTY + ".focus")
        optionsdialog.OptionsDialog.doClose(self, **kwargs)


def main():
    home = xbmcgui.Window(10000)
    home.setProperty(HARNESS_PROPERTY, "starting")
    arguments = {argument.lower() for argument in sys.argv[1:]}
    is_big = "big" in arguments
    DemoOptionsDialog.xmlFile = (
        "script-plex-options_dialog_big.xml"
        if is_big
        else "script-plex-options_dialog.xml"
    )
    info = (
        "Version actuelle : 2.1.0\nNouvelle version : 2.2.0\n\n"
        "Nouveautés\n"
        "• Navigation plus régulière dans les bibliothèques\n"
        "• Cartes et dialogues harmonisés avec le style tvOS\n"
        "• Meilleure lisibilité des informations techniques\n\n"
        "Vous pouvez installer la mise à jour maintenant ou la reporter."
        if is_big
        else (
            "Cet élément disparaîtra de votre accueil. "
            "Votre progression et votre historique seront conservés."
        )
    )
    try:
        DemoOptionsDialog.open(
            header="Mise à jour disponible" if is_big else "Retirer de Continuer la lecture ?",
            info=info,
            button0="Installer" if is_big else "Retirer",
            button1="Plus tard",
            button2="Annuler",
            select=2 if "select2" in arguments else 0,
            aggressive=True,
        )
    except Exception:
        xbmc.log("script.plexmod: options harness failed", xbmc.LOGERROR)
        raise
    finally:
        home.clearProperty(HARNESS_PROPERTY)
        home.clearProperty(HARNESS_PROPERTY + ".focus")


if __name__ == "__main__":
    main()
