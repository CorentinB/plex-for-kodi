from __future__ import absolute_import

import os
import unittest


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TEMPLATE_ROOT = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
)
SETTINGS = os.path.join(TEMPLATE_ROOT, "script-plex-settings.xml.tpl")
ROW = os.path.join(TEMPLATE_ROOT, "includes", "settings_row_layout.xml.tpl")
OPTION = os.path.join(TEMPLATE_ROOT, "includes", "settings_option_layout.xml.tpl")
HOME = os.path.join(TEMPLATE_ROOT, "script-plex-home.xml.tpl")
HOME_WINDOW = os.path.join(ROOT, "lib", "windows", "home.py")
FRENCH = os.path.join(
    ROOT,
    "resources",
    "language",
    "resource.language.fr_fr",
    "strings.po",
)


def _read(path):
    with open(path, "r") as handle:
        return handle.read()


class SettingsLayoutContractTests(unittest.TestCase):
    def test_settings_use_stable_safe_area_panels(self):
        template = _read(SETTINGS)

        self.assertIn("includes/default_background.xml.tpl", template)
        self.assertIn("script.plex/home/tvos-background-wash.png", template)
        self.assertIn("<posx>160</posx>", template)
        self.assertIn("<posx>540</posx>", template)
        self.assertIn("<posx>1320</posx>", template)
        self.assertNotIn('effect="slide"', template)

    def test_settings_focus_is_white_and_text_is_stable(self):
        layouts = _read(SETTINGS) + _read(ROW) + _read(OPTION)

        self.assertNotIn("FFE5A00D", layouts)
        self.assertNotIn("FFCC7B19", layouts)
        self.assertNotIn("<scroll>true</scroll>", layouts)
        self.assertIn("<autoscroll>false</autoscroll>", layouts)
        self.assertGreaterEqual(layouts.count('colordiffuse="FFFFFFFF"'), 5)

        settings = _read(SETTINGS)
        self.assertNotIn("<textureslidernib>-</textureslidernib>", settings)
        self.assertNotIn("<textureslidernibfocus>-</textureslidernibfocus>", settings)
        self.assertEqual(
            settings.count(
                "<textureslidernib>script.plex/transparent-6px.png</textureslidernib>"
            ),
            2,
        )
        self.assertEqual(
            settings.count(
                "<textureslidernibfocus>script.plex/transparent-6px.png</textureslidernibfocus>"
            ),
            2,
        )

    def test_native_settings_audit_labels_are_localized_in_french(self):
        french = _read(FRENCH)

        translations = {
            "Playback (user-specific)": "Lecture (par profil)",
            "Use alternate seek": "Utiliser la recherche alternative",
            "Loop theme music": "Lire le thème musical en boucle",
            "Ensure Kodi Addon position": "Conserver la position dans Kodi",
        }
        for source, translated in translations.items():
            self.assertIn(
                'msgid "{}"\nmsgstr "{}"'.format(source, translated),
                french,
            )

        self.assertIn(
            "Conserve la position de Plex dans Kodi même lorsque l’extension n’est pas lancée",
            french,
        )
        self.assertIn(
            "Utilise une méthode de recherche alternative dans les vidéos.",
            french,
        )

    def test_settings_keep_existing_control_contract_and_remote_routes(self):
        template = _read(SETTINGS)

        self.assertIn("<defaultcontrol>201</defaultcontrol>", template)
        for control_id in (75, 100, 101, 125, 126, 200, 201):
            self.assertIn('id="{}"'.format(control_id), template)
        self.assertIn("<onright>100</onright>", template)
        self.assertIn("<onleft>75</onleft>", template)
        self.assertIn("<onleft>100</onleft>", template)

    def test_home_avatar_opens_the_real_user_menu(self):
        home = _read(HOME)
        window = _read(HOME_WINDOW)

        self.assertEqual(home.count('id="202"'), 1)
        self.assertEqual(home.count('id="250"'), 1)
        self.assertEqual(home.count('id="801"'), 1)
        self.assertEqual(home.count('id="901"'), 1)
        self.assertIn("script.plex/circle-rounded-outline.png", home)
        self.assertIn("<onup>202</onup>", home)
        self.assertIn("self.setFocusId(self.SEARCH_BUTTON_ID)", window)
        self.assertIn("self.setFocusId(self.SECTION_LIST_ID)", window)


if __name__ == "__main__":
    unittest.main()
