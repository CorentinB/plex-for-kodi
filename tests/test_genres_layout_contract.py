from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
TEMPLATE = ROOT / "resources" / "skins" / "Main" / "1080i" / "templates" / "script-plex-genres.xml.tpl"
PYTHON = ROOT / "lib" / "windows" / "genres.py"
FRENCH = ROOT / "resources" / "language" / "resource.language.fr_fr" / "strings.po"


class GenresLayoutContractTests(unittest.TestCase):
    def test_genres_use_the_tvos_shell_and_selected_plex_art_background(self):
        template = TEMPLATE.read_text()

        self.assertIn('{% extends "default.xml.tpl" %}', template)
        self.assertNotIn('{% extends "library.xml.tpl" %}', template)
        self.assertIn('Container(101).ListItem.Property(background)', template)
        self.assertIn('script.plex/home/tvos-background-wash.png', template)
        self.assertIn('<posx>160</posx>', template)

    def test_genre_grid_fits_four_complete_rounded_landscape_cards_per_row(self):
        template = TEMPLATE.read_text()

        self.assertIn('<width>1600</width>', template)
        self.assertIn('<itemlayout width="400"', template)
        self.assertIn('<focusedlayout width="400"', template)
        self.assertIn('height="{{ vscale(280) }}"', template)
        self.assertIn('<height>{{ vscale(840) }}</height>', template)
        self.assertIn('<hitrect x="0" y="0" w="1600" h="840" />', template)
        self.assertIn('<width>385</width>', template)
        self.assertIn('landscape-hub-rounded-mask.png', template)
        focus = template.index('landscape-hub-rounded-focus.png')
        art = template.index('$INFO[ListItem.Property(thumb.fallback)]', focus)
        self.assertLess(focus, art)
        self.assertIn(
            'start="100" end="106" time="110" center="197.5,{{ vscale(113.5) }}" '
            'reversible="true" condition="Control.HasFocus(101)">Conditional</animation>',
            template,
        )
        self.assertNotIn('landscape-hub-rounded-outline.png', template)
        self.assertNotIn('reversible="false">Focus</animation>', template)
        self.assertNotIn('reversible="false">UnFocus</animation>', template)
        self.assertNotIn('script.plex/home/selected.png', template)

    def test_genre_captions_stay_outside_the_artwork_zoom_with_safe_spacing(self):
        template = TEMPLATE.read_text()
        focused_start = template.index('<focusedlayout width="400" height="{{ vscale(280) }}">')
        focused_end = template.index('</focusedlayout>', focused_start)
        focused = template[focused_start:focused_end]
        animation = focused.index('condition="Control.HasFocus(101)">Conditional</animation>')
        stable_caption = focused.index(
            '<!-- Keep the caption optically stable while only the artwork plate lifts. -->'
        )

        self.assertLess(animation, stable_caption)
        self.assertIn(
            '<!-- Keep the caption optically stable while only the artwork plate lifts. -->\n'
            '                <control type="label">\n'
            '                    <posx>5</posx>\n'
            '                    <posy>{{ vscale(242) }}</posy>',
            focused,
        )
        self.assertEqual(template.count('<posy>{{ vscale(242) }}</posy>'), 2)
        self.assertNotIn('<posy>{{ vscale(229) }}</posy>', template)

    def test_genre_focus_is_white_stable_and_reaches_the_header(self):
        template = TEMPLATE.read_text()

        self.assertIn('<onup>201</onup>', template)
        self.assertIn('<defaultcontrol always="true">101</defaultcontrol>', template)
        self.assertGreaterEqual(template.count('<scroll>false</scroll>'), 4)
        self.assertNotIn('FFE5A00D', template)
        self.assertNotIn('<scroll>Control.HasFocus(101)</scroll>', template)

    def test_genre_python_uses_transcoded_art_and_safe_fallbacks(self):
        source = PYTHON.read_text()

        self.assertIn('artwork.is_usable_art(thumb)', source)
        self.assertIn('thumb.asTranscodedImageURL(*self.THUMB_DIM)', source)
        self.assertIn("blur=18", source)
        self.assertIn("mli.setProperty('thumb.fallback', 'script.plex/home/background-fallback.png')", source)
        self.assertIn("self.setBoolProperty('no.content', not itemCount)", source)
        self.assertIn('itemCount and self.GENRE_PANEL_ID or self.HOME_BUTTON_ID', source)

    def test_genre_title_preserves_library_name_without_forced_uppercase(self):
        source = PYTHON.read_text()

        self.assertIn("self.setProperty('screen.title', T(34102, 'Categories'))", source)
        self.assertIn("self.section and self.section.title or ''", source)
        self.assertNotIn('self.section.title.upper()', source)

        french = FRENCH.read_text()
        self.assertIn('msgctxt "#34102"', french)
        self.assertIn('msgstr "Catégories"', french)


if __name__ == '__main__':
    unittest.main()
