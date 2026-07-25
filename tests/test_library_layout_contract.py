from __future__ import absolute_import

import os
import unittest


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LIBRARY_PYTHON = os.path.join(ROOT, "lib", "windows", "library.py")
POSTERS_TEMPLATE = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "script-plex-posters.xml.tpl",
)
LIBRARY_NAVIGATION = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "includes",
    "library_button_navigation.xml.tpl",
)
THEMED_BUTTON = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "includes",
    "themed_button.xml.tpl",
)
COMPACT_POSTERS_TEMPLATE = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "script-plex-posters-compact.xml.tpl",
)
SMALL_POSTERS_TEMPLATE = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "script-plex-posters-small.xml.tpl",
)
SMALL_COMPACT_POSTERS_TEMPLATE = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "script-plex-posters-small-compact.xml.tpl",
)
LISTVIEW_TEMPLATE = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "script-plex-listview-16x9.xml.tpl",
)
LIBRARY_TEMPLATE = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "library.xml.tpl",
)
LIBRARY_POSTERS_TEMPLATE = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "library_posters.xml.tpl",
)
SQUARES_TEMPLATE = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "script-plex-squares.xml.tpl",
)
SQUARE_LISTVIEW_TEMPLATE = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "script-plex-listview-square.xml.tpl",
)
KODIGUI_WINDOW = os.path.join(ROOT, "lib", "windows", "kodigui.py")

LIBRARY_CHROME_TEMPLATES = (
    LIBRARY_TEMPLATE,
    LIBRARY_POSTERS_TEMPLATE,
    POSTERS_TEMPLATE,
    COMPACT_POSTERS_TEMPLATE,
    SMALL_POSTERS_TEMPLATE,
    SMALL_COMPACT_POSTERS_TEMPLATE,
    SQUARES_TEMPLATE,
    LISTVIEW_TEMPLATE,
    SQUARE_LISTVIEW_TEMPLATE,
)


def _read(path):
    with open(path, "r") as handle:
        return handle.read()


class LibraryLayoutContractTests(unittest.TestCase):
    def test_posters_composite_rounded_art_over_a_white_focus_plate(self):
        template = _read(POSTERS_TEMPLATE)

        self.assertGreaterEqual(template.count('diffuse="script.plex/poster-home-rounded-mask.png"'), 4)
        self.assertIn('end="106"', template)
        focus = template.index('script.plex/poster-home-rounded-focus.png')
        art = template.index('diffuse="script.plex/poster-home-rounded-mask.png"', focus)
        self.assertLess(focus, art)
        self.assertNotIn('script.plex/poster-rounded-mask.png', template)
        self.assertNotIn('script.plex/poster-medium-rounded-focus.png', template)
        self.assertNotIn('script.plex/poster-medium-rounded-outline.png', template)
        self.assertNotIn('script.plex/home/selected.png', template)
        self.assertNotIn('<scroll>true</scroll>', template)

    def test_full_size_poster_focus_frame_and_art_keep_a_concentric_five_pixel_inset(self):
        template = _read(POSTERS_TEMPLATE)
        focused = template.split(
            '<!-- FOCUSED LAYOUT ####################################### -->',
            1,
        )[1].split('</focusedlayout>', 1)[0]

        focus_plate = focused.index('script.plex/poster-home-rounded-focus.png')
        art_group = focused.index('<control type="group">', focus_plate)
        art_mask = focused.index(
            'diffuse="script.plex/poster-home-rounded-mask.png"',
            art_group,
        )

        self.assertIn('<width>254</width>', focused[:art_group])
        self.assertIn('<height>{{ vscale(371) }}</height>', focused[:art_group])
        self.assertIn('<posx>5</posx>', focused[art_group:art_mask])
        self.assertIn('<posy>5</posy>', focused[art_group:art_mask])
        self.assertIn('<width>244</width>', focused[art_group:art_mask])
        self.assertIn('<height>{{ vscale(361) }}</height>', focused[art_group:art_mask])
        self.assertNotIn('rounded-outline', focused)

    def test_library_grid_fits_six_posters_inside_the_safe_area(self):
        template = _read(POSTERS_TEMPLATE)

        self.assertIn('<posx>100</posx>', template)
        self.assertIn('<width>1680</width>', template)
        self.assertIn('<itemlayout width="270"', template)
        self.assertIn('<focusedlayout width="270"', template)
        first_poster_left = 100 + 55 + 5
        sixth_poster_right = first_poster_left + (5 * 270) + 244
        self.assertEqual(first_poster_left, 160)
        self.assertEqual(sixth_poster_right, 1754)

    def test_library_poster_rows_keep_captions_clear_of_the_next_row(self):
        template = _read(POSTERS_TEMPLATE)

        self.assertEqual(
            template.count('<itemlayout width="270" height="{{ vscale(492) }}">'),
            1,
        )
        self.assertEqual(
            template.count('<focusedlayout width="270" height="{{ vscale(492) }}">'),
            1,
        )

        row_step = 492
        artwork_top = 137 + 5
        caption_bottom = 137 + 5 + 431 + 35
        next_artwork_top = row_step + artwork_top
        self.assertEqual(next_artwork_top - caption_bottom, 26)

    def test_full_size_library_titles_wrap_without_marqueeing_or_covering_metadata(self):
        template = _read(POSTERS_TEMPLATE)

        self.assertEqual(template.count('<control type="textbox">'), 2)
        self.assertEqual(template.count('<autoscroll>false</autoscroll>'), 2)
        self.assertEqual(template.count('<posy>{{ vscale(371) }}</posy>'), 1)
        self.assertEqual(template.count('<posy>{{ vscale(376) }}</posy>'), 1)
        self.assertEqual(template.count('<height>{{ vscale(60) }}</height>'), 2)
        self.assertEqual(template.count('<posy>{{ vscale(431) }}</posy>'), 2)
        self.assertEqual(template.count('<posy>{{ vscale(436) }}</posy>'), 2)
        self.assertEqual(template.count('<height>{{ vscale(35) }}</height>'), 4)
        self.assertNotIn('<scroll>true</scroll>', template)

    def test_full_size_library_focus_lifts_art_without_moving_caption_text(self):
        template = _read(POSTERS_TEMPLATE)
        focused = template.split('<!-- FOCUSED LAYOUT ####################################### -->', 1)[1]
        focused = focused.split('</focusedlayout>', 1)[0]

        self.assertEqual(focused.count('effect="zoom"'), 1)
        self.assertIn(
            'reversible="true" condition="Control.HasFocus(101)">Conditional</animation>',
            focused,
        )
        self.assertIn('center="127,{{ vscale(371) }}"', focused)
        self.assertNotIn('center="127,{{ vscale(185) }}"', focused)
        self.assertNotIn('reversible="false">Focus</animation>', focused)
        self.assertNotIn('reversible="false">UnFocus</animation>', focused)
        self.assertIn(
            '                        </control>\n'
            '                    </control>\n'
            '                    <control type="textbox">\n'
            '                        <autoscroll>false</autoscroll>\n'
            '                        <posx>5</posx>\n'
            '                        <posy>{{ vscale(376) }}</posy>',
            focused,
        )
        self.assertEqual(focused.count('<posy>{{ vscale(436) }}</posy>'), 2)

    def test_library_actions_use_the_tvos_style_and_explicit_navigation(self):
        template = _read(POSTERS_TEMPLATE)
        buttons = _read(THEMED_BUTTON)
        navigation = _read(LIBRARY_NAVIGATION)

        library_play_start = buttons.index('{% if name in ("play",')
        library_play_end = buttons.index(
            "{% elif preplay_style or episode_style",
            library_play_start,
        )
        library_play = buttons[library_play_start:library_play_end]
        library_icons_start = buttons.index(
            '    {% else %}\n    <animation effect="zoom"',
            library_play_end,
        )
        library_icons_end = buttons.index("    {% endif %}", library_icons_start)
        library_icons = buttons[library_icons_start:library_icons_end]

        self.assertIn('library_style = True', template)
        self.assertIn('<posx>155</posx>', template)
        self.assertIn('<itemgap>14</itemgap>', template)
        self.assertIn("script.plex/white-square-6px.png", library_play)
        self.assertNotIn("circle-152.png", library_play)
        self.assertIn("script.plex/white-square-6px.png", library_icons)
        self.assertNotIn("circle-152.png", library_icons)
        self.assertIn("<width>78</width>", library_icons)
        self.assertIn('<onup>200</onup>', navigation)
        self.assertIn('<ondown>101</ondown>', navigation)
        for control_id in (301, 302, 303, 304, 600):
            self.assertIn(str(control_id), navigation)

    def test_view_type_cycle_restores_the_action_after_a_required_refill(self):
        source = _read(LIBRARY_PYTHON)
        first_init = source[
            source.index("    def onFirstInit(self):"):
            source.index("    def doRefill(self):")
        ]
        refill = source[
            source.index("    def doRefill(self):"):
            source.index("    def onReInit(self):")
        ]
        view_type = source[
            source.index("    def viewTypeButtonClicked(self):"):
            source.index("    def sortShowPanel(", source.index("    def viewTypeButtonClicked(self):"))
        ]

        self.assertIn("self.focusViewTypeOnRefill = False", source)
        self.assertIn("self.focusViewTypeOnRefill = False", first_init)
        self.assertIn("self.focusViewTypeOnRefill = True", view_type)
        self.assertLess(
            view_type.index("self.focusViewTypeOnRefill = True"),
            view_type.index("self.nextWindow()"),
        )
        self.assertIn("focus_view_type = self.focusViewTypeOnRefill", refill)
        self.assertIn("self.focusViewTypeOnRefill = False", refill)
        self.assertIn(
            "elif focus_view_type:\n            self.setFocusId(self.VIEWTYPE_BUTTON_ID)",
            refill,
        )

    def test_compact_posters_share_tvos_actions_and_rounded_focus_art(self):
        template = _read(COMPACT_POSTERS_TEMPLATE)

        self.assertIn("library_style = True", template)
        self.assertIn('<posx>155</posx>', template)
        self.assertIn('<itemgap>14</itemgap>', template)
        self.assertIn('<posx>100</posx>', template)
        self.assertIn('<width>1680</width>', template)
        self.assertGreaterEqual(template.count('diffuse="script.plex/poster-rounded-mask.png"'), 4)
        focus = template.index('script.plex/poster-rounded-focus.png')
        art = template.index('diffuse="script.plex/poster-rounded-mask.png"', focus)
        self.assertLess(focus, art)
        self.assertNotIn('script.plex/poster-rounded-outline.png', template)
        self.assertNotIn('script.plex/home/selected.png', template)
        focused = template.split('<!-- FOCUSED LAYOUT ####################################### -->', 1)[1]
        focused = focused.split('</focusedlayout>', 1)[0]
        self.assertEqual(focused.count('effect="zoom"'), 1)
        self.assertIn('center="135,{{ vscale(398) }}"', focused)
        self.assertIn('reversible="true" condition="Control.HasFocus(101)">Conditional</animation>', focused)

    def test_small_posters_remain_dense_without_overlapping_or_square_focus(self):
        template = _read(SMALL_POSTERS_TEMPLATE)

        self.assertIn("library_style = True", template)
        self.assertIn('<posx>100</posx>', template)
        self.assertIn('<width>1700</width>', template)
        self.assertIn('<itemlayout width="170"', template)
        self.assertIn('center="77,{{ vscale(223) }}"', template)
        self.assertGreaterEqual(template.count('diffuse="script.plex/poster-rounded-mask.png"'), 4)
        focus = template.index('script.plex/poster-small-rounded-focus.png')
        art = template.index('diffuse="script.plex/poster-rounded-mask.png"', focus)
        self.assertLess(focus, art)
        self.assertNotIn('script.plex/poster-small-rounded-outline.png', template)
        self.assertNotIn('script.plex/home/selected.png', template)
        self.assertGreaterEqual(template.count('<height>{{ vscale(42) }}</height>'), 5)
        self.assertNotIn('[COLOR A0FFFFFF]($INFO[ListItem.Property(year)])[/COLOR]', template)
        self.assertNotIn('<scroll>true</scroll>', template)
        self.assertNotIn('<scrollspeed>', template)
        focused = template.split('<!-- FOCUSED LAYOUT ####################################### -->', 1)[1]
        focused = focused.split('</focusedlayout>', 1)[0]
        self.assertEqual(focused.count('effect="zoom"'), 1)
        self.assertIn('reversible="true" condition="Control.HasFocus(101)">Conditional</animation>', focused)
        self.assertIn(
            '                        </control>\n'
            '                    </control>\n'
            '                    <control type="label">\n'
            '                        <visible>String.IsEmpty(ListItem.Property(subtitle))',
            focused,
        )
        self.assertEqual(focused.count('<posy>{{ vscale(223) }}</posy>'), 3)

    def test_small_compact_posters_keep_density_with_clean_artwork_chrome(self):
        template = _read(SMALL_COMPACT_POSTERS_TEMPLATE)

        self.assertIn("library_style = True", template)
        self.assertIn('<posx>100</posx>', template)
        self.assertIn('<width>1700</width>', template)
        self.assertIn('<itemlayout width="170"', template)
        self.assertIn('center="86,{{ vscale(249) }}"', template)
        self.assertGreaterEqual(template.count('diffuse="script.plex/poster-rounded-mask.png"'), 4)
        focus = template.index('script.plex/poster-small-compact-rounded-focus.png')
        art = template.index('diffuse="script.plex/poster-rounded-mask.png"', focus)
        self.assertLess(focus, art)
        self.assertNotIn('script.plex/poster-small-compact-rounded-outline.png', template)
        self.assertNotIn('script.plex/home/selected.png', template)
        focused = template.split('<!-- FOCUSED LAYOUT ####################################### -->', 1)[1]
        focused = focused.split('</focusedlayout>', 1)[0]
        self.assertEqual(focused.count('effect="zoom"'), 1)
        self.assertIn('reversible="true" condition="Control.HasFocus(101)">Conditional</animation>', focused)

    def test_list_view_uses_shared_actions_rounded_hero_and_white_row_focus(self):
        template = _read(LISTVIEW_TEMPLATE)

        self.assertIn("library_style = True", template)
        self.assertIn('<posx>155</posx>', template)
        self.assertIn('<itemgap>14</itemgap>', template)
        self.assertEqual(template.count('diffuse="script.plex/landscape-rounded-mask.png"'), 2)
        self.assertIn('<autoscroll>false</autoscroll>', template)
        self.assertEqual(template.count('<colordiffuse>F2F5F5F5</colordiffuse>'), 1)
        self.assertEqual(template.count('texturefocus colordiffuse="FFF5F5F5"'), 3)
        self.assertGreaterEqual(template.count('<height>{{ vscale(34) }}</height>'), 6)
        self.assertIn('<textcolor>A0000000</textcolor>', template)

    def test_list_view_hero_title_and_duration_have_independent_bounded_rails(self):
        template = _read(LISTVIEW_TEMPLATE)
        hero = template.split('{% block content %}', 1)[1].split('<control type="group" id="50">', 1)[0]

        title = hero.split('<control type="textbox">', 1)[1].split('</control>', 1)[0]
        duration = hero.split('<control type="label">', 1)[1].split('</control>', 1)[0]

        self.assertIn('<posy>{{ vscale(355) }}</posy>', title)
        self.assertIn('<width>440</width>', title)
        self.assertIn('<height>{{ vscale(80) }}</height>', title)
        self.assertIn('<autoscroll>false</autoscroll>', title)
        self.assertIn('<posx>470</posx>', duration)
        self.assertIn('<width>160</width>', duration)
        self.assertLessEqual(440 + 30, 470)

    def test_square_grid_uses_aspect_correct_art_and_stable_white_focus(self):
        template = _read(SQUARES_TEMPLATE)

        self.assertIn("library_style = True", template)
        self.assertIn('<posx>100</posx>', template)
        self.assertIn('<width>1680</width>', template)
        self.assertIn('<itemlayout width="280"', template)
        self.assertGreaterEqual(template.count('diffuse="script.plex/square-rounded-mask.png"'), 4)
        self.assertEqual(template.count('script.plex/square-rounded-focus.png'), 1)
        self.assertNotIn('script.plex/square-rounded-outline.png', template)
        self.assertNotIn('script.plex/home/selected.png', template)
        self.assertEqual(template.count('<height>{{ vscale(254) }}</height>'), 1)
        self.assertIn(
            '<animation effect="zoom" start="100" end="106" time="110" '
            'center="127,{{ vscale(127) }}" reversible="true" '
            'condition="Control.HasFocus(101)">Conditional</animation>',
            template,
        )
        self.assertNotIn('start="100" end="110"', template)
        focused_layout = template.index('<focusedlayout width="280"')
        focus_plate = template.index('script.plex/square-rounded-focus.png', focused_layout)
        focused_art = template.index('diffuse="script.plex/square-rounded-mask.png"', focused_layout)
        self.assertLess(focus_plate, focused_art)
        self.assertNotIn('<scroll>true</scroll>', template)
        self.assertNotIn('<scroll>Control.HasFocus', template)

    def test_square_list_view_shares_tvos_actions_art_masks_and_white_focus(self):
        template = _read(SQUARE_LISTVIEW_TEMPLATE)

        self.assertIn("library_style = True", template)
        self.assertIn('<posx>100</posx>', template)
        self.assertGreaterEqual(template.count('diffuse="script.plex/landscape-rounded-mask.png"'), 2)
        self.assertIn('diffuse="script.plex/square-rounded-mask.png"', template)
        self.assertIn('<autoscroll>false</autoscroll>', template)
        self.assertEqual(template.count('<colordiffuse>F2F5F5F5</colordiffuse>'), 1)
        self.assertIn('<texturesliderbarfocus colordiffuse="FFF5F5F5"', template)
        self.assertIn('<colordiffuse>FFF5F5F5</colordiffuse>', template)

    def test_square_list_hero_metadata_stays_inside_its_detail_column(self):
        template = _read(SQUARE_LISTVIEW_TEMPLATE)
        hero = template.split('{% block content %}', 1)[1].split('<control type="group" id="50">', 1)[0]

        self.assertEqual(hero.count('<control type="textbox">'), 3)
        self.assertEqual(hero.count('<autoscroll>false</autoscroll>'), 3)
        self.assertIn('<width>400</width>', hero)
        self.assertIn('<posx>430</posx>', hero)
        self.assertIn('<width>200</width>', hero)
        self.assertNotIn('<posx>630</posx>', hero)
        self.assertLessEqual(400 + 30, 430)
        self.assertIn('<onleft>101</onleft>', template)

    def test_list_view_hero_summaries_are_bounded_without_scrolling(self):
        source = _read(LIBRARY_PYTHON)

        self.assertIn("from lib.home_hero import _short_text", source)
        self.assertIn("def _set_summary(mli, summary):", source)
        self.assertIn(
            "mli.setProperty('summary.short', _short_text(summary, limit=400))",
            source,
        )
        self.assertEqual(
            source.count("\n                        _set_summary(mli,"),
            3,
        )

        for path in (LISTVIEW_TEMPLATE, SQUARE_LISTVIEW_TEMPLATE):
            template = _read(path)
            hero = template.split('{% block content %}', 1)[1].split(
                '<control type="group" id="50">',
                1,
            )[0]
            self.assertIn("ListItem.Property(summary.short)", hero)
            self.assertNotIn("ListItem.Property(summary)]", hero)
            self.assertIn("<autoscroll>false</autoscroll>", hero)

    def test_shared_library_header_and_filters_never_fall_back_to_orange_focus(self):
        template = _read(LIBRARY_TEMPLATE)

        self.assertNotIn('texturefocus colordiffuse="FFE5A00D"', template)
        self.assertGreaterEqual(template.count('texturefocus colordiffuse="FFF5F5F5"'), 6)

    def test_library_chrome_uses_neutral_focus_and_real_transparent_textures(self):
        invalid_texture_sentinels = (
            "<texturefocus>-</texturefocus>",
            "<texturenofocus>-</texturenofocus>",
            "<textureslidernib>-</textureslidernib>",
            "<textureslidernibfocus>-</textureslidernibfocus>",
            "<lefttexture>-</lefttexture>",
            "<righttexture>-</righttexture>",
            "<overlaytexture>-</overlaytexture>",
        )

        for path in LIBRARY_CHROME_TEMPLATES:
            template = _read(path)
            self.assertNotIn("FFE5A00D", template, path)
            for sentinel in invalid_texture_sentinels:
                self.assertNotIn(sentinel, template, path)
            self.assertIn("script.plex/transparent-6px.png", template, path)

        for path in (
            POSTERS_TEMPLATE,
            COMPACT_POSTERS_TEMPLATE,
            SMALL_POSTERS_TEMPLATE,
            SMALL_COMPACT_POSTERS_TEMPLATE,
        ):
            self.assertIn("FFCC7B19", _read(path), path)

    def test_shared_library_background_uses_the_tvos_readability_wash(self):
        template = _read(LIBRARY_TEMPLATE)

        self.assertIn('{% include "includes/default_background.xml.tpl" %}', template)
        self.assertIn(
            '<texture colordiffuse="B0FFFFFF">script.plex/home/tvos-background-wash.png</texture>',
            template,
        )
        self.assertLess(
            template.index('script.plex/home/tvos-background-wash.png'),
            template.index('{% block header %}'),
        )

    def test_shared_library_header_keeps_long_section_names_stable(self):
        template = _read(LIBRARY_TEMPLATE)

        self.assertIn('<width max="650">auto</width>', template)
        self.assertIn('$INFO[Window.Property(screen.title)]', template)
        self.assertIn('<scroll>false</scroll>', template)
        self.assertNotIn('[UPPERCASE]$INFO[Window.Property(screen.title)]', template)
        self.assertNotIn('<scroll>true</scroll>', template)

    def test_library_filters_preserve_localized_sentence_case_in_every_view(self):
        for path in (LIBRARY_TEMPLATE, POSTERS_TEMPLATE, LISTVIEW_TEMPLATE, SQUARES_TEMPLATE):
            template = _read(path)
            self.assertNotIn('[UPPERCASE]$INFO[Window.Property(filter', template)
            self.assertNotIn('[UPPERCASE]$INFO[Window.Property(media.type)', template)
            self.assertNotIn('[UPPERCASE]$INFO[Window.Property(sort.display)', template)

    def test_dynamic_backgrounds_fall_back_from_fanart_to_item_thumbnails(self):
        window = _read(KODIGUI_WINDOW)

        self.assertIn("'defaultArt', 'art', 'parentArt', 'grandparentArt'", window)
        self.assertIn("'defaultThumb', 'thumb', 'parentThumb', 'grandparentThumb'", window)
        self.assertIn("getattr(ds, art_name, None)", window)
        self.assertIn("minimum_blur=32", window)
        self.assertIn("if background:", window)
        self.assertIn("return self.windowSetBackground(background)", window)

    def test_dynamic_backgrounds_clear_stale_art_when_item_has_no_images(self):
        window = _read(KODIGUI_WINDOW)
        update = window.split("    def updateBackgroundFrom(self, ds):", 1)[1]
        update = update.split("    def windowSetBackground(self, value):", 1)[0]

        self.assertIn("return self.windowSetBackground(BG_NA)", update)

    def test_dynamic_backgrounds_accept_zero_length_media_objects(self):
        window = _read(KODIGUI_WINDOW)
        update = window.split("    def updateBackgroundFrom(self, ds):", 1)[1]
        update = update.split("    def windowSetBackground(self, value):", 1)[0]

        self.assertIn(
            "if not util.addonSettings.dynamicBackgrounds or ds is None:",
            update,
        )
        self.assertNotIn("or not ds:", update)


if __name__ == "__main__":
    unittest.main()
