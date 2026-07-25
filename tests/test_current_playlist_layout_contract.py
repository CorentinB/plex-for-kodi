from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
TEMPLATES = ROOT / "resources" / "skins" / "Main" / "1080i" / "templates"
MUSIC_QUEUE = TEMPLATES / "script-plex-music_current_playlist.xml.tpl"
VIDEO_QUEUE = TEMPLATES / "script-plex-video_current_playlist.xml.tpl"
TRACK_CONTEXT = TEMPLATES / "script-plex-track_context.xml.tpl"
AUDIO_ROW = TEMPLATES / "includes" / "current_playlist_audio_row.xml.tpl"
VIDEO_ROW = TEMPLATES / "includes" / "current_playlist_video_row.xml.tpl"
BUTTONS = TEMPLATES / "includes" / "music_player_buttons.xml.tpl"
SEEK_DIALOG = ROOT / "lib" / "windows" / "seekdialog.py"
VIDEO_QUEUE_HARNESS = ROOT / "tools" / "kodi_video_queue_harness.py"
CURRENT_PLAYLIST = ROOT / "lib" / "windows" / "currentplaylist.py"
MUSIC_PLAYER = ROOT / "lib" / "windows" / "musicplayer.py"
WINDOW_UTILS = ROOT / "lib" / "windows" / "windowutils.py"
ENGLISH = ROOT / "resources" / "language" / "resource.language.en_gb" / "strings.po"
FRENCH = ROOT / "resources" / "language" / "resource.language.fr_fr" / "strings.po"


class CurrentPlaylistLayoutContractTests(unittest.TestCase):
    def test_music_queue_uses_a_tvos_now_playing_and_rounded_queue_split(self):
        template = MUSIC_QUEUE.read_text()

        self.assertIn("script.plex/home/tvos-background-wash.png", template)
        self.assertIn("script.plex/square-rounded-mask.png", template)
        self.assertIn("script.plex/square-rounded-outline.png", template)
        self.assertIn('colordiffuse="24FFFFFF"', template)
        self.assertIn("script.plex/white-square-rounded.png", template)
        self.assertIn("String.IsEmpty(Player.Art(landscape))", template)
        self.assertIn("script.plex/home/background-fallback.png", template)
        self.assertIn("$ADDON[script.plexmod 35036]", template)
        self.assertIn("$ADDON[script.plexmod 35037]", template)
        self.assertIn('id="101"', template)
        self.assertIn('id="500"', template)
        self.assertIn('id="400"', template)

    def test_music_queue_rows_are_stable_and_focus_is_white(self):
        row = AUDIO_ROW.read_text()

        self.assertIn("script.plex/square-rounded-mask.png", row)
        self.assertIn("<colordiffuse>FFF7F7F7</colordiffuse>", row)
        self.assertGreaterEqual(row.count("<scroll>false</scroll>"), 4)
        self.assertEqual(row.count("<focusedlayout"), 1)

    def test_music_queue_has_an_explicit_list_seek_controls_focus_graph(self):
        template = MUSIC_QUEUE.read_text()
        buttons = BUTTONS.read_text()
        source = CURRENT_PLAYLIST.read_text()
        player_source = MUSIC_PLAYER.read_text()

        self.assertIn("<ondown>500</ondown>", template)
        self.assertIn("<onup>101</onup>", template)
        self.assertIn("<ondown>406</ondown>", template)
        self.assertIn('queue_style=True', template)
        self.assertNotIn("pq.hasprevious", buttons)
        self.assertIn("Window.Property(pq.hasprev)", buttons)
        self.assertIn('<onright condition="MusicPlayer.HasNext | !String.IsEmpty(Window.Property(pq.hasnext))">409</onright>', buttons)
        self.assertIn("<onright>410</onright>", buttons)
        self.assertIn('<onleft condition="MusicPlayer.HasNext | !String.IsEmpty(Window.Property(pq.hasnext))">409</onleft>', buttons)
        self.assertIn("<onleft>407</onleft>", buttons)
        for control_id in (401, 402, 404, 406, 407, 409, 410, 411, 422, 500):
            self.assertIn(str(control_id), buttons + template)
        self.assertIn("SEEK_IMAGE_WIDTH = 630", source)
        self.assertIn("BAR_X = 90", source)
        self.assertIn("self.BAR_X + w", source)
        self.assertIn("BAR_X = 0", player_source)

    def test_music_queue_seek_states_have_a_visible_progress_rail(self):
        template = MUSIC_QUEUE.read_text()
        seek_start = template.index("<!-- SEEK -->")
        seek_end = template.index("<!-- PLAYER CONTROLS -->", seek_start)
        seek = template[seek_start:seek_end]

        self.assertEqual(
            seek.count(
                '<texturebg colordiffuse="38FFFFFF">'
                "script.plex/white-square-6px.png</texturebg>"
            ),
            2,
        )
        self.assertEqual(
            seek.count(
                '<midtexture colordiffuse="FFFFFFFF">'
                "script.plex/white-square-6px.png</midtexture>"
            ),
            2,
        )
        self.assertNotIn("<lefttexture>", seek)
        self.assertNotIn("<righttexture>", seek)
        self.assertNotIn("<overlaytexture>", seek)

    def test_music_queue_tolerates_local_items_without_plex_tags(self):
        source = CURRENT_PLAYLIST.read_text()

        for optional_field in (
            "artist",
            "album",
            "title",
            "label",
            "comment",
            "thumbnail",
            "duration",
            "playcount",
            "track",
            "file",
        ):
            self.assertIn("pi.get('{}')".format(optional_field), source)
        self.assertIn("file_path.rsplit('/', 1)[-1]", source)
        self.assertIn("mli.dataSource.get('comment') or ''", source)
        self.assertIn("ni.dataSource.get('comment') or ''", source)
        self.assertIn("playQueue and playQueue.isShuffled", source)

    def test_music_player_surfaces_close_when_the_audio_session_ends(self):
        queue_source = CURRENT_PLAYLIST.read_text()
        player_source = MUSIC_PLAYER.read_text()

        self.assertIn("player.PLAYER.on('session.ended', self.playbackSessionEnded)", queue_source)
        self.assertIn("player.PLAYER.off('session.ended', self.playbackSessionEnded)", queue_source)
        self.assertIn("player.PLAYER.on('session.ended', self.playbackSessionEnded)", player_source)
        self.assertIn("player.PLAYER.off('session.ended', self.playbackSessionEnded)", player_source)
        self.assertIn("def playbackSessionEnded(self, **kwargs):", queue_source)
        self.assertIn("util.CRON.registerReceiver(self)", queue_source)
        self.assertIn("util.CRON.cancelReceiver(self)", queue_source)
        self.assertIn("windowutils.UtilMixin, util.CronReceiver", queue_source)
        self.assertIn("util.CRON.registerReceiver(self)", player_source)
        self.assertIn("util.CRON.cancelReceiver(self)", player_source)
        self.assertIn("def tick(self):", queue_source)
        self.assertIn("not player.PLAYER.isPlayingAudio()", queue_source)

    def test_finished_audio_returns_header_focus_to_search(self):
        source = WINDOW_UTILS.read_text()

        self.assertIn("return_focus = self.getFocusId()", source)
        self.assertIn("return_focus == getattr(self, 'PLAYER_STATUS_BUTTON_ID', 204)", source)
        self.assertIn("not player.PLAYER.isPlayingAudio()", source)
        self.assertIn("self.setFocusId(getattr(self, 'SEARCH_BUTTON_ID', 202))", source)

    def test_video_queue_is_one_rounded_non_marquee_panel(self):
        template = VIDEO_QUEUE.read_text()
        row = VIDEO_ROW.read_text()

        self.assertIn("script.plex/white-square-rounded.png", template)
        self.assertIn("$ADDON[script.plexmod 35036]", template)
        self.assertIn("script.plex/landscape-rounded-mask.png", row)
        self.assertIn("<colordiffuse>FFF7F7F7</colordiffuse>", row)
        self.assertGreaterEqual(row.count("<scroll>false</scroll>"), 4)
        self.assertEqual(row.count("<focusedlayout"), 1)
        self.assertNotIn("<focusedlayout", template)

    def test_video_queue_uses_seven_compact_rows_and_only_exposes_a_useful_scrollbar(self):
        template = VIDEO_QUEUE.read_text()
        row = VIDEO_ROW.read_text()

        self.assertIn("<posx>830</posx>", template)
        self.assertIn("<width>1040</width>", template)
        self.assertIn("<height>{{ vscale(756) }}</height>", template)
        self.assertIn('condition="Integer.IsGreater(Container(101).NumItems,7)"', template)
        self.assertIn("<visible>Integer.IsGreater(Container(101).NumItems,7)</visible>", template)
        self.assertEqual(template.count("script.plex/transparent-6px.png"), 2)
        self.assertNotIn("<textureslidernib>-</textureslidernib>", template)
        self.assertIn("<width>910</width>", row)

    def test_video_queue_refresh_restores_playing_state_and_uses_native_left_navigation(self):
        template = VIDEO_QUEUE.read_text()
        source = SEEK_DIALOG.read_text()

        self.assertIn("ManagedControlList(self, self.PLAYLIST_LIST_ID, 7)", source)
        self.assertGreaterEqual(source.count("if not self.fillPlaylist():"), 3)
        self.assertIn("self.fillPlaylist():\n            self.doClose()", source)
        self.assertIn("self.updatePlayingItem()\n\n        for ni in self.playlistListControl", source)
        self.assertIn("<onleft>Close</onleft>", template)
        self.assertIn('<control type="scrollbar" id="152">', template)
        self.assertIn("<onleft>101</onleft>", template)
        self.assertNotIn("def onAction(self, action):", source[source.index("class PlaylistDialog"):])
        self.assertIn("def _itemIdentity(item):", source)
        self.assertIn("item.get('comment') or ''", source)
        self.assertIn("getattr(video, 'ratingKey', None)", source)

    def test_native_video_queue_harness_is_local_and_never_starts_playback(self):
        source = VIDEO_QUEUE_HARNESS.read_text()

        self.assertIn("class DemoPlaylistDialog(PlaylistDialog):", source)
        self.assertIn('HARNESS_PROPERTY = "codex.video_queue_harness"', source)
        self.assertNotIn("Player.Open", source)
        self.assertNotIn("requests.", source)
        self.assertNotIn("plex.tv", source)

    def test_queue_and_context_surfaces_do_not_reintroduce_legacy_orange(self):
        source = "".join(
            path.read_text()
            for path in (MUSIC_QUEUE, VIDEO_QUEUE, TRACK_CONTEXT, AUDIO_ROW, VIDEO_ROW)
        )
        for orange in ("FFE5A00D", "FFCC7B19", "FFAC5B00"):
            self.assertNotIn(orange, source)

    def test_track_context_has_fallback_art_and_bounded_copy(self):
        template = TRACK_CONTEXT.read_text()

        self.assertIn("script.plex/home/background-fallback.png", template)
        self.assertIn("script.plex/home/tvos-background-wash.png", template)
        self.assertIn("script.plex/square-rounded-mask.png", template)
        self.assertIn("<autoscroll>false</autoscroll>", template)

    def test_queue_labels_are_localized_in_english_and_french(self):
        english = ENGLISH.read_text()
        french = FRENCH.read_text()

        for context, english_text, french_text in (
            ("35036", "Queue", "File d’attente"),
            ("35037", "Now Playing", "Lecture en cours"),
            ("35038", "Items", "Éléments"),
        ):
            self.assertIn('msgctxt "#{}"'.format(context), english)
            self.assertIn('msgid "{}"'.format(english_text), english)
            self.assertIn('msgctxt "#{}"'.format(context), french)
            self.assertIn('msgstr "{}"'.format(french_text), french)


if __name__ == "__main__":
    unittest.main()
