from __future__ import absolute_import

import os
import unittest


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PREPLAY_TEMPLATE = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "script-plex-pre_play.xml.tpl",
)
PREPLAY_PYTHON = os.path.join(ROOT, "lib", "windows", "preplay.py")
PREPLAY_NAVIGATION = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "includes",
    "preplay_button_navigation.xml.tpl",
)
ROLE_CARD = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "includes",
    "role_card_layout.xml.tpl",
)
WATCHLIST_AVAILABILITY = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "includes",
    "wl_availability.xml.tpl",
)
FRENCH_STRINGS = os.path.join(
    ROOT,
    "resources",
    "language",
    "resource.language.fr_fr",
    "strings.po",
)


def _read(path):
    with open(path, "r") as handle:
        return handle.read()


class PrePlayLayoutContractTests(unittest.TestCase):
    def test_detail_page_uses_a_dedicated_blurred_art_property(self):
        template = _read(PREPLAY_TEMPLATE)
        source = _read(PREPLAY_PYTHON)

        self.assertIn("Window.Property(preplay.background.blurred)", template)
        self.assertIn("blur=18", source)
        self.assertIn("background='000000'", source)

    def test_detail_hero_uses_one_left_grid_without_a_poster_column(self):
        template = _read(PREPLAY_TEMPLATE)

        self.assertGreaterEqual(template.count("<posx>160</posx>"), 7)
        self.assertIn("<font>font60</font>", template)
        self.assertGreaterEqual(template.count("<visible>false</visible>"), 3)

    def test_detail_title_uses_the_full_safe_width_before_the_clock(self):
        template = _read(PREPLAY_TEMPLATE)
        title_label = template.index(
            "<label>$INFO[Window.Property(title)]</label>"
        )
        title_start = template.rindex("<control type=\"label\">", 0, title_label)
        title_end = template.index("</control>", title_start)
        title = template[title_start:title_end]

        self.assertIn("<posx>160</posx>", title)
        self.assertIn("<width>1400</width>", title)
        self.assertIn("<font>font60</font>", title)
        self.assertIn("<scroll>false</scroll>", title)

    def test_detail_summary_is_bounded_and_never_scrolls(self):
        template = _read(PREPLAY_TEMPLATE)

        self.assertIn("Window.Property(summary.short)", template)
        self.assertIn("<autoscroll>false</autoscroll>", template)
        self.assertNotIn('autoscroll delay="2000"', template)

    def test_resume_progress_is_attached_to_the_primary_action(self):
        template = _read(PREPLAY_TEMPLATE)
        source = _read(PREPLAY_PYTHON)

        progress_start = template.index("<!-- RESUME PROGRESS -->")
        progress_end = template.index("<!-- /RESUME PROGRESS -->", progress_start)
        progress = template[progress_start:progress_end]
        source_start = source.index(
            "            self.progressImageControl.setVisible(False)",
            source.index("    def setInfo("),
        )
        source_end = source.index(
            "            if self.video.viewOffset.asInt():",
            source_start,
        )
        progress_source = source[source_start:source_end]

        self.assertIn("<posx>155</posx>", progress)
        self.assertIn("<posy>{{ vscale(479) }}</posy>", progress)
        self.assertIn("<width>220</width>", progress)
        self.assertIn('id="250"', progress)
        self.assertIn("PREPLAY_PROGRESS_WIDTH = 220", source)
        self.assertIn("self.progressImageControl.setVisible(False)", progress_source)
        self.assertIn("self.progressImageControl.setVisible(True)", progress_source)
        self.assertIn("* self.PREPLAY_PROGRESS_WIDTH", progress_source)
        self.assertNotIn("* self.width", progress_source)
        self.assertNotIn("<posx>-1</posx>", template)
        self.assertIn(
            'action_label="$INFO[Window.Property(play.action.label)]"',
            template,
        )
        self.assertIn("action_width=220", template)
        self.assertIn("action_label_width=148", template)
        self.assertIn(
            "self.setProperty('play.action.label', T(32316, 'Resume'))",
            source,
        )
        self.assertIn(
            "self.setProperty('play.action.label', xbmc.getLocalizedString(208))",
            source,
        )

    def test_technical_metadata_uses_individual_badges(self):
        template = _read(PREPLAY_TEMPLATE)
        source = _read(PREPLAY_PYTHON)

        properties = (
            "video.res",
            "video.rendering",
            "video.codec",
            "audio.codec",
            "audio.channels",
        )
        for property_name in properties:
            self.assertIn(
                '<label>$INFO[Window.Property({})]</label>'.format(property_name),
                template,
            )
        self.assertNotIn("meta.technical", source)
        self.assertNotIn("meta.technical", template)

    def test_certification_is_normalized_and_separate_from_primary_metadata(self):
        template = _read(PREPLAY_TEMPLATE)
        source = _read(PREPLAY_PYTHON)

        badge = template.index(
            '<label>$INFO[Window.Property(content.rating)]</label>'
        )
        metadata = template.index(
            '<label>$INFO[Window.Property(meta.primary)]</label>'
        )
        self.assertLess(badge, metadata)
        self.assertIn(
            '<visible>!String.IsEmpty(Window.Property(content.rating))</visible>',
            template,
        )
        self.assertIn('colordiffuse="C0343436"', template)
        self.assertIn(
            "from lib.home_hero import _short_text, normalize_content_rating",
            source,
        )
        self.assertIn(
            "self.setProperty('content.rating', normalize_content_rating(self.video.contentRating))",
            source,
        )

        meta_start = source.index("meta_parts = (")
        meta_end = source.index("self.setProperty('meta.primary'", meta_start)
        meta_source = source[meta_start:meta_end]
        self.assertNotIn("self.getProperty('content.rating')", meta_source)

    def test_watchlist_availability_uses_the_hero_grid_without_marquee(self):
        availability = _read(WATCHLIST_AVAILABILITY)

        self.assertIn("<posx>160</posx>", availability)
        self.assertIn("<posy>{{ vscale(324) }}</posy>", availability)
        self.assertIn("<width>1500</width>", availability)
        self.assertEqual(availability.count("<height>{{ vscale(38) }}</height>"), 3)
        self.assertIn("<font>font10</font>", availability)
        self.assertIn("<scroll>false</scroll>", availability)
        self.assertNotIn("<scroll>true</scroll>", availability)
        self.assertNotIn("<posx>466</posx>", availability)
        self.assertNotIn("<posy>{{ vscale(223) }}</posy>", availability)

        summary_bottom = 169 + 96
        creators_top = 284
        availability_top = 324
        self.assertGreater(creators_top, summary_bottom)
        self.assertGreater(availability_top, creators_top + 30)

    def test_watchlist_availability_uses_an_existing_localized_label(self):
        availability = _read(WATCHLIST_AVAILABILITY)
        strings = _read(FRENCH_STRINGS)
        entry = strings[strings.index('msgctxt "#32308"'):]
        entry = entry[:entry.index("\n\n")]

        self.assertIn("$ADDON[script.plexmod 32308]", availability)
        self.assertIn('msgid "Available"', entry)
        self.assertIn('msgstr "Disponible"', entry)

    def test_detail_actions_use_the_tvos_style(self):
        template = _read(PREPLAY_TEMPLATE)
        button_template = _read(
            os.path.join(
                ROOT,
                "resources",
                "skins",
                "Main",
                "1080i",
                "templates",
                "includes",
                "themed_button.xml.tpl",
            )
        )

        self.assertIn("preplay_style = True", template)
        self.assertIn('$LOCALIZE[208]', button_template)
        self.assertIn(
            'name in ("play", "play_plus", "wait", "upcoming")',
            button_template,
        )
        self.assertIn("script.plex/white-square-6px.png", button_template)
        self.assertNotIn("script.plex/indicators/circle-152.png", button_template)
        self.assertIn('!Control.HasFocus({{ id }})', button_template)
        self.assertIn('<textcolor>FFFFFFFF</textcolor>', button_template)
        self.assertLess(template.index('name="play"'), template.index('name="info"'))

    def test_detail_secondary_actions_are_labelled_rounded_rectangles(self):
        template = _read(PREPLAY_TEMPLATE)
        button_template = _read(
            os.path.join(
                ROOT,
                "resources",
                "skins",
                "Main",
                "1080i",
                "templates",
                "includes",
                "themed_button.xml.tpl",
            )
        )

        start = button_template.index(
            "{% elif preplay_style or episode_style or seasons_style or playlist_style or music_artist_style %}"
        )
        end = button_template.index(
            "{% else %}\n    <animation effect=\"zoom\"",
            start,
        )
        secondary = button_template[start:end]

        self.assertIn("script.plex/white-square-6px.png", secondary)
        self.assertIn("{{ action_label }}", secondary)
        self.assertIn("{{ action_width }}", secondary)
        self.assertIn("{{ action_label_width }}", secondary)
        self.assertNotIn("circle-152.png", secondary)

        action_labels = {
            "info": "$LOCALIZE[29915]",
            "trailer": "$ADDON[script.plexmod 32201]",
            "media": "$ADDON[script.plexmod 35063]",
            "settings": "$ADDON[script.plexmod 35064]",
            "more": "$ADDON[script.plexmod 32307]",
        }
        for name, label in action_labels.items():
            include = template.index('name="{}"'.format(name))
            include_end = template.index("%}", include)
            self.assertIn(label, template[include:include_end])

        self.assertIn("<width>1600</width>", template)

    def test_movie_primary_action_uses_the_rectangular_preplay_style(self):
        template = _read(PREPLAY_TEMPLATE)
        button_template = _read(
            os.path.join(
                ROOT,
                "resources",
                "skins",
                "Main",
                "1080i",
                "templates",
                "includes",
                "themed_button.xml.tpl",
            )
        )

        play_include = template[
            template.index('name="play"'):template.index("%}", template.index('name="play"'))
        ]
        pill_branch = button_template[
            button_template.index('{% if name in ('):
            button_template.index(
                "{% elif preplay_style or episode_style or seasons_style or playlist_style or music_artist_style %}"
            )
        ]

        self.assertIn(
            'action_label="$INFO[Window.Property(play.action.label)]"',
            play_include,
        )
        self.assertIn("action_width=220", play_include)
        self.assertIn("action_label_width=148", play_include)
        self.assertIn("and not preplay_style", pill_branch)

    def test_close_waits_for_related_tasks_before_clearing_the_paginator(self):
        source = _read(PREPLAY_PYTHON)
        close_method = source[
            source.index("    def doClose(self, **kw):"):
            source.index("    def onFirstInit(self):")
        ]
        fill_related = source[
            source.index("    def fillRelated(self):"):
            source.index("    def fillCollections(self):")
        ]

        self.assertLess(
            close_method.index("TasksMixin.doClose(self)"),
            close_method.index("self.relatedPaginator = None"),
        )
        self.assertIn(
            "if not self.relatedPaginator or not self.relatedPaginator.leafCount:",
            fill_related,
        )

    def test_every_tvos_action_has_explicit_remote_navigation(self):
        button_template = _read(
            os.path.join(
                ROOT,
                "resources",
                "skins",
                "Main",
                "1080i",
                "templates",
                "includes",
                "themed_button.xml.tpl",
            )
        )
        navigation = _read(PREPLAY_NAVIGATION)

        self.assertEqual(
            button_template.count(
                '{% include "includes/preplay_button_navigation.xml.tpl" %}'
            ),
            3,
        )
        self.assertIn("<onup>200</onup>", navigation)
        self.assertIn("<ondown>400</ondown>", navigation)
        self.assertIn("id in (302, 2302, 2303, 2304, 2305)", navigation)
        for control_id in (303, 304, 305, 306, 307):
            self.assertIn("id == {}".format(control_id), navigation)
        self.assertIn("id in (308, 309)", navigation)

    def test_watchlist_info_routes_to_the_actual_dynamic_play_state(self):
        navigation = _read(PREPLAY_NAVIGATION)
        start = navigation.index("{% elif id == 304 %}")
        end = navigation.index("{% elif id == 303 %}", start)
        info_routes = navigation[start:end]

        for control_id in (2302, 2303, 2304, 2305):
            self.assertNotIn(
                'condition="Control.IsVisible({})"'.format(control_id),
                info_routes,
            )
        self.assertIn(
            '<onleft condition="!String.IsEmpty(Window.Property(disable_playback)) '
            '+ !String.IsEmpty(Window.Property(wl_availability_checking))">2302</onleft>',
            info_routes,
        )
        self.assertIn(
            '<onleft condition="!String.IsEmpty(Window.Property(disable_playback)) '
            '+ String.IsEmpty(Window.Property(wl_availability_checking)) '
            '+ !String.IsEmpty(Window.Property(wl_availability_multiple))">2303</onleft>',
            info_routes,
        )
        self.assertIn(
            '<onleft condition="!String.IsEmpty(Window.Property(disable_playback)) '
            '+ String.IsEmpty(Window.Property(wl_availability_checking)) '
            '+ String.IsEmpty(Window.Property(wl_availability_multiple)) '
            '+ !String.IsEmpty(Window.Property(wl_availability))">2304</onleft>',
            info_routes,
        )
        self.assertIn(
            '<onleft condition="!String.IsEmpty(Window.Property(disable_playback)) '
            '+ String.IsEmpty(Window.Property(wl_availability_checking)) '
            '+ String.IsEmpty(Window.Property(wl_availability_multiple)) '
            '+ String.IsEmpty(Window.Property(wl_availability))">2305</onleft>',
            info_routes,
        )

    def test_returning_to_actions_restores_the_full_hero(self):
        source = _read(PREPLAY_PYTHON)

        self.assertIn("ACTION_BUTTON_IDS = (", source)
        self.assertIn("HERO_FOCUS_IDS = ACTION_BUTTON_IDS + (", source)
        self.assertIn("elif controlID in self.HERO_FOCUS_IDS:", source)
        self.assertIn("self.setProperty('hub.focus', '')", source)
        self.assertIn("self.setProperty('on.extras', '')", source)

    def test_lower_section_focus_hides_hero_copy_without_hiding_actions(self):
        template = _read(PREPLAY_TEMPLATE)
        start = template.index("<!-- HERO COPY:")
        end = template.index("<!-- /HERO COPY -->", start)
        hero_copy = template[start:end]

        self.assertIn(
            '<animation effect="fade" start="100" end="0" time="140" '
            'condition="!String.IsEmpty(Window.Property(on.extras))">Conditional</animation>',
            hero_copy,
        )
        self.assertNotIn('control type="grouplist" id="300"', hero_copy)
        self.assertLess(template.index('control type="grouplist" id="300"'), start)

    def test_cast_band_has_a_heading_and_fits_seven_faces(self):
        template = _read(PREPLAY_TEMPLATE)
        role_card = _read(ROLE_CARD)

        self.assertIn("$ADDON[script.plexmod 35019]", template)
        self.assertIn(
            '{% include "includes/role_card_layout.xml.tpl" with role_focus_id=400 %}',
            template,
        )
        self.assertIn('<itemlayout width="240">', role_card)
        self.assertIn('<focusedlayout width="240">', role_card)
        self.assertIn("<width>200</width>", role_card)

        first_face_left = 100 + 60
        seventh_face_right = first_face_left + (6 * 240) + 200
        self.assertEqual(first_face_left, 160)
        self.assertEqual(seventh_face_right, 1800)
        self.assertLessEqual(seventh_face_right, 1840)

    def test_cast_focus_is_white_stable_and_composited_behind_portraits(self):
        roles = _read(ROLE_CARD)

        focus = roles.index("script.plex/circle-rounded-focus.png")
        art = roles.index("script.plex/thumb_fallbacks/role.png", focus)
        self.assertLess(focus, art)
        self.assertNotIn("script.plex/buttons/role-selected.png", roles)
        self.assertNotIn("<scroll>true</scroll>", roles)

    def test_review_cards_are_rounded_stable_and_fit_three_complete_cards(self):
        template = _read(PREPLAY_TEMPLATE)
        start = template.index("<!-- REVIEWS -->")
        end = template.index("<!-- /REVIEWS -->", start)
        reviews = template[start:end]

        self.assertIn('<itemlayout width="560">', reviews)
        self.assertIn('<focusedlayout width="560">', reviews)
        self.assertEqual(
            reviews.count("script.plex/review-rounded-surface.png"), 2
        )
        focus = reviews.index("script.plex/review-rounded-focus.png")
        self.assertLess(
            focus,
            reviews.index("script.plex/review-rounded-surface.png", focus),
        )
        self.assertIn("<colordiffuse>F01A1A1C</colordiffuse>", reviews)
        self.assertNotIn("script.plex/white-square-rounded.png", reviews)
        self.assertIn("<autoscroll>false</autoscroll>", reviews)
        self.assertNotIn("autoscroll delay=", reviews)
        self.assertNotIn("script.plex/home/selected.png", reviews)

        first_card_left = 100 + 60
        third_card_right = first_card_left + (2 * 560) + 530
        self.assertEqual(first_card_left, 160)
        self.assertLessEqual(third_card_right, 1840)

    def test_extras_are_four_complete_rounded_landscape_cards(self):
        template = _read(PREPLAY_TEMPLATE)
        source = _read(PREPLAY_PYTHON)
        start = template.index("<!-- EXTRAS -->")
        end = template.index("<!-- /EXTRAS -->", start)
        extras = template[start:end]
        focus = extras.index("script.plex/landscape-hub-rounded-focus.png")

        self.assertIn("<height>{{ vscale(446) }}</height>", extras)
        self.assertIn('<itemlayout width="420">', extras)
        self.assertIn('<focusedlayout width="420">', extras)
        self.assertGreaterEqual(
            extras.count("script.plex/landscape-hub-rounded-mask.png"), 6
        )
        self.assertLess(
            focus,
            extras.index("script.plex/landscape-hub-rounded-mask.png", focus),
        )
        self.assertEqual(
            extras.count(
                "<visible>!String.IsEmpty(ListItem.Property(extra.duration.available))</visible>"
            ),
            2,
        )
        self.assertEqual(
            extras.count("<label>$INFO[ListItem.Property(extra.duration)]</label>"),
            2,
        )
        self.assertNotIn('effect="zoom" start="60"', extras)
        self.assertNotIn("script.plex/home/selected.png", extras)
        self.assertNotIn("<width>244</width>", extras)
        self.assertNotIn("<height>{{ vscale(361) }}</height>", extras)
        self.assertIn("extra_duration = extra.duration and", source)
        self.assertIn("if extra_duration:", source)
        self.assertIn("'extra.duration', extra_duration", source)
        self.assertIn("'extra.duration.available', '1'", source)
        self.assertNotIn(
            "'extra.duration', extra.duration and", source
        )

        first_card_left = 100 + 60
        fourth_card_right = first_card_left + (3 * 420) + 395
        self.assertEqual(first_card_left, 160)
        self.assertLessEqual(fourth_card_right, 1840)

    def test_lower_poster_hubs_share_rounded_white_focus_and_stable_labels(self):
        template = _read(PREPLAY_TEMPLATE)
        sections = (
            ("RELATED", "403"),
            ("COLLECTION HUB 0", "404"),
            ("COLLECTION HUB 1", "405"),
            ("COLLECTION HUB 2", "406"),
        )

        for section_name, control_id in sections:
            start = template.index("<!-- {} -->".format(section_name))
            end = template.index("<!-- /{} -->".format(section_name), start)
            section = template[start:end]
            focus = section.index("script.plex/poster-home-rounded-focus.png")

            self.assertIn('<itemlayout width="287">', section)
            self.assertIn('<focusedlayout width="287">', section)
            self.assertGreaterEqual(
                section.count("script.plex/poster-home-rounded-mask.png"), 6
            )
            self.assertLess(
                focus,
                section.index("script.plex/poster-home-rounded-mask.png", focus),
            )
            self.assertNotIn("script.plex/home/selected.png", section)
            self.assertNotIn(
                "<scroll>Control.HasFocus({})</scroll>".format(control_id),
                section,
            )

    def test_lower_focus_fades_previous_sections_and_uses_section_heights(self):
        template = _read(PREPLAY_TEMPLATE)
        sections = (
            ("ROLES", "0"),
            ("REVIEWS", "1"),
            ("EXTRAS", "2"),
            ("RELATED", "3"),
            ("COLLECTION HUB 0", "4"),
            ("COLLECTION HUB 1", "5"),
        )

        for section_name, threshold in sections:
            start = template.index("<!-- {} -->".format(section_name))
            end = template.index("<!-- /{} -->".format(section_name), start)
            section = template[start:end]
            self.assertIn(
                'effect="fade" start="100" end="0" time="140" '
                'condition="Integer.IsGreater(Window.Property(hub.focus),{})"'.format(
                    threshold
                ),
                section,
            )

        for offset in ("-650", "-446", "-446", "-555", "-555", "-555"):
            self.assertIn(
                '<effect type="slide" end="0,{{{{ vscale({}) }}}}"'.format(
                    offset
                ),
                template,
            )

    def test_preplay_uses_stable_sentence_case_typography(self):
        template = _read(PREPLAY_TEMPLATE)

        self.assertNotIn("[UPPERCASE]", template)
        title_start = template.index('<label>$INFO[Window.Property(title)]</label>')
        title = template[template.rfind('<control type="label">', 0, title_start):title_start]
        self.assertIn('<width>1400</width>', title)
        self.assertIn('<scroll>false</scroll>', title)
        self.assertNotIn('<scroll>true</scroll>', title)

        meta_start = template.index('<label>$INFO[Window.Property(meta.primary)]</label>')
        meta_end = template.index('<control type="grouplist">', meta_start)
        metadata = template[meta_start:meta_end]
        self.assertIn('Window.Property(remainingTime)', metadata)
        self.assertIn('<font>font10</font>', metadata)
        self.assertNotIn('FFE5A00D', metadata)

        for marker in ("REVIEWS", "EXTRAS", "RELATED", "COLLECTION HUB 0", "COLLECTION HUB 1", "COLLECTION HUB 2"):
            start = template.index("<!-- {} -->".format(marker))
            end = template.index("<!-- /{} -->".format(marker), start)
            section = template[start:end]
            self.assertIn('<height>{{ vscale(48) }}</height>', section)
            self.assertIn('<font>font30_title</font>', section)

    def test_every_lower_section_uses_the_same_safe_area_rail(self):
        template = _read(PREPLAY_TEMPLATE)
        sections = (
            ("REVIEWS", "501"),
            ("EXTRAS", "502"),
            ("RELATED", "503"),
            ("COLLECTION HUB 0", "504"),
            ("COLLECTION HUB 1", "505"),
            ("COLLECTION HUB 2", "506"),
        )

        for section_name, control_id in sections:
            start = template.index("<!-- {} -->".format(section_name))
            end = template.index("<!-- /{} -->".format(section_name), start)
            section = template[start:end]
            self.assertIn('<control type="group" id="{}">'.format(control_id), section)
            self.assertIn("<posx>160</posx>", section)
            self.assertIn("<posx>100</posx>", section)
            self.assertIn("<width>1740</width>", section)

        self.assertIn("<posx>155</posx>", template)


if __name__ == "__main__":
    unittest.main()
