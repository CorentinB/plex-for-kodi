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


if __name__ == "__main__":
    unittest.main()
