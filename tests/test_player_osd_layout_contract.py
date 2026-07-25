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

    def test_osd_uses_an_unframed_hierarchical_transport_rail(self):
        seek = SEEK.read_text()
        transport = seek[seek.index('<control type="group" id="801">'):seek.index('<control type="group" id="500">')]
        self.assertNotIn('<width>1360</width>', transport)
        self.assertNotIn('<width>780</width>', transport)
        self.assertNotIn('colordiffuse="E60B0B0B" border="34"', transport)
        self.assertIn('<control type="group" id="423">', transport)
        self.assertIn('<control type="group" id="425">', transport)
        self.assertEqual(transport.count('<width>38</width>'), 2)
        self.assertIn('<itemgap>-26</itemgap>', transport)

    def test_osd_names_the_focused_action_without_permanent_button_labels(self):
        seek = SEEK.read_text()
        labels = seek[seek.index('<control type="group" id="440">'):seek.index('<control type="grouplist" id="400">')]
        for control_id in (401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 412, 413):
            self.assertIn('Control.HasFocus({})'.format(control_id), labels)
        self.assertIn('$ADDON[script.plexmod 32925]', labels)
        self.assertIn('$ADDON[script.plexmod 32396]', labels)
        self.assertIn('$ADDON[script.plexmod 35036]', labels)
        self.assertIn('$LOCALIZE[36044]', labels)
        self.assertIn('$LOCALIZE[36045]', labels)

    def test_custom_player_dialog_is_the_only_visible_osd_layer(self):
        seek = SEEK.read_text()
        python = SEEK_PYTHON.read_text()
        dialog_guard = 'String.IsEmpty(Window.Property(dialog.visible))'

        self.assertGreaterEqual(seek.count(dialog_guard), 2)

        handle_dialog = python[
            python.index("    def handleDialog(self, func):"):
            python.index("    def videoSettingsHaveChanged(self):")
        ]
        self.assertIn("self.setBoolProperty('dialog.visible', True)", handle_dialog)
        self.assertIn("self.setBoolProperty('dialog.visible', False)", handle_dialog)

    def test_osd_keeps_time_progress_action_and_transport_in_separate_bands(self):
        seek = SEEK.read_text()
        action_labels = seek[
            seek.index('<control type="group" id="440">'):
            seek.index('<control type="grouplist" id="400">')
        ]
        self.assertIn('<posy>{{ vscale(288) }}r</posy>', seek)
        self.assertIn('<posy>{{ vscale(190) }}r</posy>', seek)
        self.assertIn('<posy>592</posy>', seek)
        self.assertIn('<posx>60</posx>', action_labels)
        self.assertIn('<posy>{{ vscale(92) }}</posy>', action_labels)
        self.assertGreaterEqual(action_labels.count('<width>1580</width>'), 12)
        self.assertGreaterEqual(action_labels.count('<align>left</align>'), 12)
        self.assertIn('<posy>{{ vscale(146) }}r</posy>', seek)
        self.assertIn('BAR_Y = 856', SEEK_PYTHON.read_text())
        self.assertIn('BAR_BOTTOM = 919', SEEK_PYTHON.read_text())

    def test_seek_preview_stays_above_the_subtitle_safe_area(self):
        seek = SEEK.read_text()
        python = SEEK_PYTHON.read_text()

        self.assertIn('<control type="group" id="300">', seek)
        self.assertIn('<posy>592</posy>', seek)
        self.assertIn('BIF_IMAGE_Y = 592', python)
        self.assertIn(
            'self.bifImageControl.setPosition(bifx, self.BIF_IMAGE_Y)',
            python,
        )
        self.assertNotIn('self.bifImageControl.setPosition(bifx, 752)', python)

    def test_osd_timeline_is_inset_visible_and_uses_one_coordinate_system(self):
        seek = SEEK.read_text()
        python = SEEK_PYTHON.read_text()
        timeline_y = seek.index('<posy>{{ vscale(190) }}r</posy>')
        timeline = seek[
            seek.rindex('<control type="group">', 0, timeline_y):
            seek.index('</control>\n<control type="button" id="800">')
        ]

        self.assertIn('<posx>60</posx>', timeline)
        self.assertIn('<width>1800</width>', timeline)
        self.assertIn('<height>{{ vscale(8) }}</height>', timeline)
        self.assertIn('<colordiffuse>52FFFFFF</colordiffuse>', timeline)
        self.assertIn('SEEK_IMAGE_WIDTH = 1800', python)
        self.assertIn('BAR_X = 60', python)
        self.assertIn('BAR_RIGHT = 1860', python)
        self.assertIn('self.BAR_X + w', python)
        self.assertIn('self.BAR_X - 8 + pxOffset', python)

    def test_play_left_skips_controls_that_are_not_visible(self):
        seek = SEEK.read_text()
        self.assertIn('<onleft condition="!String.IsEmpty(Window.Property(nav.ffwdrwd))">405</onleft>', seek)
        self.assertIn('!String.IsEmpty(Window.Property(pq.hasprev)) + !String.IsEmpty(Window.Property(nav.prevnext))', seek)
        self.assertIn('String.IsEmpty(Window.Property(pq.hasprev)) | String.IsEmpty(Window.Property(nav.prevnext))', seek)
        self.assertIn('<onleft condition="Control.IsVisible(413)">413</onleft>', seek)
        self.assertIn('<onleft condition="!Control.IsVisible(413) + Control.IsVisible(412)">412</onleft>', seek)
        self.assertIn('<onleft>407</onleft>', seek)

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

    def test_select_on_hidden_player_surface_opens_osd_in_python(self):
        python = SEEK_PYTHON.read_text()
        on_action = python[
            python.index("    def onAction(self, action):"):
            python.index("    def doKodiSelectDialogHack", python.index("    def onAction(self, action):"))
        ]

        route = (
            "if controlID == self.NO_OSD_BUTTON_ID and "
            "action == xbmcgui.ACTION_SELECT_ITEM:"
        )
        self.assertIn(route, on_action)
        branch = on_action[on_action.index(route):]
        self.assertLess(branch.index("self.onClick(controlID)"), branch.index("return"))

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
        title_rail = seek[seek.index('<posy>{{ vscale(40) }}</posy>'):seek.index('<posy>{{ vscale(288) }}r</posy>')]
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
        self.assertIn('"quick_subtitles"', harness)
        self.assertIn('profile = "minimal"', harness)
        self.assertIn('profile = "default"', harness)
        self.assertIn('self.setProperty("time.current", "28:14")', harness)
        self.assertIn('self.getControl(501).addItems', harness)
        self.assertIn('focus_id = 406', harness)
        self.assertIn('self._publish("open", focus_id)', harness)
        self.assertIn('"Passer le générique (10)"', harness)
        self.assertIn("# The production button is deliberately inert", harness)
        self.assertNotIn("Player.Open", harness)
        self.assertNotIn("doSeek", harness)


if __name__ == "__main__":
    unittest.main()
