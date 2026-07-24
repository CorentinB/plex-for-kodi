from __future__ import absolute_import


HERO_KEYS = (
    "visible",
    "title",
    "subtitle",
    "logo",
    "content_rating",
    "content_rating_wide",
    "meta",
    "rating",
    "rating_image",
    "rating2",
    "rating2_image",
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

VIDEO_RATING_TYPES = frozenset(("movie", "show", "season", "episode"))

MEDIA_DISPLAY_TYPES = {
    "movie": "poster",
    "show": "poster",
    "season": "poster",
    "episode": "ar16x9",
    "clip": "ar16x9",
    "video": "ar16x9",
    "album": "square",
    "artist": "square",
    "photo": "square",
    "photodirectory": "square",
    "track": "square",
}

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


def _attribute(obj, key, default=""):
    if obj is None:
        return default
    try:
        value = getattr(obj, key)
    except AttributeError:
        return default
    if value is None or callable(value):
        return default
    return value


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


def media_display_type(media_type, playlist_type="", default="poster"):
    media_type = _text(media_type).lower()
    if media_type == "playlist":
        playlist_type = _text(playlist_type).lower()
        if playlist_type == "audio":
            return "square"
        if playlist_type == "video":
            return "ar16x9"
        return default
    return MEDIA_DISPLAY_TYPES.get(media_type, default)


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


def _media_type(obj):
    return _first_text(obj, ("type", "TYPE")).lower()


def _different_text(value, reference):
    value = _text(value)
    reference = _text(reference)
    if not value or value.lower() == reference.lower():
        return ""
    return value


def _identity_text(obj, media_type):
    computed_title = _text(_attribute(obj, "defaultTitle", ""))
    item_title = _first_text(obj, ("title",)) or computed_title
    default_title = computed_title or _first_text(obj, ("defaultTitle", "title"))
    parent_title = _first_text(obj, ("parentTitle",))
    grandparent_title = _first_text(obj, ("grandparentTitle",))

    if media_type == "episode":
        title = grandparent_title or default_title or parent_title or item_title
        return title, _different_text(item_title, title)
    if media_type == "season":
        title = parent_title or grandparent_title or default_title or item_title
        return title, _different_text(item_title, title)
    if media_type == "album":
        title = parent_title or grandparent_title or default_title or item_title
        return title, _different_text(item_title, title)
    if media_type == "track":
        if grandparent_title:
            return grandparent_title, _different_text(item_title, grandparent_title)
        return item_title or default_title or parent_title, ""
    if media_type in ("photo", "photodirectory"):
        title = parent_title or grandparent_title or default_title or item_title
        return title, _different_text(item_title, title)
    if media_type in ("clip", "video"):
        title = grandparent_title or parent_title or default_title or item_title
        return title, _different_text(item_title, title)

    return default_title or item_title or parent_title or grandparent_title, ""


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


def _index_text(value, prefix):
    index = _text(value)
    if not index or index == "0":
        return ""
    return "{}{}".format(prefix, index)


def _meta_parts(obj, media_type):
    parts = []
    if media_type == "episode":
        season = _index_text(_get(obj, "parentIndex", ""), "S")
        episode = _index_text(_get(obj, "index", ""), "E")
        parts.extend(part for part in (season, episode) if part)
    elif media_type == "track":
        album = _first_text(obj, ("parentTitle",))
        track = _index_text(_get(obj, "index", ""), "#")
        parts.extend(part for part in (album, track) if part)

    year = _text(_get(obj, "year", ""))
    duration = _duration_text(_get(obj, "duration", ""))
    parts.extend(part for part in (year, duration) if part)

    if media_type != "track":
        genres = _joined_tags(_get(obj, "genres", ()), 2)
        if genres:
            parts.append(genres)
    return parts


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


def _rating_float(value):
    if hasattr(value, "asFloat"):
        try:
            return value.asFloat()
        except (TypeError, ValueError):
            return 0.0
    try:
        return float(value)
    except (TypeError, ValueError):
        return 0.0


def _rating_text(value, image):
    text = _text(value)
    if not text or not _rating_float(value):
        return ""
    if _text(image).lower().startswith("rottentomatoes:"):
        return "{}%".format(int(_rating_float(value) * 10))
    return text


def _rating_image(value):
    image = _text(value)
    if not image:
        return ""
    if image.startswith("script.plex/"):
        return image
    image = image.replace("themoviedb", "tmdb").replace("://", "/")
    return "script.plex/ratings/{}.png".format(image)


def _ratings(obj, media_type, include_ratings):
    if not include_ratings or media_type not in VIDEO_RATING_TYPES:
        return "", "", "", ""

    rating_source = _get(obj, "ratingImage", "")
    audience_source = _get(obj, "audienceRatingImage", "")
    rating = _rating_text(_get(obj, "rating", ""), rating_source)
    audience = _rating_text(_get(obj, "audienceRating", ""), audience_source)
    return (
        rating,
        _rating_image(rating_source) if rating else "",
        audience,
        _rating_image(audience_source) if audience else "",
    )


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


def logo_metadata_key(obj):
    """Return the Plex provider metadata id that owns the item's logo."""
    media_type = _media_type(obj)
    if media_type == "episode":
        guid_keys = ("grandparentGuid",)
        guid_prefix = "plex://show/"
    elif media_type == "season":
        guid_keys = ("parentGuid",)
        guid_prefix = "plex://show/"
    elif media_type == "show":
        guid_keys = ("guid",)
        guid_prefix = "plex://show/"
    elif media_type == "movie":
        guid_keys = ("guid",)
        guid_prefix = "plex://movie/"
    else:
        return ""

    guid = _first_text(obj, guid_keys)
    if not guid.startswith(guid_prefix):
        return ""
    return guid[len(guid_prefix):].split("?", 1)[0].strip("/")


def clear_logo_url_from_metadata(data):
    """Extract Plex's curated clear logo from a provider metadata response."""
    if data is None:
        return ""
    if hasattr(data, "getroot"):
        data = data.getroot()
    if not hasattr(data, "iter"):
        return ""

    images = list(data.iter("Image"))
    for image_type in ("clearlogo", "clearlogowide"):
        for image in images:
            if image.attrib.get("type", "").lower() == image_type:
                return _text(image.attrib.get("url", ""))
    return ""


def empty_hero_properties():
    return dict((key, "") for key in HERO_KEYS)


def build_hero_properties(obj, include_ratings=True):
    media_type = _media_type(obj)
    title, subtitle = _identity_text(obj, media_type)
    logo = _logo_url(obj)
    content_rating = normalize_content_rating(_first_text(obj, ("contentRating", "mpaaRating")))
    summary = _first_text(obj, ("summary", "tagline"))
    if media_type == "movie":
        tagline = _first_text(obj, ("tagline",))
        explicit_summary = _first_text(obj, ("summary",))
        if tagline and explicit_summary:
            subtitle = _different_text(tagline, title)
    cast = _joined_tags(_get(obj, "roles", ()), 4)
    art, art_blurred = _art_urls(obj)
    rating, rating_image, rating2, rating2_image = _ratings(
        obj,
        media_type,
        include_ratings,
    )

    props = empty_hero_properties()
    props.update({
        "title": title,
        "subtitle": subtitle,
        "logo": logo,
        "content_rating": content_rating,
        "content_rating_wide": "1" if len(content_rating) > 5 else "",
        "meta": " • ".join(_meta_parts(obj, media_type)),
        "rating": rating,
        "rating_image": rating_image,
        "rating2": rating2,
        "rating2_image": rating2_image,
        "summary": summary,
        "short_summary": _short_text(summary),
        "cast": cast,
        "art": art,
        "art_blurred": art_blurred,
    })
    if title or subtitle or summary or art:
        props["visible"] = "1"
    return props


def ratings_enabled_for(media_type, rating_sections):
    media_type = _text(media_type).lower()
    rating_sections = rating_sections or ""
    if media_type == "movie":
        return "movies" in rating_sections
    if media_type in ("episode", "season", "show"):
        return "series" in rating_sections
    return False


def build_home_hero_properties(obj, rating_sections="", no_titles=False,
                               no_summaries=False, no_ratings=False,
                               spoiler_text=""):
    media_type = _media_type(obj)
    spoilers_hidden = media_type == "episode" and bool(_get(obj, "_noSpoilers", False))
    include_ratings = ratings_enabled_for(media_type, rating_sections)
    if spoilers_hidden and no_ratings:
        include_ratings = False

    props = build_hero_properties(obj, include_ratings=include_ratings)
    if not spoilers_hidden:
        return props

    spoiler_text = _text(spoiler_text)
    if no_titles:
        props["subtitle"] = spoiler_text
    if no_summaries:
        props["summary"] = spoiler_text
        props["short_summary"] = _short_text(spoiler_text)
    return props
