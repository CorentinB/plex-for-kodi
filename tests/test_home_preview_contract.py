from __future__ import absolute_import

import os
import unittest


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PREVIEW_ROOT = os.path.join(ROOT, "tools", "kodi-ui-preview")


def _read(name):
    with open(os.path.join(PREVIEW_ROOT, name), "r") as handle:
        return handle.read()


class HomePreviewContractTests(unittest.TestCase):
    def test_preview_hero_has_distinct_identity_metadata_and_rating_slots(self):
        markup = _read("index.html")

        for hook in (
            "data-hero-title",
            "data-hero-subtitle",
            "data-hero-certification",
            "data-hero-meta",
            "data-hero-rating",
            "data-hero-rating2",
            "data-hero-summary",
        ):
            self.assertIn(hook, markup)

    def test_preview_declares_a_local_favicon_without_a_network_request(self):
        markup = _read("index.html")

        self.assertIn('<link rel="icon" href="data:,">', markup)

    def test_preview_cards_are_art_only_and_use_the_native_geometry_rhythm(self):
        script = _read("app.js")
        styles = _read("styles.css")

        self.assertIn("card.setAttribute('aria-label'", script)
        self.assertNotIn("<h3>${item.label}</h3>", script)
        self.assertNotIn("<p>${item.sub || ''}</p>", script)
        self.assertIn("const HUB_ROW_STEPS = { poster: 475, square: 370, ar16x9: 350 };", script)
        self.assertIn("function hubScrollShift(hubIndex)", script)
        self.assertIn("HUB_ROW_STEPS[hub.display]", script)
        self.assertIn("return -147 - precedingHeight;", script)
        self.assertIn("const shift = hubScrollShift(hubIndex);", script)
        self.assertIn("classList.toggle('has-subtitle'", script)
        self.assertIn("height: 475px;", styles)
        self.assertIn(".hub-square {\n  height: 370px;", styles)
        self.assertIn(".hub-ar16x9 {\n  height: 350px;", styles)
        self.assertIn("height: 435px;", styles)
        self.assertIn(".hub-stack {\n  position: absolute;\n  z-index: 2;\n  top: 435px;", styles)
        self.assertIn(".hero-panel.has-subtitle .hero-facts", styles)
        self.assertNotIn(".media-card h3", styles)
        self.assertNotIn(".media-card p", styles)

    def test_preview_uses_the_native_generic_asset_for_source_less_ratings(self):
        script = _read("app.js")

        self.assertIn("other: `${ASSET_BASE}/ratings/other/image.rating.png`", script)
        self.assertIn("rating.image || RATING_ASSETS.other", script)
        self.assertIn("critic: { score: '7.8' }", script)

    def test_preview_mirrors_the_large_title_fallback_and_content_sized_fact_rail(self):
        styles = _read("styles.css")

        self.assertIn("font-size: 45px;", styles)
        self.assertIn(
            ".kodi-stage.is-scrolled .hero-panel h1 {\n"
            "  height: 58px;\n"
            "  font-size: 40px;",
            styles,
        )
        self.assertIn("width: max-content;", styles)
        self.assertIn("max-width: 850px;", styles)
        self.assertNotIn(".hero-description {\n  width: 600px;", styles)
        self.assertNotIn(".hero-ratings {\n  width: 340px;", styles)
        self.assertNotIn("margin-left: 20px;", styles)

    def test_preview_mirrors_the_balanced_native_hero_stack(self):
        styles = _read("styles.css")

        self.assertIn(
            ".hero-subtitle {\n"
            "  position: absolute;\n"
            "  top: 82px;\n"
            "  left: 0;\n"
            "  width: 880px;\n"
            "  height: 34px;",
            styles,
        )
        self.assertIn(".hero-panel.has-subtitle .hero-facts {\n  top: 126px;", styles)
        self.assertIn(
            ".hero-panel.has-subtitle .hero-summary {\n"
            "  top: 168px;\n"
            "  width: 920px;\n"
            "  height: 60px;",
            styles,
        )
        self.assertIn(
            ".kodi-stage.is-scrolled .hero-subtitle {\n"
            "  top: 70px;\n"
            "  width: 880px;\n"
            "  height: 30px;",
            styles,
        )
        self.assertIn(
            ".kodi-stage.is-scrolled .hero-panel.has-subtitle .hero-facts {\n"
            "  top: 112px;",
            styles,
        )
        self.assertIn(
            ".kodi-stage.is-scrolled .hero-panel.has-subtitle .hero-summary {\n"
            "  top: 154px;\n"
            "  width: 1120px;\n"
            "  height: 56px;",
            styles,
        )

    def test_preview_mirrors_the_single_resume_action_and_collapsed_hub(self):
        markup = _read("index.html")
        script = _read("app.js")
        styles = _read("styles.css")

        self.assertIn("data-resume-action", markup)
        self.assertIn("Reprendre", markup)
        self.assertIn(
            "/skin-media/script.plex/buttons/player/modern/play.png",
            markup,
        )
        self.assertIn('class="resume-icon"', markup)
        self.assertIn("function singleResumeItem()", script)
        self.assertIn("identifier === 'home.continue'", script)
        self.assertIn(
            "identifier === 'video.inprogress'",
            script,
        )
        self.assertIn("stage.classList.toggle('is-single-resume'", script)
        self.assertIn("if (resumeItem && hubIndex === 0) return;", script)
        self.assertIn("resumeAction.addEventListener('keydown'", script)
        self.assertIn(".resume-action", styles)
        self.assertIn("  width: 260px;", styles)
        self.assertIn("  color: #111;", styles)
        self.assertIn("  background: #fff;", styles)
        self.assertIn(".resume-icon::before", styles)
        self.assertIn(
            ".kodi-stage.is-single-resume .hub-stack {\n"
            "  top: 396px;",
            styles,
        )
        self.assertIn(
            ".kodi-stage.is-single-resume .hero-panel.has-summary + .hub-stack {\n"
            "  top: 472px;",
            styles,
        )
        self.assertIn(
            ".kodi-stage.is-single-resume "
            ".hero-panel:not(.has-subtitle) + .hub-stack {\n"
            "  top: 372px;",
            styles,
        )
        self.assertIn(
            ".kodi-stage.is-single-resume "
            ".hero-panel.has-summary:not(.has-subtitle) + .hub-stack {\n"
            "  top: 435px;",
            styles,
        )


if __name__ == "__main__":
    unittest.main()
