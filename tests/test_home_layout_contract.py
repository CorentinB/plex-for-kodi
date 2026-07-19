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
HOME_WINDOW = os.path.join(ROOT, "lib", "windows", "home.py")
FRENCH_CATALOG = os.path.join(
    ROOT,
    "resources",
    "language",
    "resource.language.fr_fr",
    "strings.po",
)


def _read(*parts):
    with open(os.path.join(TEMPLATE_ROOT, *parts), "r") as handle:
        return handle.read()


def _read_file(path):
    with open(path, "r") as handle:
        return handle.read()


class HomeLayoutContractTests(unittest.TestCase):
    def test_server_selection_and_now_playing_remain_remote_reachable(self):
        home = _read("script-plex-home.xml.tpl")
        window = _read_file(HOME_WINDOW)
        french = _read_file(FRENCH_CATALOG)

        self.assertIn(
            '<onright condition="Control.IsVisible(204)">204</onright>',
            home,
        )
        self.assertIn(
            '<visible>Player.HasAudio + String.IsEmpty(Window(10000).Property(script.plex.theme_playing))</visible>\n'
            '\t        <posx>1180</posx>',
            home,
        )
        self.assertIn('<defaultcontrol always="true">204</defaultcontrol>', home)
        self.assertIn("data_source='server'", window)
        self.assertIn('def chooseServer(self):', window)
        self.assertIn("header=T(34004, 'Choose server')", window)
        self.assertIn('msgstr "Choisir le serveur"', french)

    def test_native_home_uses_one_safe_left_edge(self):
        home = _read("script-plex-home.xml.tpl")
        content = home.split("{% endblock content %}", 1)[0]

        self.assertIn('<control type="fixedlist" id="101">', content)
        self.assertIn("<posx>160</posx>\n            <posy>{{ vscale(6) }}</posy>\n            <width>1500</width>", content)
        self.assertIn("<posx>160</posx>\n            <posy>{{ vscale(118) }}</posy>\n            <width>1120</width>", content)
        self.assertIn("<posx>160</posx>\n            <posy>0</posy>\n            <width>1680</width>", content)
        self.assertIn("<posx>100</posx>\n            <posy>{{ vscale(42) }}</posy>\n            <width>1740</width>", content)

    def test_home_tab_content_is_optically_centered(self):
        home = _read("script-plex-home.xml.tpl")
        nav_content = _read("includes", "home_nav_content.xml.tpl")
        nav_size = _read("includes", "home_nav_content_size.xml.tpl")
        nav_plate = _read("includes", "home_nav_focus_plate.xml.tpl")
        nav_plate_size = _read("includes", "home_nav_focus_plate_size.xml.tpl")
        nav_shift = _read("includes", "home_nav_shift.xml.tpl")
        start = home.index('<control type="fixedlist" id="101">')
        end = home.index(
            '<control type="group">\n'
            '            <visible>!String.IsEmpty(Window.Property(home.hero.visible))',
            start,
        )
        nav = home[start:end]

        # Kodi's container keeps a stable slot width while each complete visual
        # item is shifted onto a cumulative, content-width-aware navigation row.
        self.assertEqual(
            nav.count('{% include "includes/home_nav_content.xml.tpl" %}'),
            2,
        )
        self.assertEqual(
            nav.count('{% include "includes/home_nav_focus_plate.xml.tpl" %}'),
            1,
        )
        self.assertIn('<itemlayout width="192">', nav)
        self.assertIn('<focusedlayout width="192">', nav)
        self.assertEqual(
            nav.count('{% include "includes/home_nav_shift.xml.tpl" %}'),
            2,
        )
        self.assertIn("range(-512, 644, 4)", nav_shift)
        self.assertIn(
            "!String.IsEmpty(ListItem.Property(nav.offset.{{ nav_shift }}))",
            nav_shift,
        )
        self.assertIn(
            'center="0,{{ vscale(30) }}" reversible="true" '
            'condition="Control.HasFocus(101) + '
            '!String.IsEmpty(ListItem.Property(is.home))"',
            nav,
        )
        self.assertIn(
            'center="130,{{ vscale(30) }}" reversible="true" '
            'condition="Control.HasFocus(101) + '
            '!String.IsEmpty(ListItem.Property(nav.width.180)) + '
            'String.IsEmpty(ListItem.Property(is.home))"',
            nav,
        )
        self.assertNotIn('end="-92,0"', nav)
        self.assertNotIn("<posx>56</posx>", nav)
        self.assertNotIn("<posx>94</posx>", nav)
        self.assertNotIn("<width>auto</width>", nav)
        self.assertIn("nav.width.60", nav_content)
        for width in (80, 100, 120, 140, 180):
            self.assertIn("nav_label_width = {}".format(width), nav_content)
        self.assertIn("nav.width.{{ nav_label_width }}", nav_size)
        self.assertIn("nav_label_control_width = 194", nav_content)
        self.assertIn("<align>left</align>", nav_content)
        self.assertIn("<align>left</align>", nav_size)
        self.assertIn("<posx>20</posx>", nav_content)
        self.assertIn("<posx>60</posx>", nav_content)
        self.assertIn("nav_label_width", _read_file(HOME_WINDOW))

        plate_contracts = (
            (60, 140, 166, 129),
            (80, 160, 186, 149),
            (100, 180, 206, 169),
            (120, 200, 226, 189),
            (140, 220, 246, 209),
            (180, 260, 286, 249),
        )
        for values in plate_contracts:
            self.assertIn(
                "nav_label_width = {} & nav_plate_width = {} & "
                "nav_shadow_width = {} & nav_dot_x = {}".format(
                    *values
                ),
                nav_plate,
            )
            self.assertEqual(-13 + (values[2] / 2.0), values[1] / 2.0)
        self.assertIn("<posx>0</posx>", nav_plate)
        self.assertIn("<width>160</width>", nav_plate)
        self.assertIn("nav.width.{{ nav_label_width }}", nav_plate_size)
        self.assertIn("<width>{{ nav_plate_width }}</width>", nav_plate_size)

    def test_home_hero_prefers_plex_logo_with_title_fallback(self):
        home = _read("script-plex-home.xml.tpl")

        self.assertEqual(
            home.count("$INFO[Window.Property(home.hero.logo)]"),
            2,
        )
        self.assertEqual(
            home.count("String.IsEmpty(Window.Property(home.hero.logo))"),
            4,
        )
        self.assertIn("<width>560</width>", home)
        self.assertIn("<width>500</width>", home)
        self.assertEqual(
            home.count('<aspectratio align="left" aligny="center">keep</aspectratio>'),
            2,
        )

    def test_home_hero_uses_a_compact_certification_badge_with_metadata_fallback(self):
        home = _read("script-plex-home.xml.tpl")
        metadata = _read("includes", "home_hero_metadata.xml.tpl")

        self.assertEqual(
            home.count('{% include "includes/home_hero_metadata.xml.tpl" %}'),
            2,
        )
        self.assertNotIn(
            '<label>$INFO[Window.Property(home.hero.meta)]</label>',
            home,
        )
        self.assertIn("Window.Property(home.hero.content_rating)", metadata)
        self.assertIn("Window.Property(home.hero.content_rating_wide)", metadata)
        self.assertEqual(metadata.count('<width>86</width>'), 2)
        self.assertEqual(metadata.count('<width>150</width>'), 2)
        self.assertIn('<height>{{ vscale(28) }}</height>', metadata)
        self.assertIn('border="8" colordiffuse="C0343436"', metadata)
        self.assertNotIn('white-outline-rounded.png', metadata)
        self.assertIn('<posx>104</posx>', metadata)
        self.assertIn('<posx>168</posx>', metadata)
        self.assertIn(
            'String.IsEmpty(Window.Property(home.hero.content_rating)) + '
            '!String.IsEmpty(Window.Property(home.hero.meta))',
            metadata,
        )
        self.assertEqual(
            metadata.count('<label>$INFO[Window.Property(home.hero.meta)]</label>'),
            3,
        )

    def test_home_hero_places_clear_art_at_top_right_until_rows_scroll(self):
        home = _read("script-plex-home.xml.tpl")
        mask_path = os.path.join(
            ROOT,
            "resources",
            "skins",
            "Main",
            "media",
            "script.plex",
            "home",
            "tvos-first-row-art-mask.png",
        )
        generator_path = os.path.join(ROOT, "tools", "generate_tvos_masks.sh")

        blurred_texture = (
            '<texture background="true">'
            '$INFO[Window.Property(home.hero.art_blurred)]</texture>'
        )
        clear_texture = (
            '<texture background="true" diffuse="script.plex/home/tvos-first-row-art-mask.png">'
            '$INFO[Window.Property(home.hero.art)]</texture>'
        )

        self.assertIn(
            '<visible>!String.IsEmpty(Window.Property(home.hero.art)) + '
            'String.IsEmpty(Window.Property(hub.scrolled))</visible>',
            home,
        )
        self.assertIn(
            '<visible>!String.IsEmpty(Window.Property(home.hero.art_blurred))</visible>',
            home,
        )
        self.assertIn(
            '<posx>640</posx>\n'
            '    <posy>0</posy>\n'
            '    <width>1280</width>\n'
            '    <height>720</height>',
            home,
        )
        self.assertIn(
            '<aspectratio align="right" aligny="top">keep</aspectratio>',
            home,
        )
        self.assertIn(blurred_texture, home)
        self.assertIn(clear_texture, home)
        self.assertLess(home.index(blurred_texture), home.index(clear_texture))
        self.assertEqual(
            home.count("$INFO[Window.Property(home.hero.art_blurred)]"),
            1,
        )
        self.assertIn(
            '<visible>String.IsEmpty(Window.Property(hub.scrolled))</visible>\n'
            '    <posx>0</posx>\n'
            '    <posy>0</posy>\n'
            '    <width>1920</width>\n'
            '    <height>1080</height>\n'
            '    <texture colordiffuse="D8FFFFFF">'
            'script.plex/home/tvos-background-wash.png</texture>',
            home,
        )
        self.assertIn(
            '<visible>!String.IsEmpty(Window.Property(hub.scrolled))</visible>\n'
            '    <posx>0</posx>\n'
            '    <posy>0</posy>\n'
            '    <width>1920</width>\n'
            '    <height>1080</height>\n'
            '    <texture>script.plex/home/tvos-background-wash.png</texture>',
            home,
        )
        self.assertNotIn("tvos-first-row-blur-mask.png", home)
        self.assertTrue(os.path.exists(mask_path))
        self.assertIn(
            '"$MEDIA_DIR/home/tvos-first-row-art-mask.png"',
            _read_file(generator_path),
        )

    def test_poster_and_square_rows_end_on_full_cards(self):
        list_left = 100
        list_width = 1740
        art_left_in_item = 55 + 5
        item_width = 287
        art_width = 244

        first_art_left = list_left + art_left_in_item
        sixth_art_right = first_art_left + (5 * item_width) + art_width
        seventh_art_left = first_art_left + (6 * item_width)

        self.assertEqual(first_art_left, 160)
        self.assertEqual(sixth_art_right, list_left + list_width - 1)
        self.assertGreaterEqual(seventh_art_left, list_left + list_width)

    def test_all_home_art_keeps_a_subtle_radius_when_unfocused(self):
        masks = {
            "poster": "poster-home-rounded-mask.png",
            "square": "square-rounded-mask.png",
            "ar16x9": "landscape-hub-rounded-mask.png",
        }
        for shape, mask in masks.items():
            for state in ("itemlayout", "focusedlayout"):
                layout = _read("includes", "hub_{}_{}.xml.tpl".format(state, shape))
                self.assertIn(
                    'background="true" diffuse="script.plex/{}"'.format(mask),
                    layout,
                )

    def test_home_focus_plates_precede_art_and_zoom_about_their_true_centers(self):
        focus_contracts = {
            "poster": (
                "poster-home-rounded-focus.png",
                "poster-home-rounded-mask.png",
                'center="127,{{ vscale(185.5) }}"',
                "poster-medium-rounded-outline.png",
            ),
            "square": (
                "square-rounded-focus.png",
                "square-rounded-mask.png",
                'center="127,{{ vscale(127) }}"',
                "square-rounded-outline.png",
            ),
            "ar16x9": (
                "landscape-hub-rounded-focus.png",
                "landscape-hub-rounded-mask.png",
                'center="197.5,{{ vscale(113.5) }}"',
                "landscape-hub-rounded-outline.png",
            ),
        }
        for shape, (focus_asset, mask, center, old_outline) in focus_contracts.items():
            layout = _read("includes", "hub_focusedlayout_{}.xml.tpl".format(shape))
            focus = layout.index("script.plex/{}".format(focus_asset))
            art = layout.index("script.plex/{}".format(mask), focus)

            self.assertLess(focus, art)
            self.assertIn(center, layout)
            self.assertIn('end="106" time="110"', layout)
            self.assertIn(
                'reversible="true" condition="Control.HasFocus({{ hub_id }})">Conditional',
                layout,
            )
            self.assertNotIn("script.plex/{}".format(old_outline), layout)
            self.assertNotIn("script.plex/white-outline-rounded.png", layout)
            self.assertNotIn('<texture border="10">', layout)
            self.assertNotIn('reversible="false">Focus</animation>', layout)
            self.assertNotIn('>UnFocus</animation>', layout)

    def test_home_poster_composites_art_over_its_focus_plate(self):
        layout = _read("includes", "hub_focusedlayout_poster.xml.tpl")

        focus = layout.index("script.plex/poster-home-rounded-focus.png")
        art = layout.index("script.plex/poster-home-rounded-mask.png")
        self.assertLess(focus, art)
        self.assertNotIn("script.plex/poster-medium-rounded-outline.png", layout)

    def test_generated_focus_outline_uses_the_same_inner_curve_as_art(self):
        with open(os.path.join(ROOT, "tools", "generate_tvos_masks.sh"), "r") as handle:
            generator = handle.read()

        # A centred stroke changes both the radius and the curve centre. Build
        # each frame from an outer shape minus the inset artwork shape instead,
        # so its transparent opening is exactly the artwork mask translated by
        # the five-rendered-pixel frame inset.
        self.assertEqual(generator.count("-compose DstOut -composite"), 8)
        self.assertNotIn("-strokewidth 16", generator)
        self.assertNotIn("-strokewidth 18", generator)
        self.assertEqual(generator.count("-strokewidth 10"), 1)
        self.assertIn('roundrectangle 0,0 519,775 36,36', generator)
        self.assertIn('roundrectangle 0,0 487,721 22,22', generator)
        self.assertIn('roundrectangle 0,0 507,741 32,32', generator)
        self.assertIn('roundrectangle 0,0 539,795 46,46', generator)
        for focus_asset in (
            "poster-rounded-focus.png",
            "poster-medium-rounded-focus.png",
            "poster-small-rounded-focus.png",
            "poster-small-compact-rounded-focus.png",
            "poster-search-rounded-focus.png",
            "square-search-rounded-focus.png",
            "landscape-hub-rounded-focus.png",
            "landscape-search-rounded-focus.png",
            "review-rounded-focus.png",
            "circle-rounded-focus.png",
            "thumb_fallbacks/role.png",
        ):
            self.assertIn(focus_asset, generator)
        self.assertIn('roundrectangle 10,10 529,785 36,36', generator)
        self.assertIn('roundrectangle 10,10 497,737 34,34', generator)
        self.assertIn('roundrectangle 10,10 297,435 20,20', generator)
        self.assertIn('roundrectangle 10,10 333,487 22,22', generator)
        self.assertIn('roundrectangle 10,10 369,549 25,25', generator)
        self.assertIn('roundrectangle 0,0 359,539 25,25', generator)
        self.assertIn('roundrectangle 0,0 539,539 24,24', generator)
        self.assertIn('roundrectangle 0,0 559,559 34,34', generator)
        self.assertIn('roundrectangle 0,0 519,519 32,32', generator)
        self.assertIn('roundrectangle 10,10 509,509 22,22', generator)
        self.assertIn('roundrectangle 0,0 789,453 32,32', generator)
        self.assertIn('roundrectangle 10,10 779,443 22,22', generator)
        self.assertIn('roundrectangle 0,0 619,357 32,32', generator)
        self.assertIn('roundrectangle 10,10 609,347 22,22', generator)

    def test_wide_row_fits_four_complete_cards(self):
        item = _read("includes", "hub_itemlayout_ar16x9.xml.tpl")

        self.assertIn('<itemlayout width="420"', item)
        self.assertIn("<width>385</width>", item)
        self.assertIn("<height>{{ vscale(217) }}</height>", item)

        first_art_left = 100 + 55 + 5
        fourth_art_right = first_art_left + (3 * 420) + 385
        fifth_art_left = first_art_left + (4 * 420)

        self.assertEqual(first_art_left, 160)
        self.assertLessEqual(fourth_art_right, 1840)
        self.assertEqual(fifth_art_left, 1840)

    def test_focused_card_titles_wrap_without_marquee_fragments(self):
        for name in (
            "hub_focusedlayout_poster.xml.tpl",
            "hub_focusedlayout_square.xml.tpl",
            "hub_focusedlayout_ar16x9.xml.tpl",
        ):
            layout = _read("includes", name)
            self.assertIn('<control type="textbox">', layout)
            self.assertNotIn("<scroll>Control.HasFocus", layout)

    def test_scrolled_header_preserves_ambient_art_without_a_separate_black_bar(self):
        home = _read("script-plex-home.xml.tpl")

        self.assertIn(
            '<animation effect="fade" start="100" end="0" time="140" '
            'condition="Integer.IsGreater(Window.Property(hub.focus),{{ i }})">'
            "Conditional</animation>",
            home,
        )
        self.assertNotIn("<colordiffuse>FF000000</colordiffuse>", home)
        self.assertNotIn("tvos-row-top-scrim.png", home)
        self.assertNotIn("<colordiffuse>78000000</colordiffuse>", home)

    def test_home_chrome_uses_neutral_focus_and_real_transparent_textures(self):
        home = _read("script-plex-home.xml.tpl")
        invalid_texture_sentinels = (
            "<texture>-</texture>",
            "<texturefocus>-</texturefocus>",
            "<texturenofocus>-</texturenofocus>",
            "<lefttexture>-</lefttexture>",
            "<righttexture>-</righttexture>",
            "<overlaytexture>-</overlaytexture>",
            "<texturesliderbackground>-</texturesliderbackground>",
            "<textureslidernib>-</textureslidernib>",
            "<textureslidernibfocus>-</textureslidernibfocus>",
        )

        for sentinel in invalid_texture_sentinels:
            self.assertNotIn(sentinel, home)
        self.assertNotIn("E5A00D", home)
        self.assertEqual(home.count("script.plex/transparent-6px.png"), 11)
        self.assertEqual(home.count('colordiffuse="FFF5F5F5"'), 9)
        self.assertIn(
            "<textcolor>A0000000</textcolor>\n"
            "                                    <label>$INFO[ListItem.Label2]</label>",
            home,
        )

    def test_home_header_uses_one_subtle_reversible_focus_lift(self):
        home = _read("script-plex-home.xml.tpl")

        self.assertEqual(home.count('end="106" time="110"'), 9)
        for control_id in (202, 203):
            self.assertIn(
                'reversible="true" condition="Control.HasFocus({})">Conditional'.format(
                    control_id
                ),
                home,
            )
        self.assertEqual(
            home.count('reversible="true" condition="Control.HasFocus(101) + '),
            7,
        )
        for oversized in ('end="108"', 'start="108"', 'end="118"', 'start="118"'):
            self.assertNotIn(oversized, home)
        self.assertNotIn('reversible="false">Focus</animation>', home)

    def test_square_and_wide_secondary_text_have_three_line_height(self):
        for name in (
            "hub_itemlayout_square.xml.tpl",
            "hub_focusedlayout_square.xml.tpl",
            "hub_itemlayout_ar16x9.xml.tpl",
            "hub_focusedlayout_ar16x9.xml.tpl",
        ):
            layout = _read("includes", name)
            self.assertIn("<height>{{ vscale(90) }}</height>", layout)

    def test_home_textboxes_never_start_vertical_autoscroll(self):
        paths = (
            ("script-plex-home.xml.tpl",),
            ("includes", "hub_itemlayout_poster.xml.tpl"),
            ("includes", "hub_focusedlayout_poster.xml.tpl"),
            ("includes", "hub_itemlayout_square.xml.tpl"),
            ("includes", "hub_focusedlayout_square.xml.tpl"),
            ("includes", "hub_itemlayout_ar16x9.xml.tpl"),
            ("includes", "hub_focusedlayout_ar16x9.xml.tpl"),
        )
        for path in paths:
            layout = _read(*path)
            self.assertEqual(
                layout.count('<control type="textbox">'),
                layout.count("<autoscroll>false</autoscroll>"),
                "every textbox in {} must explicitly disable scrolling".format(
                    "/".join(path)
                ),
            )


if __name__ == "__main__":
    unittest.main()
