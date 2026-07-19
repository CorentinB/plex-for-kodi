from __future__ import absolute_import

import os
import unittest


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TEMPLATE_ROOT = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
)
FRENCH_STRINGS = os.path.join(
    ROOT,
    "resources",
    "language",
    "resource.language.fr_fr",
    "strings.po",
)


def _read(*parts):
    with open(os.path.join(TEMPLATE_ROOT, *parts), "r") as handle:
        return handle.read()


class SearchLayoutContractTests(unittest.TestCase):
    def test_search_sidebar_is_one_quiet_glass_surface(self):
        template = _read("script-plex-search.xml.tpl")

        self.assertIn('<width>1920</width>\n        <height>1080</height>\n        <texture colordiffuse="70000000"', template)
        self.assertIn('colordiffuse="F21A1A1C"', template)
        self.assertNotIn("FF2D2D2D", template)
        self.assertNotIn("FFE5A00D", template)
        self.assertNotIn("FFCC7B19", template)

    def test_keyboard_uses_restrained_white_focus_and_rounded_keys(self):
        template = _read("script-plex-search.xml.tpl")
        keyboard = template[
            template.index("<!-- BUTTONS ROW 1 -->") : template.index(
                '<animation effect="fade" start="0" end="100" time="100" '
                'condition="!String.IsEmpty(Window.Property(searching))">Visible</animation>'
            )
        ]

        self.assertEqual(
            template.count(
                'texturefocus colordiffuse="FFF5F5F5" border="50">'
                'script.plex/white-square-rounded-with-shadow.png'
            ),
            39,
        )
        self.assertGreaterEqual(template.count("script.plex/white-square-rounded.png"), 45)
        self.assertNotIn('end="120"', template)
        self.assertNotIn('start="120"', template)
        self.assertEqual(keyboard.count('end="106" time="110"'), 39)
        self.assertEqual(keyboard.count('reversible="true" condition="Control.HasFocus('), 39)
        self.assertNotIn('end="108"', keyboard)
        self.assertNotIn('start="108"', keyboard)
        self.assertNotIn('reversible="false"', keyboard)
        self.assertNotIn('>Focus</animation>', keyboard)
        self.assertNotIn('>UnFocus</animation>', keyboard)

    def test_search_uses_real_transparency_and_localizes_the_all_filter(self):
        template = _read("script-plex-search.xml.tpl")
        invalid_texture_sentinels = (
            "<texture>-</texture>",
            "<texturefocus>-</texturefocus>",
            "<texturenofocus>-</texturenofocus>",
            "<texturesliderbackground>-</texturesliderbackground>",
            "<textureslidernib>-</textureslidernib>",
            "<textureslidernibfocus>-</textureslidernibfocus>",
        )

        for sentinel in invalid_texture_sentinels:
            self.assertNotIn(sentinel, template)
        self.assertEqual(template.count("script.plex/transparent-6px.png"), 50)
        self.assertEqual(template.count("$ADDON[script.plexmod 32345]"), 2)
        self.assertNotIn("<label>All</label>", template)

    def test_search_history_copy_is_localized_in_french(self):
        with open(FRENCH_STRINGS, "r") as handle:
            strings = handle.read()

        for string_id, translation in (
            (35004, "Historique"),
            (35005, "Effacer l’historique de recherche"),
            (35006, "Effacer tout l’historique de recherche ?"),
        ):
            self.assertIn(
                'msgctxt "#{}"\nmsgid '.format(string_id),
                strings,
            )
            self.assertIn('msgstr "{}"'.format(translation), strings)

    def test_search_close_control_matches_the_subtle_header_motion(self):
        template = _read("script-plex-search.xml.tpl")
        header = template[:template.index('<control type="group" id="899">')]

        self.assertIn(
            'end="106" time="110" center="80,{{ vscale(67.5) }}" '
            'reversible="true" condition="Control.HasFocus(999)">Conditional',
            header,
        )
        self.assertNotIn('end="112"', header)
        self.assertNotIn('start="112"', header)
        self.assertNotIn('reversible="false">Focus</animation>', header)

    def test_search_results_use_aspect_matched_art_and_focus_frames(self):
        assets = {
            "search_hub_poster.xml.tpl": (
                "poster-search-rounded-mask.png",
                "white-square-rounded.png",
            ),
            "search_hub_square.xml.tpl": (
                "square-search-rounded-mask.png",
                "white-square-rounded.png",
            ),
            "search_hub_ar16x9.xml.tpl": (
                "landscape-search-rounded-mask.png",
                "white-square-rounded.png",
            ),
        }
        for filename, (mask, focus_asset) in assets.items():
            layout = _read("includes", filename)
            self.assertEqual(layout.count("script.plex/{}".format(mask)), 4)
            self.assertEqual(
                layout.count(
                    '<texture border="22">script.plex/white-square-rounded.png</texture>'
                ),
                1,
            )
            self.assertEqual(
                layout.count("<visible>String.IsEmpty(ListItem.Thumb)</visible>"),
                2,
            )
            focus = layout.index("script.plex/{}".format(focus_asset))
            art = layout.index("script.plex/{}".format(mask), focus)
            self.assertLess(focus, art)
            self.assertIn(
                'end="106" time="110"',
                layout,
            )
            self.assertIn(
                'reversible="true" condition="Control.HasFocus({{ hub_id }})">Conditional',
                layout,
            )
            self.assertNotIn('reversible="false"', layout)
            self.assertNotIn('>Focus</animation>', layout)
            self.assertNotIn('>UnFocus</animation>', layout)
            self.assertNotIn("script.plex/home/selected.png", layout)

        poster = _read("includes", "search_hub_poster.xml.tpl")
        focus = poster.index("white-square-rounded.png")
        art = poster.index("poster-search-rounded-mask.png", focus)
        self.assertLess(focus, art)
        self.assertNotIn("poster-search-rounded-focus.png", poster)
        self.assertNotIn("poster-search-rounded-outline.png", poster)

        square = _read("includes", "search_hub_square.xml.tpl")
        self.assertNotIn("square-search-rounded-focus.png", square)
        self.assertNotIn("square-rounded-outline.png", square)

        landscape = _read("includes", "search_hub_ar16x9.xml.tpl")
        self.assertNotIn("landscape-search-rounded-focus.png", landscape)
        self.assertNotIn("landscape-search-rounded-outline.png", landscape)

        circle = _read("includes", "search_hub_circle.xml.tpl")
        self.assertEqual(
            circle.count("<visible>String.IsEmpty(ListItem.Thumb)</visible>"),
            2,
        )
        focus = circle.index("script.plex/circle-rounded-focus.png")
        art = circle.index("script.plex/masks/role.png", focus)
        self.assertLess(focus, art)
        self.assertNotIn("script.plex/circle-rounded-outline.png", circle)
        self.assertNotIn("script.plex/buttons/role-selected.png", circle)
        self.assertIn(
            'end="106" time="110" center="127,{{ vscale(127) }}" '
            'reversible="true" condition="Control.HasFocus({{ hub_id }})">Conditional',
            circle,
        )


if __name__ == "__main__":
    unittest.main()
