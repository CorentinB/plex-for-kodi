from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
TEMPLATES = ROOT / "resources" / "skins" / "Main" / "1080i" / "templates"
ARTIST = TEMPLATES / "script-plex-artist.xml.tpl"
ALBUM = TEMPLATES / "script-plex-album.xml.tpl"
THEMED_BUTTON = TEMPLATES / "includes" / "themed_button.xml.tpl"
ARTIST_NAV = TEMPLATES / "includes" / "music_artist_button_navigation.xml.tpl"
SUBITEMS = ROOT / "lib" / "windows" / "subitems.py"
TRACKS = ROOT / "lib" / "windows" / "tracks.py"
MASK_GENERATOR = ROOT / "tools" / "generate_tvos_masks.sh"


class MusicDetailLayoutContractTests(unittest.TestCase):
    def test_music_details_use_blurred_art_with_shared_readability_wash(self):
        artist = ARTIST.read_text()
        album = ALBUM.read_text()
        source = SUBITEMS.read_text() + TRACKS.read_text()

        self.assertIn("Window.Property(artist.background.blurred)", artist)
        self.assertIn("Window.Property(album.background.blurred)", album)
        self.assertEqual(
            artist.count("script.plex/home/tvos-background-wash.png"),
            1,
        )
        self.assertEqual(
            album.count("script.plex/home/tvos-background-wash.png"),
            1,
        )
        self.assertGreaterEqual(source.count("blur=18"), 2)
        self.assertGreaterEqual(source.count("defaultArt or"), 2)

    def test_artist_biography_is_bounded_and_cards_use_matching_masks(self):
        source = ARTIST.read_text()
        python = SUBITEMS.read_text()

        self.assertIn("Window.Property(summary.short)", source)
        self.assertIn("<autoscroll>false</autoscroll>", source)
        self.assertIn("_short_text(summary, limit=190)", python)
        self.assertIn("script.plex/masks/role.png", source)
        self.assertIn("script.plex/circle-rounded-outline.png", source)
        self.assertIn("script.plex/square-rounded-mask.png", source)
        self.assertIn("script.plex/square-rounded-focus.png", source)
        self.assertGreaterEqual(source.count("<posx>160</posx>"), 3)
        self.assertNotIn("[UPPERCASE]", source)

    def test_artist_lower_sections_use_complete_safe_rails_and_clean_paging(self):
        source = ARTIST.read_text()

        self.assertEqual(source.count("<font>font30_title</font>"), 2)
        self.assertNotIn("<font>font_title</font>", source)
        self.assertEqual(source.count("<width>1740</width>"), 2)
        self.assertIn('<itemlayout width="280">', source)
        self.assertIn('<focusedlayout width="280">', source)
        self.assertIn('<itemlayout width="240">', source)
        self.assertIn('<focusedlayout width="240">', source)
        self.assertLessEqual(100 + 60 + (5 * 280) + 220, 1920)
        self.assertLessEqual(100 + 60 + (6 * 240) + 200, 1920)
        fade = (
            '<animation effect="fade" start="100" end="0" time="140" '
            'condition="String.IsEqual(Window.Property(hub.focus),1)">Conditional</animation>'
        )
        self.assertEqual(source.count(fade), 3)

    def test_artist_focus_plates_render_before_inset_art(self):
        source = ARTIST.read_text()

        album_focus = source.index("script.plex/square-rounded-focus.png")
        album_art = source.index("$INFO[ListItem.Property(thumb.fallback)]", album_focus)
        related_focus = source.index("script.plex/circle-rounded-focus.png")
        related_art = source.index("$INFO[ListItem.Property(thumb.fallback)]", related_focus)
        self.assertLess(album_focus, album_art)
        self.assertLess(related_focus, related_art)

    def test_artist_actions_have_explicit_remote_routes(self):
        template = ARTIST.read_text()
        button = THEMED_BUTTON.read_text()
        navigation = ARTIST_NAV.read_text()

        self.assertIn("music_artist_style = True", template)
        self.assertIn("or music_artist_style", button)
        self.assertEqual(
            button.count(
                '{% include "includes/music_artist_button_navigation.xml.tpl" %}'
            ),
            3,
        )
        self.assertIn("<ondown>400</ondown>", navigation)
        for left, current, right in (
            ("noop", 302, 301),
            (302, 301, 303),
            (301, 303, 304),
            (303, 304, "noop"),
        ):
            section = navigation[navigation.index("id == {}".format(current)) :]
            self.assertIn("<onleft>{}</onleft>".format(left), section)
            self.assertIn("<onright>{}</onright>".format(right), section)

    def test_music_detail_actions_use_labelled_rectangles(self):
        artist = ARTIST.read_text()
        album = ALBUM.read_text()
        button = THEMED_BUTTON.read_text()

        self.assertIn(
            "or playlist_style or music_artist_style",
            button,
        )
        self.assertIn(
            "and not playlist_style and not music_artist_style",
            button,
        )
        for source in (artist, album):
            self.assertIn('action_label="$LOCALIZE[208]"', source)
            self.assertIn('action_label="$ADDON[script.plexmod 32935]"', source)
            self.assertIn("action_width=300 & action_label_width=228", source)
            self.assertIn('action_label="$ADDON[script.plexmod 32307]"', source)
            self.assertIn("action_width=130 & action_label_width=58", source)
        self.assertIn('action_label="$LOCALIZE[29915]"', artist)
        self.assertIn("<width>780</width>", artist)
        self.assertIn("<width>600</width>", album)

    def test_album_uses_tvos_actions_rounded_art_and_white_track_focus(self):
        source = ALBUM.read_text()

        self.assertIn("playlist_style = True", source)
        self.assertIn("script.plex/square-rounded-shadow.png", source)
        self.assertIn("script.plex/square-rounded-mask.png", source)
        self.assertIn("script.plex/square-detail-rounded-plate.png", source)
        self.assertNotIn("script.plex/square-rounded-outline.png", source)
        self.assertIn("$ADDON[script.plexmod 35034]", source)
        self.assertIn('<colordiffuse>F2FFFFFF</colordiffuse>', source)
        self.assertIn("<onleft>300</onleft>", source)
        self.assertIn(
            '<onright condition="Integer.IsGreater(Container(101).NumPages,1)">152</onright>',
            source,
        )
        for orange in ("FFE5A00D", "FFCC7B19", "FFAC5B00"):
            self.assertNotIn(orange, source)
        self.assertNotIn("[UPPERCASE]", source)

    def test_album_cover_plate_is_exact_concentric_and_behind_art(self):
        source = ALBUM.read_text()
        generator = MASK_GENERATOR.read_text()

        self.assertIn("magick -size 508x508 xc:none", generator)
        self.assertIn('roundrectangle 0,0 507,507 26,26', generator)
        self.assertIn('square-detail-rounded-plate.png', generator)
        plate = source.index('script.plex/square-detail-rounded-plate.png')
        fallback = source.index('script.plex/thumb_fallbacks/music.png', plate)
        art = source.index('Window.Property(album.thumb)', fallback)
        self.assertLess(plate, fallback)
        self.assertLess(fallback, art)
        self.assertIn('<posx>-4</posx>', source[:plate])
        self.assertIn('<width>508</width>', source[:plate])

    def test_album_actions_heading_and_scrollbar_keep_visible_clean_chrome(self):
        source = ALBUM.read_text()
        button = THEMED_BUTTON.read_text()

        self.assertIn('playlist_style = True & light_plate = True', source)
        self.assertGreaterEqual(
            button.count(
                '{% if light_plate %}26FFFFFF{% else %}78000000{% endif %}'
            ),
            2,
        )
        self.assertIn('<posy>{{ vscale(660) }}</posy>', source)
        self.assertIn('<height>{{ vscale(58) }}</height>', source)
        self.assertEqual(
            source.count('Integer.IsGreater(Container(101).NumPages,1)'),
            3,
        )
        self.assertEqual(source.count('script.plex/transparent-6px.png'), 2)
        self.assertNotIn('<textureslidernib>-</textureslidernib>', source)
        self.assertNotIn('<textureslidernibfocus>-</textureslidernibfocus>', source)


if __name__ == "__main__":
    unittest.main()
