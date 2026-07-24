# Home Art-Only Hubs Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Deliver artwork-only Home hub cards and a type-aware focused hero with movie/TV certifications, critic ratings, and audience ratings.

**Architecture:** Extend the pure `lib/home_hero.py` property builder so Kodi XML receives one normalized hero contract for every supported Home item type. Keep card overlays and focus composition in the existing Home-only layout includes, render all focused text above the rail, and align the browser preview only after native source contracts pass.

**Tech Stack:** Python 3 compatible with the add-on's Python 2 style constraints, Kodi WindowXML templates rendered through Ibis, Python `unittest`, dependency-free browser preview JavaScript and CSS.

## Global Constraints

- Apply caption removal only to Home hub templates; captions on all other views remain unchanged.
- Preserve exact Home focus plates, five-pixel artwork insets, rounded masks, centered reversible 106 percent lift, progress overlays, watched indicators, loading cards, and end cards.
- Keep content certification separate from critic and audience scores.
- Honor the existing `show_ratings` preference for movie and series score visibility.
- Use existing local rating assets and no new dependency or network source.
- Treat native Kodi XML as authoritative and the browser preview as approximate.
- Do not commit or push unless Corentin requests it.

---

### Task 1: Extend the Tested Hero Data Contract

**Files:**
- Modify: `tests/test_home_hero.py`
- Modify: `lib/home_hero.py`
- Modify: `lib/windows/home.py`

**Interfaces:**
- Consumes: Plex media fields exposed through attributes or `get`, including `type`, `TYPE`, title hierarchy, indexes, duration, genres, content rating, critic/audience scores, score source images, summary, art, and clearLogo images.
- Produces: `build_hero_properties(obj, include_ratings=True) -> dict` containing every `HERO_KEYS` entry, including `subtitle`, `rating`, `rating_image`, `rating2`, and `rating2_image`.

- [x] **Step 1: Write failing hero identity tests**

Add tests proving that an episode maps show title to `title`, episode title to `subtitle`, and season/episode indexes to the first metadata part; album and track objects map artist identity and focused titles without duplication.

- [x] **Step 2: Write failing rating tests**

Add movie and show fixtures with `rating`, `ratingImage`, `audienceRating`, and `audienceRatingImage`. Assert Rotten Tomatoes percentage formatting, non-Rotten-Tomatoes score preservation, local asset paths, and empty score properties when `include_ratings=False`.

- [x] **Step 3: Verify the tests fail for missing contract fields**

Run: `python3 -m unittest tests.test_home_hero`

Expected: failures for missing `subtitle` and rating keys or incorrect title/meta mappings.

- [x] **Step 4: Implement minimal pure formatting and mapping helpers**

Add media-type detection, distinct parent/title selection, type-aware metadata composition, critic/audience score formatting, and local rating asset path normalization to `lib/home_hero.py`. Keep all helpers independent from Kodi runtime modules.

- [x] **Step 5: Honor the existing rating preference in HomeWindow**

In `setHomeHeroFromDataSource`, derive whether scores are enabled from `util.getSetting('show_ratings')` and the focused item's media type, then pass `include_ratings` to `build_hero_properties`.

- [x] **Step 6: Verify the hero tests pass**

Run: `python3 -m unittest tests.test_home_hero`

Expected: all Home hero tests pass.

### Task 2: Render the Sleek Hero and Artwork-Only Cards

**Files:**
- Modify: `tests/test_home_layout_contract.py`
- Modify: `resources/skins/Main/1080i/templates/script-plex-home.xml.tpl`
- Modify: `resources/skins/Main/1080i/templates/includes/home_hero_metadata.xml.tpl`
- Modify: `resources/skins/Main/1080i/templates/includes/hub_itemlayout_poster.xml.tpl`
- Modify: `resources/skins/Main/1080i/templates/includes/hub_focusedlayout_poster.xml.tpl`
- Modify: `resources/skins/Main/1080i/templates/includes/hub_itemlayout_square.xml.tpl`
- Modify: `resources/skins/Main/1080i/templates/includes/hub_focusedlayout_square.xml.tpl`
- Modify: `resources/skins/Main/1080i/templates/includes/hub_itemlayout_ar16x9.xml.tpl`
- Modify: `resources/skins/Main/1080i/templates/includes/hub_focusedlayout_ar16x9.xml.tpl`

**Interfaces:**
- Consumes: `Window.Property(home.hero.*)`, `Window.Property(hub.display.4xx)`, and existing `ListItem` art/overlay properties.
- Produces: two type-aware hero states and six Home-only artwork card layouts with no caption controls.

- [x] **Step 1: Write failing layout contract tests**

Replace caption-presence assertions with assertions that all six Home card templates omit `ListItem.Label`, `ListItem.Label2`, and caption textboxes. Assert two hero subtitle controls, critic/audience property references, a 475-pixel row step, -570 first slide, -475 subsequent slides, and a 435-pixel list viewport.

- [x] **Step 2: Verify the layout tests fail for the old markup**

Run: `python3 -m unittest tests.test_home_layout_contract`

Expected: failures identifying existing captions, missing subtitle/rating controls, and old 555/650 geometry.

- [x] **Step 3: Remove only Home card captions**

Delete the title and secondary-label controls from all six Home card includes. Do not alter artwork masks, focus plates, focus centers, progress controls, watched indicators, loading controls, or end controls.

- [x] **Step 4: Add the hero subtitle in both states**

Render `home.hero.subtitle` beneath the logo/title slot with a bounded, non-scrolling label. Move metadata and summary down only enough to preserve the existing row boundary.

- [x] **Step 5: Add critic and audience scores to the metadata rail**

Render up to two source icons and values from `home.hero.rating*` after the certification and descriptive metadata. Use existing rating fallbacks, stable widths, and conditional visibility so absent ratings leave no gap.

- [x] **Step 6: Tighten Home row geometry**

Change the generated row step and lower-row slide distances to 475/-570/-475, the list height to 435, and the generated parent height to match. Keep horizontal sizing and control IDs unchanged.

- [x] **Step 7: Verify the layout tests pass**

Run: `python3 -m unittest tests.test_home_layout_contract`

Expected: all Home layout contract tests pass.

### Task 3: Align the Browser Preview

**Files:**
- Modify: `tools/kodi-ui-preview/index.html`
- Modify: `tools/kodi-ui-preview/app.js`
- Modify: `tools/kodi-ui-preview/styles.css`
- Modify: `tools/kodi-ui-preview/README.md`

**Interfaces:**
- Consumes: static preview fixture objects.
- Produces: an approximate browser representation of the native hero hierarchy and caption-free Home rails.

- [x] **Step 1: Add preview subtitle and rating rails**

Add dedicated hero subtitle, certification, critic, and audience nodes. Populate them from fixture fields without duplicating the brand title.

- [x] **Step 2: Remove preview card captions**

Render only the artwork frame and functional overlays for ordinary and end cards. Preserve accessible labels on the focusable card element.

- [x] **Step 3: Align preview row geometry**

Use 475-pixel row blocks and the corresponding -570/-475 shift calculation. Remove obsolete caption CSS and retain the existing focused-card treatment.

- [x] **Step 4: Verify preview syntax and server behavior**

Run: `node --check tools/kodi-ui-preview/app.js && node --check tools/kodi-ui-preview/server.mjs`

Expected: both commands exit successfully.

### Task 4: Full Verification and Project Context

**Files:**
- Modify: `/Users/corentin/Documents/Brain/projects/plex-for-kodi/Plex for Kodi.md`
- Create: `/Users/corentin/Documents/Brain/worklog/2026-07-19-plex-for-kodi-home-art-only-hubs/2026-07-19 Plex for Kodi Home Art-Only Hubs.md`
- Modify: `/Users/corentin/Documents/Brain/worklog/Worklog.md`

**Interfaces:**
- Consumes: final source diff and verification output.
- Produces: current project invariants and an auditable session record.

- [x] **Step 1: Run the focused test suite**

Run: `python3 -m unittest tests.test_home_hero tests.test_home_layout_contract`

Expected: all focused tests pass.

- [x] **Step 2: Run the complete test suite**

Run: `python3 -m unittest discover -s tests`

Expected: zero failures.

- [x] **Step 3: Compile Python and render Home XML**

Run: `python3 -m py_compile lib/home_hero.py lib/windows/home.py tests/test_home_hero.py tests/test_home_layout_contract.py`

Run: `python3 tools/render_skin_templates.py home`

Parse the generated `resources/skins/Main/1080i/script-plex-home.xml` with `xml.etree.ElementTree` and require success.

- [x] **Step 4: Smoke-test the preview**

Start `node tools/kodi-ui-preview/server.mjs` on an unused local port and require successful responses from `/`, `/app.js`, and `/api/templates`.

- [x] **Step 5: Check the diff**

Run: `git diff --check`

Expected: no output and exit zero.

- [x] **Step 6: Update Brain context**

Record the Home-only caption boundary, hero identity/rating contract, row geometry, files changed, exact verification commands, and any native screenshot limitation. Run the Brain layout checker on the touched vault files.

## Completion Evidence

- The complete suite passes 268 tests, including all 12 supported Home media types, all three card geometries, movie/series rating preferences, source formatting, title/provider-logo fallbacks, all eight episode spoiler combinations, and executable first-load/refresh/retained-focus lifecycle scenarios.
- All 47 production templates render and parse at both 1920 x 1080 and 3024 x 1832.
- Browser QA covers 27 fixture cards at 2560 x 1440, 1080 x 900, and 390 x 844, plus a 46-state keyboard traversal with no mismatched hero, overflow, collision, or broken image.
- Native Kodi QA covers all eight live Home hubs and 78 reachable Plex cards. Every focused label matches the hero title, and page extension is proven at poster, square, and 16:9 boundaries.
- A final native reload and real `Refresh Hubs` cycle kept the focused card and complete hero synchronized. Kodi remained on Home with no active player and no Home hero failure or traceback.
