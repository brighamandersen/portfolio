# Homepage Redesign — Design

Source spec: `2026-07-10_portfolio-rewrite-spec.md` (repo root)

## Objective

Turn the homepage from a landing page that points visitors toward the Projects page into the primary showcase of Brigham's engineering work. A visitor should understand, within 60-90 seconds and without clicking to Projects: who he is, what he builds, and see proof via real projects.

## Current State (for reference)

- Static HTML/CSS site, no JS, no build step, no framework (deliberate — see README FAQ on staying simple for perf/Lighthouse scores).
- 5 hand-written pages, each duplicating the navbar markup: `index.html`, `resume.html`, `projects.html`, `designs.html`, `contact.html`.
- `global.css` provides a reusable design system: light/dark CSS custom properties, `.card`/`.shadowed`, `.icon-button`, `.icon-grid`, `.tooltip`.
- `index.html` today = Hero (bio + photo) + Latest Content (GitHub/YouTube/LinkedIn icon links). No projects, no professional experience section — company names (Nike, Oracle, Chick-fil-A, McDonald's, Walmart, Adobe) only appear inline in the bio paragraph.
- `projects.html` today = 20 project cards in one flat list, prose-only descriptions (no tech badges, no highlights, no structured data), mixing personal apps, work-for-employer projects, and school projects.

## New Homepage Flow

```
Hero
↓
Featured Projects
↓
Additional Projects
↓
Latest Content
↓
Contact
```

No Professional Experience section in this pass (explicitly deferred — see Out of Scope).

## Hero

Keep existing strengths (name, title, mission, photo). Tighten copy to be shorter/punchier per the spec. CTA row: Resume, GitHub, LinkedIn, Contact — reusing the existing `.icon-button` pattern.

## Featured Projects

Five projects, in this order:

1. **Retain** — Google Keep clone (React + Node.js API)
2. **No End Insight** — social platform for sharing uplifting insights
3. **Optiplex Web Server** — self-hosted server infrastructure project
4. **Portfolio (This Website)** — combined story of the React → vanilla HTML/CSS rewrite, linking both the current repo and the archived `react-portfolio` repo
5. **Handshaker** — Python/Selenium job-application automation bot

Each featured project is a card (extends the existing `.card`/`.shadowed` pattern) containing:

- Screenshot (reuse existing `assets/shots/*` images; Optiplex has no screenshot asset today — card will need to work without one, e.g. an icon/illustration in its place)
- Project name
- One-sentence overview
- Tech-stack badges — new small pill/badge component to add to `global.css`
- Engineering-highlight bullets (e.g. REST API, JWT Auth, browser APIs used, etc.)
- A native `<details>/<summary>` "Learn More" expander (no JS) containing:
  - Why I Built It
  - A dedicated paragraph on what was learned/grown from building it
  - An "Engineering Challenge" callout (the most interesting implementation problem solved)
- Live Demo / GitHub icon-buttons where they exist. Optiplex has neither (private repo, no public demo) — its card leans on the Learn More content instead. Portfolio's card links both the current repo and the `react-portfolio` repo.

Multi-photo galleries per featured project are a possible future enhancement, not built in this pass — but card markup should not actively block adding more images later (e.g. don't hardcode assumptions of exactly one image where easily avoided).

## Additional Projects

A lighter grid below Featured Projects, on the homepage. Cards contain only: thumbnail, one sentence, tech-stack badges, Live Demo/GitHub links — no long descriptions, no expanders.

Included (all remaining projects that already have a screenshot asset in `projects.html`), in current `projects.html` order minus the 5 featured:

Silver Fund Web App, Pecos Solutions, Internalize, Tweeter, Tutorials, Jolt, iRecognize, Instruct.me, Melting Pot, Venmo Tithing Calculator, VBB Mentoring Portal, Adobe.

Excluded from this grid (but untouched on `projects.html`): React Portfolio (folded into the Portfolio featured card's story), Approachable App and HTML URL Shortener (no screenshot asset exists for either today).

## Content Approach

No tech badges, highlight bullets, or structured "why/challenge/learned" copy exist anywhere in the codebase today — all prose on `projects.html` is a single descriptive paragraph per project. Content will be drafted as follows:

- **Additional Projects one-sentence overviews**: reuse/trim existing `projects.html` wording as directly as possible — pull the core sentence rather than writing new copy.
- **Featured Projects**: reuse existing wording as the base, but reformat it to fit the new structure (overview / why built it / what was learned / engineering challenge) and add extra supporting detail where the existing prose is thin for a given field. Not a wholesale rewrite — existing phrasing and voice should carry through wherever it fits.
- Tech-stack badges will be inferred from existing prose plus a check of each project's linked GitHub repo/README where accuracy matters, then flagged for Brigham's review before going live (existing site prose doesn't always specify exact stack details, e.g. Retain's database).

## `projects.html`

Stays structurally as-is — all 20 entries remain, full prose intact. Reframed conceptually (per the source spec) as the complete archive vs. the homepage's curated "best of," but no badge/highlight rework or content changes there in this pass.

## Visual/CSS additions needed

- Tech-stack badge/pill component
- Featured project card layout (screenshot + text + badges + highlights + expander + links)
- Additional Projects grid card (lighter version of the above)
- Styling for `<details>/<summary>` "Learn More" expanders consistent with existing dark/light theme variables

## Out of Scope (this pass)

- Professional Experience section (deferred — spec assumed one already existed on the homepage; it doesn't, only inline bio mentions do)
- Standalone "why I build so many side projects" personality section
- Standalone "What I Learned" section (folded into each featured project's own write-up instead)
- Multi-photo galleries on featured cards
- Any content/badge upgrades to the existing `projects.html` entries beyond what's needed for Additional Projects on the homepage
- Designs page changes
- Any templating/build-step changes to reduce navbar duplication across pages

## Success Criteria

Matches the source spec: after 60-90 seconds on the homepage, a visitor should know Brigham is an experienced engineer, what he builds, that he's worked with notable companies (still via the existing bio mention), that there are multiple real projects worth exploring, and how to get in touch — without needing to click into Projects.
