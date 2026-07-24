# Home Hero Breathing Room

## Scope

- Disable episode-spoiler protection only for the active local Kodi profile. Do not change the add-on default or behavior for other users.
- Rebalance the Home hero for both logo and text-title identities without reducing the clearLogo size requested in the preceding pass.
- Preserve the existing artwork-only hub cards, geometry-aware row cadence, ratings, and focused lower-row baseline.

## Layout

The full Home hero remains a single left-aligned vertical stack: identity artwork, item subtitle, facts with inline ratings, then synopsis. Each transition gets an explicit visual gap instead of relying on the previous four-to-eight-pixel residual spacing. The subtitle and synopsis gain wider readable bounds so ordinary episode copy wraps less aggressively.

The first hub starts below the completed hero stack. Its downward adjustment is paired with the same additional initial scroll offset, so navigating to lower hubs produces the same established compact-hero baseline. The scrolled hero uses the same hierarchy with slightly tighter spacing appropriate to its smaller composition.

Missing subtitle and missing-logo states continue to collapse without blank slots. Rating images and values remain inline with structural metadata.

## Profile Setting

Persist `no_episode_spoilers4` as an empty JSON list in the current `script.plexmod` Kodi profile. The repository default remains `unwatched`, image blur, and summary hiding for untouched profiles.

## Verification

- Add layout contracts before changing production geometry and confirm they fail for the old compressed stack.
- Render and parse every production template at both supported resolutions.
- Run the complete Python test suite and JavaScript syntax/preview contracts.
- Restart or refresh Kodi safely, confirm the selected episode exposes its real summary, and capture native top and scrolled states with no overlap or playback.
