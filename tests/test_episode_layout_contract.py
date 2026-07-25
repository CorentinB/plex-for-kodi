from __future__ import absolute_import

import os
import unittest


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
EPISODES_TEMPLATE = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "script-plex-episodes.xml.tpl",
)
EPISODES_PYTHON = os.path.join(ROOT, "lib", "windows", "episodes.py")
EPISODE_CARD = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "includes",
    "episode_card_layout.xml.tpl",
)
EPISODE_NAVIGATION = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "includes",
    "episode_button_navigation.xml.tpl",
)
THEMED_BUTTON = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "includes",
    "themed_button.xml.tpl",
)
EPISODE_EXTRAS = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "includes",
    "episode_extra_card_layout.xml.tpl",
)
EPISODE_RELATED = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "includes",
    "episode_related_card_layout.xml.tpl",
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
MASK_GENERATOR = os.path.join(ROOT, "tools", "generate_tvos_masks.sh")


def _read(path):
    with open(path, "r") as handle:
        return handle.read()


class EpisodeLayoutContractTests(unittest.TestCase):
    def test_episode_view_has_a_dedicated_blurred_background_with_fallback(self):
        template = _read(EPISODES_TEMPLATE)
        source = _read(EPISODES_PYTHON)

        self.assertIn('includes/default_background.xml.tpl', template)
        self.assertIn('Window.Property(episodes.background.blurred)', template)
        self.assertIn("blur=18", source)
        self.assertIn("background='000000'", source)

    def test_episode_actions_use_tvos_buttons_in_play_first_order(self):
        template = _read(EPISODES_TEMPLATE)

        self.assertEqual(template.count("episode_style = True"), 2)
        first_group = template[template.index('id="300"'):template.index('</control>', template.index('id="1300"'))]
        self.assertLess(first_group.index('name="play"'), first_group.index('name="info"'))
        self.assertIn('<posx>155</posx>', first_group)
        self.assertIn('<itemgap>14</itemgap>', first_group)

    def test_episode_actions_are_labelled_rectangles(self):
        template = _read(EPISODES_TEMPLATE)
        buttons = _read(THEMED_BUTTON)

        self.assertIn(
            "{% elif preplay_style or episode_style or seasons_style or playlist_style or music_artist_style %}",
            buttons,
        )
        for group_id in (300, 1300):
            start = template.index(
                '<control type="grouplist" id="{}">'.format(group_id)
            )
            end = template.index("{% endwith %}", start)
            self.assertIn("<width>1600</width>", template[start:end])
        self.assertNotIn('action_label="$LOCALIZE[208]"', template)
        self.assertEqual(template.count('action_label="$LOCALIZE[29915]"'), 2)
        self.assertEqual(
            template.count('action_label="$ADDON[script.plexmod 35064]"'),
            2,
        )
        self.assertEqual(
            template.count('action_label="$ADDON[script.plexmod 32307]"'),
            2,
        )
        self.assertEqual(
            template.count('action_label="$ADDON[script.plexmod 32935]"'),
            2,
        )
        self.assertEqual(
            template.count("action_width=300 & action_label_width=228"),
            2,
        )

    def test_episode_primary_action_tracks_resume_state(self):
        template = _read(EPISODES_TEMPLATE)
        source = _read(EPISODES_PYTHON)
        set_progress = source.split("    def setProgress(self, mli, view_offset=None):", 1)[1]
        set_progress = set_progress.split("    def createListItem(self, episode):", 1)[0]

        self.assertEqual(
            template.count(
                'action_label="$INFO[Window.Property(play.action.label)]"'
            ),
            4,
        )
        self.assertEqual(
            template.count("action_width=220 & action_label_width=148"),
            4,
        )
        self.assertIn(
            "T(32316, 'Resume') if view_offset else xbmc.getLocalizedString(208)",
            set_progress,
        )

    def test_episode_actions_have_an_explicit_dpad_graph(self):
        navigation = _read(EPISODE_NAVIGATION)

        self.assertIn('<onup>200</onup>', navigation)
        self.assertIn('<ondown>400</ondown>', navigation)
        for control_id in (301, 302, 303, 304, 305, 306):
            self.assertIn(str(control_id), navigation)
        for control_id in (1301, 1302, 1303, 1304, 1305, 1306, 1307):
            self.assertIn(str(control_id), navigation)

    def test_episode_cards_are_rounded_and_use_restrained_white_focus(self):
        template = _read(EPISODES_TEMPLATE)
        card = _read(EPISODE_CARD)

        self.assertIn('<itemlayout width="420">', card)
        self.assertIn('<focusedlayout width="420">', card)
        self.assertGreaterEqual(card.count('diffuse="script.plex/landscape-hub-rounded-mask.png"'), 6)
        self.assertIn('end="106"', card)
        focus = card.index('script.plex/landscape-hub-rounded-focus.png')
        art = card.index('$INFO[ListItem.Property(thumb.fallback)]', focus)
        self.assertLess(focus, art)
        self.assertNotIn('script.plex/white-outline-rounded.png', card)
        self.assertNotIn('$INFO[ListItem.Label]', card)
        self.assertNotIn('$INFO[ListItem.Label2]', card)

        episode_section_start = template.index('<!-- EPISODES -->')
        episode_section_end = template.index('<!-- Seasons -->', episode_section_start)
        episode_section = template[episode_section_start:episode_section_end]
        self.assertIn('<height>{{ vscale(330) }}</height>', episode_section)
        self.assertIn('<height>{{ vscale(320) }}</height>', episode_section)
        self.assertNotIn('script.plex/home/selected.png', card)
        self.assertNotIn('<scroll>Control.HasFocus(400)</scroll>', card)

    def test_episode_hero_and_seasons_use_exact_solid_rounding_assets(self):
        template = _read(EPISODES_TEMPLATE)
        generator = _read(MASK_GENERATOR)

        self.assertEqual(template.count('script.plex/episode-hero-rounded-mask.png'), 2)
        seasons_start = template.index('<!-- Seasons -->')
        seasons_end = template.index('<!-- ROLES -->', seasons_start)
        seasons = template[seasons_start:seasons_end]
        self.assertGreaterEqual(seasons.count('script.plex/poster-season-rounded-mask.png'), 4)
        focus = seasons.index('script.plex/poster-season-rounded-focus.png')
        art = seasons.index('$INFO[ListItem.Property(thumb.fallback)]', focus)
        self.assertLess(focus, art)
        self.assertNotIn('script.plex/white-outline-rounded.png', seasons)
        self.assertNotIn('<scroll>Control.HasFocus(401)</scroll>', seasons)
        self.assertIn(
            'start="100" end="106" time="110" center="84,{{ vscale(123) }}" '
            'reversible="true" condition="Control.HasFocus(401)">Conditional</animation>',
            seasons,
        )
        self.assertNotIn('start="100" end="105"', seasons)
        self.assertNotIn('start="106" end="100"', seasons)
        for asset in (
            'episode-hero-rounded-mask.png',
            'poster-season-rounded-mask.png',
            'poster-season-rounded-focus.png',
        ):
            self.assertIn(asset, generator)

    def test_episode_extras_and_related_use_complete_exact_rails(self):
        template = _read(EPISODES_TEMPLATE)
        extras = _read(EPISODE_EXTRAS)
        related = _read(EPISODE_RELATED)

        self.assertIn('includes/episode_extra_card_layout.xml.tpl', template)
        self.assertIn('includes/episode_related_card_layout.xml.tpl', template)
        self.assertIn('<itemlayout width="420">', extras)
        self.assertIn('<focusedlayout width="420">', extras)
        self.assertGreaterEqual(extras.count('script.plex/landscape-hub-rounded-mask.png'), 4)
        extras_focus = extras.index('script.plex/landscape-hub-rounded-focus.png')
        extras_art = extras.index('$INFO[ListItem.Property(thumb.fallback)]', extras_focus)
        self.assertLess(extras_focus, extras_art)
        self.assertNotIn('script.plex/home/selected.png', extras)
        self.assertNotIn('<scroll>Control.HasFocus(403)</scroll>', extras)
        self.assertIn('<itemlayout width="287">', related)
        self.assertIn('<focusedlayout width="287">', related)
        self.assertGreaterEqual(related.count('script.plex/poster-home-rounded-mask.png'), 4)
        related_focus = related.index('script.plex/poster-home-rounded-focus.png')
        related_art = related.index('$INFO[ListItem.Property(thumb.fallback)]', related_focus)
        self.assertLess(related_focus, related_art)
        self.assertNotIn('script.plex/home/selected.png', related)
        self.assertNotIn('<scroll>Control.HasFocus(404)</scroll>', related)

    def test_every_episode_lower_section_uses_the_safe_area_rail(self):
        template = _read(EPISODES_TEMPLATE)

        for control_id in (500, 501, 502, 503, 504):
            start = template.index('<control type="group" id="{}">'.format(control_id))
            next_start = template.find('<control type="group" id="{}">'.format(control_id + 1), start + 1)
            section = template[start:next_start if next_start != -1 else len(template)]
            self.assertIn('<posx>160</posx>', section)
            self.assertIn('<posx>100</posx>', section)
            self.assertIn('<width>1740</width>', section)

    def test_returning_to_episode_actions_restores_the_hero(self):
        source = _read(EPISODES_PYTHON)

        self.assertIn('ACTION_BUTTON_IDS = (', source)
        self.assertIn('HERO_FOCUS_IDS = ACTION_BUTTON_IDS + (', source)
        self.assertIn('elif controlID in self.HERO_FOCUS_IDS:', source)
        self.assertIn("self.setProperty('hub.focus', '')", source)
        self.assertIn("self.setProperty('on.extras', '')", source)

    def test_episode_streams_use_fixed_non_marquee_columns(self):
        template = _read(EPISODES_TEMPLATE)
        start = template.index('<posy>{{ vscale(263) }}</posy>')
        end = template.index('<control type="textbox">', start)
        stream_row = template[start:end]

        self.assertIn('<width>500</width>', stream_row)
        self.assertIn('<posx>1280</posx>', stream_row)
        self.assertIn('<width>544</width>', stream_row)
        self.assertIn('<width>360</width>', stream_row)
        self.assertIn('<width>330</width>', stream_row)
        self.assertEqual(stream_row.count('<scroll>false</scroll>'), 2)
        self.assertNotIn('<scroll>true</scroll>', stream_row)
        self.assertNotIn('<width>1360</width>', stream_row)

    def test_episode_summary_has_a_bounded_row_below_the_actions(self):
        template = _read(EPISODES_TEMPLATE)
        summary_label = (
            "<label>$INFO[Container(400).ListItem.Property(summary)]</label>"
        )
        summary_end = template.index(summary_label) + len(summary_label)
        summary_start = template.rfind(
            '<control type="textbox">', 0, summary_end
        )
        summary = template[summary_start:summary_end]

        self.assertIn("<posy>{{ vscale(420) }}</posy>", summary)
        self.assertIn("<height>{{ vscale(110) }}</height>", summary)
        self.assertLess(315 + 90, 420)
        self.assertLess(420 + 110, 565)

    def test_episode_ratings_share_the_primary_facts_rail(self):
        template = _read(EPISODES_TEMPLATE)
        facts_label = template.index(
            "<label>$INFO[Container(400).ListItem.Property(duration)]"
        )
        facts_start = template.rindex(
            '<control type="grouplist">', 0, facts_label
        )
        facts_end = template.index(
            '<control type="grouplist">', facts_label
        )
        facts = template[facts_start:facts_end]

        rating = facts.index(
            "$INFO[Container(400).ListItem.Property(rating)]"
        )
        technical = facts.index(
            "$INFO[Container(400).ListItem.Property(video.res)]"
        )
        self.assertLess(rating, technical)
        self.assertIn(
            "$INFO[Container(400).ListItem.Property(rating2)]", facts
        )
        self.assertIn(
            "$INFO[Container(400).ListItem.Property(rating.stars)]", facts
        )
        self.assertNotIn("<posx>1560</posx>", template)
        self.assertNotIn("<posx>1726</posx>", template)

    def test_episode_metadata_and_section_titles_use_sentence_case(self):
        template = _read(EPISODES_TEMPLATE)
        source = _read(EPISODES_PYTHON)

        self.assertNotIn('[UPPERCASE]', template)
        self.assertIn('ListItem.Property(creators)', template)
        self.assertIn("mli.setProperty('creators', u'    \\u2022    '.join(creators))", source)
        self.assertNotIn("T(32383, u'DIRECTOR').upper()", source)
        self.assertNotIn("T(32402, u'WRITER').upper()", source)
        for label in ('episodes.header', 'seasons.header', 'extras.header', 'related.header'):
            self.assertIn('<label>$INFO[Window.Property({})]</label>'.format(label), template)

    def test_episode_lower_focus_fades_departed_rows_and_uses_section_heights(self):
        template = _read(EPISODES_TEMPLATE)

        hero_start = template.index('{% block buttons %}')
        lower_start = template.index('<!-- EPISODES -->', hero_start)
        hero = template[hero_start:lower_start]
        self.assertEqual(
            hero.count(
                'effect="fade" start="100" end="0" time="140" '
                'condition="Integer.IsGreater(Window.Property(hub.focus),0)"'
            ),
            3,
        )

        for control_id, threshold in ((500, 0), (501, 1), (502, 2), (503, 3), (504, 4)):
            start = template.index('<control type="group" id="{}">'.format(control_id))
            next_start = template.find('<control type="group" id="{}">'.format(control_id + 1), start + 1)
            section = template[start:next_start if next_start != -1 else len(template)]
            self.assertIn(
                'effect="fade" start="100" end="0" time="140" '
                'condition="Integer.IsGreater(Window.Property(hub.focus),{})"'.format(threshold),
                section,
            )

        for offset in ('-330', '-380', '-400', '-360'):
            self.assertIn(
                '<effect type="slide" end="0,{{{{ vscale({}) }}}}"'.format(offset),
                template,
            )

    def test_episode_cast_uses_a_stable_white_focus_plate(self):
        template = _read(EPISODES_TEMPLATE)
        roles = _read(ROLE_CARD)

        self.assertIn(
            '{% include "includes/role_card_layout.xml.tpl" with role_focus_id=402 %}',
            template,
        )
        self.assertIn('<itemlayout width="240">', roles)
        self.assertIn('<focusedlayout width="240">', roles)
        focus = roles.index("script.plex/circle-rounded-focus.png")
        art = roles.index("script.plex/thumb_fallbacks/role.png", focus)
        self.assertLess(focus, art)
        self.assertNotIn("script.plex/buttons/role-selected.png", roles)
        self.assertNotIn("<scroll>true</scroll>", roles)

        first_face_left = 100 + 60
        seventh_face_right = first_face_left + (6 * 240) + 200
        self.assertEqual(seventh_face_right, 1800)
        self.assertLessEqual(seventh_face_right, 1840)


if __name__ == "__main__":
    unittest.main()
