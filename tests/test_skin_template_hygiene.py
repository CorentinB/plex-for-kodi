from pathlib import Path
import re
import unittest


ROOT = Path(__file__).resolve().parents[1]
TEMPLATES = ROOT / "resources" / "skins" / "Main" / "1080i" / "templates"
EXACT_DASH_TEXTURE = re.compile(
    r"<[^>]*texture[^>]*>\s*-\s*</[^>]*texture[^>]*>",
    re.IGNORECASE,
)


class SkinTemplateHygieneTests(unittest.TestCase):
    def test_invisible_textures_use_the_real_transparent_asset(self):
        offenders = []
        for path in sorted(TEMPLATES.rglob("*.xml.tpl")):
            if EXACT_DASH_TEXTURE.search(path.read_text()):
                offenders.append(str(path.relative_to(ROOT)))

        self.assertEqual(offenders, [])


if __name__ == "__main__":
    unittest.main()
