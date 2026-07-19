# coding=utf-8
from __future__ import absolute_import


MISSING_ART_SENTINELS = frozenset(('', 'none', 'null', 'undefined'))


def is_usable_art(value):
    """Return whether a Plex art value names an image Kodi can request."""
    if not value:
        return False

    try:
        normalized = value.strip().lower()
    except (AttributeError, TypeError):
        normalized = str(value).strip().lower()

    return normalized not in MISSING_ART_SENTINELS
