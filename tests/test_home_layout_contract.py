from __future__ import absolute_import

import ast
import importlib.util
import math
import os
import types
import unittest
import xml.etree.ElementTree as ElementTree


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
HERO_MODULE_PATH = os.path.join(ROOT, "lib", "home_hero.py")
HERO_SPEC = importlib.util.spec_from_file_location("home_hero_contract", HERO_MODULE_PATH)
HERO_MODULE = importlib.util.module_from_spec(HERO_SPEC)
HERO_SPEC.loader.exec_module(HERO_MODULE)
clear_logo_url_from_metadata = HERO_MODULE.clear_logo_url_from_metadata
TEMPLATE_ROOT = os.path.join(
    ROOT,
    "resources",
    "skins",
    "Main",
    "1080i",
    "templates",
)
HOME_WINDOW = os.path.join(ROOT, "lib", "windows", "home.py")
SETTINGS_WINDOW = os.path.join(ROOT, "lib", "windows", "settings.py")
FRENCH_CATALOG = os.path.join(
    ROOT,
    "resources",
    "language",
    "resource.language.fr_fr",
    "strings.po",
)

HOME_HUB_LAYOUTS = (
    "hub_itemlayout_poster.xml.tpl",
    "hub_focusedlayout_poster.xml.tpl",
    "hub_itemlayout_square.xml.tpl",
    "hub_focusedlayout_square.xml.tpl",
    "hub_itemlayout_ar16x9.xml.tpl",
    "hub_focusedlayout_ar16x9.xml.tpl",
)


def _read(*parts):
    with open(os.path.join(TEMPLATE_ROOT, *parts), "r") as handle:
        return handle.read()


def _read_file(path):
    with open(path, "r") as handle:
        return handle.read()


def _class_method(class_name, name, namespace=None):
    tree = ast.parse(_read_file(HOME_WINDOW))
    method = None
    for node in tree.body:
        if isinstance(node, ast.ClassDef) and node.name == class_name:
            method = next(
                (child for child in node.body if isinstance(child, ast.FunctionDef) and child.name == name),
                None,
            )
            break
    if method is None:
        raise AssertionError("{}.{} is missing".format(class_name, name))

    method.decorator_list = []
    module = ast.Module(body=[method], type_ignores=[])
    ast.fix_missing_locations(module)
    scope = dict(namespace or {})
    exec(compile(module, HOME_WINDOW, "exec"), scope)
    return scope[name]


def _home_method(name, namespace=None):
    return _class_method("HomeWindow", name, namespace)


class _HubFlag(object):
    def __init__(self, value=False):
        self.value = value

    def asBool(self):
        return bool(self.value)

    def __bool__(self):
        return bool(self.value)


class _HubMedia(object):
    def __init__(self, title, rating_key, media_type="movie", in_progress=False):
        self.title = title
        self.ratingKey = rating_key
        self.type = media_type
        self.TYPE = media_type
        self.in_progress = in_progress
        self.cachable = False


class _HubListItem(object):
    def __init__(self, data_source):
        self.dataSource = data_source
        self.properties = {}

    def getProperty(self, key):
        return self.properties.get(key, "")

    def setProperty(self, key, value):
        self.properties[key] = value


class _HubControl(object):
    def __init__(self, items=None, selected=0):
        self.items = list(items or ())
        self.selected = selected
        self.dataSource = None

    def __iter__(self):
        return iter(self.items)

    def __getitem__(self, index):
        return self.items[index]

    def size(self):
        return len(self.items)

    def reset(self):
        self.items = []
        self.selected = 0

    def getSelectedPos(self):
        return self.selected

    def getSelectedItem(self):
        if not self.items:
            return None
        return self.items[self.selected]

    def selectItem(self, index):
        self.selected = index

    def replaceItems(self, items):
        self.items = list(items)
        if self.items:
            self.selected = min(self.selected, len(self.items) - 1)
        else:
            self.selected = 0


class _Hub(object):
    def __init__(self, items):
        self.items = list(items)
        self.title = "Test hub"
        self.hubIdentifier = "home.test"
        self.is_watchlist = False
        self.more = _HubFlag(False)

    def reset(self):
        return None


def _show_hub_window(control, last_focus=400, any_item_action=False):
    controls = list(control) if isinstance(control, (list, tuple)) else [control]
    fake_util = types.SimpleNamespace(
        HUB_ITEM_STATES={},
        addonSettings=types.SimpleNamespace(continueUseThumb=False),
        getSetting=lambda key: False,
    )
    fake_plexapp = types.SimpleNamespace(
        util=types.SimpleNamespace(
            INTERFACE=types.SimpleNamespace(getRCBaseKey=lambda: "test")
        )
    )
    namespace = {
        "HUB_PAGE_SIZE": 10,
        "backgroundthread": types.SimpleNamespace(),
        "kodigui": types.SimpleNamespace(),
        "math": math,
        "plexapp": fake_plexapp,
        "util": fake_util,
    }

    class Window(object):
        HUB_BASE_ID = 400
        RESUME_BUTTON_ID = 205
        SINGLE_RESUME_HUBS = frozenset((
            "continueWatching",
            "home.continue",
            "movie.inprogress",
            "tv.inprogress",
            "video.inprogress",
        ))
        _showHub = _home_method("_showHub", namespace)
        _syncHomeHeroSelection = _home_method("_syncHomeHeroSelection")
        _singleResumeItem = _home_method("_singleResumeItem")
        _syncHomeResumeAction = _home_method("_syncHomeResumeAction")

        def __init__(self):
            self.hubControls = controls
            self.lastFocusID = last_focus
            self._anyItemAction = any_item_action
            self._initialHomeHeroSet = False
            self.tasks = []
            self.backgrounds = []
            self.heroes = []
            self.properties = {}
            self.focused = last_focus

        def setProperty(self, key, value):
            self.properties[key] = value

        def getProperty(self, key):
            return self.properties.get(key, "")

        def getFocusId(self):
            return self.focused

        def setFocusId(self, control_id):
            self.focused = control_id

        def createListItem(self, obj, wide=False):
            return _HubListItem(obj)

        def updateBackgroundFrom(self, obj):
            self.backgrounds.append(obj.title)
            return None

        def setHomeHeroFromDataSource(self, obj):
            self.heroes.append(obj.title)

    return Window()


def _resume_window(items=None, focused=101):
    class Window(object):
        HUB_BASE_ID = 400
        RESUME_BUTTON_ID = 205
        SINGLE_RESUME_HUBS = frozenset((
            "continueWatching",
            "home.continue",
            "movie.inprogress",
            "tv.inprogress",
            "video.inprogress",
        ))

        def __init__(self):
            self.hubControls = [_HubControl(items)]
            self.properties = {}
            self.focused = focused

        def getProperty(self, key):
            return self.properties.get(key, "")

        def setProperty(self, key, value):
            self.properties[key] = value

        def getFocusId(self):
            return self.focused

        def setFocusId(self, control_id):
            self.focused = control_id

    Window._singleResumeItem = _home_method("_singleResumeItem")
    Window._syncHomeResumeAction = _home_method("_syncHomeResumeAction")
    return Window()


def _resume_action_window():
    class Window(object):
        SECTION_LIST_ID = 101
        SERVER_LIST_ID = 260
        USER_LIST_ID = 250
        PLAYER_STATUS_BUTTON_ID = 204
        SEARCH_BUTTON_ID = 203
        HUB_BASE_ID = 400
        RESUME_BUTTON_ID = 205

        def __init__(self):
            first = _HubListItem(
                _HubMedia("Resume me", "1", in_progress=True)
            )
            self.hubControls = [
                _HubControl([first]),
                _HubControl(),
            ]
            self.properties = {"home.resume.visible": "1"}
            self.focused = self.SECTION_LIST_ID
            self.play_calls = []
            self.hub_focus = []
            self.synced = []
            self._ignoreInput = False

        def getProperty(self, key):
            return self.properties.get(key, "")

        def setFocusId(self, control_id):
            self.focused = control_id

        def hubItemClicked(self, control_id, auto_play=False):
            self.play_calls.append((control_id, auto_play))

        def _setHubFocus(self, index=None):
            self.hub_focus.append(index)

        def _syncHomeHeroSelection(self, index, control, pos=None, force=False):
            self.synced.append((index, force))
            return True

    Window._homeResumeVisible = _home_method("_homeResumeVisible")
    Window._focusHomeResumeItem = _home_method("_focusHomeResumeItem")
    Window.onClick = _home_method("onClick")
    return Window()


class HomeLayoutContractTests(unittest.TestCase):
    def test_inprogress_home_items_resume_directly_by_default(self):
        settings = _read_file(SETTINGS_WINDOW)
        resume_setting = settings.split(
            "'home_inprogress_resume'",
            1,
        )[1].split(
            ").description(",
            1,
        )[0]

        self.assertIn(
            "T(33713, 'Home: Resume in-progress items'), True",
            resume_setting,
        )

    def test_single_resume_requires_one_unpaginated_in_progress_video(self):
        item = _HubListItem(
            _HubMedia(
                "Resume me",
                "1",
                media_type="episode",
                in_progress=True,
            )
        )
        window = _resume_window([item])

        self.assertIs(
            window._singleResumeItem(
                window.hubControls[0],
                "home.continue",
                False,
            ),
            item,
        )
        self.assertIs(
            window._singleResumeItem(
                window.hubControls[0],
                "tv.inprogress",
                False,
            ),
            item,
        )
        self.assertIsNone(
            window._singleResumeItem(
                window.hubControls[0],
                "home.continue",
                True,
            )
        )
        self.assertIsNone(
            window._singleResumeItem(
                window.hubControls[0],
                "home.test",
                False,
            )
        )

    def test_single_movie_resume_supports_library_inprogress_hub(self):
        item = _HubListItem(
            _HubMedia(
                "Resume movie",
                "1",
                media_type="movie",
                in_progress=True,
            )
        )
        window = _resume_window([item])

        self.assertIs(
            window._singleResumeItem(
                window.hubControls[0],
                "movie.inprogress",
                False,
            ),
            item,
        )

    def test_single_resume_supports_section_scoped_video_inprogress_hub(self):
        resume_hubs = _read_file(HOME_WINDOW).split(
            "SINGLE_RESUME_HUBS = frozenset((",
            1,
        )[1].split("))", 1)[0]
        item = _HubListItem(
            _HubMedia(
                "Resume generic video",
                "1",
                media_type="movie",
                in_progress=True,
            )
        )
        window = _resume_window([item])

        self.assertIn("'video.inprogress'", resume_hubs)
        self.assertIs(
            window._singleResumeItem(
                window.hubControls[0],
                "video.inprogress",
                False,
            ),
            item,
        )

    def test_single_resume_rejects_multiple_or_unstarted_items(self):
        resumable = _HubListItem(
            _HubMedia("Resume me", "1", in_progress=True)
        )
        fresh = _HubListItem(
            _HubMedia("Fresh", "2", in_progress=False)
        )
        window = _resume_window([resumable, fresh])

        self.assertIsNone(
            window._singleResumeItem(
                window.hubControls[0],
                "continueWatching",
                False,
            )
        )
        self.assertIsNone(
            _resume_window([fresh])._singleResumeItem(
                _HubControl([fresh]),
                "continueWatching",
                False,
            )
        )

    def test_resume_property_is_owned_only_by_first_hub(self):
        window = _resume_window([
            _HubListItem(
                _HubMedia("Resume me", "1", in_progress=True)
            )
        ])

        window._syncHomeResumeAction(
            0,
            "home.continue",
            window.hubControls[0],
            False,
        )
        self.assertEqual(window.properties["home.resume.visible"], "1")

        window._syncHomeResumeAction(
            1,
            "home.test",
            _HubControl(),
            False,
        )
        self.assertEqual(window.properties["home.resume.visible"], "1")

        window._syncHomeResumeAction(
            0,
            "home.continue",
            _HubControl(),
            False,
        )
        self.assertEqual(window.properties["home.resume.visible"], "")

    def test_resume_click_delegates_to_first_hub_direct_playback(self):
        window = _resume_action_window()

        window.onClick(window.RESUME_BUTTON_ID)

        self.assertEqual(
            window.play_calls,
            [(window.HUB_BASE_ID, True)],
        )

    def test_resume_focus_restores_first_item_hero_and_full_composition(self):
        window = _resume_action_window()

        self.assertTrue(window._focusHomeResumeItem())

        self.assertEqual(window.hub_focus, [None])
        self.assertEqual(window.synced, [(0, True)])

    def test_resume_directional_navigation_is_owned_by_native_xml(self):
        home = _read("script-plex-home.xml.tpl")
        window = _read_file(HOME_WINDOW)

        self.assertEqual(
            home.count(
                '<ondown condition="!String.IsEmpty('
                'Window.Property(home.resume.visible))">205</ondown>'
            ),
            2,
        )
        self.assertEqual(
            home.count(
                '<ondown condition="String.IsEmpty('
                'Window.Property(home.resume.visible))">400</ondown>'
            ),
            2,
        )
        resume = home.split(
            '<control type="button" id="205">',
            1,
        )[1].split("</control>", 1)[0]
        self.assertIn("<ondown>401</ondown>", resume)
        self.assertIn("{% elif i == 1 %}", home)
        self.assertIn(
            '<onup condition="!String.IsEmpty('
            'Window.Property(home.resume.visible))">205</onup>',
            home,
        )
        self.assertIn('<control type="group" id="206">', home)
        resume_wrapper = home.split(
            '<control type="group" id="206">',
            1,
        )[1].split("</control>", 1)[0]
        self.assertIn(
            'condition="!String.IsEmpty(Window.Property(hub.scrolled))"',
            resume_wrapper,
        )
        self.assertNotIn("_routeHomeResumeAction", window)
        self.assertNotIn("_returnToHomeResumeAction", window)

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

    def test_watchlist_discover_hub_prefix_is_localized_in_french(self):
        french = _read_file(FRENCH_CATALOG)
        entry = french.split('msgctxt "#34019"', 1)[1].split("msgctxt", 1)[0]

        self.assertIn('msgid "Discover: {}"', entry)
        self.assertIn('msgstr "Découvrir : {}"', entry)

    def test_down_commits_new_section_before_hub_navigation(self):
        window = _read_file(HOME_WINDOW)
        on_action = window.split("def onAction(self, action):", 1)[1]
        on_action = on_action.split("def onClick(self, controlID):", 1)[0]

        commit = (
            "if (action == xbmcgui.ACTION_MOVE_DOWN\n"
            "                        and self._commitSectionBeforeHubNavigation()):\n"
            "                    return"
        )
        self.assertIn(commit, on_action)
        self.assertLess(
            on_action.index(commit),
            on_action.index("self.checkSectionItem(action=action)"),
        )

    def test_down_recovers_when_native_focus_reaches_stale_hub(self):
        window = _read_file(HOME_WINDOW)
        on_action = window.split("def onAction(self, action):", 1)[1]
        on_action = on_action.split("def onClick(self, controlID):", 1)[0]

        recovery = (
            "if (action == xbmcgui.ACTION_MOVE_DOWN\n"
            "                    and (controlID == self.RESUME_BUTTON_ID or 399 < controlID < 500)\n"
            "                    and self._commitSectionBeforeHubNavigation()):\n"
            "                return"
        )
        self.assertIn(recovery, on_action)
        self.assertLess(
            on_action.index(recovery),
            on_action.index("if controlID == self.SERVER_BUTTON_ID:"),
        )

    def test_section_commit_cancels_debounce_and_focuses_loaded_hub(self):
        class SectionList(object):
            def __init__(self, item):
                self.item = item

            def getSelectedItem(self):
                return self.item

        class Window(object):
            _commitSectionBeforeHubNavigation = _home_method(
                "_commitSectionBeforeHubNavigation"
            )

            def __init__(self, selected, current):
                self.sectionList = SectionList(
                    types.SimpleNamespace(dataSource=selected)
                )
                self.lastSection = current
                self.sectionChangeTimeout = 42
                self.committed = []
                self._pendingSectionHubFocus = None
                self.focusRequests = []

            def _sectionReallyChanged(self, section):
                self.committed.append(section)

            def _focusPendingSectionHub(self, section):
                self.focusRequests.append(section)

        current = object()
        selected = object()
        window = Window(selected, current)

        self.assertTrue(window._commitSectionBeforeHubNavigation())
        self.assertIsNone(window.sectionChangeTimeout)
        self.assertEqual(window.committed, [selected])
        self.assertIs(window._pendingSectionHubFocus, selected)
        self.assertEqual(window.focusRequests, [selected])

        unchanged = Window(current, current)
        self.assertFalse(unchanged._commitSectionBeforeHubNavigation())
        self.assertEqual(unchanged.sectionChangeTimeout, 42)
        self.assertEqual(unchanged.committed, [])
        self.assertIsNone(unchanged._pendingSectionHubFocus)
        self.assertEqual(unchanged.focusRequests, [])

    def test_section_debounce_does_not_wait_for_unrelated_hub_tasks(self):
        started = []

        class Thread(object):
            def __init__(self, target, name):
                self.target = target
                self.name = name

            def start(self):
                started.append((self.target, self.name))

        class Monitor(object):
            def waitAmount(self, *args, **kwargs):
                raise AssertionError("section focus must not block on hub tasks")

        class Window(object):
            sectionChanged = _home_method(
                "sectionChanged",
                {
                    "threading": types.SimpleNamespace(Thread=Thread),
                    "time": types.SimpleNamespace(time=lambda: 100),
                    "util": types.SimpleNamespace(MONITOR=Monitor()),
                },
            )

            def __init__(self):
                self._shuttingDown = False
                self.tasks = [object()]
                self.sectionChangeThread = None
                self.sectionChangeTimeout = 0

            def _sectionChanged(self, immediate=False):
                return None

        window = Window()
        window.sectionChanged()

        self.assertEqual(window.sectionChangeTimeout, 100.5)
        self.assertEqual(started, [(window._sectionChanged, "sectionchanged")])

    def test_pending_section_down_focus_waits_for_real_hub_controls(self):
        class Window(object):
            _focusPendingSectionHub = _home_method("_focusPendingSectionHub")

            def __init__(self, section):
                self._pendingSectionHubFocus = section
                self.lastSection = section
                self.hubFocusIndexes = (0, 1)
                self.hubControls = ([], [])
                self.focused = 0

            def focusFirstValidHub(self, force=False):
                self.focused += 1

        section = object()
        window = Window(section)

        self.assertFalse(window._focusPendingSectionHub(section))
        self.assertIs(window._pendingSectionHubFocus, section)
        self.assertEqual(window.focused, 0)

        window.hubControls = ([object()], [])
        self.assertTrue(window._focusPendingSectionHub(section))
        self.assertIsNone(window._pendingSectionHubFocus)
        self.assertEqual(window.focused, 1)

        self.assertFalse(window._focusPendingSectionHub(section))
        self.assertEqual(window.focused, 1)

    def test_valid_hub_focus_always_synchronizes_its_selected_item(self):
        class Window(object):
            SECTION_LIST_ID = 101
            focusFirstValidHub = _home_method(
                "focusFirstValidHub",
                {"util": types.SimpleNamespace(DEBUG_LOG=lambda *args: None)},
            )

            def __init__(self):
                self.hubFocusIndexes = (0,)
                self.hubControls = ([object()],)
                self.lastFocusID = 400
                self.focused = []
                self.checked = []

            def setFocusId(self, control_id):
                self.focused.append(control_id)

            def checkHubItem(self, control_id):
                self.checked.append(control_id)

        window = Window()
        window.focusFirstValidHub()

        self.assertEqual(window.focused, [])
        self.assertEqual(window.checked, [400])

    def test_hub_focus_resynchronizes_artwork_after_header_entry(self):
        class Window(object):
            HUB_BASE_ID = 400
            RESUME_BUTTON_ID = 205
            SECTION_LIST_ID = 101
            SEARCH_BUTTON_ID = 203
            SERVER_BUTTON_ID = 202
            USER_BUTTON_ID = 201
            PLAYER_STATUS_BUTTON_ID = 204
            onFocus = _home_method(
                "onFocus",
                {
                    "time": types.SimpleNamespace(time=lambda: 100),
                    "xbmc": types.SimpleNamespace(
                        getCondVisibility=lambda condition: False,
                    ),
                    "util": types.SimpleNamespace(
                        setGlobalBoolProperty=lambda *args: None,
                    ),
                },
            )

            def __init__(self):
                self._goRootHoldUntil = 0
                self.lastFocusID = self.SECTION_LIST_ID
                self.hubFocusIndexes = (0,)
                self.hubControls = (["selected"],)
                self.movingSection = False
                self.focused_hubs = []
                self.synced = []

            def _setHubFocus(self, index=None):
                self.focused_hubs.append(index)

            def _syncHomeHeroSelection(self, index, control, force=False):
                self.synced.append((index, control, force))

        window = Window()
        window.onFocus(400)

        self.assertEqual(window.lastFocusID, 400)
        self.assertEqual(window.focused_hubs, [0])
        self.assertEqual(window.synced, [(0, window.hubControls[0], True)])

    def test_pending_section_focus_reasserts_native_focus_after_detail_return(self):
        class Window(object):
            SECTION_LIST_ID = 101
            focusFirstValidHub = _home_method(
                "focusFirstValidHub",
                {"util": types.SimpleNamespace(DEBUG_LOG=lambda *args: None)},
            )
            _focusPendingSectionHub = _home_method("_focusPendingSectionHub")

            def __init__(self, section):
                self._pendingSectionHubFocus = section
                self.lastSection = section
                self.hubFocusIndexes = (0,)
                self.hubControls = ([object()],)
                self.lastFocusID = 400
                self.focused = []
                self.checked = []

            def setFocusId(self, control_id):
                self.focused.append(control_id)

            def checkHubItem(self, control_id):
                self.checked.append(control_id)

        section = object()
        window = Window(section)

        self.assertTrue(window._focusPendingSectionHub(section))
        self.assertEqual(window.focused, [400])
        self.assertEqual(window.checked, [400])

    def test_completed_hub_draw_fulfills_pending_section_down_focus_after_reveal(self):
        window = _read_file(HOME_WINDOW)
        show_hubs = window.split(
            "    def showHubs(self, section=None, update=False, force=False, reselect_pos_dict=None):",
            1,
        )[1].split("    def getCurrentHubsPositions(", 1)[0]

        self.assertIn("self._focusPendingSectionHub(section)", show_hubs)
        self.assertLess(
            show_hubs.index("self.setProperty('drawing', '')"),
            show_hubs.index("self._focusPendingSectionHub(section)"),
        )

    def test_pending_section_focus_runs_when_hubs_are_focusable(self):
        class Lock(object):
            def __enter__(self):
                return self

            def __exit__(self, exc_type, exc_value, traceback):
                return False

        class Window(object):
            showHubs = _home_method("showHubs")

            def __init__(self):
                self.lock = Lock()
                self.properties = {}
                self.focus_states = []

            def setBoolProperty(self, key, value):
                self.properties[key] = value

            def setProperty(self, key, value):
                self.properties[key] = value

            def _showHubs(self, **kwargs):
                self.assert_drawing = self.properties.get("drawing")

            def _focusPendingSectionHub(self, section):
                self.focus_states.append(
                    (section, self.properties.get("drawing"))
                )

        section = object()
        window = Window()
        window.showHubs(section)

        self.assertEqual(window.assert_drawing, "1")
        self.assertEqual(window.focus_states, [(section, "")])

    def test_playlist_hub_uses_localized_title_when_server_title_is_empty(self):
        class Hub(object):
            def getCleanHubIdentifier(self, is_home=False):
                return "playlists.audio"

        class Window(object):
            showHub = _home_method(
                "showHub",
                {"PLAYLIST_HUB_TITLES": {"playlists.audio": "Audio Playlists"}},
            )

            def getHubRenderFlags(self, hub, identifier):
                return {
                    "with_progress": False,
                    "with_art": False,
                    "ar16x9": False,
                    "text2lines": False,
                }

            def _showHub(self, hub, **kwargs):
                self.render_kwargs = kwargs

        window = Window()
        self.assertTrue(window.showHub(Hub(), hub_index=0))
        self.assertEqual(window.render_kwargs.get("title"), "Audio Playlists")

    def test_french_catalog_localizes_playlist_hub_titles(self):
        catalog = _read_file(FRENCH_CATALOG)

        self.assertIn(
            'msgctxt "#34094"\n'
            'msgid "Audio Playlists"\n'
            'msgstr "Listes de lecture audio"',
            catalog,
        )
        self.assertIn(
            'msgctxt "#34095"\n'
            'msgid "Video Playlists"\n'
            'msgstr "Listes de lecture vidéo"',
            catalog,
        )

    def test_native_home_uses_one_safe_left_edge(self):
        home = _read("script-plex-home.xml.tpl")
        content = home.split("{% endblock content %}", 1)[0]

        self.assertIn('<control type="fixedlist" id="101">', content)
        self.assertIn("<posx>160</posx>\n            <posy>{{ vscale(6) }}</posy>\n            <width>960</width>", content)
        self.assertIn("<posx>160</posx>\n            <posy>{{ vscale(142) }}</posy>\n            <width>1120</width>", content)
        self.assertIn("<posx>160</posx>\n            <posy>0</posy>\n            <width>1680</width>", content)
        self.assertIn("<posx>100</posx>\n            <posy>{{ vscale(42) }}</posy>\n            <width>1740</width>", content)

    def test_home_navigation_keeps_the_widest_end_tab_on_screen(self):
        home = _read("script-plex-home.xml.tpl")
        start = home.index('<control type="fixedlist" id="101">')
        end = home.index("</control>", start)
        nav = home[start:end]

        self.assertIn("<focusposition>1</focusposition>", nav)
        self.assertIn("<movement>1</movement>", nav)

        focused_right_edge = (
            160
            + ((1 + 1) * HERO_MODULE.NAV_SLOT_WIDTH)
            + HERO_MODULE.NAV_SHIFT_MAX
            + max(HERO_MODULE.NAV_PLATE_WIDTHS.values())
        )
        self.assertLessEqual(focused_right_edge, 1680)

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
        self.assertIn('<width>960</width>', nav)
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
        self.assertIn(
            'center="200,{{ vscale(30) }}" reversible="true" '
            'condition="Control.HasFocus(101) + '
            '!String.IsEmpty(ListItem.Property(nav.width.320)) + '
            'String.IsEmpty(ListItem.Property(is.home))"',
            nav,
        )
        self.assertNotIn('end="-92,0"', nav)
        self.assertNotIn("<posx>56</posx>", nav)
        self.assertNotIn("<posx>94</posx>", nav)
        self.assertNotIn("<width>auto</width>", nav)
        self.assertIn("nav.width.60", nav_content)
        for width in (80, 100, 120, 140, 180, 220, 260, 320):
            self.assertIn("nav_label_width = {}".format(width), nav_content)
        self.assertIn("nav.width.{{ nav_label_width }}", nav_size)
        self.assertIn("nav_label_control_width = 334", nav_content)
        self.assertNotIn('nav_scroll = "Control.HasFocus(101)"', nav)
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
            (220, 300, 326, 289),
            (260, 340, 366, 329),
            (320, 400, 426, 389),
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
            11,
        )
        self.assertEqual(
            home.count("$INFO[Window.Property(home.hero.subtitle)]"),
            2,
        )
        self.assertEqual(
            home.count("!String.IsEmpty(Window.Property(home.hero.subtitle))"),
            2,
        )
        self.assertIn("<width>700</width>", home)
        self.assertIn("<height>{{ vscale(112) }}</height>", home)
        self.assertIn("<posy>{{ vscale(-30) }}</posy>", home)
        self.assertIn("<width>620</width>", home)
        self.assertIn("<height>{{ vscale(84) }}</height>", home)
        self.assertEqual(
            home.count('<aspectratio align="left" aligny="center">keep</aspectratio>'),
            2,
        )
        self.assertEqual(home.count("<font>font45_title</font>"), 1)
        self.assertEqual(home.count("<font>font40_title</font>"), 1)

    def test_home_hero_resolves_missing_provider_logos_in_a_cached_background_task(self):
        window = _read_file(HOME_WINDOW)

        self.assertIn("class HomeHeroLogoTask(backgroundthread.Task):", window)
        self.assertIn("plexapp.SERVERMANAGER.getDiscoverServer()", window)
        self.assertIn("logo_metadata_key(data_source)", window)
        self.assertIn("self._homeHeroLogoCache", window)
        self.assertIn("self._homeHeroLogoPending", window)
        self.assertIn("backgroundthread.BGThreader.addTask(task)", window)

        refresh = window.split("def serverRefresh(self, section=None):", 1)[1]
        refresh = refresh.split("def ", 1)[0]
        self.assertIn("self._homeHeroLogoPending.clear()", refresh)

    def test_home_logo_task_retries_in_english_when_localized_metadata_has_no_logo(self):
        localized = ElementTree.fromstring(
            '<MediaContainer><Directory><Image type="background" url="/art" />'
            '</Directory></MediaContainer>'
        )
        english = ElementTree.fromstring(
            '<MediaContainer><Directory><Image type="clearLogo" url="/logo" />'
            '</Directory></MediaContainer>'
        )
        calls = []
        callbacks = []

        class Server(object):
            def __init__(self):
                self.session = types.SimpleNamespace(
                    headers={
                        "X-Plex-Language": "fr",
                        "Accept-Language": "fr-FR,fr",
                    }
                )

            def query(self, path, **kwargs):
                calls.append((path, kwargs))
                return localized if len(calls) == 1 else english

            def buildUrl(self, path, includeToken=False):
                return "https://plex.invalid{}".format(path)

        server = Server()
        fake_util = types.SimpleNamespace(
            MONITOR=types.SimpleNamespace(waitFor=lambda amount: False),
            LOG=lambda *args, **kwargs: None,
            DEBUG_LOG=lambda *args, **kwargs: None,
        )
        namespace = {
            "clear_logo_url_from_metadata": clear_logo_url_from_metadata,
            "plexapp": types.SimpleNamespace(
                SERVERMANAGER=types.SimpleNamespace(getDiscoverServer=lambda: server)
            ),
            "util": fake_util,
        }

        class Task(object):
            run = _class_method("HomeHeroLogoTask", "run", namespace)
            metadata_key = "show-id"
            is_current = staticmethod(lambda key: True)
            callback = staticmethod(lambda key, logo: callbacks.append((key, logo)))

            def isCanceled(self):
                return False

        Task().run()

        self.assertEqual(len(calls), 2)
        self.assertNotIn("headers", calls[0][1])
        self.assertNotIn("headers", calls[1][1])
        self.assertEqual(
            server.session.headers,
            {"X-Plex-Language": "en", "Accept-Language": "en-US,en"},
        )
        self.assertEqual(calls[1][1]["params"]["X-Plex-Language"], "en")
        self.assertEqual(callbacks, [("show-id", "https://plex.invalid/logo")])

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
        self.assertEqual(metadata.count('<width>86</width>'), 3)
        self.assertEqual(metadata.count('<width>150</width>'), 3)
        self.assertIn('<height>{{ vscale(28) }}</height>', metadata)
        self.assertIn('border="8" colordiffuse="C0343436"', metadata)
        self.assertNotIn('white-outline-rounded.png', metadata)
        self.assertNotIn('<posx>104</posx>', metadata)
        self.assertNotIn('<posx>168</posx>', metadata)
        self.assertNotIn('<posx>620</posx>', metadata)
        self.assertIn('<itemgap>12</itemgap>', metadata)
        self.assertEqual(metadata.count('<width>auto</width>'), 3)
        self.assertIn("Window.Property(home.hero.rating)", metadata)
        self.assertIn("Window.Property(home.hero.rating_image)", metadata)
        self.assertIn("Window.Property(home.hero.rating2)", metadata)
        self.assertIn("Window.Property(home.hero.rating2_image)", metadata)
        self.assertEqual(
            metadata.count(
                'fallback="script.plex/ratings/other/image.rating.png"'
            ),
            2,
        )
        self.assertEqual(
            metadata.count('<label>$INFO[Window.Property(home.hero.meta)]</label>'),
            1,
        )

    def test_home_hero_collapses_optional_subtitle_space(self):
        home = _read("script-plex-home.xml.tpl")
        metadata = _read("includes", "home_hero_metadata.xml.tpl")

        self.assertIn("hero_meta_empty_shift = -44", home)
        self.assertIn("hero_meta_empty_shift = -42", home)
        self.assertIn(
            'end="0,{{ vscale(hero_meta_empty_shift) }}" time="0" '
            'condition="String.IsEmpty(Window.Property(home.hero.subtitle))"',
            metadata,
        )
        self.assertIn(
            'end="0,{{ vscale(-44) }}" time="0" '
            'condition="String.IsEmpty(Window.Property(home.hero.subtitle))"',
            home,
        )
        self.assertIn(
            'end="0,{{ vscale(-42) }}" time="0" '
            'condition="String.IsEmpty(Window.Property(home.hero.subtitle))"',
            home,
        )

    def test_home_hero_gives_logo_episode_metadata_and_summary_breathing_room(self):
        home = _read("script-plex-home.xml.tpl")

        self.assertIn(
            "<posy>{{ vscale(82) }}</posy>\n"
            "                <width>880</width>\n"
            "                <height>{{ vscale(34) }}</height>",
            home,
        )
        self.assertIn(
            "hero_meta_y = 126 & hero_meta_height = 32 & "
            "hero_meta_empty_shift = -44 & hero_logo_shift = 28",
            home,
        )
        self.assertIn(
            "<posy>{{ vscale(168) }}</posy>\n"
            "                <width>920</width>\n"
            "                <height>{{ vscale(60) }}</height>",
            home,
        )
        self.assertIn(
            "<posy>{{ vscale(70) }}</posy>\n"
            "        <width>880</width>\n"
            "        <height>{{ vscale(30) }}</height>",
            home,
        )
        self.assertIn(
            "hero_meta_y = 112 & hero_meta_height = 30 & "
            "hero_meta_empty_shift = -42 & hero_logo_shift = 26",
            home,
        )
        self.assertIn(
            "<posy>{{ vscale(154) }}</posy>\n"
            "        <width>1120</width>\n"
            "        <height>{{ vscale(56) }}</height>",
            home,
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

    def test_home_hub_cards_are_art_only_without_losing_media_state(self):
        for name in HOME_HUB_LAYOUTS:
            layout = _read("includes", name)
            self.assertNotIn("$INFO[ListItem.Label]", layout)
            self.assertNotIn("$INFO[ListItem.Label2]", layout)
            self.assertNotIn('<control type="textbox">', layout)
            self.assertIn("$INFO[ListItem.Thumb]", layout)
            self.assertIn("ListItem.Property(progress)", layout)
            self.assertIn("ListItem.Property(is.end)", layout)
            self.assertIn("ListItem.Property(is.updating)", layout)
            if "square" in name:
                self.assertNotIn("includes/watched_indicator.xml.tpl", layout)
            else:
                self.assertIn("includes/watched_indicator.xml.tpl", layout)

    def test_home_hub_rows_use_geometry_aware_art_only_rhythm(self):
        home = _read("script-plex-home.xml.tpl")

        self.assertIn('end="0,{{ vscale(-622) }}"', home)
        self.assertIn('end="0,{{ vscale(-475) }}"', home)
        self.assertIn('end="0,{{ vscale(-125) }}"', home)
        self.assertIn('end="0,{{ vscale(-105) }}"', home)
        self.assertIn('end="0,{{ vscale(125) }}"', home)
        self.assertIn('end="0,{{ vscale(105) }}"', home)
        self.assertIn("for previous_i in range(i)", home)
        self.assertNotIn("range(core.hub_count - 1)", home)
        self.assertIn("hub.display.{{ previous_i + 400 }}),ar16x9", home)
        self.assertIn("hub.display.{{ previous_i + 400 }}),square", home)
        self.assertIn("grouplist_height = n * 475 + 407", home)
        self.assertIn("row_y = i * 475 + 407", home)
        self.assertIn("<height>{{ vscale(475) }}</height>", home)
        self.assertIn("<height>{{ vscale(435) }}</height>", home)
        self.assertNotIn('end="0,{{ vscale(-590) }}"', home)
        self.assertNotIn("n * 555 + 355", home)
        self.assertNotIn("i * 555 + 355", home)

    def test_single_resume_action_replaces_only_the_first_visual_hub(self):
        home = _read("script-plex-home.xml.tpl")
        french = _read_file(FRENCH_CATALOG)
        self.assertIn('<control type="button" id="205">', home)
        resume = home.split(
            '<control type="button" id="205">',
            1,
        )[1].split("</control>", 1)[0]

        self.assertIn("$ADDON[script.plexmod 32316]", resume)
        self.assertIn("<width>260</width>", resume)
        self.assertIn("<onup>101</onup>", resume)
        self.assertIn("<ondown>401</ondown>", resume)
        self.assertIn("<textcolor>FF111111</textcolor>", resume)
        self.assertIn(
            '<texturefocus colordiffuse="FFFFFFFF" border="20">'
            "script.plex/white-square-rounded.png</texturefocus>",
            resume,
        )
        self.assertIn(
            '<texturenofocus colordiffuse="FFFFFFFF" border="20">'
            "script.plex/white-square-rounded.png</texturenofocus>",
            resume,
        )
        self.assertEqual(home.count("script.plex/circle-rounded-focus.png"), 1)
        self.assertEqual(
            home.count("script.plex/buttons/player/modern/play.png"),
            1,
        )
        self.assertNotIn(
            "script.plex/buttons/player/modern-focused/play.png",
            home,
        )
        self.assertIn(
            "String.IsEmpty(Window.Property(home.hero.short_summary))",
            home,
        )
        self.assertIn(
            "{% if loop.is_first %} + "
            "String.IsEmpty(Window.Property(home.resume.visible))"
            "{% endif %}",
            home,
        )
        self.assertIn('end="0,{{ vscale(-410) }}"', home)
        self.assertIn('end="0,{{ vscale(-305) }}"', home)
        self.assertIn('end="0,{{ vscale(-285) }}"', home)
        self.assertIn(
            '<animation effect="slide" end="0,{{ vscale(-47) }}" time="0" '
            'condition="!String.IsEmpty(Window.Property(home.resume.visible)) + '
            'String.IsEmpty(Window.Property(hub.scrolled)) + '
            'String.IsEmpty(Window.Property(home.hero.short_summary))"',
            home,
        )
        self.assertIn(
            '<animation effect="slide" end="0,{{ vscale(-52) }}" time="0" '
            'condition="!String.IsEmpty(Window.Property(home.resume.visible)) + '
            'String.IsEmpty(Window.Property(hub.scrolled)) + '
            'String.IsEmpty(Window.Property(home.hero.logo)) + '
            'String.IsEmpty(Window.Property(home.hero.subtitle)) + '
            'String.IsEmpty(Window.Property(home.hero.short_summary))"',
            home,
        )
        self.assertIn(
            '<animation effect="slide" end="0,{{ vscale(-36) }}" time="0" '
            'condition="!String.IsEmpty(Window.Property(home.resume.visible)) + '
            'String.IsEmpty(Window.Property(hub.scrolled)) + '
            'String.IsEmpty(Window.Property(home.hero.logo)) + '
            'String.IsEmpty(Window.Property(home.hero.subtitle)) + '
            '!String.IsEmpty(Window.Property(home.hero.short_summary))"',
            home,
        )
        self.assertIn(
            '<animation effect="zoom" start="100" end="106" time="110" '
            'center="130,{{ vscale(29) }}"',
            home,
        )
        self.assertIn("<posy>{{ vscale(376) }}</posy>", home)
        self.assertIn(
            "!String.IsEmpty(Window.Property(home.resume.visible)) + "
            "String.IsEmpty(Window.Property(hub.scrolled))",
            home,
        )

        resume_translation = french.split(
            'msgctxt "#32316"',
            1,
        )[1].split("msgctxt", 1)[0]
        self.assertIn('msgid "Resume"', resume_translation)
        self.assertIn('msgstr "Reprendre"', resume_translation)

    def test_initial_home_hero_is_built_after_episode_spoiler_state(self):
        window = _read_file(HOME_WINDOW)
        hub_loop = window.split("for obj in hubitems or hub.items:", 1)[1]
        hub_loop = hub_loop.split("if util.getSetting('cache_requests'):", 1)[0]
        show_hub = window.split("def _showHub", 1)[1]

        self.assertLess(
            hub_loop.index("obj._noSpoilers = no_spoilers = self.hideSpoilers"),
            hub_loop.index("mli = self.createListItem(obj, wide=wide)"),
        )
        self.assertLess(
            show_hub.index("obj._noSpoilers = no_spoilers = self.hideSpoilers"),
            show_hub.index("if not use_reselect_pos and not self._initialHomeHeroSet:"),
        )

    def test_initial_hub_uses_first_selected_item_when_background_is_unavailable(self):
        media = (_HubMedia("First", "1"), _HubMedia("Second", "2"))
        control = _HubControl()
        window = _show_hub_window(control)

        window._showHub(_Hub(media), identifier="home.test", index=0)

        self.assertEqual(control.getSelectedItem().dataSource.title, "First")
        self.assertEqual(window.backgrounds, ["First"])
        self.assertEqual(window.heroes, ["First"])

    def test_initial_redraw_waits_for_the_hub_that_retains_focus(self):
        first_control = _HubControl()
        focused_control = _HubControl()
        window = _show_hub_window(
            [first_control, focused_control],
            last_focus=401,
        )

        window._showHub(
            _Hub([_HubMedia("First hub", "1")]),
            identifier="home.first",
            index=0,
        )
        self.assertEqual(window.heroes, [])

        window._showHub(
            _Hub([_HubMedia("Focused hub", "2")]),
            identifier="home.focused",
            index=1,
        )

        self.assertEqual(window.heroes, ["Focused hub"])
        self.assertEqual(window.backgrounds, ["Focused hub"])

    def test_same_position_refresh_rebuilds_the_focused_hero(self):
        old = _HubListItem(_HubMedia("Old title", "1"))
        control = _HubControl([old], selected=0)
        window = _show_hub_window(control)
        window._initialHomeHeroSet = True

        window._showHub(
            _Hub([_HubMedia("Fresh title", "1")]),
            reselect_pos=("1", 0),
            identifier="home.test",
            index=0,
        )

        self.assertEqual(window.heroes, ["Fresh title"])
        self.assertEqual(window.backgrounds, ["Fresh title"])

    def test_manual_selection_during_refresh_rebuilds_current_focused_hero(self):
        old_items = [
            _HubListItem(_HubMedia("Old first", "1")),
            _HubListItem(_HubMedia("Old second", "2")),
        ]
        control = _HubControl(old_items, selected=1)
        window = _show_hub_window(control, any_item_action=True)
        window._initialHomeHeroSet = True

        window._showHub(
            _Hub([_HubMedia("Fresh first", "1"), _HubMedia("Fresh second", "2")]),
            reselect_pos=("1", 0),
            identifier="home.test",
            index=0,
        )

        self.assertEqual(control.getSelectedPos(), 1)
        self.assertEqual(window.heroes, ["Fresh second"])

    def test_missing_refresh_key_falls_back_to_last_item_and_rebuilds_hero(self):
        old_items = [
            _HubListItem(_HubMedia("Old first", "1")),
            _HubListItem(_HubMedia("Old second", "2")),
        ]
        control = _HubControl(old_items, selected=1)
        window = _show_hub_window(control)
        window._initialHomeHeroSet = True

        window._showHub(
            _Hub([_HubMedia("Fresh first", "1"), _HubMedia("Fresh last", "2")]),
            reselect_pos=("missing", 5),
            identifier="home.test",
            index=0,
        )

        self.assertEqual(control.getSelectedPos(), 1)
        self.assertEqual(window.heroes, ["Fresh last"])

    def test_background_refresh_does_not_overwrite_hero_from_another_hub(self):
        old = _HubListItem(_HubMedia("Old title", "1"))
        control = _HubControl([old], selected=0)
        window = _show_hub_window(control, last_focus=401)
        window._initialHomeHeroSet = True

        window._showHub(
            _Hub([_HubMedia("Fresh title", "1")]),
            reselect_pos=("1", 0),
            identifier="home.test",
            index=0,
        )

        self.assertEqual(window.heroes, [])
        self.assertEqual(window.backgrounds, [])

    def test_extended_hub_refreshes_hero_for_item_replacing_more_sentinel(self):
        window = _read_file(HOME_WINDOW)
        extension = window.split("if hubitems:", 1)[1]
        extension = extension.split("else:\n            control.replaceItems(items)", 1)[0]

        self.assertIn("control.selectItem(end)", extension)
        self.assertIn("self._syncHomeHeroSelection(index, control, end)", extension)

    def test_every_classified_home_media_type_has_a_list_item_dispatcher(self):
        window = _read_file(HOME_WINDOW)
        tree = ast.parse(window)
        dispatch_keys = set()
        for node in ast.walk(tree):
            if not isinstance(node, ast.Assign):
                continue
            if not any(
                isinstance(target, ast.Name) and target.id == "CREATE_LI_MAP"
                for target in node.targets
            ):
                continue
            dispatch_keys = set(
                key.value
                for key in node.value.keys
                if isinstance(key, ast.Constant) and isinstance(key.value, str)
            )
            break

        expected = {
            "movie",
            "show",
            "season",
            "episode",
            "clip",
            "video",
            "album",
            "artist",
            "photo",
            "photodirectory",
            "track",
            "playlist",
        }
        self.assertEqual(dispatch_keys, expected)

    def test_home_uses_one_media_display_contract_for_all_fallback_paths(self):
        window = _read_file(HOME_WINDOW)

        self.assertIn("media_display_type", window)
        self.assertGreaterEqual(window.count("media_display_type("), 6)
        self.assertNotIn("TYPE_TO_DISPLAY", window)

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

    def test_deferred_hubs_use_compact_busy_indicator_without_message_card(self):
        home = _read("script-plex-home.xml.tpl")

        self.assertIn(
            "<visible>!String.IsEmpty(Window.Property(busy)) | "
            "!String.IsEmpty(Window.Property(loading.content))</visible>",
            home,
        )
        self.assertNotIn("$ADDON[script.plexmod 34020]", home)
        self.assertNotIn("$ADDON[script.plexmod 34021]", home)

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

        self.assertEqual(home.count('end="106" time="110"'), 13)
        for control_id in (202, 203):
            self.assertIn(
                'reversible="true" condition="Control.HasFocus({})">Conditional'.format(
                    control_id
                ),
                home,
            )
        self.assertEqual(
            home.count('reversible="true" condition="Control.HasFocus(101) + '),
            10,
        )
        for oversized in ('end="108"', 'start="108"', 'end="118"', 'start="118"'):
            self.assertNotIn(oversized, home)
        self.assertNotIn('reversible="false">Focus</animation>', home)

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
