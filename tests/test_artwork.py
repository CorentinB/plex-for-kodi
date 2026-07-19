from __future__ import absolute_import

import importlib.util
import os
import unittest


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MODULE_PATH = os.path.join(ROOT, "lib", "artwork.py")
UTIL_PATH = os.path.join(ROOT, "lib", "util.py")
SPEC = importlib.util.spec_from_file_location("artwork", MODULE_PATH)
artwork = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(artwork)


class StringLikeArt(object):
    def __init__(self, value):
        self.value = value

    def __str__(self):
        return self.value


class ArtworkTests(unittest.TestCase):
    def test_rejects_empty_and_plex_missing_art_sentinels(self):
        for value in (None, "", "None", " null ", "UNDEFINED"):
            self.assertFalse(artwork.is_usable_art(value))

    def test_rejects_missing_sentinel_from_string_like_plex_value(self):
        self.assertFalse(artwork.is_usable_art(StringLikeArt("None")))

    def test_accepts_real_plex_art_paths_and_urls(self):
        self.assertTrue(artwork.is_usable_art("/library/metadata/42/art/1"))
        self.assertTrue(artwork.is_usable_art("https://example.invalid/art.jpg"))

    def test_background_transcodes_can_enforce_a_minimum_fallback_blur(self):
        with open(UTIL_PATH, "r") as handle:
            util_source = handle.read()

        self.assertIn("minimum_blur=None", util_source)
        self.assertIn("blur = max(blur, minimum_blur)", util_source)
        self.assertIn("blur=blur", util_source)


if __name__ == "__main__":
    unittest.main()
