from __future__ import absolute_import

import ast
from pathlib import Path
import re
import types
import unittest


ROOT = Path(__file__).resolve().parents[1]
UTIL = ROOT / "lib" / "util.py"
PREPLAY = ROOT / "lib" / "windows" / "preplay.py"


def _long_date_formatter(region_format):
    tree = ast.parse(UTIL.read_text())
    function = next(
        (
            node
            for node in tree.body
            if isinstance(node, ast.FunctionDef)
            and node.name == "getLongDateFormat"
        ),
        None,
    )
    if function is None:
        raise AssertionError("getLongDateFormat is missing")

    module = ast.Module(body=[function], type_ignores=[])
    namespace = {
        "re": re,
        "xbmc": types.SimpleNamespace(
            getRegion=lambda name: region_format if name == "datelong" else "",
        ),
    }
    exec(
        compile(ast.fix_missing_locations(module), str(UTIL), "exec"),
        namespace,
    )
    return namespace["getLongDateFormat"]


def _leading_zero_cleaner():
    tree = ast.parse(UTIL.read_text())
    function = next(
        (
            node
            for node in tree.body
            if isinstance(node, ast.FunctionDef)
            and node.name == "cleanLeadingZeros"
        ),
        None,
    )
    if function is None:
        raise AssertionError("cleanLeadingZeros is missing")

    module = ast.Module(body=[function], type_ignores=[])
    namespace = {"re": re}
    exec(
        compile(ast.fix_missing_locations(module), str(UTIL), "exec"),
        namespace,
    )
    return namespace["cleanLeadingZeros"]


class DateFormatContractTests(unittest.TestCase):
    def test_long_date_format_follows_french_regional_order_without_weekday(self):
        formatter = _long_date_formatter("%A %-d %B %Y")

        self.assertEqual(formatter(), "%d %B %Y")

    def test_long_date_format_handles_weekday_punctuation(self):
        formatter = _long_date_formatter("%A, %B %-d, %Y")

        self.assertEqual(formatter(), "%B %d, %Y")

    def test_long_date_format_has_a_portable_fallback(self):
        formatter = _long_date_formatter("")

        self.assertEqual(formatter(), "%B %d, %Y")

    def test_preplay_dates_use_the_regional_long_format(self):
        source = PREPLAY.read_text()

        self.assertEqual(
            source.count(
                "originallyAvailableAt.asDatetime(util.getLongDateFormat())"
            ),
            2,
        )

    def test_windows_do_not_hard_code_long_date_order(self):
        windows = ROOT / "lib" / "windows"

        for path in windows.rglob("*.py"):
            source = path.read_text()
            with self.subTest(path=path.relative_to(ROOT)):
                self.assertNotIn("%B %d, %Y", source)
                self.assertNotIn("%d %B %Y", source)

    def test_leading_zero_cleaner_handles_dates_at_start_of_text(self):
        cleaner = _leading_zero_cleaner()

        self.assertEqual(cleaner("08 février 2026"), "8 février 2026")
        self.assertEqual(cleaner("Publié le 08 février 2026"), "Publié le 8 février 2026")
        self.assertEqual(cleaner("1080p"), "1080p")


if __name__ == "__main__":
    unittest.main()
