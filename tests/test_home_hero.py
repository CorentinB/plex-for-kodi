from __future__ import absolute_import

import unittest
import importlib.util
import os
import xml.etree.ElementTree as ElementTree


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MODULE_PATH = os.path.join(ROOT, "lib", "home_hero.py")
SPEC = importlib.util.spec_from_file_location("home_hero", MODULE_PATH)
home_hero = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(home_hero)
_short_text = home_hero._short_text
normalize_content_rating = home_hero.normalize_content_rating
build_hero_properties = home_hero.build_hero_properties
build_home_hero_properties = home_hero.build_home_hero_properties
clear_logo_url_from_metadata = getattr(home_hero, "clear_logo_url_from_metadata", None)
logo_metadata_key = getattr(home_hero, "logo_metadata_key", None)
nav_label_width = home_hero.nav_label_width
nav_visual_offsets = home_hero.nav_visual_offsets


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


class FakeServer(object):
    def buildUrl(self, path, includeToken=False):
        suffix = "?token=1" if includeToken else ""
        return "https://plex.invalid{}{}".format(path, suffix)


class PlexPropertyMedia(object):
    def __init__(self):
        self.type = "movie"
        self.TYPE = "movie"
        self.title = "Blade Runner"
        self.editionTitle = "The Final Cut"

    @property
    def defaultTitle(self):
        return "{} • {}".format(self.title, self.editionTitle)

    def genres(self):
        raise AssertionError("metadata access must not resolve Plex methods")

    def get(self, key, default=None):
        # PlexObject.get() does not resolve class properties such as defaultTitle.
        return self.__dict__.get(key, default)


class HomeHeroTests(unittest.TestCase):
    def test_media_display_contract_covers_every_home_media_type(self):
        display_type = getattr(home_hero, "media_display_type", None)
        self.assertIsNotNone(display_type)

        expected = {
            "movie": "poster",
            "show": "poster",
            "season": "poster",
            "episode": "ar16x9",
            "clip": "ar16x9",
            "video": "ar16x9",
            "album": "square",
            "artist": "square",
            "photo": "square",
            "photodirectory": "square",
            "track": "square",
        }
        for media_type, geometry in expected.items():
            self.assertEqual(display_type(media_type), geometry)

        self.assertEqual(display_type("playlist", "audio"), "square")
        self.assertEqual(display_type("playlist", "video"), "ar16x9")
        self.assertEqual(display_type("playlist", ""), "poster")
        self.assertEqual(display_type("unknown", default="square"), "square")

    def test_every_home_media_type_returns_the_complete_string_contract(self):
        for media_type in (
            "movie",
            "show",
            "season",
            "episode",
            "clip",
            "video",
            "album",
            "artist",
            "photo",
            "photodirectory",
            "track",
            "playlist",
        ):
            with self.subTest(media_type=media_type):
                props = build_hero_properties(
                    FakeMedia(type=media_type, TYPE=media_type, title="Focused item")
                )
                self.assertEqual(set(props), set(home_hero.HERO_KEYS))
                self.assertTrue(all(isinstance(value, str) for value in props.values()))

    def test_navigation_label_widths_fit_common_localized_sections(self):
        self.assertEqual(nav_label_width("Accueil"), 80)
        self.assertEqual(nav_label_width("Films"), 60)
        self.assertEqual(nav_label_width("Séries TV"), 100)
        self.assertEqual(nav_label_width("Livres audio"), 140)
        self.assertEqual(nav_label_width("Listes de lecture"), 180)

    def test_navigation_offsets_follow_adaptive_plate_widths(self):
        offsets = nav_visual_offsets(
            [80, 100, 180, 60],
            [True, False, False, False],
        )

        self.assertEqual(offsets, [0, -24, -28, 48])

    def test_builds_movie_hero_properties_from_common_media_fields(self):
        media = FakeMedia(
            type="movie",
            TYPE="movie",
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
        self.assertEqual(props["subtitle"], "")
        self.assertEqual(props["logo"], "")
        self.assertEqual(props["content_rating"], "TV-PG")
        self.assertEqual(props["content_rating_wide"], "")
        self.assertEqual(props["meta"], "2018 • 30m • Comedy, Sitcom")
        self.assertEqual(props["rating"], "")
        self.assertEqual(props["rating_image"], "")
        self.assertEqual(props["rating2"], "")
        self.assertEqual(props["rating2_image"], "")
        self.assertEqual(props["summary"], "Follow-up to the comedy series Roseanne.")
        self.assertEqual(props["short_summary"], "Follow-up to the comedy series Roseanne.")
        self.assertEqual(props["cast"], "John Goodman, Laurie Metcalf")
        self.assertEqual(
            props["art"],
            "https://example.invalid/art.jpg?width=1920&height=1080&blur=&opacity=&background=",
        )
        self.assertEqual(
            props["art_blurred"],
            "https://example.invalid/art.jpg?width=320&height=180&blur=64&opacity=100&background=000000",
        )
        self.assertEqual(props["visible"], "1")

    def test_missing_media_fields_return_empty_strings(self):
        props = build_hero_properties(FakeMedia())

        self.assertEqual(props["title"], "")
        self.assertEqual(props["subtitle"], "")
        self.assertEqual(props["logo"], "")
        self.assertEqual(props["content_rating"], "")
        self.assertEqual(props["content_rating_wide"], "")
        self.assertEqual(props["meta"], "")
        self.assertEqual(props["rating"], "")
        self.assertEqual(props["rating_image"], "")
        self.assertEqual(props["rating2"], "")
        self.assertEqual(props["rating2_image"], "")
        self.assertEqual(props["summary"], "")
        self.assertEqual(props["short_summary"], "")
        self.assertEqual(props["cast"], "")
        self.assertEqual(props["art"], "")
        self.assertEqual(props["art_blurred"], "")
        self.assertEqual(props["visible"], "")

    def test_uses_plex_clear_logo_image_when_hub_metadata_provides_one(self):
        data = ElementTree.fromstring(
            '<Video title="Malcolm"><Image type="background" url="/art" />'
            '<Image type="clearLogo" url="/logo/123" /></Video>'
        )
        media = FakeMedia(title="Malcolm", data=data, server=FakeServer())

        props = build_hero_properties(media)

        self.assertEqual(props["logo"], "https://plex.invalid/logo/123?token=1")

    def test_logo_lookup_uses_the_parent_show_guid_for_episode_and_season_items(self):
        self.assertIsNotNone(logo_metadata_key)
        cases = (
            (
                FakeMedia(
                    type="episode",
                    guid="plex://episode/episode-id",
                    parentGuid="plex://season/season-id",
                    grandparentGuid="plex://show/show-id",
                ),
                "show-id",
            ),
            (
                FakeMedia(
                    type="season",
                    guid="plex://season/season-id",
                    parentGuid="plex://show/show-id",
                ),
                "show-id",
            ),
            (FakeMedia(type="show", guid="plex://show/show-id"), "show-id"),
            (FakeMedia(type="movie", guid="plex://movie/movie-id"), "movie-id"),
        )

        for media, expected in cases:
            with self.subTest(media_type=media.type):
                self.assertEqual(logo_metadata_key(media), expected)

    def test_discover_metadata_prefers_the_curated_clear_logo_over_wide_fallback(self):
        self.assertIsNotNone(clear_logo_url_from_metadata)
        data = ElementTree.fromstring(
            '<MediaContainer><Directory title="The Boys">'
            '<Image type="clearLogoWide" url="/logo/wide" />'
            '<Image type="background" url="/art" />'
            '<Image type="clearLogo" url="https://metadata.plex.invalid/logo.png" />'
            '</Directory></MediaContainer>'
        )

        self.assertEqual(
            clear_logo_url_from_metadata(data),
            "https://metadata.plex.invalid/logo.png",
        )

    def test_text_title_remains_when_plex_has_no_clear_logo(self):
        data = ElementTree.fromstring(
            '<Video title="Movie"><Image type="background" url="/art" /></Video>'
        )

        props = build_hero_properties(FakeMedia(title="Movie", data=data))

        self.assertEqual(props["logo"], "")
        self.assertEqual(props["title"], "Movie")

    def test_numeric_critic_rating_is_not_presented_as_content_rating(self):
        props = build_hero_properties(FakeMedia(title="Movie", rating=0.0, year=2025))

        self.assertEqual(props["content_rating"], "")
        self.assertEqual(props["meta"], "2025")

    def test_episode_hero_uses_show_identity_episode_title_and_episode_index(self):
        props = build_hero_properties(
            FakeMedia(
                type="episode",
                TYPE="episode",
                defaultTitle="Loki",
                grandparentTitle="Loki",
                parentTitle="Season 2",
                title="Glorious Purpose",
                parentIndex=2,
                index=1,
                year=2023,
                duration=47 * 60 * 1000,
                genres=["Drama", "Science Fiction"],
            )
        )

        self.assertEqual(props["title"], "Loki")
        self.assertEqual(props["subtitle"], "Glorious Purpose")
        self.assertEqual(
            props["meta"],
            "S2 • E1 • 2023 • 47m • Drama, Science Fiction",
        )

    def test_album_and_track_heroes_keep_artist_identity_above_focused_title(self):
        album = build_hero_properties(
            FakeMedia(
                type="album",
                TYPE="album",
                parentTitle="Beth Gibbons",
                title="Lives Outgrown",
                year=2024,
                duration=41 * 60 * 1000,
                genres=["Alternative"],
            )
        )
        track = build_hero_properties(
            FakeMedia(
                type="track",
                TYPE="track",
                grandparentTitle="Beth Gibbons",
                parentTitle="Lives Outgrown",
                title="Floating on a Moment",
                index=4,
                duration=4 * 60 * 1000,
            )
        )

        self.assertEqual(album["title"], "Beth Gibbons")
        self.assertEqual(album["subtitle"], "Lives Outgrown")
        self.assertEqual(album["meta"], "2024 • 41m • Alternative")
        self.assertEqual(track["title"], "Beth Gibbons")
        self.assertEqual(track["subtitle"], "Floating on a Moment")
        self.assertEqual(track["meta"], "Lives Outgrown • #4 • 4m")

    def test_every_hierarchical_media_type_uses_its_parent_identity(self):
        cases = (
            ("season", {"parentTitle": "Severance", "title": "Season 2"}, "Severance", "Season 2"),
            ("photo", {"parentTitle": "Summer 2026", "title": "IMG_0421"}, "Summer 2026", "IMG_0421"),
            ("photodirectory", {"parentTitle": "Family", "title": "Peyrenegre"}, "Family", "Peyrenegre"),
            ("clip", {"grandparentTitle": "Twin Peaks", "title": "Behind the scenes"}, "Twin Peaks", "Behind the scenes"),
            ("video", {"parentTitle": "Home Movies", "title": "Christmas 2000"}, "Home Movies", "Christmas 2000"),
        )

        for media_type, values, title, subtitle in cases:
            values.update({"type": media_type, "TYPE": media_type})
            with self.subTest(media_type=media_type):
                props = build_hero_properties(FakeMedia(**values))
                self.assertEqual(props["title"], title)
                self.assertEqual(props["subtitle"], subtitle)

    def test_photo_identity_prefers_the_immediate_parent_folder(self):
        for media_type in ("photo", "photodirectory"):
            with self.subTest(media_type=media_type):
                props = build_hero_properties(
                    FakeMedia(
                        type=media_type,
                        TYPE=media_type,
                        grandparentTitle="Photos",
                        parentTitle="Summer 2026",
                        title="IMG_0421",
                    )
                )

                self.assertEqual(props["title"], "Summer 2026")
                self.assertEqual(props["subtitle"], "IMG_0421")

    def test_movie_identity_reads_real_plex_default_title_property(self):
        props = build_hero_properties(PlexPropertyMedia())

        self.assertEqual(props["title"], "Blade Runner • The Final Cut")
        self.assertEqual(props["subtitle"], "")

    def test_non_hierarchical_media_types_use_one_identity_line(self):
        for media_type, title in (
            ("show", "Severance"),
            ("artist", "Beth Gibbons"),
            ("playlist", "Sunday Morning"),
        ):
            with self.subTest(media_type=media_type):
                props = build_hero_properties(
                    FakeMedia(type=media_type, TYPE=media_type, title=title)
                )
                self.assertEqual(props["title"], title)
                self.assertEqual(props["subtitle"], "")

    def test_hierarchical_media_without_parent_collapses_to_one_title_line(self):
        for media_type in (
            "episode",
            "season",
            "album",
            "track",
            "photo",
            "photodirectory",
            "clip",
            "video",
        ):
            with self.subTest(media_type=media_type):
                props = build_hero_properties(
                    FakeMedia(type=media_type, TYPE=media_type, title="Focused item")
                )
                self.assertEqual(props["title"], "Focused item")
                self.assertEqual(props["subtitle"], "")

    def test_movie_tagline_only_uses_second_line_when_summary_is_distinct(self):
        tagline_only = build_hero_properties(
            FakeMedia(type="movie", TYPE="movie", title="Alien", tagline="In space no one can hear you scream.")
        )
        tagline_and_summary = build_hero_properties(
            FakeMedia(
                type="movie",
                TYPE="movie",
                title="Alien",
                tagline="In space no one can hear you scream.",
                summary="A crew encounters a lethal organism.",
            )
        )

        self.assertEqual(tagline_only["subtitle"], "")
        self.assertEqual(tagline_only["summary"], "In space no one can hear you scream.")
        self.assertEqual(tagline_and_summary["subtitle"], "In space no one can hear you scream.")
        self.assertEqual(tagline_and_summary["summary"], "A crew encounters a lethal organism.")

    def test_all_video_media_types_accept_series_rating_preference(self):
        for media_type in ("show", "season", "episode"):
            with self.subTest(media_type=media_type):
                props = build_home_hero_properties(
                    FakeMedia(
                        type=media_type,
                        TYPE=media_type,
                        title="Rated item",
                        rating=8.4,
                        ratingImage="tmdb://image.rating",
                    ),
                    "series",
                )
                self.assertEqual(props["rating"], "8.4")
                self.assertEqual(
                    props["rating_image"],
                    "script.plex/ratings/tmdb/image.rating.png",
                )

    def test_track_without_artist_uses_track_title_without_album_substitution(self):
        props = build_hero_properties(
            FakeMedia(
                type="track",
                TYPE="track",
                parentTitle="Lives Outgrown",
                title="Floating on a Moment",
                index=4,
            )
        )

        self.assertEqual(props["title"], "Floating on a Moment")
        self.assertEqual(props["subtitle"], "")
        self.assertEqual(props["meta"], "Lives Outgrown • #4")

    def test_movie_hero_formats_critic_and_audience_rating_sources(self):
        props = build_hero_properties(
            FakeMedia(
                type="movie",
                TYPE="movie",
                title="The Substance",
                contentRating="fr/12",
                rating=8.6,
                ratingImage="rottentomatoes://image.rating.ripe",
                audienceRating=7.3,
                audienceRatingImage="imdb://image.rating",
            )
        )

        self.assertEqual(props["content_rating"], "12")
        self.assertEqual(props["rating"], "86%")
        self.assertEqual(
            props["rating_image"],
            "script.plex/ratings/rottentomatoes/image.rating.ripe.png",
        )
        self.assertEqual(props["rating2"], "7.3")
        self.assertEqual(
            props["rating2_image"],
            "script.plex/ratings/imdb/image.rating.png",
        )

    def test_rating_slots_cover_single_source_fallback_and_invalid_scores(self):
        cases = (
            (
                {"rating": 7.4},
                ("7.4", "", "", ""),
            ),
            (
                {
                    "audienceRating": 6.2,
                    "audienceRatingImage": "themoviedb://image.rating",
                },
                ("", "", "6.2", "script.plex/ratings/tmdb/image.rating.png"),
            ),
            (
                {
                    "rating": 8.1,
                    "ratingImage": "script.plex/ratings/imdb/image.rating.png",
                },
                ("8.1", "script.plex/ratings/imdb/image.rating.png", "", ""),
            ),
            (
                {"rating": 0, "audienceRating": "not-a-score"},
                ("", "", "", ""),
            ),
        )

        for values, expected in cases:
            values.update({"type": "movie", "TYPE": "movie", "title": "Rated movie"})
            with self.subTest(values=values):
                props = build_hero_properties(FakeMedia(**values))
                self.assertEqual(
                    (
                        props["rating"],
                        props["rating_image"],
                        props["rating2"],
                        props["rating2_image"],
                    ),
                    expected,
                )

    def test_tv_rating_scores_can_be_suppressed_without_hiding_certification(self):
        props = build_hero_properties(
            FakeMedia(
                type="show",
                TYPE="show",
                title="Severance",
                contentRating="TV-MA",
                rating=9.1,
                ratingImage="imdb://image.rating",
                audienceRating=9.0,
                audienceRatingImage="rottentomatoes://image.rating.upright",
            ),
            include_ratings=False,
        )

        self.assertEqual(props["content_rating"], "TV-MA")
        self.assertEqual(props["rating"], "")
        self.assertEqual(props["rating_image"], "")
        self.assertEqual(props["rating2"], "")
        self.assertEqual(props["rating2_image"], "")

    def test_home_rating_preferences_map_movies_series_and_non_video_items(self):
        movie = FakeMedia(
            type="movie",
            TYPE="movie",
            title="The Substance",
            rating=8.6,
            ratingImage="imdb://image.rating",
        )
        episode = FakeMedia(
            type="episode",
            TYPE="episode",
            grandparentTitle="Loki",
            title="Ouroboros",
            rating=8.2,
            ratingImage="imdb://image.rating",
        )
        album = FakeMedia(
            type="album",
            TYPE="album",
            parentTitle="Beth Gibbons",
            title="Lives Outgrown",
            rating=9.9,
            ratingImage="imdb://image.rating",
        )

        self.assertEqual(
            build_home_hero_properties(movie, "movies")["rating"],
            "8.6",
        )
        self.assertEqual(build_home_hero_properties(movie, "series")["rating"], "")
        self.assertEqual(
            build_home_hero_properties(episode, "series")["rating"],
            "8.2",
        )
        self.assertEqual(build_home_hero_properties(episode, "movies")["rating"], "")
        self.assertEqual(
            build_home_hero_properties(album, "movies,series")["rating"],
            "",
        )

    def test_home_spoiler_policy_redacts_episode_details_and_ratings(self):
        episode = FakeMedia(
            type="episode",
            TYPE="episode",
            grandparentTitle="Loki",
            title="Ouroboros",
            summary="OB learns who created the TVA.",
            rating=8.2,
            ratingImage="imdb://image.rating",
            _noSpoilers=True,
        )

        props = build_home_hero_properties(
            episode,
            "series",
            no_titles=True,
            no_summaries=True,
            no_ratings=True,
            spoiler_text="[Spoilers removed]",
        )

        self.assertEqual(props["title"], "Loki")
        self.assertEqual(props["subtitle"], "[Spoilers removed]")
        self.assertEqual(props["summary"], "[Spoilers removed]")
        self.assertEqual(props["short_summary"], "[Spoilers removed]")
        self.assertEqual(props["rating"], "")
        self.assertEqual(props["rating_image"], "")

    def test_home_spoiler_policy_preserves_details_not_selected_for_redaction(self):
        episode = FakeMedia(
            type="episode",
            TYPE="episode",
            grandparentTitle="Loki",
            title="Ouroboros",
            summary="OB learns who created the TVA.",
            rating=8.2,
            ratingImage="imdb://image.rating",
            _noSpoilers=True,
        )

        props = build_home_hero_properties(episode, "series")

        self.assertEqual(props["subtitle"], "Ouroboros")
        self.assertEqual(props["summary"], "OB learns who created the TVA.")
        self.assertEqual(props["rating"], "8.2")

    def test_home_spoiler_controls_are_independent_in_every_combination(self):
        for no_titles in (False, True):
            for no_summaries in (False, True):
                for no_ratings in (False, True):
                    with self.subTest(
                        no_titles=no_titles,
                        no_summaries=no_summaries,
                        no_ratings=no_ratings,
                    ):
                        props = build_home_hero_properties(
                            FakeMedia(
                                type="episode",
                                TYPE="episode",
                                grandparentTitle="Loki",
                                title="Ouroboros",
                                summary="OB learns who created the TVA.",
                                rating=8.2,
                                ratingImage="imdb://image.rating",
                                _noSpoilers=True,
                            ),
                            "series",
                            no_titles=no_titles,
                            no_summaries=no_summaries,
                            no_ratings=no_ratings,
                            spoiler_text="[Spoilers removed]",
                        )

                        self.assertEqual(props["title"], "Loki")
                        self.assertEqual(
                            props["subtitle"],
                            "[Spoilers removed]" if no_titles else "Ouroboros",
                        )
                        self.assertEqual(
                            props["summary"],
                            "[Spoilers removed]" if no_summaries else "OB learns who created the TVA.",
                        )
                        self.assertEqual(props["rating"], "" if no_ratings else "8.2")

    def test_spoiler_preferences_do_not_redact_unprotected_or_non_episode_items(self):
        for media in (
            FakeMedia(
                type="episode",
                TYPE="episode",
                grandparentTitle="Loki",
                title="Ouroboros",
                summary="Episode summary",
                rating=8.2,
                ratingImage="imdb://image.rating",
                _noSpoilers=False,
            ),
            FakeMedia(
                type="movie",
                TYPE="movie",
                title="Alien",
                summary="Movie summary",
                rating=8.5,
                ratingImage="imdb://image.rating",
                _noSpoilers=True,
            ),
        ):
            with self.subTest(media_type=media.type):
                props = build_home_hero_properties(
                    media,
                    "movies,series",
                    no_titles=True,
                    no_summaries=True,
                    no_ratings=True,
                    spoiler_text="[Spoilers removed]",
                )
                self.assertNotEqual(props["summary"], "[Spoilers removed]")
                self.assertNotEqual(props["rating"], "")

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
