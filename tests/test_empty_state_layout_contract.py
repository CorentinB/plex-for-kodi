from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
TEMPLATES = ROOT / "resources" / "skins" / "Main" / "1080i" / "templates"


class EmptyStateLayoutContractTests(unittest.TestCase):
    def test_primary_empty_states_use_rounded_readable_panels(self):
        expectations = {
            "script-plex-home.xml.tpl": 1,
            "library.xml.tpl": 2,
            "script-plex-person.xml.tpl": 1,
        }
        for name, count in expectations.items():
            with self.subTest(name=name):
                source = (TEMPLATES / name).read_text()
                self.assertGreaterEqual(source.count('colordiffuse="D90B0B0B" border="30"'), count)

    def test_busy_surfaces_are_rounded_and_not_legacy_bitmaps(self):
        for name in ("script-plex-busy.xml.tpl", "script-plex-busy_msg.xml.tpl"):
            with self.subTest(name=name):
                source = (TEMPLATES / name).read_text()
                self.assertIn("script.plex/white-square-rounded.png", source)
                self.assertNotIn("script.plex/busy-back.png", source)

    def test_shared_header_focus_and_progress_are_white(self):
        source = (TEMPLATES / "default.xml.tpl").read_text()
        self.assertNotIn("FFE5A00D", source)
        self.assertNotIn("FFCC7B19", source)
        self.assertIn('texturefocus colordiffuse="FFFFFFFF"', source)

    def test_shared_detail_and_library_headers_use_the_subtle_focus_lift(self):
        for name in ("default.xml.tpl", "library.xml.tpl"):
            with self.subTest(name=name):
                source = (TEMPLATES / name).read_text()
                self.assertEqual(source.count('end="106" time="110" center="20,{{ vscale(20) }}"'), 2)
                self.assertIn('condition="Control.HasFocus(201)">Conditional', source)
                self.assertIn('condition="Control.HasFocus(202)">Conditional', source)
                self.assertNotIn('end="144"', source)


if __name__ == "__main__":
    unittest.main()
