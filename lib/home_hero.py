from __future__ import absolute_import


HERO_KEYS = (
    "visible",
    "title",
    "logo",
    "content_rating",
    "content_rating_wide",
    "meta",
    "summary",
    "short_summary",
    "cast",
    "art",
    "art_blurred",
)

NAV_LABEL_WIDTHS = (60, 80, 100, 120, 140, 180)
NAV_PLATE_WIDTHS = {
    60: 140,
    80: 160,
    100: 180,
    120: 200,
    140: 220,
    180: 260,
}
NAV_HOME_PLATE_WIDTH = 160
NAV_SLOT_WIDTH = 192
NAV_PLATE_GAP = 8
NAV_SHIFT_MIN = -512
NAV_SHIFT_MAX = 640

COUNTRY_RATING_PREFIXES = frozenset((
    "au",
    "br",
    "ca",
    "de",
    "es",
    "fr",
    "gb",
    "it",
    "jp",
    "kr",
    "mx",
    "nl",
    "uk",
    "us",
))

try:
    string_types = (basestring,)
except NameError:
    string_types = (str,)


def _get(obj, key, default=""):
    if obj is None:
        return default
    try:
        value = obj.get(key, default)
    except AttributeError:
        value = getattr(obj, key, default)
    return default if value is None else value


def _text(value):
    if value is None:
        return ""
    try:
        if isinstance(value, bytes):
            return value.decode("utf-8", "replace")
    except NameError:
        pass
    text = str(value).strip()
    return "" if text in ("()", "[]", "{}", "None", "none") else text


def nav_label_width(value):
    """Return the nearest skin width for a localized Home navigation label."""
    label = _text(value)
    if not label:
        return 80

    estimated = 0
    for char in label:
        if char in " ilIjtfr.,:;!|'`":
            estimated += 6
        elif char in "MW@%&QO":
            estimated += 17
        elif char.isupper():
            estimated += 14
        else:
            estimated += 12
    estimated += max(4, len(label) // 2)

    for width in NAV_LABEL_WIDTHS:
        if estimated <= width:
            return width
    return 180


def nav_visual_offsets(label_widths, home_flags=None):
    """Place navigation plates by content width over Kodi's fixed item slots."""
    if home_flags is None:
        home_flags = [False] * len(label_widths)

    offsets = []
    visual_x = 0
    for index, (label_width, is_home) in enumerate(zip(label_widths, home_flags)):
        offset = visual_x - (index * NAV_SLOT_WIDTH)
        offset = max(NAV_SHIFT_MIN, min(NAV_SHIFT_MAX, offset))
        offsets.append(offset)
        plate_width = NAV_HOME_PLATE_WIDTH if is_home else NAV_PLATE_WIDTHS[label_width]
        visual_x += plate_width + NAV_PLATE_GAP
    return offsets


def _first_text(obj, keys):
    for key in keys:
        value = _text(_get(obj, key, ""))
        if value:
            return value
    return ""


def _tag_text(value):
    if value is None:
        return ""
    if isinstance(value, string_types):
        return _text(value)
    for key in ("tag", "title", "name", "defaultTitle"):
        text = _text(_get(value, key, ""))
        if text:
            return text
    return _text(value)


def _joined_tags(values, limit):
    if not values:
        return ""
    if isinstance(values, string_types):
        values = (values,)
    tags = []
    for value in values:
        tag = _tag_text(value)
        if tag:
            tags.append(tag)
        if len(tags) >= limit:
            break
    return ", ".join(tags)


def _duration_text(value):
    try:
        duration = int(value)
    except (TypeError, ValueError):
        return ""
    if duration <= 0:
        return ""

    minutes = int(round(duration / 60000.0))
    if minutes < 60:
        return "{}m".format(minutes)

    hours = minutes // 60
    remaining = minutes % 60
    if remaining:
        return "{}h {}m".format(hours, remaining)
    return "{}h".format(hours)


def normalize_content_rating(value):
    rating = _text(value)
    if not rating:
        return ""

    if "/" in rating:
        prefix, localized_rating = rating.split("/", 1)
        if prefix.strip().lower() in COUNTRY_RATING_PREFIXES and localized_rating.strip():
            rating = localized_rating.strip()

    aliases = {
        "not rated": "NR",
        "not yet rated": "NR",
        "unrated": "NR",
    }
    return aliases.get(rating.lower(), rating)


# Retain the original private name for callers that imported the first helper
# while the public normalization contract is shared with detail surfaces.
_content_rating_text = normalize_content_rating


def _short_text(value, limit=190):
    text = _text(value)
    if len(text) <= limit:
        return text
    shortened = text[:limit + 1].rsplit(" ", 1)[0].rstrip(" ,.;:-")
    return shortened + "…"


def _art_urls(obj):
    art = _get(obj, "art", "") or _get(obj, "thumb", "")
    if not art:
        return "", ""
    if hasattr(art, "asTranscodedImageURL"):
        clear_art = art.asTranscodedImageURL(1920, 1080)
        # The Home underlay is a palette field, not a second readable copy of
        # the fanart. Transcoding it at a deliberately small size before a
        # strong blur preserves the artwork's colors while removing its
        # composition when Kodi expands it to the viewport.
        blurred_art = art.asTranscodedImageURL(
            320,
            180,
            blur=64,
            opacity=100,
            background="000000",
        )
        return clear_art, blurred_art
    text = _text(art)
    return text, text


def _resolved_image_url(obj, value):
    if not value:
        return ""
    if hasattr(value, "asURL"):
        try:
            return value.asURL(includeToken=True)
        except (AttributeError, TypeError):
            pass

    path = _text(value)
    if not path:
        return ""
    server = getattr(obj, "server", None)
    if server and hasattr(server, "buildUrl"):
        return server.buildUrl(path, includeToken=True)
    return path


def _logo_url(obj):
    for key in ("clearLogo", "logo"):
        logo = _get(obj, key, "")
        if logo:
            return _resolved_image_url(obj, logo)

    data = getattr(obj, "data", None)
    if data is None or not hasattr(data, "findall"):
        return ""

    for image in data.findall("Image"):
        if image.attrib.get("type", "").lower() == "clearlogo":
            return _resolved_image_url(obj, image.attrib.get("url", ""))
    return ""


def empty_hero_properties():
    return dict((key, "") for key in HERO_KEYS)


def build_hero_properties(obj):
    title = _first_text(obj, ("defaultTitle", "title", "grandparentTitle", "parentTitle"))
    logo = _logo_url(obj)
    content_rating = normalize_content_rating(_first_text(obj, ("contentRating", "mpaaRating")))
    year = _text(_get(obj, "year", ""))
    duration = _duration_text(_get(obj, "duration", ""))
    genres = _joined_tags(_get(obj, "genres", ()), 2)
    summary = _first_text(obj, ("summary", "tagline"))
    cast = _joined_tags(_get(obj, "roles", ()), 4)
    art, art_blurred = _art_urls(obj)

    meta_parts = [part for part in (year, duration, genres) if part]
    props = empty_hero_properties()
    props.update({
        "title": title,
        "logo": logo,
        "content_rating": content_rating,
        "content_rating_wide": "1" if len(content_rating) > 5 else "",
        "meta": "    ".join(meta_parts),
        "summary": summary,
        "short_summary": _short_text(summary),
        "cast": cast,
        "art": art,
        "art_blurred": art_blurred,
    })
    if title or summary or art:
        props["visible"] = "1"
    return props
