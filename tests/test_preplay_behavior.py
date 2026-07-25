from __future__ import absolute_import

import ast
import os
import types
import unittest


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PREPLAY_WINDOW = os.path.join(ROOT, "lib", "windows", "preplay.py")


def _preplay_method(name, namespace=None):
    with open(PREPLAY_WINDOW, "r") as handle:
        tree = ast.parse(handle.read())

    method = None
    for node in tree.body:
        if isinstance(node, ast.ClassDef) and node.name == "PrePlayWindow":
            method = next(
                (
                    child
                    for child in node.body
                    if isinstance(child, ast.FunctionDef) and child.name == name
                ),
                None,
            )
            break
    if method is None:
        raise AssertionError("PrePlayWindow.{} is missing".format(name))

    method.decorator_list = []
    module = ast.Module(body=[method], type_ignores=[])
    ast.fix_missing_locations(module)
    scope = dict(namespace or {})
    exec(compile(module, PREPLAY_WINDOW, "exec"), scope)
    return scope[name]


class _Control(object):
    def __init__(self):
        self.reset_count = 0

    def reset(self):
        self.reset_count += 1


class PrePlayBehaviorTests(unittest.TestCase):
    def test_watchlist_movies_do_not_query_local_collection_endpoints(self):
        queries = []

        class CollectionPaginator(object):
            def __init__(self, *args, **kwargs):
                self.path = None

            def setup(self, server, path):
                self.path = path
                return self

            def paginate(self):
                queries.append(self.path)

        class Window(object):
            fillCollections = _preplay_method(
                "fillCollections",
                {
                    "CollectionPaginator": CollectionPaginator,
                    "plexlibrary": types.SimpleNamespace(
                        WatchlistSection=types.SimpleNamespace(ID="watchlist"),
                    ),
                    "plexobjects": types.SimpleNamespace(
                        listItems=lambda server, path: queries.append(path) or [],
                    ),
                    "util": types.SimpleNamespace(ERROR=lambda: None),
                },
            )

            def __init__(self):
                collection = types.SimpleNamespace(
                    tag="Example Collection",
                    filter="collection=example",
                )
                self.video = types.SimpleNamespace(
                    type="movie",
                    collections=lambda: [collection],
                    getLibrarySectionId=lambda: "watchlist",
                    server=object(),
                )
                self.collectionListControls = [_Control(), _Control()]
                self.collectionPaginators = [object(), object()]
                self.properties = {}

            def setProperty(self, key, value):
                self.properties[key] = value

        window = Window()

        result = window.fillCollections()

        self.assertFalse(result)
        self.assertEqual(queries, [])
        self.assertEqual(
            [control.reset_count for control in window.collectionListControls],
            [1, 1],
        )
        self.assertEqual(window.collectionPaginators, [None, None])
        self.assertEqual(
            window.properties,
            {
                "collection.header.0": "",
                "collection.header.1": "",
            },
        )


if __name__ == "__main__":
    unittest.main()
