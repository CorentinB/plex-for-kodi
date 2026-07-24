# Home Art-Only Hubs Design

**Status:** Approved by Corentin on 2026-07-19

**Goal:** Remove redundant captions from Home hub cards and move the complete focused-item identity into a sleek, type-aware hero without changing caption behavior on other Kodi surfaces.

## Scope

This change applies only to the Home window and its poster, square, and 16:9 hub layouts.

Library grids and lists, Search results, related/collection rails, episode and bonus rows, queues, and cast/people cards retain their captions. Those surfaces do not have a dynamic hero that identifies each focused card.

## Visual Direction

The direction is refined tvOS minimalism:

- Home cards contain artwork only, plus functional overlays such as progress, watched state, unwatched count, loading, and the end-of-row affordance.
- The existing exact focus plate, five-pixel artwork inset, centered reversible 106 percent lift, rounded masks, and ambient artwork composition remain unchanged.
- The hero uses a strict hierarchy: brand or parent identity, focused title, compact metadata and ratings, then a short synopsis.
- Missing fields collapse cleanly. The UI never repeats the same title on two lines; the localized spoiler-redaction marker appears only when the existing episode spoiler preference requests it.
- Movie and TV media retain their content-certification badge and add Plex critic and audience ratings when available and enabled by the existing rating preference.

## Hero Contract

`build_hero_properties(obj, include_ratings=True)` returns every key in `HERO_KEYS` as a string.

`build_home_hero_properties(...)` applies Home-specific rating preferences and episode spoiler policy to that base contract. For protected episodes, it preserves the show identity while independently redacting the episode subtitle, summary, and scores according to the existing title, summary, and rating spoiler settings.

The new keys are:

- `subtitle`: the focused child title when it differs from the brand/title line.
- `rating`: primary Plex critic score.
- `rating_image`: local skin asset for the primary score source.
- `rating2`: Plex audience score.
- `rating2_image`: local skin asset for the audience score source.

The existing keys remain compatible: `title`, `logo`, `content_rating`, `content_rating_wide`, `meta`, `summary`, `short_summary`, `cast`, `art`, and `art_blurred`.

### Identity Mapping

| Media type | Hero title / logo fallback | Hero subtitle |
| --- | --- | --- |
| Episode | Show title | Episode title |
| Season | Show title | Season title |
| TV show | Show title | Empty |
| Movie | Movie title | Tagline only when a separate summary exists |
| Artist | Artist name | Empty |
| Album | Artist name | Album title |
| Track | Artist name | Track title |
| Playlist | Playlist title | Empty |
| Photo | Parent album/folder when available | Photo title when a parent exists |
| Photo directory | Parent library/album when available | Directory title when a parent exists |
| Clip/video | Parent show/movie/source when available | Clip title when a parent exists |

If parent identity is absent, the focused item title becomes the hero title and `subtitle` remains empty.

### Metadata Mapping

- Episode metadata begins with `S{season} • E{episode}` when indexes exist, followed by year, duration, and up to two genres.
- Track metadata begins with album title and `#{track}` when available, followed by year and duration.
- Other media use available year, duration, and up to two genres.
- Metadata parts use a restrained ` • ` separator.
- Content certification remains a separate compact badge.
- Critic and audience scores are limited to movie, show, season, and episode objects. Rotten Tomatoes values are rendered as percentages; other sources retain their Plex score text. Source icons reuse `script.plex/ratings/...` assets and the existing generic fallback.
- `HomeWindow` honors the existing `show_ratings` setting: `movies` gates movie scores and `series` gates show, season, and episode scores.

### Spoiler Safety

- Protected Continue Watching and On Deck episodes calculate `_noSpoilers` before the initial hero is built.
- `no_unwatched_episode_titles` replaces the episode subtitle with the localized spoiler marker while preserving the show logo/title.
- `hide_summary` replaces both summary variants with the same localized marker.
- `hide_ratings` removes critic and audience scores for the protected episode without hiding certification or structural season/episode metadata.
- Focus updates reuse the per-item `_noSpoilers` state, so initial and subsequent selections follow the same policy.

## Home Layout

Both full and compact hero states render the same information hierarchy. The compact state uses less vertical space but does not replace the focused identity with card captions.

All six Home hub card templates remove `ListItem.Label` and `ListItem.Label2` controls. Artwork, progress, watched/unwatched state, end-of-row state, loading state, masks, focus plates, shadows, and focus animation remain intact.

The Home row rhythm tightens after captions disappear:

- Hub vertical step: 475 design pixels instead of 555.
- First lower-row slide: -570 design pixels instead of -650.
- Subsequent lower-row slide: -475 design pixels instead of -555.
- Hub list viewport height: 435 design pixels.
- Hub group height: 475 design pixels.

These values keep the complete poster focus shadow inside the row viewport while removing the former caption reservation.

## Preview

The browser preview remains an approximation. It mirrors the new hierarchy, score rail, artwork-only cards, and 475-pixel row step, but native Kodi screenshots remain authoritative.

## Verification

- The 268-test suite covers all 12 supported Home media types, every hero key, three display geometries, identity and provider-logo fallbacks, dual-rating formatting and preferences, all eight episode spoiler combinations, pagination replacement, preserved functional overlays, and executable first-load/refresh/retained-focus lifecycle scenarios.
- All 47 production templates render and parse at both 1920 x 1080 and 3024 x 1832; the Python modules compile and the preview JavaScript parses.
- The preview's 27 cards pass at 2560 x 1440, 1080 x 900, and 390 x 844. A 46-state keyboard traversal found no hero mismatch, collision, overflow, or broken image, and every card retains an accessible label.
- Native Kodi traversal covers all eight live Home hubs and 78 reachable Plex cards. Poster, square, and 16:9 page-extension boundaries replace the More sentinel while synchronizing focus, artwork, and hero metadata.
- A final native reload and real `Refresh Hubs` cycle preserve focused-card/hero identity with complete metadata and no Home hero failure. No playback was started, no active player remains, all preview endpoints respond, and `git diff --check` passes.
