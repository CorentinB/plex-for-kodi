#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_DIR=$(dirname -- "$SCRIPT_DIR")
MEDIA_DIR="$REPO_DIR/resources/skins/Main/media/script.plex"

# Two-times source assets keep the antialiased edge clean when Kodi renders the
# 260x388 artwork. Focus frames are generated for every poster geometry used by
# the skin. Reusing the 270x398 frame on a smaller card scales its ten-source-
# pixel inset below five rendered pixels while the artwork remains inset by
# five, producing the dark seam and mismatched curve visible on compact cards.
magick -size 520x776 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 519,775 36,36" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/poster-rounded-mask.png"

# Home posters are rendered at 244x361. Their 11 px radius matches the square
# and landscape Home cards, while the focus plate keeps the exact five-pixel
# concentric inset. The smaller curve avoids a bulbous corner on pale artwork.
magick -size 488x722 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 487,721 22,22" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/poster-home-rounded-mask.png"

magick -size 508x742 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 507,741 32,32" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/poster-home-rounded-focus.png"

magick -size 540x796 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 539,795 46,46" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/poster-rounded-focus.png"

magick -size 540x796 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 539,795 46,46" \
  \( -size 540x796 xc:none -fill white -stroke none \
     -draw "roundrectangle 10,10 529,785 36,36" \) \
  -compose DstOut -composite \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/poster-rounded-outline.png"

# 244x364 artwork inside a 254x374 frame. The same asset is also safe at the
# legacy 254x371 geometry: Kodi trims only the straight vertical run.
magick -size 508x748 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 507,747 44,44" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/poster-medium-rounded-focus.png"

magick -size 508x748 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 507,747 44,44" \
  \( -size 508x748 xc:none -fill white -stroke none \
     -draw "roundrectangle 10,10 497,737 34,34" \) \
  -compose DstOut -composite \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/poster-medium-rounded-outline.png"

# 144x213 artwork inside a 154x223 frame.
magick -size 308x446 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 307,445 30,30" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/poster-small-rounded-focus.png"

magick -size 308x446 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 307,445 30,30" \
  \( -size 308x446 xc:none -fill white -stroke none \
     -draw "roundrectangle 10,10 297,435 20,20" \) \
  -compose DstOut -composite \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/poster-small-rounded-outline.png"

# 162x239 artwork inside a 172x249 frame.
magick -size 344x498 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 343,497 32,32" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/poster-small-compact-rounded-focus.png"

magick -size 344x498 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 343,497 32,32" \
  \( -size 344x498 xc:none -fill white -stroke none \
     -draw "roundrectangle 10,10 333,487 22,22" \) \
  -compose DstOut -composite \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/poster-small-compact-rounded-outline.png"

# Keep transparent texels white as well as transparent. Kodi filters texture
# RGB before the alpha edge, so transparent black would leave a dark inner arc
# when these masks are scaled on a focused card.
# 180x270 artwork inside a 190x280 Search frame.
magick -size 360x540 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 359,539 25,25" \
  -channel RGB -evaluate set 100% +channel \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/poster-search-rounded-mask.png"

magick -size 380x560 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 379,559 35,35" \
  -channel RGB -evaluate set 100% +channel \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/poster-search-rounded-focus.png"

magick -size 380x560 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 379,559 35,35" \
  \( -size 380x560 xc:none -fill white -stroke none \
     -draw "roundrectangle 10,10 369,549 25,25" \) \
  -compose DstOut -composite \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/poster-search-rounded-outline.png"

# Search squares use a dedicated 270x270 mask inside a 280x280 solid plate.
# The five-pixel inset and matched radii keep both curves concentric.
magick -size 540x540 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 539,539 24,24" \
  -channel RGB -evaluate set 100% +channel \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/square-search-rounded-mask.png"

magick -size 560x560 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 559,559 34,34" \
  -channel RGB -evaluate set 100% +channel \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/square-search-rounded-focus.png"

# Square library cards use their own matched pair. Keeping the square asset at
# its native aspect prevents Kodi's diffuse pass from distorting the radius.
magick -size 500x500 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 499,499 22,22" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/square-rounded-mask.png"

# Solid square focus plates let the inset artwork resolve into white instead
# of meeting a separately filtered transparent outline at the inner corner.
magick -size 520x520 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 519,519 32,32" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/square-rounded-focus.png"

# The album-detail cover is static rather than focused. Give its 500x500 art
# an exact four-pixel concentric plate instead of scaling the 520x520 outline
# down over the image. At radius 26, the outer curve and the inset art's
# radius-22 curve share the same centre (4 + 22), so the quiet edge remains
# even at every corner and the antialiased artwork resolves into the plate.
magick -size 508x508 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 507,507 26,26" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/square-detail-rounded-plate.png"

# Playlist-index cards use smaller exact focus plates. The square card renders
# 238x238 art inside a 248x248 plate; the video card renders 520x293 art inside
# a 530x303 plate. Generate both at 2x so their curve centres stay concentric
# with the five-pixel inset instead of overlaying a separately filtered ring.
magick -size 496x496 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 495,495 31,31" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/square-playlist-rounded-focus.png"

magick -size 1060x606 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 1059,605 38,38" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/landscape-playlist-rounded-focus.png"

# The photo viewer filmstrip renders 132x132 artwork inside a 142x142 focus
# plate. Keep both assets exact instead of vertically scaling the generic
# 500x500 mask into the old 123x114 pseudo-square thumbnails. At a five-pixel
# inset, the radius-14 outer curve and radius-9 artwork curve are concentric.
magick -size 264x264 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 263,263 18,18" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/square-photo-queue-rounded-mask.png"

magick -size 284x284 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 283,283 28,28" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/square-photo-queue-rounded-focus.png"

magick -size 520x520 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 519,519 32,32" \
  \( -size 520x520 xc:none -fill white -stroke none \
     -draw "roundrectangle 10,10 509,509 22,22" \) \
  -compose DstOut -composite \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/square-rounded-outline.png"

# 16:9 library hero art uses a separate aspect-correct mask so its corners are
# circular rather than a stretched version of the square legacy mask.
magick -size 1260x710 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 1259,709 24,24" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/landscape-rounded-mask.png"

# The episode browser hero is a smaller 520x293 crop. A dedicated mask keeps
# its radius circular instead of stretching either the square legacy mask or
# the much larger list-view landscape mask.
magick -size 1040x586 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 1039,585 28,28" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/episode-hero-rounded-mask.png"

# Season posters are 158x236 inside a 168x246 focus plate. Their old generic
# outline was stretched independently over the artwork and exposed a dark,
# bracket-shaped seam at the corners. Use an exact solid plate under the art.
magick -size 316x472 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 315,471 24,24" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/poster-season-rounded-mask.png"

magick -size 336x492 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 335,491 34,34" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/poster-season-rounded-focus.png"

# Home's 385x217 landscape cards need their own matched set. Reusing the
# larger list-view mask shrinks its radius and reintroduces nearly square
# corners. These assets map 1:2 to the 385x217 art and 395x227 focus frame.
magick -size 770x434 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 769,433 22,22" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/landscape-hub-rounded-mask.png"

magick -size 790x454 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 789,453 32,32" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/landscape-hub-rounded-focus.png"

magick -size 790x454 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 789,453 32,32" \
  \( -size 790x454 xc:none -fill white -stroke none \
     -draw "roundrectangle 10,10 779,443 22,22" \) \
  -compose DstOut -composite \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/landscape-hub-rounded-outline.png"

# Post-play's replay and up-next cards deliberately use different sizes to
# preserve their primary/secondary hierarchy. Give each size its own exact
# mask and solid five-pixel focus plate rather than stretching the shared Home
# outline over both geometries. The outer and inset artwork curves are
# concentric, so focused corners cannot expose a dark alpha seam.
magick -size 924x518 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 923,517 24,24" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/postplay-previous-rounded-mask.png"

magick -size 944x538 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 943,537 34,34" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/postplay-previous-rounded-focus.png"

magick -size 1074x606 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 1073,605 28,28" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/postplay-next-rounded-mask.png"

magick -size 1094x626 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 1093,625 38,38" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/postplay-next-rounded-focus.png"

# Critic cards are broad 520x310 surfaces inside a 530x320 focus plate. The
# legacy generic rounded square was stretched to both aspect ratios, making
# the focused corner soft and letting a bright backdrop wash the card gray.
# Exact-size solid assets keep both radii circular and allow the template to
# tint the focused surface opaque, like tvOS review cards.
magick -size 1040x620 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 1039,619 36,36" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/review-rounded-surface.png"

magick -size 1060x640 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 1059,639 46,46" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/review-rounded-focus.png"

# Search and the compact show Bonus rail use a denser 300x169 landscape card
# and a 310x179 focus plate. Keep this exact pair together so those surfaces
# never stretch the larger Home geometry or overlay a separately filtered ring.
magick -size 600x338 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 599,337 22,22" \
  -channel RGB -evaluate set 100% +channel \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/landscape-search-rounded-mask.png"

magick -size 620x358 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 619,357 32,32" \
  -channel RGB -evaluate set 100% +channel \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/landscape-search-rounded-focus.png"

magick -size 620x358 xc:none \
  -fill white -stroke none \
  -draw "roundrectangle 0,0 619,357 32,32" \
  \( -size 620x358 xc:none -fill white -stroke none \
     -draw "roundrectangle 10,10 609,347 22,22" \) \
  -compose DstOut -composite \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/landscape-search-rounded-outline.png"

# People keep the circular crop but use the same neutral white focus language.
magick -size 508x508 xc:none \
  -fill none -stroke white -strokewidth 10 \
  -draw "ellipse 253.5,253.5 248.5,248.5 0,360" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/circle-rounded-outline.png"

# People use a solid focus plate under the portrait for the same reason as
# posters: two separately filtered transparent edges can expose a dark seam.
# The fallback deliberately stays low-contrast so absent Plex photography does
# not dominate a row of real faces.
magick -size 512x512 xc:none \
  -fill white -stroke none \
  -draw "circle 255.5,255.5 255.5,0.5" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/circle-rounded-focus.png"

magick -size 512x512 xc:'#282A2F' \
  -fill '#555962' -stroke none \
  -draw 'circle 256,178 256,106' \
  -draw "path 'M 82,512 C 91,374 157,296 256,296 C 355,296 421,374 430,512 Z'" \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/thumb_fallbacks/role.png"

# Home keeps a full-screen blurred canvas, then places a sharp 1280x720 copy
# against the upper-right edge while the first hub is focused. This diffuse
# mask dissolves that copy into the blur before it reaches the left-side hero
# text or the card rows, avoiding a visible rectangular artwork boundary.
magick \
  \( -size 1280x720 xc:black \
     -sparse-color Barycentric '100,0 black 420,0 white 100,719 black 420,719 white' \) \
  \( -size 1280x720 xc:black \
     -sparse-color Barycentric '0,230 white 1279,230 white 0,430 black 1279,430 black' \) \
  -compose Multiply -composite \
  -alpha copy \
  -channel RGB -evaluate set 100% +channel \
  -define png:color-type=6 \
  -depth 8 \
  "$MEDIA_DIR/home/tvos-first-row-art-mask.png"
