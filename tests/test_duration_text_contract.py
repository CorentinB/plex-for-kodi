from __future__ import absolute_import

import ast
from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
UTIL = ROOT / "lib" / "util.py"


def _duration_formatter(translations):
    tree = ast.parse(UTIL.read_text())
    function = next(
        node
        for node in tree.body
        if isinstance(node, ast.FunctionDef) and node.name == "durationToText"
    )
    module = ast.Module(body=[function], type_ignores=[])
    namespace = {
        "T": lambda string_id, fallback="": translations.get(string_id, fallback)
    }
    exec(compile(ast.fix_missing_locations(module), str(UTIL), "exec"), namespace)
    return namespace["durationToText"]


class DurationTextContractTests(unittest.TestCase):
    def test_duration_formatter_uses_localized_compact_units(self):
        french = {
            35048: "{0} jour",
            35049: "{0} jours",
            35050: "{0} h",
            35051: "{0} h",
            35052: "{0} min",
            35053: "{0} min",
            35054: "{0} s",
            35055: "{0} s",
            35056: "0 s",
        }
        duration = _duration_formatter(french)

        self.assertEqual(duration(0), "0 s")
        self.assertEqual(duration(1000), "1 s")
        self.assertEqual(duration(12000), "12 s")
        self.assertEqual(duration(60000), "1 min")
        self.assertEqual(duration(720000), "12 min")
        self.assertEqual(duration(3600000), "1 h")
        self.assertEqual(duration(40020000), "11 h 7 min")
        self.assertEqual(duration(86400000), "1 jour")
        self.assertEqual(duration(172800000), "2 jours")

    def test_duration_formatter_preserves_english_fallbacks(self):
        duration = _duration_formatter({})

        self.assertEqual(duration(720000), "12 mins")
        self.assertEqual(duration(40020000), "11 hrs 7 mins")
        self.assertEqual(duration(172800000), "2 days")


if __name__ == "__main__":
    unittest.main()
