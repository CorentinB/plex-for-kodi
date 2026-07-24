from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
TEMPLATE = ROOT / "resources" / "skins" / "Main" / "1080i" / "templates" / "script-plex-music_player.xml.tpl"
BUTTONS = ROOT / "resources" / "skins" / "Main" / "1080i" / "templates" / "includes" / "music_player_buttons.xml.tpl"


class MusicPlayerLayoutContractTests(unittest.TestCase):
    def test_music_backdrop_has_the_shared_readability_wash(self):
        source = TEMPLATE.read_text()
        self.assertIn("script.plex/home/tvos-background-wash.png", source)
        self.assertIn('colordiffuse="33000000"', source)

    def test_album_art_uses_matching_rounded_assets(self):
        source = TEMPLATE.read_text()
        self.assertIn("script.plex/square-rounded-shadow.png", source)
        self.assertIn("script.plex/square-rounded-mask.png", source)
        self.assertIn("script.plex/square-rounded-outline.png", source)
        self.assertIn('colordiffuse="24FFFFFF"', source)

    def test_missing_track_art_uses_neutral_music_fallbacks(self):
        source = TEMPLATE.read_text()

        self.assertIn("String.IsEmpty(Player.Art(landscape))", source)
        self.assertIn("script.plex/home/background-fallback.png", source)
        self.assertIn('fallback="script.plex/thumb_fallbacks/music.png"', source)

    def test_music_player_has_no_legacy_orange(self):
        source = TEMPLATE.read_text() + BUTTONS.read_text()
        for orange in ("FFE5A00D", "FFCC7B19", "FFAC5B00"):
            self.assertNotIn(orange, source)

    def test_music_focus_uses_dedicated_focus_assets(self):
        source = BUTTONS.read_text()
        self.assertIn("theme.assets.buttons.focusBase", source)
        for name in ("play", "pause", "next", "repeat", "shuffle", "pqueue", "more"):
            self.assertIn(name, source)

    def test_up_next_labels_anchor_to_the_right_detail_edge(self):
        source = TEMPLATE.read_text()
        artist = source.index("$INFO[MusicPlayer.offset(1).Artist]")
        title = source.index("$INFO[MusicPlayer.offset(1).Title]")
        up_next = source[artist - 350 : title + 100]

        self.assertEqual(up_next.count("<posx>820</posx>"), 2)

    def test_track_progress_has_a_visible_rail_below_the_time(self):
        source = TEMPLATE.read_text()
        time = source.index(
            "$INFO[Player.Time]$INFO[MusicPlayer.Duration, / ]"
        )
        progress_start = source.index('<control type="progress">', time)
        progress_end = source.index("</control>", progress_start)
        progress = source[progress_start:progress_end]

        self.assertIn("<posx>0</posx>", progress)
        self.assertIn("<posy>{{ vscale(650) }}</posy>", progress)
        self.assertIn("<width>820</width>", progress)
        self.assertIn(
            '<texturebg colordiffuse="38FFFFFF">'
            "script.plex/white-square-6px.png</texturebg>",
            progress,
        )
        self.assertIn("<info>Player.Progress</info>", progress)


if __name__ == "__main__":
    unittest.main()
