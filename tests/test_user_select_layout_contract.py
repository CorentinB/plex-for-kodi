from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
TEMPLATE = ROOT / "resources" / "skins" / "Main" / "1080i" / "templates" / "script-plex-user_select.xml.tpl"
HARNESS = ROOT / "tools" / "kodi_user_select_audio_harness.py"


class UserSelectLayoutContractTests(unittest.TestCase):
    def test_user_select_uses_the_tvos_background_wash(self):
        source = TEMPLATE.read_text()
        self.assertIn("script.plex/home/background-fallback.png", source)
        self.assertIn('colordiffuse="88FFFFFF"', source)
        self.assertIn("script.plex/home/tvos-background-wash.png", source)
        self.assertIn('colordiffuse="44000000"', source)

    def test_user_and_pin_focus_do_not_use_legacy_orange(self):
        source = TEMPLATE.read_text()
        for orange in ("FFE5A00D", "FFCC7B19", "FFAC5B00"):
            self.assertNotIn(orange, source)

    def test_heading_is_stable_title_case(self):
        source = TEMPLATE.read_text()
        self.assertIn("<label>$ADDON[script.plexmod 35032]</label>", source)
        self.assertNotIn("[UPPERCASE]$ADDON[script.plexmod 32437]", source)

    def test_profiles_are_circular_without_legacy_square_cards(self):
        source = TEMPLATE.read_text()
        self.assertIn("script.plex/user_select/avatar-diffuse.png", source)
        self.assertIn("script.plex/user_select/avatar-background.png", source)
        self.assertNotIn("script.plex/user_select/item-background.png", source)
        self.assertNotIn("script.plex/user_select/item-background-top.png", source)
        self.assertNotIn("script.plex/user_select/item-background-bottom.png", source)

    def test_profile_names_remain_visible_without_focus(self):
        source = TEMPLATE.read_text()
        self.assertGreaterEqual(source.count("<label>$INFO[ListItem.Label]</label>"), 2)

    def test_profile_and_refresh_focus_share_the_restrained_lift(self):
        source = TEMPLATE.read_text()
        start = source.index("<!-- FOCUSED LAYOUT")
        end = source.index("</focusedlayout>", start)
        focused_layout = source[start:end]

        self.assertEqual(focused_layout.count('end="106"'), 2)
        self.assertNotIn('end="108"', focused_layout)
        self.assertNotIn('end="110"', focused_layout)
        self.assertEqual(focused_layout.count('reversible="true"'), 2)

    def test_now_playing_dock_is_rounded_bounded_and_aligned(self):
        source = TEMPLATE.read_text()
        dock = source[
            source.index("<visible>Player.HasAudio"):
            source.index('<control type="group" id="100">')
        ]

        self.assertIn('<width>1086</width>', dock)
        self.assertIn('<height>{{ vscale(273) }}</height>', dock)
        self.assertIn('script.plex/square-rounded-shadow.png', dock)
        self.assertIn('fallback="script.plex/thumb_fallbacks/music.png"', dock)
        self.assertIn('diffuse="script.plex/square-rounded-mask.png"', dock)
        self.assertIn('script.plex/square-rounded-outline.png', dock)
        self.assertIn('script.plex/buttons/player/modern-focused/pause.png', dock)
        self.assertIn('script.plex/buttons/player/modern/stop.png', dock)
        self.assertIn('<label>[B]$INFO[MusicPlayer.Title][/B]</label>', dock)
        self.assertIn('<posx>918</posx>', dock)
        self.assertNotIn('<posx>1038</posx>', dock)
        self.assertEqual(dock.count('end="106"'), 4)
        self.assertNotIn('end="124"', dock)

    def test_now_playing_harness_is_inert_and_uses_production_xml(self):
        source = HARNESS.read_text()

        self.assertIn('xmlFile = "script-plex-user_select.xml"', source)
        self.assertIn('class UserSelectAudioHarness(kodigui.BaseDialog)', source)
        self.assertIn('self.setFocusId(406)', source)
        self.assertIn('Transport controls are deliberately inert', source)
        self.assertNotIn('Player.Open', source)
        self.assertNotIn('PlayerControl(', source)
        self.assertNotIn('plex.tv', source)


if __name__ == "__main__":
    unittest.main()
