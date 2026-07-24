# Home Single Resume Action Design

**Status:** Approved by Corentin on 2026-07-24

**Goal:** Replace a lone Continue Watching thumbnail with a compact `Reprendre`
action while preserving the normal carousel whenever the user has several
choices.

## Scope

This change applies only to the first Home hub when it is Plex Continue
Watching. It does not alter library, Search, detail, Watchlist, playlist, or
other Home hub cards.

## Eligibility

The button-only mode is active when all of these conditions are true:

- The first rendered Home hub is `continueWatching` or `home.continue`.
- The hub has exactly one real item and no additional Plex page.
- The item is an in-progress movie or episode.

Loading and end-of-row sentinels do not count as media. Zero items, several
items, a paginated hub, an unwatched next episode, or any other media type use
the existing carousel unchanged.

## Layout

The hero remains the source of identity, artwork, episode or movie title,
metadata, ratings, and synopsis. In button-only mode:

- A compact 260 x 58 play action labeled with localized string `#32316`
  appears beneath the hero copy.
- The Continue Watching heading and thumbnail row are hidden.
- The next Home hub moves upward below the completed hero and action. Its
  native design baseline is 425 when the synopsis is empty and 472 when a
  synopsis is present. The summary-free position gives equal optical spacing
  above and below the hub heading, while the populated state preserves enough
  separation for two lines of copy.
- Poster, square, and 16:9 first-hub geometry each receive the matching
  top-state offset so the next hub lands on one common baseline.
- Scrolled lower-hub geometry remains unchanged.

The action follows the selected-tab tvOS treatment: a solid white plate with a
black label and circular play icon in both resting and focused states. Focus
adds one subtle reversible lift without changing the action's colors. The
French `#32316` translation becomes `Reprendre`.

## Focus And Playback

When button-only mode is active, focus moves:

`Home navigation -> Reprendre -> next visible hub`

Moving back up from that hub returns to `Reprendre`. Focusing the action restores
the full hero and reselects the lone Continue Watching item as the hero owner.
When the mode is inactive, the existing navigation-to-first-carousel path is
unchanged.

Selecting the action delegates to the existing first-hub playback path with
direct playback enabled. Plex therefore resumes the item's existing view
offset instead of opening its detail screen. The Play remote action does the
same thing. Existing watched and context-menu actions remain available while
the button is focused.

No playback is started during visual QA.

## State Changes

The native list remains populated while its visual row is hidden, so it
continues to own the media object, progress state, hero data, refresh behavior,
and existing playback implementation.

Eligibility is recalculated after each first-hub draw or refresh and cleared
with the other Home state. If refresh changes the hub between button and
carousel modes, focus transfers to the corresponding visible control. Other
hubs cannot enable or clear the action.

The browser preview mirrors the singleton action and collapsed top-state
spacing, but native Kodi remains authoritative. Because its action uses a
different coordinate parent, the preview uses a 396 px summary-free hub
position to reproduce the native 18/18 design-pixel control gaps.

## Verification

- Add failing tests for eligibility, pagination and multi-item fallbacks,
  property cleanup, playback delegation, and focus transfer before production
  changes.
- Add XML contracts for button visibility, localized label, navigation,
  hidden first row, geometry-aware collapse, and unchanged lower-hub scroll.
- Add preview contracts for the button and singleton layout.
- Render and parse all production templates at 1920 x 1080 and 3024 x 1832.
- Run the complete Python suite, Python compilation, preview JavaScript syntax,
  gettext checks, and `git diff --check`.
- Verify top navigation, `Reprendre`, and the next hub in native Kodi, capture a
  screenshot, and confirm `Player.GetActivePlayers` remains empty.
