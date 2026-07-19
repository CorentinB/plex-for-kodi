from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
TEMPLATES = ROOT / "resources" / "skins" / "Main" / "1080i" / "templates"


class SignInLayoutContractTests(unittest.TestCase):
    def read(self, name):
        return (TEMPLATES / name).read_text()

    def test_all_signin_surfaces_use_the_shared_tvos_shell(self):
        for name in (
            "script-plex-pre_signin.xml.tpl",
            "script-plex-signin_background.xml.tpl",
            "script-plex-signin_blank.xml.tpl",
            "script-plex-refresh_code.xml.tpl",
            "script-plex-pin_login.xml.tpl",
        ):
            with self.subTest(name=name):
                source = self.read(name)
                self.assertIn('includes/signin_background.xml.tpl', source)
                self.assertNotIn("pre-signin.jpg", source)
                self.assertNotIn("pin-display.jpg", source)
                self.assertNotIn("refresh-code.jpg", source)

    def test_interactive_signin_controls_have_visible_rounded_focus(self):
        for name in (
            "script-plex-pre_signin.xml.tpl",
            "script-plex-signin_blank.xml.tpl",
            "script-plex-refresh_code.xml.tpl",
            "script-plex-pin_login.xml.tpl",
        ):
            with self.subTest(name=name):
                source = self.read(name)
                self.assertIn('<control type="button" id="100">', source)
                self.assertIn("white-square-rounded.png", source)
                self.assertIn("<focusedcolor>FF111111</focusedcolor>", source)
                self.assertNotIn("<texturefocus>-</texturefocus>", source)

    def test_link_code_is_four_separate_rounded_cells(self):
        source = self.read("script-plex-pin_login.xml.tpl")
        self.assertIn("{% for digit in range(4) %}", source)
        self.assertIn("Window.Property(pin.image.{{ digit }})", source)
        self.assertIn("<itemgap>20</itemgap>", source)
        self.assertIn("$ADDON[script.plexmod 35024]", source)

    def test_signin_strings_are_localized_in_english_and_french(self):
        for language in ("resource.language.en_gb", "resource.language.fr_fr"):
            po = (ROOT / "resources" / "language" / language / "strings.po").read_text()
            for string_id in range(35020, 35032):
                self.assertIn('msgctxt "#{}"'.format(string_id), po)


if __name__ == "__main__":
    unittest.main()
