#!/usr/bin/env python3
"""Render selected Kodi XML templates without starting a second Kodi process."""

from __future__ import absolute_import

import argparse
import copy
import operator
import os
import runpy
import sys


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TEMPLATE_DIR = os.path.join(ROOT, "resources", "skins", "Main", "1080i", "templates")
TARGET_DIR = os.path.dirname(TEMPLATE_DIR)
KODI_SIX_DIR = os.path.expanduser(
    "~/Library/Application Support/Kodi/addons/script.module.six/lib"
)
if os.path.isdir(KODI_SIX_DIR):
    sys.path.insert(0, KODI_SIX_DIR)
sys.path.insert(0, os.path.join(ROOT, "lib", "_included_packages"))

import ibis  # noqa: E402
from ibis.context import ContextDict, Undefined  # noqa: E402


def _register_builtin(name, function):
    ibis.context.builtins[name] = function


@ibis.filters.register("get")
def get_attr(obj, attr, fallback=None, default=None):
    if isinstance(attr, Undefined):
        return obj.get(fallback, default)
    return obj.get(attr, default)


def calc(a, b, op="add"):
    if isinstance(a, str):
        a = float(a) if "." in a else int(a)
    elif isinstance(b, str):
        b = float(b) if "." in b else int(b)
    return getattr(operator, op)(a, b)


def vperc(height, perc=50, ref=1080, rel=50, r=2):
    """Mirror the skin's vertical percentage positioning filter."""
    return round(perc * ref / 100.0 - height * rel / 100.0, r)


@ibis.filters.register("resolve", with_context=True)
def resolve_variable(arg, context=None):
    """Defer a name lookup to the caller context, matching the live renderer."""
    return ibis.nodes.ResolveContextVariable(arg)


@ibis.filters.register("vscale", with_context=True)
def vscale(value, up=1, negpos=False, context=None):
    if not context.core.needs_scaling:
        return value
    width, height = context.core.resolution
    scale = (1080.0 / 1920.0) / (height / float(width))
    if negpos and value < 0:
        return value + round(scale * value, 2) * up
    return round(scale * value, 2) * up


@ibis.filters.register("mul")
def mul(a, b):
    return calc(a, b, op="mul")


@ibis.filters.register("int")
def cast_int(value):
    return int(value)


for _name, _function in (
    ("vscale", vscale),
    ("vperc", vperc),
    ("mul", mul),
    ("int", cast_int),
    ("resolve", resolve_variable),
):
    _register_builtin(_name, _function)


def _deep_update(source, overrides):
    for key, value in overrides.items():
        if isinstance(value, dict) and value:
            source[key] = _deep_update(source.get(key, {}), value)
        else:
            source[key] = copy.deepcopy(value)
    return source


def _inherit(name, sources):
    stack = []
    while name:
        current = copy.deepcopy(sources[name])
        name = current.pop("INHERIT", None)
        stack.append(current)
    merged = {}
    while stack:
        _deep_update(merged, stack.pop())
    return merged


def _context(theme, indicators, width, height, hub_count):
    contexts = runpy.run_path(os.path.join(ROOT, "lib", "templating", "context.py"))[
        "TEMPLATE_CONTEXTS"
    ]
    theme_data = _inherit(theme, contexts["themes"])
    indicator_data = _inherit(indicators, contexts["indicators"])
    indicator_data.update(
        {
            "style": indicators,
            "hide_aw_bg": False,
            "use_scaling": True,
        }
    )
    core = copy.deepcopy(contexts["core"])
    core.update(
        {
            "resolution": [width, height],
            "needs_scaling": True,
            "hub_count": hub_count,
        }
    )
    return ContextDict(
        {
            "theme": ContextDict(theme_data),
            "indicators": ContextDict(indicator_data),
            "core": ContextDict(core),
        }
    )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("templates", nargs="+", help="template names, for example home person")
    parser.add_argument("--theme", default="modern-colored")
    parser.add_argument("--indicators", default="modern_2024")
    parser.add_argument("--width", type=int, default=3024)
    parser.add_argument("--height", type=int, default=1832)
    parser.add_argument("--hub-count", type=int, default=8)
    args = parser.parse_args()

    loader = ibis.loaders.FileLoader(TEMPLATE_DIR)
    ibis.loader = loader
    context = _context(
        args.theme,
        args.indicators,
        args.width,
        args.height,
        args.hub_count,
    )

    for name in args.templates:
        source = "script-plex-{}.xml.tpl".format(name)
        target = os.path.join(TARGET_DIR, "script-plex-{}.xml".format(name))
        rendered = loader(source).render(context)
        with open(target, "w", encoding="utf-8") as handle:
            handle.write(rendered)
        print("rendered {} -> {}".format(source, target))


if __name__ == "__main__":
    main()
