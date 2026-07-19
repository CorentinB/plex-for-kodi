from __future__ import absolute_import

import os
import unittest


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TEMPLATE = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "script-plex-playlists.xml.tpl",
)
WINDOW = os.path.join(ROOT, "lib", "windows", "playlists.py")
MASK_GENERATOR = os.path.join(ROOT, "tools", "generate_tvos_masks.sh")


def _read(path):
    with open(path, "r") as handle:
        return handle.read()


class PlaylistsLayoutContractTests(unittest.TestCase):
    def test_playlists_use_dynamic_art_with_tvos_fallback_stack(self):
        template = _read(TEMPLATE)
        window = _read(WINDOW)

        self.assertIn('includes/default_background.xml.tpl', template)
        self.assertIn('script.plex/home/tvos-background-wash.png', template)
        self.assertIn("def onFocus(self, controlID):", window)
        self.assertIn('elif action in MOVE_ACTIONS:', window)
        self.assertIn('self.updateSelectedBackground(self.getFocusId())', window)
        self.assertIn("mli.setProperty('background', background)", window)
        self.assertNotIn('playlists[0]', window)

    def test_playlist_rows_share_safe_rails_and_complete_card_counts(self):
        template = _read(TEMPLATE)

        self.assertEqual(template.count('<posx>160</posx>'), 3)
        self.assertEqual(template.count('<posx>100</posx>'), 2)
        self.assertEqual(template.count('<width>1740</width>'), 2)
        self.assertIn('<itemlayout width="287">', template)
        self.assertIn('<itemlayout width="550">', template)
        self.assertNotIn('[UPPERCASE]', template)

    def test_audio_and_video_art_keep_matched_rounding(self):
        template = _read(TEMPLATE)
        generator = _read(MASK_GENERATOR)

        self.assertEqual(
            template.count('diffuse="script.plex/square-rounded-mask.png"'),
            4,
        )
        self.assertEqual(template.count('diffuse="script.plex/episode-hero-rounded-mask.png"'), 4)
        self.assertEqual(template.count('script.plex/square-playlist-rounded-focus.png'), 1)
        self.assertEqual(template.count('script.plex/landscape-playlist-rounded-focus.png'), 1)
        self.assertNotIn('script.plex/square-rounded-outline.png', template)
        self.assertNotIn('script.plex/landscape-hub-rounded-outline.png', template)
        self.assertIn('magick -size 496x496 xc:none', generator)
        self.assertIn('magick -size 1060x606 xc:none', generator)
        self.assertEqual(template.count('end="106"'), 2)
        self.assertNotIn('script.plex/home/selected.png', template)

    def test_video_playlist_cards_fit_three_complete_items_on_the_safe_rail(self):
        template = _read(TEMPLATE)

        self.assertIn('<itemlayout width="550">', template)
        self.assertIn('<focusedlayout width="550">', template)
        self.assertEqual(template.count('<width>520</width>'), 8)
        self.assertEqual(template.count('<height>{{ vscale(293) }}</height>'), 4)
        self.assertLessEqual(100 + 35 + 25 + (2 * 550) + 520, 1800)
        self.assertLessEqual(100 + 35 + 20 + (2 * 550) + 530, 1800)

    def test_playlist_focus_plates_render_before_inset_art(self):
        template = _read(TEMPLATE)

        audio_plate = template.index('script.plex/square-playlist-rounded-focus.png')
        audio_art = template.index('ListItem.Property(thumb.fallback)', audio_plate)
        video_plate = template.index('script.plex/landscape-playlist-rounded-focus.png')
        video_art = template.index('ListItem.Property(thumb.fallback)', video_plate)
        self.assertLess(audio_plate, audio_art)
        self.assertLess(video_plate, video_art)

    def test_playlist_titles_do_not_marquee(self):
        template = _read(TEMPLATE)

        self.assertEqual(template.count('<scroll>false</scroll>'), 8)
        self.assertNotIn('<scroll>Control.HasFocus', template)

    def test_empty_playlist_rows_do_not_trap_remote_focus(self):
        template = _read(TEMPLATE)

        self.assertIn(
            '<ondown condition="!Integer.IsGreater(Container(301).NumItems,0)">101</ondown>',
            template,
        )
        self.assertIn(
            '<onup condition="!Integer.IsGreater(Container(101).NumItems,0)">200</onup>',
            template,
        )


if __name__ == "__main__":
    unittest.main()
