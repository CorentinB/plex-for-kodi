from __future__ import absolute_import

import unittest
import importlib.util
import os


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MODULE_PATH = os.path.join(ROOT, "lib", "home_hero.py")
SPEC = importlib.util.spec_from_file_location("home_hero", MODULE_PATH)
home_hero = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(home_hero)
_short_text = home_hero._short_text
normalize_content_rating = home_hero.normalize_content_rating
build_hero_properties = home_hero.build_hero_properties


class FakeMedia(object):
    def __init__(self, **values):
        self._values = values
        for key, value in values.items():
            setattr(self, key, value)

    def get(self, key, default=None):
        return self._values.get(key, default)


class FakeImage(object):
    def __init__(self, url):
        self.url = url

    def asTranscodedImageURL(self, width, height, **kwargs):
        return "{0}?width={1}&height={2}&blur={3}&opacity={4}&background={5}".format(
            self.url,
            width,
            height,
            kwargs.get("blur", ""),
            kwargs.get("opacity", ""),
            kwargs.get("background", ""),
        )


class HomeHeroTests(unittest.TestCase):
    def test_builds_movie_hero_properties_from_common_media_fields(self):
        media = FakeMedia(
            defaultTitle="The Conners",
            year=2018,
            duration=30 * 60 * 1000,
            contentRating="TV-PG",
            genres=["Comedy", FakeMedia(tag="Sitcom")],
            summary="Follow-up to the comedy series Roseanne.",
            roles=[FakeMedia(tag="John Goodman"), FakeMedia(tag="Laurie Metcalf")],
            art=FakeImage("https://example.invalid/art.jpg"),
        )

        props = build_hero_properties(media)

        self.assertEqual(props["title"], "The Conners")
        self.assertEqual(props["content_rating"], "TV-PG")
        self.assertEqual(props["content_rating_wide"], "")
        self.assertEqual(props["meta"], "2018    30m    Comedy, Sitcom")
        self.assertEqual(props["summary"], "Follow-up to the comedy series Roseanne.")
        self.assertEqual(props["short_summary"], "Follow-up to the comedy series Roseanne.")
        self.assertEqual(props["cast"], "John Goodman, Laurie Metcalf")
        self.assertEqual(
            props["art"],
            "https://example.invalid/art.jpg?width=1920&height=1080&blur=18&opacity=70&background=000000",
        )
        self.assertEqual(props["visible"], "1")

    def test_missing_media_fields_return_empty_strings(self):
        props = build_hero_properties(FakeMedia())

        self.assertEqual(props["title"], "")
        self.assertEqual(props["content_rating"], "")
        self.assertEqual(props["content_rating_wide"], "")
        self.assertEqual(props["meta"], "")
        self.assertEqual(props["summary"], "")
        self.assertEqual(props["short_summary"], "")
        self.assertEqual(props["cast"], "")
        self.assertEqual(props["art"], "")
        self.assertEqual(props["visible"], "")

    def test_numeric_critic_rating_is_not_presented_as_content_rating(self):
        props = build_hero_properties(FakeMedia(title="Movie", rating=0.0, year=2025))

        self.assertEqual(props["content_rating"], "")
        self.assertEqual(props["meta"], "2025")

    def test_country_prefixed_certifications_become_compact_badge_text(self):
        self.assertEqual(normalize_content_rating("fr/12"), "12")
        self.assertEqual(normalize_content_rating("us/TV-14"), "TV-14")
        self.assertEqual(normalize_content_rating("TV-PG"), "TV-PG")

    def test_long_localized_certifications_request_the_wide_badge(self):
        props = build_hero_properties(
            FakeMedia(title="Movie", contentRating="Tous publics")
        )

        self.assertEqual(props["content_rating"], "Tous publics")
        self.assertEqual(props["content_rating_wide"], "1")

    def test_long_unrated_labels_use_the_conventional_badge_code(self):
        self.assertEqual(normalize_content_rating("Not Rated"), "NR")
        self.assertEqual(normalize_content_rating("Not Yet Rated"), "NR")
        self.assertEqual(normalize_content_rating("Unrated"), "NR")

    def test_long_summaries_are_shortened_on_a_word_boundary(self):
        summary = "A deliberately long sentence " * 20
        props = build_hero_properties(FakeMedia(title="Movie", summary=summary))

        self.assertEqual(props["summary"], summary.strip())
        self.assertLessEqual(len(props["short_summary"]), 191)
        self.assertTrue(props["short_summary"].endswith("…"))
        self.assertNotIn("  ", props["short_summary"])

    def test_short_text_supports_a_detail_page_limit(self):
        summary = "A deliberately long sentence " * 20

        shortened = _short_text(summary, limit=220)

        self.assertLessEqual(len(shortened), 221)
        self.assertTrue(shortened.endswith("…"))

    def test_string_genres_are_treated_as_single_values(self):
        props = build_hero_properties(FakeMedia(title="Movie", genres="Comedy"))

        self.assertEqual(props["meta"], "Comedy")

    def test_empty_plex_collection_strings_are_suppressed(self):
        props = build_hero_properties(
            FakeMedia(
                title="Movie",
                year=2003,
                genres="()",
                roles="()",
            )
        )

        self.assertEqual(props["meta"], "2003")
        self.assertEqual(props["cast"], "")


if __name__ == "__main__":
    unittest.main()
