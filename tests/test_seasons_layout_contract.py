from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
TEMPLATES = ROOT / "resources" / "skins" / "Main" / "1080i" / "templates"
SEASONS = TEMPLATES / "script-plex-seasons.xml.tpl"
BUTTONS = TEMPLATES / "includes" / "themed_button.xml.tpl"
NAVIGATION = TEMPLATES / "includes" / "seasons_button_navigation.xml.tpl"
POSTERS = TEMPLATES / "includes" / "show_poster_card_layout.xml.tpl"
ROLES = TEMPLATES / "includes" / "show_role_card_layout.xml.tpl"
LANDSCAPE = TEMPLATES / "includes" / "show_landscape_card_layout.xml.tpl"
PYTHON = ROOT / "lib" / "windows" / "subitems.py"


class SeasonsLayoutContractTests(unittest.TestCase):
    def test_show_hero_uses_blurred_art_and_a_poster_free_safe_rail(self):
        template = SEASONS.read_text()
        source = PYTHON.read_text()

        self.assertIn("Window.Property(seasons.background.blurred)", template)
        self.assertIn("script.plex/home/tvos-background-wash.png", template)
        self.assertIn("self.mediaItem.defaultArt or self.mediaItem.defaultThumb", source)
        self.assertIn("self.setProperty('seasons.background.blurred'", source)
        self.assertIn("<font>font60</font>", template)
        self.assertGreaterEqual(template.count("<posx>160</posx>"), 5)
        self.assertNotIn("Window.Property(thumb)", template)

    def test_show_summary_and_metadata_are_bounded_and_stable(self):
        template = SEASONS.read_text()
        source = PYTHON.read_text()

        self.assertIn("Window.Property(summary.short)", template)
        self.assertIn("<autoscroll>false</autoscroll>", template)
        self.assertIn("_short_text(summary, limit=180)", source)
        self.assertIn("Window.Property(creator.label)", template)
        self.assertIn("Window.Property(creator.name)", template)
        self.assertIn("Window.Property(cast.names)", template)
        self.assertNotIn("[UPPERCASE]", template)
        self.assertNotIn("<scroll>true</scroll>", template)
        self.assertNotIn("creator_label.upper()", source)
        self.assertNotIn("T(32419, 'Cast').upper()", source)

    def test_show_sections_share_the_movie_and_episode_heading_hierarchy(self):
        template = SEASONS.read_text()

        self.assertEqual(template.count("<font>font30_title</font>"), 4)
        self.assertNotIn("<font>font_title</font>", template)
        self.assertIn("$ADDON[script.plexmod 35019]", template)
        self.assertEqual(template.count("$ADDON[script.plexmod 32419]"), 1)

    def test_show_scroll_hides_departed_hero_and_rails(self):
        template = SEASONS.read_text()

        for focus_index in range(3):
            fade = (
                '<animation effect="fade" start="100" end="0" time="140" '
                'condition="Integer.IsGreater(Window.Property(hub.focus),{})">Conditional</animation>'
            ).format(focus_index)
            self.assertIn(fade, template)
        self.assertGreaterEqual(
            template.count("Integer.IsGreater(Window.Property(hub.focus),0)"),
            2,
        )

    def test_zero_watch_progress_does_not_leave_a_white_pixel_at_the_left_edge(self):
        source = PYTHON.read_text()

        self.assertIn("self.progressImageControl.setVisible(False)", source)
        self.assertIn("if wBase > 0:", source)
        self.assertIn("self.progressImageControl.setVisible(True)", source)
        self.assertNotIn("width = (int(wBase * self.width)) or 1", source)

    def test_show_actions_are_play_first_and_have_explicit_remote_routes(self):
        template = SEASONS.read_text()
        buttons = BUTTONS.read_text()
        navigation = NAVIGATION.read_text()

        self.assertIn("seasons_style = True", template)
        self.assertLess(template.index('name="play"'), template.index('name="info"'))
        self.assertIn("or seasons_style", buttons)
        self.assertEqual(
            buttons.count('{% include "includes/seasons_button_navigation.xml.tpl" %}'),
            3,
        )
        self.assertIn("<ondown>400</ondown>", navigation)
        for control_id in (301, 302, 303, 304, 308, 309, 2302, 2303, 2304, 2305):
            self.assertIn(str(control_id), navigation)

    def test_show_actions_are_labelled_rectangles(self):
        template = SEASONS.read_text()
        buttons = BUTTONS.read_text()

        self.assertIn(
            "{% elif preplay_style or episode_style or seasons_style or playlist_style or music_artist_style %}",
            buttons,
        )
        self.assertIn("<width>1600</width>", template)
        for label in (
            'action_label="$LOCALIZE[208]"',
            'action_label="$LOCALIZE[29915]"',
            'action_label="$ADDON[script.plexmod 32935]"',
            'action_label="$ADDON[script.plexmod 32307]"',
        ):
            self.assertIn(label, template)
        self.assertIn("action_width=300 & action_label_width=228", template)

    def test_every_lower_show_section_uses_the_same_rail_and_rounded_art(self):
        template = SEASONS.read_text()
        poster = POSTERS.read_text()
        roles = ROLES.read_text()
        landscape = LANDSCAPE.read_text()

        for section_name, control_id, list_id in (
            ("SEASONS", 500, 400),
            ("ROLES", 501, 401),
            ("EXTRAS", 502, 402),
            ("RELATED", 503, 403),
        ):
            start = template.index("<!-- {} -->".format(section_name))
            end = template.index("<!-- /{} -->".format(section_name), start)
            section = template[start:end]
            self.assertIn('<control type="group" id="{}">'.format(control_id), section)
            self.assertIn('<control type="list" id="{}">'.format(list_id), section)
            self.assertIn("<posx>160</posx>", section)
            self.assertIn("<posx>100</posx>", section)

        self.assertIn("script.plex/poster-rounded-mask.png", poster)
        self.assertIn("script.plex/poster-medium-rounded-focus.png", poster)
        self.assertNotIn("script.plex/poster-medium-rounded-outline.png", poster)
        self.assertIn("<posx>-5</posx>", poster)
        self.assertIn("<posy>{{ vscale(-5) }}</posy>", poster)
        self.assertIn("<width>254</width>", poster)
        self.assertIn("<height>{{ vscale(364) }}</height>", poster)
        self.assertIn("<height>{{ vscale(374) }}</height>", poster)
        self.assertNotIn("<height>{{ vscale(372) }}</height>", poster)
        self.assertNotIn("+ (", poster)
        self.assertIn("script.plex/masks/role.png", roles)
        self.assertIn('<itemlayout width="240">', roles)
        self.assertIn('<focusedlayout width="240">', roles)
        focus = roles.index("script.plex/circle-rounded-focus.png")
        art = roles.index("script.plex/thumb_fallbacks/role.png", focus)
        self.assertLess(focus, art)
        self.assertNotIn("script.plex/circle-rounded-outline.png", roles)
        self.assertLessEqual(100 + 60 + (6 * 240) + 200, 1840)
        self.assertEqual(
            landscape.count("script.plex/landscape-search-rounded-mask.png"),
            4,
        )
        focus = landscape.index("script.plex/landscape-search-rounded-focus.png")
        art = landscape.index("$INFO[ListItem.Property(thumb.fallback)]", focus)
        self.assertLess(focus, art)
        self.assertIn("<posx>-5</posx>", landscape)
        self.assertIn("<posy>{{ vscale(-5) }}</posy>", landscape)
        self.assertIn("<width>310</width>", landscape)
        self.assertIn("<height>{{ vscale(179) }}</height>", landscape)
        self.assertIn(
            'start="100" end="106" time="110" center="150,{{ vscale(84.5) }}" '
            'reversible="true" condition="Control.HasFocus(402)">Conditional</animation>',
            landscape,
        )
        self.assertNotIn("script.plex/landscape-hub-rounded-outline.png", landscape)
        self.assertNotIn('reversible="false">Focus</animation>', landscape)
        self.assertNotIn('reversible="false">UnFocus</animation>', landscape)

    def test_show_surface_does_not_reintroduce_legacy_orange(self):
        source = "".join(
            path.read_text()
            for path in (SEASONS, NAVIGATION, POSTERS, ROLES, LANDSCAPE)
        )
        for orange in ("FFE5A00D", "FFCC7B19", "FFAC5B00"):
            self.assertNotIn(orange, source)


if __name__ == "__main__":
    unittest.main()
