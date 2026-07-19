from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
TEMPLATES = ROOT / "resources" / "skins" / "Main" / "1080i" / "templates"
FRENCH = ROOT / "resources" / "language" / "resource.language.fr_fr" / "strings.po"
DROPDOWN_SOURCE = ROOT / "lib" / "windows" / "dropdown.py"


class DropdownLayoutContractTests(unittest.TestCase):
    def test_dropdowns_use_tvos_white_focus_instead_of_plex_orange(self):
        for filename in ("script-plex-dropdown.xml.tpl", "script-plex-dropdown_header.xml.tpl"):
            template = (TEMPLATES / filename).read_text()
            self.assertIn('colordiffuse="FFF5F5F5"', template)
            self.assertNotIn("E5A00D", template)

    def test_header_dropdown_uses_real_transparency_without_forced_marquee(self):
        template = (TEMPLATES / "script-plex-dropdown_header.xml.tpl").read_text()
        invalid_texture_nodes = (
            "<texturefocus>-</texturefocus>",
            "<texturenofocus>-</texturenofocus>",
            "<textureslidernib>-</textureslidernib>",
            "<textureslidernibfocus>-</textureslidernibfocus>",
        )

        for node in invalid_texture_nodes:
            self.assertNotIn(node, template)

        self.assertEqual(template.count("script.plex/transparent-6px.png"), 4)
        self.assertNotIn("<scroll>true</scroll>", template)
        self.assertNotIn("<scrollspeed>", template)

    def test_plain_dropdown_uses_real_transparency_without_forced_marquee(self):
        template = (TEMPLATES / "script-plex-dropdown.xml.tpl").read_text()

        self.assertNotIn("<texturefocus>-</texturefocus>", template)
        self.assertNotIn("<texturenofocus>-</texturenofocus>", template)
        self.assertEqual(template.count("script.plex/transparent-6px.png"), 2)
        self.assertNotIn("<scroll>true</scroll>", template)
        self.assertNotIn("<scrollspeed>", template)

    def test_dropdown_positioning_uses_supported_group_not_xml_scrollbar(self):
        source = DROPDOWN_SOURCE.read_text()
        header = (TEMPLATES / "script-plex-dropdown_header.xml.tpl").read_text()

        self.assertIn("def positionControls(self, x, y):", source)
        self.assertIn("getControl(100).setPosition(x, y)", source)
        self.assertNotIn("getControl(self.SCROLLBAR_ID)", source)
        self.assertIn('<control type="label" id="112">', header)

    def test_long_header_dropdown_scrollbar_matches_fourteen_row_list(self):
        header = (TEMPLATES / "script-plex-dropdown_header.xml.tpl").read_text()

        self.assertIn('<pagecontrol>1152</pagecontrol>', header)
        self.assertIn('<control type="scrollbar" id="1152">', header)
        scrollbar = header.split('<control type="scrollbar" id="1152">', 1)[1]
        self.assertIn('<height>{{ vscale(924) }}</height>', scrollbar)

    def test_poster_library_filters_match_the_white_focus_language(self):
        template = (TEMPLATES / "library_posters.xml.tpl").read_text()
        self.assertEqual(template.count('texturefocus colordiffuse="FFF5F5F5"'), 3)
        self.assertNotIn('texturefocus colordiffuse="FFE5A00D"', template)

    def test_french_playback_sheet_uses_concise_localized_labels(self):
        french = FRENCH.read_text()

        expected_entries = (
            ('32522', "Automatically Skip Intro", "Saut auto de l'intro"),
            ('32526', "Automatically Skip Credits", "Saut auto du générique"),
            ('33505', "Show intro skip button early", "« Passer l'intro » dès le début"),
        )
        for string_id, source, translation in expected_entries:
            entry = (
                'msgctxt "#{0}"\nmsgid "{1}"\nmsgstr "{2}"'
                .format(string_id, source, translation)
            )
            self.assertIn(entry, french)

        self.assertEqual(french.count('msgctxt "#32973"'), 1)
        self.assertEqual(french.count('msgstr "Lecture continue des épisodes"'), 1)


if __name__ == "__main__":
    unittest.main()
