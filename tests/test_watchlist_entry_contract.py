from __future__ import absolute_import

import ast
import os
import types
import unittest


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WATCHLIST_MIXIN = os.path.join(
    ROOT,
    "lib",
    "windows",
    "mixins",
    "watchlist.py",
)
OPENER = os.path.join(ROOT, "lib", "windows", "opener.py")
HOME = os.path.join(ROOT, "lib", "windows", "home.py")
LIBRARY = os.path.join(ROOT, "lib", "windows", "library.py")


def _read(path):
    with open(path, "r") as handle:
        return handle.read()


def _function(path, name, scope=None, strip_relative_imports=False):
    tree = ast.parse(_read(path))
    helpers = [
        candidate
        for candidate in tree.body
        if isinstance(candidate, ast.FunctionDef)
        and candidate.name == "_source_bitrate"
    ]
    node = next(
        (
            candidate
            for candidate in tree.body
            if isinstance(candidate, ast.FunctionDef) and candidate.name == name
        ),
        None,
    )
    if node is None:
        raise AssertionError("{} is missing from {}".format(name, path))

    if strip_relative_imports:
        node.body = [
            statement
            for statement in node.body
            if not (
                isinstance(statement, ast.ImportFrom)
                and statement.level
            )
        ]

    module = ast.Module(body=helpers + [node], type_ignores=[])
    ast.fix_missing_locations(module)
    scope = dict(scope or {})
    exec(compile(module, path, "exec"), scope)
    return scope[name]


class _Element(object):
    def __init__(self, tag, values=None, children=None):
        self.tag = tag
        self.values = values or {}
        self.children = children or []

    def get(self, key, default=None):
        return self.values.get(key, default)

    def __iter__(self):
        return iter(self.children)


class _Response(list):
    def get(self, key, default=None):
        if key == "size":
            return len(self)
        return default


class WatchlistEntryContractTests(unittest.TestCase):
    def test_preferred_source_keeps_the_selected_server(self):
        choose = _function(WATCHLIST_MIXIN, "select_preferred_source")
        sources = [
            ("Remote", {"server_uuid": "remote", "bitrate": "80000"}),
            ("Current", {"server_uuid": "current", "bitrate": "20000"}),
        ]

        selected = choose(sources, "current")

        self.assertEqual(selected[0], "Current")

    def test_preferred_source_uses_the_best_quality_on_the_selected_server(self):
        choose = _function(WATCHLIST_MIXIN, "select_preferred_source")
        sources = [
            ("Current HD", {"server_uuid": "current", "bitrate": "9000"}),
            ("Current 4K", {"server_uuid": "current", "bitrate": "26000"}),
            ("Remote 4K", {"server_uuid": "remote", "bitrate": "50000"}),
        ]

        selected = choose(sources, "current")

        self.assertEqual(selected[0], "Current 4K")

    def test_preferred_source_falls_back_to_the_best_available_quality(self):
        choose = _function(WATCHLIST_MIXIN, "select_preferred_source")
        sources = [
            ("HD", {"server_uuid": "one", "bitrate": "9000"}),
            ("4K", {"server_uuid": "two", "bitrate": "26000"}),
        ]

        selected = choose(sources, "missing")

        self.assertEqual(selected[0], "4K")

    def test_availability_compares_every_media_version_for_a_copy(self):
        availability_for_server = _function(
            WATCHLIST_MIXIN,
            "availability_for_server",
            scope={
                "plexobjects": types.SimpleNamespace(searchType=lambda value: value),
            },
        )
        low_then_high = _Element(
            "Video",
            values={
                "ratingKey": "copy-a",
                "librarySectionTitle": "Movies",
            },
            children=[
                _Element("Media", values={"videoResolution": "720", "bitrate": "1000"}),
                _Element("Media", values={"videoResolution": "4k", "bitrate": "80000"}),
            ],
        )
        medium = _Element(
            "Video",
            values={
                "ratingKey": "copy-b",
                "librarySectionTitle": "Movies",
            },
            children=[
                _Element("Media", values={"videoResolution": "1080", "bitrate": "20000"}),
            ],
        )
        server = types.SimpleNamespace(
            uuid="server",
            name="Server",
            query=lambda *args, **kwargs: _Response([low_then_high, medium]),
        )

        sources = availability_for_server(server, "plex://movie/guid", "movie")

        self.assertEqual(sources[0][1]["rating_key"], "copy-a")
        self.assertEqual(sources[0][1]["bitrate"], "80000")
        self.assertEqual(sources[0][1]["resolution"], "4k")

    def test_only_explicit_watchlist_entries_use_the_direct_resolver(self):
        calls = []
        unresolved = object()
        open_item = _function(
            OPENER,
            "open",
            scope={
                "six": types.SimpleNamespace(string_types=(str,)),
                "playqueue": types.SimpleNamespace(PlayQueue=type("PlayQueue", (), {})),
                "_WATCHLIST_UNRESOLVED": unresolved,
                "_open_resolved_watchlist_item": lambda obj, kwargs: calls.append(obj) or "resolved",
            },
        )
        item = types.SimpleNamespace(TYPE="unknown")

        ordinary_discover = open_item(
            item,
            from_watchlist=True,
            external_item=True,
        )
        actual_watchlist = open_item(
            item,
            from_watchlist=True,
            external_item=True,
            watchlist_entry=True,
        )

        self.assertIsNone(ordinary_discover)
        self.assertEqual(actual_watchlist, "resolved")
        self.assertEqual(calls, [item])

    def test_server_disappearance_falls_back_without_crashing(self):
        unresolved = object()
        source = (
            "Server",
            {
                "server_uuid": "gone",
                "rating_key": "123",
                "type": "movie",
            },
        )
        resolver = _function(
            OPENER,
            "_open_resolved_watchlist_item",
            strip_relative_imports=True,
            scope={
                "_WATCHLIST_UNRESOLVED": unresolved,
                "busy": types.SimpleNamespace(
                    widthDialog=lambda method, message, obj, delay: [source],
                ),
                "watchlist": types.SimpleNamespace(
                    find_watchlist_sources=lambda item: [source],
                    select_preferred_source=lambda sources, uuid: sources[0],
                    GUIDToRatingKey=lambda guid: guid,
                ),
                "plexapp": types.SimpleNamespace(
                    SERVERMANAGER=types.SimpleNamespace(
                        selectedServer=types.SimpleNamespace(uuid="current"),
                        getServer=lambda uuid: (_ for _ in ()).throw(KeyError(uuid)),
                    ),
                ),
                "util": types.SimpleNamespace(LOG=lambda *args: None),
                "open": lambda *args, **kwargs: "opened",
            },
        )

        result = resolver(types.SimpleNamespace(guid="plex://movie/guid"), {})

        self.assertIs(result, unresolved)

    def test_watchlist_context_menu_preserves_explicit_server_choice(self):
        source = _read(HOME)

        self.assertIn("'choose_watchlist_source'", source)
        self.assertIn("choose_watchlist_source=True", source)
        self.assertIn("watchlist_entry=True", source)

    def test_watchlist_grid_uses_the_same_direct_entry_resolver(self):
        source = _read(LIBRARY)
        start = source.index("def showPanelClicked(self):")
        end = source.index("\n    def ", start + 5)
        show_panel = source[start:end]

        self.assertNotIn("preplay.PrePlayWindowWL", show_panel)
        self.assertGreaterEqual(show_panel.count("opener.open("), 2)
        self.assertIn("external_item", show_panel)

    def test_watchlist_grid_context_menu_preserves_explicit_server_choice(self):
        source = _read(LIBRARY)
        start = source.index("def itemOptions(self):")
        end = source.index("\n    def ", start + 5)
        item_options = source[start:end]

        self.assertIn("'choose_watchlist_source'", item_options)
        self.assertIn("choose_watchlist_source=True", item_options)


if __name__ == "__main__":
    unittest.main()
