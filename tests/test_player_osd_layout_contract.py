from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
TEMPLATES = ROOT / "resources" / "skins" / "Main" / "1080i" / "templates"
SEEK = TEMPLATES / "script-plex-seek_dialog.xml.tpl"
PHOTO = TEMPLATES / "script-plex-photo.xml.tpl"
MUSIC_BUTTONS = TEMPLATES / "includes" / "music_player_buttons.xml.tpl"
THEMED_BUTTON = TEMPLATES / "includes" / "themed_button.xml.tpl"
CONTEXT = ROOT / "lib" / "templating" / "context.py"
SEEK_PYTHON = ROOT / "lib" / "windows" / "seekdialog.py"
MARKER_HARNESS = ROOT / "tools" / "kodi_seek_marker_harness.py"


class PlayerOsdLayoutContractTests(unittest.TestCase):
    def test_modern_osd_has_dedicated_focused_assets(self):
        context = CONTEXT.read_text()
        seek = SEEK.read_text()
        self.assertIn('"focusBase": "script.plex/buttons/player/modern-focused/"', context)
        self.assertGreaterEqual(seek.count("theme.assets.buttons.focusBase"), 12)
        self.assertIn("script.plex/buttons/player/modern-focused/vs10.png", seek)

    def test_osd_uses_a_floating_rounded_control_shelf(self):
        seek = SEEK.read_text()
        self.assertIn('<width>1360</width>', seek)
        self.assertIn('<width>780</width>', seek)
        self.assertIn('colordiffuse="E60B0B0B" border="34"', seek)
        self.assertIn("script.plex/white-square-rounded.png", seek)

    def test_play_left_skips_controls_that_are_not_visible(self):
        seek = SEEK.read_text()
        self.assertIn('<onleft condition="!String.IsEmpty(Window.Property(nav.ffwdrwd))">405</onleft>', seek)
        self.assertIn('!String.IsEmpty(Window.Property(pq.hasprev)) + !String.IsEmpty(Window.Property(nav.prevnext))', seek)
        self.assertIn('String.IsEmpty(Window.Property(pq.hasprev)) | String.IsEmpty(Window.Property(nav.prevnext))', seek)

    def test_seek_previews_and_chapters_are_rounded(self):
        seek = SEEK.read_text()
        self.assertGreaterEqual(seek.count('diffuse="script.plex/landscape-rounded-mask.png"'), 9)
        self.assertGreaterEqual(seek.count("script.plex/landscape-search-rounded-outline.png"), 2)

    def test_osd_focus_and_progress_do_not_fall_back_to_orange(self):
        seek = SEEK.read_text()
        for orange in ("FFE5A00D", "FFCC7B19", "FFAC5B00"):
            self.assertNotIn(orange, seek)

    def test_player_transport_focus_uses_a_subtle_reversible_lift(self):
        themed = THEMED_BUTTON.read_text()
        sources = "".join(
            path.read_text()
            for path in (SEEK, PHOTO, MUSIC_BUTTONS, THEMED_BUTTON)
        )
        self.assertGreaterEqual(sources.count('end="106"'), 4)
        self.assertEqual(themed.count('end="106"'), 3)
        self.assertNotIn('end="108"', themed)
        self.assertNotIn('end="110"', themed)
        self.assertNotIn('end="124"', sources)
        self.assertNotIn('start="124"', sources)
        self.assertNotIn('end="116"', sources)
        self.assertNotIn('start="116"', sources)
        self.assertGreaterEqual(sources.count('reversible="true"'), 4)

    def test_invisible_seek_controls_use_a_real_transparent_texture(self):
        seek = SEEK.read_text()
        self.assertGreaterEqual(seek.count("script.plex/transparent-6px.png"), 8)
        self.assertNotIn('<texturefocus>-</texturefocus>', seek)
        self.assertNotIn('<texturenofocus>-</texturenofocus>', seek)

    def test_skip_marker_is_a_bounded_tvos_pill(self):
        seek = SEEK.read_text()
        marker = seek[seek.index('<!-- SKIP MARKER BUTTON -->'):]
        self.assertIn('<posx>1400</posx>', marker)
        self.assertIn('<posy>{{ vscale(800) }}</posy>', marker)
        self.assertIn('<width>440</width>', marker)
        self.assertIn('<width min="300" max="440">auto</width>', marker)
        self.assertIn('<align>right</align>', marker)
        self.assertIn('<height>{{ vscale(64) }}</height>', marker)
        self.assertIn('end="104"', marker)
        self.assertIn('border="22">script.plex/white-square-rounded.png', marker)
        self.assertIn('<pulseonselect>false</pulseonselect>', marker)
        self.assertNotIn('end="110,120"', marker)
        self.assertNotIn('buttons/blank-focus.png', marker)

    def test_osd_title_rail_is_stable_safe_and_localized(self):
        seek = SEEK.read_text()
        python = SEEK_PYTHON.read_text()
        title_rail = seek[seek.index('<posy>{{ vscale(40) }}</posy>'):seek.index('<posy>{{ vscale(115) }}r</posy>')]
        self.assertEqual(title_rail.count('<scroll>false</scroll>'), 3)
        self.assertNotIn('<scroll>true</scroll>', title_rail)
        self.assertIn('Window.Property(ep.season)', title_rail)
        self.assertIn('Window.Property(ep.episode)', title_rail)
        self.assertNotIn('&#8226; Season ', title_rail)
        self.assertNotIn('Episode ]', title_rail)
        self.assertIn("T(32303, 'Season {}')", python)
        self.assertIn("T(32304, 'Episode {}')", python)

    def test_seek_marker_harness_is_inert_and_uses_production_xml(self):
        harness = MARKER_HARNESS.read_text()
        self.assertIn('xmlFile = "script-plex-seek_dialog.xml"', harness)
        self.assertIn('class SeekMarkerHarness(kodigui.BaseDialog)', harness)
        self.assertIn('self.setProperty("show.markerSkip", "1")', harness)
        self.assertIn('self.setProperty("show.OSD", "1")', harness)
        self.assertIn('focus_id = 406', harness)
        self.assertIn('"Passer le générique (10)"', harness)
        self.assertIn("# The production button is deliberately inert", harness)
        self.assertNotIn("Player.Open", harness)
        self.assertNotIn("doSeek", harness)


if __name__ == "__main__":
    unittest.main()
