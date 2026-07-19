from __future__ import absolute_import

import os
import unittest


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TEMPLATE = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
    "script-plex-photo.xml.tpl",
)
PHOTOS_SOURCE = os.path.join(ROOT, "lib", "windows", "photos.py")
GENERATOR = os.path.join(ROOT, "tools", "generate_tvos_masks.sh")
MEDIA = os.path.join(ROOT, "resources", "skins", "Main", "media", "script.plex")


def _read(path=TEMPLATE):
    with open(path, "r") as handle:
        return handle.read()


class PhotoLayoutContractTests(unittest.TestCase):
    def test_photo_osd_is_a_compact_rounded_dock(self):
        template = _read()

        self.assertIn("<posx>480</posx>", template)
        self.assertIn("<width>960</width>", template)
        self.assertIn('border="34">script.plex/white-square-rounded.png', template)
        self.assertIn("<itemgap>-30</itemgap>", template)
        self.assertNotIn("<width>1140</width>", template)

    def test_photo_controls_use_real_transparency_and_neutral_focus(self):
        template = _read()

        self.assertNotIn("<texturefocus>-</texturefocus>", template)
        self.assertNotIn("<texturenofocus>-</texturenofocus>", template)
        self.assertGreaterEqual(template.count("script.plex/transparent-6px.png"), 4)
        self.assertNotIn("FFE5A00D", template)
        self.assertNotIn("FFCC7B19", template)

    def test_photo_queue_uses_exact_square_plate_before_art(self):
        template = _read()

        self.assertIn('<itemlayout width="150">', template)
        self.assertIn('<focusedlayout width="150">', template)
        self.assertGreaterEqual(template.count("<width>132</width><height>132</height>"), 2)
        self.assertIn("<width>142</width><height>142</height>", template)
        self.assertIn("script.plex/square-photo-queue-rounded-mask.png", template)
        self.assertIn("script.plex/square-photo-queue-rounded-focus.png", template)
        self.assertNotIn("script.plex/square-rounded-outline.png", template)

        focused = template[template.index('<focusedlayout width="150">') :]
        self.assertLess(
            focused.index("script.plex/square-photo-queue-rounded-focus.png"),
            focused.index("script.plex/square-photo-queue-rounded-mask.png"),
        )

    def test_photo_queue_assets_are_exact_source_geometry(self):
        generator = _read(GENERATOR)

        self.assertIn("magick -size 264x264 xc:none", generator)
        self.assertIn('"$MEDIA_DIR/square-photo-queue-rounded-mask.png"', generator)
        self.assertIn("magick -size 284x284 xc:none", generator)
        self.assertIn('"$MEDIA_DIR/square-photo-queue-rounded-focus.png"', generator)

        for name in (
            "square-photo-queue-rounded-mask.png",
            "square-photo-queue-rounded-focus.png",
        ):
            self.assertTrue(os.path.exists(os.path.join(MEDIA, name)), name)

    def test_photo_inspector_is_bounded_and_non_focusable(self):
        template = _read()
        inspector = template[template.index("<!-- Bounded metadata card.") :]

        self.assertIn("<posx>1390</posx>", inspector)
        self.assertIn("<width>470</width>", inspector)
        self.assertIn("<height>720</height>", inspector)
        self.assertIn("$ADDON[script.plexmod 35057]", inspector)
        self.assertIn("$ADDON[script.plexmod 35058]", inspector)
        self.assertIn("$ADDON[script.plexmod 35059]", inspector)
        self.assertIn("$ADDON[script.plexmod 35060]", inspector)
        self.assertIn(
            "<posx>96</posx><posy>366</posy><width>294</width><height>36</height>\n"
            "                <font>font10</font>",
            inspector,
        )
        self.assertNotIn('<control type="button"', inspector)

    def test_photo_filmstrip_has_explicit_remote_route(self):
        template = _read()

        self.assertIn(
            '<ondown condition="!String.IsEmpty(Window.Property(show.pqueue))">500</ondown>',
            template,
        )
        self.assertIn("<onup>412</onup>", template)
        self.assertIn("<ondown>250</ondown>", template)

    def test_photo_python_clicks_next_and_selects_filmstrip(self):
        source = _read(PHOTOS_SOURCE)

        self.assertIn("elif controlID == self.NEXT_BUTTON_ID:\n            self.next()", source)
        self.assertNotIn("elif controlID == self.NEXT_BUTTON_ID:\n            next(self)", source)
        self.assertIn("elif controlID == self.PQUEUE_LIST_ID:", source)
        self.assertIn("self.playQueue.setCurrentItem(item.dataSource)", source)
        self.assertIn("self.showPhoto()", source)
        self.assertIn("if not self.osdVisible() and not self.pqueueVisible():", source)

    def test_photo_first_filmstrip_item_is_selectable(self):
        source = _read(PHOTOS_SOURCE)

        self.assertIn("if not selected:\n            return", source)
        self.assertNotIn("if not selected or not selected.pos():", source)

    def test_photo_metadata_uses_file_size_not_orientation(self):
        source = _read(PHOTOS_SOURCE)

        self.assertIn("part_size = photo.media[0].parts[0].size.asInt()", source)
        self.assertIn("attributes.append(util.simpleSize(part_size))", source)
        self.assertNotIn("parts[0].orientation and", source)


if __name__ == "__main__":
    unittest.main()
