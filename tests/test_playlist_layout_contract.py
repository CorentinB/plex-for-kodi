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
    "script-plex-playlist.xml.tpl",
)
ROW = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "includes",
    "playlist_row_layout.xml.tpl",
)
NAVIGATION = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "includes",
    "playlist_button_navigation.xml.tpl",
)
WINDOW = os.path.join(ROOT, "lib", "windows", "playlist.py")


def _read(path):
    with open(path, "r") as handle:
        return handle.read()


class PlaylistLayoutContractTests(unittest.TestCase):
    def test_playlist_uses_blurred_dynamic_art_and_rounded_hero(self):
        template = _read(TEMPLATE)
        window = _read(WINDOW)

        self.assertIn('includes/default_background.xml.tpl', template)
        self.assertIn('script.plex/home/tvos-background-wash.png', template)
        self.assertEqual(template.count('diffuse="script.plex/square-rounded-mask.png"'), 3)
        self.assertIn('def onFocus(self, controlID):', window)
        self.assertIn('elif action in MOVE_ACTIONS', window)
        self.assertIn('self.updateSelectedBackground()', window)
        self.assertIn("mli.setProperty('background', background)", window)

    def test_playlist_split_layout_uses_safe_rails(self):
        template = _read(TEMPLATE)

        self.assertIn('<posx>160</posx>', template)
        self.assertIn('<posx>760</posx>', template)
        self.assertIn('<width>1000</width>', template)
        self.assertIn('<width>950</width>', template)
        self.assertNotIn('FFE5A00D', template)

    def test_playlist_rows_use_white_focus_and_stable_art(self):
        row = _read(ROW)

        self.assertIn('<colordiffuse>F5FFFFFF</colordiffuse>', row)
        self.assertIn('square-rounded-mask.png', row)
        self.assertIn('landscape-search-rounded-mask.png', row)
        self.assertGreaterEqual(row.count('<scroll>false</scroll>'), 4)
        self.assertNotIn('FFE5A00D', row)

    def test_playlist_actions_have_explicit_remote_routes(self):
        template = _read(TEMPLATE)
        navigation = _read(NAVIGATION)

        self.assertIn('playlist_style = True', template)
        self.assertIn('<width>600</width>', template)
        self.assertIn('action_label="$LOCALIZE[208]"', template)
        self.assertIn('action_label="$ADDON[script.plexmod 32935]"', template)
        self.assertIn('action_width=300 & action_label_width=228', template)
        self.assertIn('action_label="$ADDON[script.plexmod 32307]"', template)
        self.assertIn('action_width=130 & action_label_width=58', template)
        self.assertIn('<ondown>101</ondown>', navigation)
        self.assertIn('<onright>101</onright>', navigation)
        self.assertIn('<onleft>301</onleft>', navigation)

    def test_playlist_detail_uses_aligned_heading_visible_actions_and_clean_paging(self):
        template = _read(TEMPLATE)

        self.assertIn('script.plex/square-detail-rounded-plate.png', template)
        plate = template.index('script.plex/square-detail-rounded-plate.png')
        art = template.index('Window.Property(playlist.thumb)', plate)
        self.assertLess(plate, art)
        self.assertIn('playlist_style = True & light_plate = True', template)
        self.assertIn('$ADDON[script.plexmod 35038]', template)
        self.assertIn('<height>{{ vscale(700) }}</height>', template)
        self.assertEqual(
            template.count('Integer.IsGreater(Container(101).NumPages,1)'),
            3,
        )
        self.assertEqual(template.count('script.plex/transparent-6px.png'), 2)
        self.assertNotIn('<textureslidernib>-</textureslidernib>', template)
        self.assertNotIn('<textureslidernibfocus>-</textureslidernibfocus>', template)

    def test_playlist_waits_on_a_focusable_action_while_rows_load(self):
        template = _read(TEMPLATE)
        window = _read(WINDOW)

        self.assertIn('<defaultcontrol>301</defaultcontrol>', template)
        self.assertIn('self.setFocusId(self.PLAYLIST_LIST_ID)', window)
        self.assertIn("'defaultThumb', 'thumb'", window)


if __name__ == "__main__":
    unittest.main()
