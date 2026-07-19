from __future__ import absolute_import


HERO_KEYS = (
    "visible",
    "title",
    "content_rating",
    "content_rating_wide",
    "meta",
    "summary",
    "short_summary",
    "cast",
    "art",
)

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


def _art_url(obj):
    art = _get(obj, "art", "") or _get(obj, "thumb", "")
    if not art:
        return ""
    if hasattr(art, "asTranscodedImageURL"):
        return art.asTranscodedImageURL(
            1920,
            1080,
            blur=18,
            opacity=70,
            background="000000",
        )
    return _text(art)


def empty_hero_properties():
    return dict((key, "") for key in HERO_KEYS)


def build_hero_properties(obj):
    title = _first_text(obj, ("defaultTitle", "title", "grandparentTitle", "parentTitle"))
    content_rating = normalize_content_rating(_first_text(obj, ("contentRating", "mpaaRating")))
    year = _text(_get(obj, "year", ""))
    duration = _duration_text(_get(obj, "duration", ""))
    genres = _joined_tags(_get(obj, "genres", ()), 2)
    summary = _first_text(obj, ("summary", "tagline"))
    cast = _joined_tags(_get(obj, "roles", ()), 4)
    art = _art_url(obj)

    meta_parts = [part for part in (year, duration, genres) if part]
    props = empty_hero_properties()
    props.update({
        "title": title,
        "content_rating": content_rating,
        "content_rating_wide": "1" if len(content_rating) > 5 else "",
        "meta": "    ".join(meta_parts),
        "summary": summary,
        "short_summary": _short_text(summary),
        "cast": cast,
        "art": art,
    })
    if title or summary or art:
        props["visible"] = "1"
    return props
