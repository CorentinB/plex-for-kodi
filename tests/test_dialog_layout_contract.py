from __future__ import absolute_import

import os
import unittest


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PLAYER_SETTINGS = os.path.join(ROOT, "lib", "windows", "playersettings.py")
OPTIONS_SOURCE = os.path.join(ROOT, "lib", "windows", "optionsdialog.py")
TEMPLATE_ROOT = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
)
NAMES = (
    "script-plex-options_dialog.xml.tpl",
    "script-plex-options_dialog_big.xml.tpl",
    "script-plex-settings_select_dialog.xml.tpl",
    "script-plex-video_settings_dialog.xml.tpl",
)


def _read(name):
    with open(os.path.join(TEMPLATE_ROOT, name), "r") as handle:
        return handle.read()


def _read_include(name):
    with open(os.path.join(TEMPLATE_ROOT, "includes", name), "r") as handle:
        return handle.read()


class DialogLayoutContractTests(unittest.TestCase):
    def test_dialogs_share_white_focus_and_stable_labels(self):
        for name in NAMES:
            template = _read(name)
            self.assertNotIn("FFE5A00D", template, name)
            self.assertNotIn("FFCC7B19", template, name)
            self.assertNotIn("<scroll>true</scroll>", template, name)
            self.assertNotIn("[UPPERCASE]", template, name)

    def test_confirmation_dialogs_use_opaque_rounded_surfaces(self):
        for name in NAMES[:2]:
            template = _read(name)
            self.assertIn('colordiffuse="B3000000"', template)
            self.assertIn('border="28">script.plex/white-square-rounded.png', template)
            self.assertIn("<autoscroll>false</autoscroll>", template)

    def test_confirmation_buttons_are_shared_spaced_and_subtle(self):
        button = _read_include("options_dialog_button.xml.tpl")
        for name in NAMES[:2]:
            template = _read(name)
            self.assertEqual(template.count("includes/options_dialog_button.xml.tpl"), 3)
            self.assertIn("<itemgap>18</itemgap>", template)
            self.assertNotIn("<itemgap>-50</itemgap>", template)

        self.assertIn('effect="zoom" start="100" end="104"', button)
        self.assertNotIn('end="110,120"', button)
        self.assertIn('<height>{{ vscale(64) }}</height>', button)
        self.assertIn('colordiffuse="24FFFFFF"', button)
        self.assertIn('<pulseonselect>false</pulseonselect>', button)

    def test_confirmation_buttons_follow_their_window_properties(self):
        button = _read_include("options_dialog_button.xml.tpl")

        self.assertIn("Window.Property(button.{{ index }})", button)
        self.assertIn('allowhiddenfocus="true"', button)
        self.assertNotIn("<onleft>", button)
        self.assertNotIn("<onright>", button)

    def test_selected_confirmation_choice_is_focused_without_delay(self):
        with open(OPTIONS_SOURCE, "r") as handle:
            source = handle.read()

        self.assertIn("util.MONITOR.waitForAbort(0.1)", source)
        self.assertIn("self.setFocusId(self.BUTTON_IDS[select])", source)
        self.assertNotIn("if self.delayButtons:\n            util.MONITOR.waitForAbort(0.1)", source)

    def test_list_dialogs_use_inset_rounded_selection(self):
        select = _read(NAMES[2])
        video = _read(NAMES[3])

        self.assertIn("<width>580</width>", select)
        self.assertIn("<width>970</width>", video)
        self.assertIn('border="24">script.plex/white-square-rounded.png', select)
        self.assertIn('border="24">script.plex/white-square-rounded.png', video)

    def test_select_dialog_shell_fits_short_option_lists(self):
        select = _read(NAMES[2])

        self.assertIn("{% for rows in range(1, 8) %}", select)
        self.assertIn(
            "{% with shadow_height = rows * 100 + 170 & "
            "body_height = rows * 100 + 10 %}",
            select,
        )
        self.assertIn(
            "{% with slide_y = 350 - rows * 50 %}",
            select,
        )
        self.assertIn(
            'condition="Integer.IsEqual(Container(100).NumItems,{{ rows }})"',
            select,
        )
        self.assertIn(
            "Integer.IsGreaterOrEqual(Container(100).NumItems,7)",
            select,
        )
        self.assertIn(
            'end="0,{{ vscale(slide_y) }}"',
            select,
        )
        self.assertNotIn("vscale((", select)
        self.assertNotIn("<height>{{ vscale(870) }}</height>", select)
        self.assertNotIn("<height>{{ vscale(710) }}</height>", select)

    def test_video_settings_scrollbar_uses_real_transparency(self):
        video = _read(NAMES[3])

        self.assertNotIn("<textureslidernib>-</textureslidernib>", video)
        self.assertNotIn("<textureslidernibfocus>-</textureslidernibfocus>", video)
        self.assertEqual(video.count("script.plex/transparent-6px.png"), 2)

    def test_video_settings_hide_behind_plex_child_dialogs(self):
        video = _read(NAMES[3])
        with open(PLAYER_SETTINGS, "r") as handle:
            source = handle.read()

        self.assertEqual(
            video.count("String.IsEmpty(Window.Property(child.dialog.visible))"),
            2,
        )
        self.assertIn("def showChildDialog(self, callback, *args, **kwargs):", source)
        self.assertIn("self.setProperty('child.dialog.visible', '1')", source)
        self.assertIn("finally:\n            self.clearProperty('child.dialog.visible')", source)
        self.assertEqual(source.count("self.showChildDialog("), 4)
        for callback in (
            "showAudioDialog,",
            "showSubtitlesDialog,",
            "showQualityDialog,",
            "self.downloadPlexSubtitles,",
        ):
            self.assertIn(callback, source)

    def test_quality_picker_uses_the_localized_heading(self):
        with open(PLAYER_SETTINGS, "r") as handle:
            source = handle.read()

        self.assertIn(
            "showOptionsDialog(T(32397, 'Quality'), options",
            source,
        )
        self.assertNotIn("showOptionsDialog('Quality', options", source)


if __name__ == "__main__":
    unittest.main()
