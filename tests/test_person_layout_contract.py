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
    "script-plex-person.xml.tpl",
)
PERSON_WINDOW = os.path.join(ROOT, "lib", "windows", "person.py")
PLEX_MEDIA = os.path.join(ROOT, "lib", "_included_packages", "plexnet", "media.py")


def _read(path):
    with open(path, "r") as handle:
        return handle.read()


class PersonLayoutContractTests(unittest.TestCase):
    def test_person_hero_uses_blurred_dynamic_art_with_tvos_wash(self):
        template = _read(TEMPLATE)
        window = _read(PERSON_WINDOW)

        self.assertIn('includes/default_background.xml.tpl', template)
        self.assertIn('script.plex/home/tvos-background-wash.png', template)
        self.assertIn('def updateBackgroundForControl', window)
        self.assertIn('if (action in MOVE_ACTIONS', window)
        self.assertGreaterEqual(window.count('self.updateBackgroundForControl(controlID)'), 2)
        self.assertIn("util.backgroundFromArt(", window)
        self.assertIn("mli.setProperty('background', background)", window)

    def test_person_details_and_rows_share_the_safe_left_rail(self):
        template = _read(TEMPLATE)

        self.assertIn('<posx>160</posx>\n        <posy>{{ vscale(145) }}</posy>', template)
        self.assertGreaterEqual(template.count('<posx>160</posx>'), 3)
        self.assertEqual(template.count('<posx>100</posx>'), 2)
        self.assertEqual(template.count('<width>1740</width>'), 2)
        self.assertIn('<posx>1580</posx>', template)
        self.assertIn('<width>180</width>', template)
        self.assertIn('<width>1100</width>', template)

    def test_person_biography_and_card_titles_never_auto_scroll(self):
        template = _read(TEMPLATE)

        self.assertIn('<autoscroll>false</autoscroll>', template)
        self.assertNotIn('<autoscroll delay=', template)
        self.assertNotIn('<scroll>Control.HasFocus', template)

    def test_person_filmography_uses_matched_poster_focus(self):
        template = _read(TEMPLATE)

        self.assertEqual(
            template.count('diffuse="script.plex/poster-home-rounded-mask.png"'),
            8,
        )
        self.assertEqual(template.count('script.plex/poster-home-rounded-focus.png'), 2)
        self.assertNotIn('script.plex/poster-rounded-mask.png', template)
        self.assertNotIn('script.plex/poster-medium-rounded-focus.png', template)
        self.assertNotIn('script.plex/poster-medium-rounded-outline.png', template)
        self.assertEqual(template.count('end="106"'), 2)
        self.assertNotIn('script.plex/home/selected.png', template)

    def test_person_async_loading_starts_on_a_focusable_control(self):
        template = _read(TEMPLATE)
        window = _read(PERSON_WINDOW)

        self.assertIn('<defaultcontrol>300</defaultcontrol>', template)
        self.assertIn('self.initialFocusPending = True', window)
        self.assertIn('self.setFocusId(self.FILMOGRAPHY_LIST_ID)', window)

    def test_discover_singleton_objects_and_bad_entries_are_normalized(self):
        window = _read(PERSON_WINDOW)
        media = _read(PLEX_MEDIA)

        self.assertIn('if not isinstance(credit_data, dict):', window)
        self.assertIn('if isinstance(credits, dict):', window)
        self.assertIn('if isinstance(credit_groups, dict):', media)
        self.assertGreaterEqual(media.count('if isinstance(credits, dict):'), 2)


if __name__ == "__main__":
    unittest.main()
