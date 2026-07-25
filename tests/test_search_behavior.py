from __future__ import absolute_import

import ast
import os
import types
import unittest


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SEARCH_WINDOW = os.path.join(ROOT, "lib", "windows", "search.py")


def _search_method(name, namespace=None):
    with open(SEARCH_WINDOW, "r") as handle:
        tree = ast.parse(handle.read())

    method = None
    for node in tree.body:
        if isinstance(node, ast.ClassDef) and node.name == "SearchDialog":
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
        raise AssertionError("SearchDialog.{} is missing".format(name))

    method.decorator_list = []
    module = ast.Module(body=[method], type_ignores=[])
    ast.fix_missing_locations(module)
    scope = dict(namespace or {})
    exec(compile(module, SEARCH_WINDOW, "exec"), scope)
    return scope[name]


class _Size(object):
    def __init__(self, value):
        self.value = value

    def asInt(self):
        return self.value


class _Hub(object):
    def __init__(self, size=1):
        self.size = _Size(size)
        self.type = "movie"


class _Control(object):
    def __init__(self, control_id, items=None, selected=0):
        self.controlID = control_id
        self.items = list(items or ())
        self.selected = selected

    def getSelectedItem(self):
        return self.items[self.selected] if self.items else None

    def getSelectedPos(self):
        return self.selected

    def selectItem(self, pos):
        self.selected = pos

    def size(self):
        return len(self.items)

    def reset(self):
        self.items = []
        self.selected = 0


class SearchBehaviorTests(unittest.TestCase):
    def test_opening_result_remembers_its_hub_and_position(self):
        class Result(object):
            TYPE = "movie"

            def exists(self):
                return True

        class Window(object):
            hubItemClicked = _search_method(
                "hubItemClicked",
                {"opener": types.SimpleNamespace(open=lambda item: "open")},
            )

            def __init__(self):
                item = types.SimpleNamespace(dataSource=Result())
                self.hubControls = [_Control(2103, [item, item, item], selected=2)]
                self.edit = types.SimpleNamespace(getText=lambda: "Lilo")
                self.exitCommand = False
                self._returnFocusState = None

            def addToHistory(self, query):
                return None

            def doClose(self):
                return None

            def processCommand(self, command):
                return None

            def show(self):
                return None

        window = Window()
        window.hubItemClicked(2103)

        self.assertEqual(window._returnFocusState, (2103, 2, "Lilo"))

    def test_returning_from_result_restores_query_before_redraw(self):
        class Edit(object):
            def __init__(self):
                self.text = ""

            def getText(self):
                return self.text

            def setText(self, text):
                self.text = text

        class Window(object):
            onReInit = _search_method("onReInit")

            def __init__(self):
                self.edit = Edit()
                self._returnFocusState = (2103, 2, "Lilo")
                self.updated = 0
                self.history_shown = 0

            def updateResults(self):
                self.updated += 1

            def showSearchHistory(self):
                self.history_shown += 1

        window = Window()
        window.onReInit()

        self.assertEqual(window.edit.getText(), "Lilo")
        self.assertEqual(window.updated, 1)
        self.assertEqual(window.history_shown, 0)

    def test_result_redraw_restores_visible_hub_and_item_focus(self):
        class Window(object):
            SEARCH_HUB_COUNT = 12
            showHubs = _search_method("showHubs")

            def __init__(self):
                self.hubControls = [
                    _Control(2100 + index) for index in range(self.SEARCH_HUB_COUNT)
                ]
                self.properties = {}
                self.focused = None
                self._returnFocusState = (2103, 2, "Lilo")

            def clearHubs(self):
                for control in self.hubControls:
                    control.reset()
                self.properties["hub.focus"] = ""

            def opaqueBackground(self, on=True):
                return None

            def getProperty(self, key):
                return "all" if key == "search.section" else self.properties.get(key, "")

            def setProperty(self, key, value):
                self.properties[key] = value

            def setFocusId(self, control_id):
                self.focused = control_id

            def showHub(self, hub, index):
                count = 3 if index == 3 else 1
                self.hubControls[index].items = [object()] * count
                return 2100 + index

        window = Window()
        window.showHubs([_Hub(), _Hub(), _Hub(), _Hub()])

        self.assertEqual(window.hubControls[3].getSelectedPos(), 2)
        self.assertEqual(window.properties["hub.focus"], "3")
        self.assertEqual(window.focused, 2103)
        self.assertIsNone(window._returnFocusState)


if __name__ == "__main__":
    unittest.main()
