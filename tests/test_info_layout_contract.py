from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
TEMPLATES = ROOT / "resources" / "skins" / "Main" / "1080i" / "templates"
INFO = TEMPLATES / "script-plex-info.xml.tpl"
DEFAULT = TEMPLATES / "default.xml.tpl"
PYTHON = ROOT / "lib" / "windows" / "info.py"
ENGLISH = ROOT / "resources" / "language" / "resource.language.en_gb" / "strings.po"
FRENCH = ROOT / "resources" / "language" / "resource.language.fr_fr" / "strings.po"


class InfoLayoutContractTests(unittest.TestCase):
    def test_info_uses_the_shared_background_and_aspect_specific_rounded_art(self):
        template = INFO.read_text()

        self.assertIn('includes/default_background.xml.tpl', template)
        self.assertIn('script.plex/home/tvos-background-wash.png', template)
        for mask in (
            'poster-rounded-mask.png',
            'square-rounded-mask.png',
            'landscape-rounded-mask.png',
        ):
            self.assertIn(mask, template)
        self.assertIn('<posx>160</posx>', template)

    def test_info_has_bounded_summary_and_a_separate_media_panel(self):
        template = INFO.read_text()
        source = PYTHON.read_text()

        self.assertIn('Window.Property(info.summary)', template)
        self.assertIn('Window.Property(info.media)', template)
        self.assertGreaterEqual(template.count('<autoscroll>false</autoscroll>'), 4)
        self.assertIn("self.setProperty('info.summary', summary)", source)
        self.assertIn("self.setProperty('info.media', mediaInfo)", source)
        self.assertNotIn('\\n\\n\\n\\nMedia', source)
        self.assertNotIn('Media{}', source)

    def test_info_focus_graph_is_white_and_reaches_header_scrollbar_and_done(self):
        template = INFO.read_text()
        shell = DEFAULT.read_text()
        source = PYTHON.read_text()

        self.assertIn('<defaultcontrol always="true">150</defaultcontrol>', template)
        self.assertIn('<control type="button" id="150">', template)
        self.assertIn('<control type="scrollbar" id="152">', template)
        self.assertIn('<onup>201</onup>', template)
        self.assertIn('<ondown>150</ondown>', template)
        self.assertIn('texturesliderbarfocus colordiffuse="FFFFFFFF"', template)
        self.assertIn('<textureslidernib>script.plex/transparent-6px.png</textureslidernib>', template)
        self.assertNotIn('<textureslidernib>-</textureslidernib>', template)
        self.assertNotIn('>-<', shell)
        self.assertNotIn('FFE5A00D', template)
        self.assertIn('CLOSE_BUTTON_ID = 150', source)
        self.assertIn('self.setFocusId(self.CLOSE_BUTTON_ID)', source)

    def test_info_header_actions_and_missing_art_are_safe(self):
        source = PYTHON.read_text()

        self.assertIn('artwork.is_usable_art(self.thumb)', source)
        self.assertIn('HOME_BUTTON_ID = 201', source)
        self.assertIn('SEARCH_BUTTON_ID = 202', source)
        self.assertIn('self.goHome()', source)
        self.assertIn('search.dialog(self, section_id=sectionID)', source)

    def test_info_copy_is_localized_in_english_and_french(self):
        english = ENGLISH.read_text()
        french = FRENCH.read_text()

        for context, english_text, french_text in (
            ('35039', 'Media Details', 'Détails du média'),
            ('35040', 'Done', 'Terminé'),
            ('35041', 'File', 'Fichier'),
            ('35042', 'Added', 'Ajouté le'),
            ('35043', 'Size', 'Taille'),
            ('35044', 'Mapped via', 'Chemin mappé via'),
            ('35045', 'Files', 'Fichiers'),
            ('35046', 'Parts', 'Segments'),
            ('35047', 'Default', 'Par défaut'),
        ):
            self.assertIn('msgctxt "#{}"'.format(context), english)
            self.assertIn('msgid "{}"'.format(english_text), english)
            self.assertIn('msgctxt "#{}"'.format(context), french)
            self.assertIn('msgstr "{}"'.format(french_text), french)

    def test_info_technical_details_use_individually_spaced_facts(self):
        source = PYTHON.read_text()

        self.assertIn('" • ".join(str(value) for value in videoParts if value)', source)
        self.assertIn('" • ".join(str(value) for value in audioParts if value)', source)
        self.assertIn('"{} × {}".format(stream.width, stream.height)', source)
        self.assertIn('"{}-bit".format(stream.bitDepth)', source)
        self.assertIn('"{} ch".format(stream.channels)', source)
        self.assertIn('"{} kbit/s".format(stream.bitrate)', source)


if __name__ == '__main__':
    unittest.main()
