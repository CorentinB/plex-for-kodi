from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
TEMPLATES = ROOT / "resources" / "skins" / "Main" / "1080i" / "templates"
TEMPLATE = TEMPLATES / "script-plex-video_player.xml.tpl"
PYTHON = ROOT / "lib" / "windows" / "videoplayer.py"
HARNESS = ROOT / "tools" / "kodi_postplay_harness.py"
GENERATOR = ROOT / "tools" / "generate_tvos_masks.sh"
ON_DECK = TEMPLATES / "includes" / "postplay_ondeck_card_layout.xml.tpl"
RELATED = TEMPLATES / "includes" / "postplay_related_card_layout.xml.tpl"
ROLES = TEMPLATES / "includes" / "role_card_layout.xml.tpl"


class VideoPlayerLayoutContractTests(unittest.TestCase):
    def test_post_play_background_has_a_readability_wash(self):
        source = TEMPLATE.read_text()
        self.assertIn("script.plex/home/tvos-background-wash.png", source)
        self.assertIn('colordiffuse="44000000"', source)

    def test_post_play_art_uses_rounded_masks_and_seam_free_focus_frames(self):
        source = TEMPLATE.read_text()
        on_deck = ON_DECK.read_text()
        related = RELATED.read_text()
        roles = ROLES.read_text()

        self.assertIn('includes/postplay_ondeck_card_layout.xml.tpl', source)
        self.assertIn('includes/postplay_related_card_layout.xml.tpl', source)
        self.assertIn('includes/role_card_layout.xml.tpl', source)
        self.assertIn('<itemlayout width="420">', on_deck)
        self.assertIn('script.plex/landscape-hub-rounded-mask.png', on_deck)
        self.assertIn('script.plex/landscape-hub-rounded-focus.png', on_deck)
        self.assertLess(
            on_deck.index('script.plex/landscape-hub-rounded-focus.png'),
            on_deck.index('$INFO[ListItem.Property(thumb.fallback)]', on_deck.index('<focusedlayout')),
        )
        self.assertIn('<itemlayout width="287">', related)
        self.assertIn('script.plex/poster-home-rounded-mask.png', related)
        self.assertIn('script.plex/poster-home-rounded-focus.png', related)
        self.assertLess(
            related.index('script.plex/poster-home-rounded-focus.png'),
            related.index('$INFO[ListItem.Property(thumb.fallback)]', related.index('<focusedlayout')),
        )
        self.assertIn('<itemlayout width="240">', roles)
        self.assertNotIn('script.plex/buttons/role-selected.png', source)
        self.assertNotIn('script.plex/home/selected.png', ''.join((on_deck, related, roles)))

    def test_post_play_hero_uses_exact_focus_plates_and_subtle_motion(self):
        source = TEMPLATE.read_text()
        generator = GENERATOR.read_text()
        hero = source[:source.index('<control type="grouplist" id="60">')]

        for prefix in ("postplay-previous", "postplay-next"):
            focus = hero.index('script.plex/{}-rounded-focus.png'.format(prefix))
            art = hero.index('script.plex/{}-rounded-mask.png'.format(prefix), focus)
            self.assertLess(focus, art)
        self.assertEqual(hero.count('end="105"'), 2)
        self.assertNotIn('end="110"', hero)
        self.assertNotIn('script.plex/landscape-hub-rounded-outline.png', hero)
        self.assertIn('magick -size 924x518 xc:none', generator)
        self.assertIn('magick -size 944x538 xc:none', generator)
        self.assertIn('magick -size 1074x606 xc:none', generator)
        self.assertIn('magick -size 1094x626 xc:none', generator)

    def test_post_play_hero_uses_blurred_art_and_landscape_fallback(self):
        python = PYTHON.read_text()
        harness = HARNESS.read_text()

        self.assertEqual(python.count("minimum_blur=18"), 2)
        self.assertIn("script.plex/thumb_fallbacks/movie16x9.png", python)
        self.assertIn('"home",\n    "background-fallback.png"', harness)
        self.assertIn("script.plex/thumb_fallbacks/movie16x9.png", harness)

    def test_post_play_does_not_auto_scroll_or_force_uppercase(self):
        source = TEMPLATE.read_text()
        self.assertNotIn("<scroll>true</scroll>", source)
        self.assertNotIn("<autoscroll", source)
        self.assertNotIn("[UPPERCASE]", source)

    def test_post_play_uses_the_shared_left_rail(self):
        source = TEMPLATE.read_text()
        self.assertGreaterEqual(source.count("<posx>160</posx>"), 5)
        self.assertGreaterEqual(source.count("<posx>100</posx>"), 3)
        self.assertGreaterEqual(source.count("<width>1740</width>"), 3)

        self.assertLessEqual(100 + 60 + (3 * 420) + 385, 1840)
        self.assertLessEqual(100 + 60 + (5 * 287) + 244, 1840)
        self.assertLessEqual(100 + 60 + (6 * 240) + 200, 1840)

    def test_post_play_remote_graph_has_no_dead_bottom_target(self):
        source = TEMPLATE.read_text()

        self.assertIn('<onright>102</onright>', source)
        self.assertIn('<onleft>101</onleft>', source)
        self.assertIn('<ondown>400</ondown>', source)
        self.assertIn('<ondown>401</ondown>', source)
        self.assertIn('<ondown>403</ondown>', source)
        self.assertNotIn('<ondown>404</ondown>', source)

    def test_post_play_section_motion_matches_the_real_section_heights(self):
        source = TEMPLATE.read_text()
        python = PYTHON.read_text()

        self.assertIn('end="0,{{ vscale(-360) }}"', source)
        self.assertIn('end="0,{{ vscale(-520) }}"', source)
        self.assertNotIn('<texturenofocus>-</texturenofocus>', source)
        self.assertIn("y -= 360", python)
        self.assertIn("y -= 520", python)

    def test_post_play_requests_art_at_the_exact_visible_card_sizes(self):
        python = PYTHON.read_text()

        self.assertIn("ONDECK_DIM = util.scaleResolution(385, 217)", python)
        self.assertIn("RELATED_DIM = util.scaleResolution(244, 361)", python)
        self.assertIn("ROLES_DIM = util.scaleResolution(200, 200)", python)

    def test_native_post_play_harness_is_local_and_playback_inert(self):
        source = HARNESS.read_text()

        self.assertIn("class DemoPostPlayWindow(VideoPlayerWindow):", source)
        self.assertIn("self.setFocusId(self.NEXT_BUTTON_ID)", source)
        self.assertIn("VideoPlayerWindow.onFocus(self, controlID)", source)
        self.assertIn('setProperty(FOCUS_PROPERTY, str(controlID))', source)
        self.assertIn("kodigui.ControlledWindow.onAction(self, action)", source)
        for forbidden in ("Player.Open", "playVideo(", "requests.", "plex.tv"):
            self.assertNotIn(forbidden, source)

    def test_post_play_focus_and_progress_have_no_legacy_orange(self):
        source = TEMPLATE.read_text()
        for orange in ("FFE5A00D", "FFCC7B19", "FFAC5B00"):
            self.assertNotIn(orange, source)


if __name__ == "__main__":
    unittest.main()
