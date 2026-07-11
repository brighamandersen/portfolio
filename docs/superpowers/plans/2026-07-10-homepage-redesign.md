# Homepage Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn `index.html` into the primary showcase of Brigham's engineering work — hero, five Featured Projects with real engineering depth, a grid of Additional Projects, Latest Content, and a Contact section — so a visitor never has to click into Projects to see proof of ability.

**Architecture:** Pure static HTML/CSS edits, no build step, no JavaScript. Shared card/contact styles currently duplicated in per-page `<style>` blocks move into `global.css` so they can be reused on the homepage; three new CSS components (tech badges, engineering-highlight lists, native `<details>/<summary>` "Learn More" expanders) are added there too. `index.html` gains two new sections between Hero and Latest Content: Featured Projects (rich cards) and Additional Projects (a lightweight grid). A new Contact section is appended at the bottom, reusing `contact.html`'s existing markup/wording.

**Tech Stack:** Vanilla HTML5, CSS3 (custom properties for light/dark mode), no JS, no build tooling.

**Design doc:** `docs/superpowers/specs/2026-07-10-homepage-redesign-design.md`

## Global Constraints

- No JavaScript may be introduced anywhere. Any interactivity (expand/collapse) must use native HTML (`<details>/<summary>`) — this site is deliberately zero-JS for performance (see `README.md`).
- All new images must be square and `.webp` format, consistent with existing `assets/shots/*` assets.
- Reuse the existing light/dark mode CSS custom properties (`--primary`, `--secondary`, `--background`, `--surface`, `--text`, `--hover`) — never hardcode colors.
- Follow the existing inline-SVG icon pattern (icons copied directly into markup so `fill` can use CSS variables) — do not add an icon library or external icon requests.
- Reuse existing wording from `projects.html` as directly as possible for Additional Projects one-sentence overviews. For the 5 Featured Projects, reformat existing wording into the new structure (overview / highlights / why built it / what I learned / engineering challenge) and add extra detail where the source prose is thin — do not do a wholesale rewrite of the voice.
- `projects.html` stays structurally unchanged (all 20 entries, full prose) except for the shared CSS being moved out of its local `<style>` block — no badge/highlight rework there in this pass.
- No Professional Experience section, no personality/"why side projects" section, no standalone "What I Learned" section, no multi-photo galleries, no templating/build-step changes — all explicitly out of scope per the design doc.

---

## Task 1: Global CSS Foundation

**Files:**
- Modify: `global.css` (append new sections at end of file, after line 354)
- Modify: `projects.html:13-77` (remove rules now owned by `global.css`)
- Modify: `contact.html:13-30` (remove the entire now-empty `<style>` block)

**Interfaces:**
- Produces: CSS classes `.card`, `.card h2`, `.project-cards`, `.project-text`, `.project-shot`, `.links` (moved, unchanged behavior), `.contact-item` (moved, unchanged behavior), `.tech-badges`/`.tech-badge`, `.highlights`, `.learn-more`/`.challenge-callout`, `.mini-cards`/`.mini-card`/`.mini-card-shot`, `.hero-ctas`/`.cta-button` — all later tasks depend on these class names existing exactly as spelled here.

- [ ] **Step 1: Write a verification check for the "before" state**

Run these and confirm the expected counts (these classes should NOT exist in `global.css` yet, and SHOULD exist in `projects.html`/`contact.html`):

```bash
cd /Users/brig/dev/portfolio
grep -c '^\.card {' global.css            # expect 0
grep -c '^\.card {' projects.html         # expect 1
grep -c '^\.contact-item {' global.css    # expect 0
grep -c '^\.contact-item {' contact.html  # expect 1
grep -c '\.tech-badges' global.css        # expect 0
```

- [ ] **Step 2: Run the check to confirm the "before" state**

Run the commands from Step 1. Expected output: `0`, `1`, `0`, `1`, `0` in that order. If any differ, stop and re-read the current file contents before proceeding.

- [ ] **Step 3: Append the new CSS to `global.css`**

Add this to the end of `global.css` (after the existing final `}` that closes the mobile tooltip media query):

```css

/* CARD */
/* Moved here from projects.html so it can be reused on the homepage */

.card {
  background: var(--surface);
  border-radius: 8px;
  padding: 32px;
  display: flex;
  justify-content: space-between;
}

.card h2 {
  margin-top: 16px;
  margin-bottom: 16px;
}

.project-cards {
  display: flex;
  flex-direction: column;
  gap: 32px;
}

.project-text {
  display: flex;
  flex-direction: column;
}

.project-shot {
  height: 250px;
  width: 250px;
  margin-left: 32px;
  align-self: center;
  object-fit: cover;
}

.links {
  margin-left: -16px;
  margin-right: -16px;
}

/* Don't show project shots on tablet and mobile, only project text */
/* var(--tablet-breakpoint) but can't use in media queries */
@media (max-width: 960px) {
  .project-shot {
    display: none;
  }
}

/* CONTACT ITEM */
/* Moved here from contact.html so it can be reused on the homepage */

.contact-item {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 16px;
  padding: 8px;
  border-radius: 8px;
}

.contact-item:hover {
  background: var(--hover);
}

.contact-item:hover .contact-icon {
  fill: var(--primary);
}

/* TECH BADGES */

.tech-badges {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin: 12px 0;
  padding: 0;
  list-style: none;
}

.tech-badge {
  background-color: var(--hover);
  color: var(--primary);
  font-family: 'Rubik', sans-serif;
  font-size: 0.8em;
  padding: 4px 12px;
  border-radius: 999px;
  white-space: nowrap;
}

/* ENGINEERING HIGHLIGHTS */

.highlights {
  margin: 0 0 16px 0;
  padding-left: 20px;
}

.highlights li {
  font-family: 'Rubik-Light', 'Rubik', sans-serif;
  font-size: large;
  color: var(--text);
  margin-bottom: 4px;
}

/* LEARN MORE (native details/summary — no JS) */

.learn-more {
  margin-top: 8px;
}

.learn-more summary {
  cursor: pointer;
  color: var(--secondary);
  font-family: 'Rubik-SemiBold', 'Rubik', sans-serif;
  padding: 8px 0;
}

.learn-more summary:hover {
  color: var(--primary);
}

.learn-more[open] summary {
  color: var(--primary);
  margin-bottom: 8px;
}

.learn-more h3 {
  margin-top: 16px;
  margin-bottom: 8px;
  font-size: 1.1em;
}

.learn-more h3:first-of-type {
  margin-top: 0;
}

.challenge-callout {
  background-color: var(--hover);
  border-left: 3px solid var(--primary);
  padding: 12px 16px;
  margin: 8px 0;
  font-style: italic;
}

/* MINI CARDS (Additional Projects grid) */

.mini-cards {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 24px;
}

/* var(--tablet-breakpoint) but can't use in media queries */
@media (max-width: 960px) {
  .mini-cards {
    grid-template-columns: repeat(2, 1fr);
  }
}

/* var(--mobile-breakpoint) but can't use in media queries */
@media (max-width: 600px) {
  .mini-cards {
    grid-template-columns: repeat(1, 1fr);
  }
}

.mini-card {
  background: var(--surface);
  border-radius: 8px;
  padding: 24px;
  display: flex;
  flex-direction: column;
}

.mini-card-shot {
  width: 100%;
  aspect-ratio: 1 / 1;
  object-fit: cover;
  border-radius: 8px;
  margin-bottom: 16px;
}

.mini-card h3 {
  margin-top: 0;
  margin-bottom: 8px;
  font-size: 1.2em;
}

.mini-card p {
  font-size: medium;
  margin-top: 0;
  margin-bottom: 12px;
}

/* HERO CTAS */

.hero-ctas {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-top: 24px;
}

.cta-button {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 10px 20px;
  border-radius: 8px;
  border: 1px solid var(--secondary);
  color: var(--text);
  text-decoration: none;
  font-family: 'Rubik-SemiBold', 'Rubik', sans-serif;
}

.cta-button:hover {
  border-color: var(--primary);
  color: var(--primary);
  background-color: var(--hover);
  text-decoration: none;
}

.cta-button .icon {
  width: 20px;
  height: 20px;
}
```

- [ ] **Step 4: Remove the now-duplicated rules from `projects.html`**

In `projects.html`, the `<style>` block (currently lines 13-77) contains rules that now live in `global.css`. Replace the whole block:

```html
  <style>
    .project-cards {
      display: flex;
      flex-direction: column;
      gap: 32px;
    }

    .card {
      background: var(--surface);
      border-radius: 8px;
      padding: 32px;
      display: flex;
      justify-content: space-between;
    }

    .card h2 {
      margin-top: 16px;
      margin-bottom: 16px;
    }

    .links {
      margin-left: -16px;
      margin-right: -16px;
    }

    .project-text {
      display: flex;
      flex-direction: column;
    }

    .project-shot {
      height: 250px;
      width: 250px;
      margin-left: 32px;
      align-self: center;
    }

    /* Don't show project shots on tablet and mobile, only project text */
    /* var(--tablet-breakpoint) but can't use in media queries */
    @media (max-width: 960px) {
      .project-shot {
        display: none;
      }
    }

    .projects-footer {
      margin-top: 32px;
      margin-bottom: 32px;
    }

    .projects-footer,
    .projects-footer-link {
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .projects-footer-link svg {
      margin-left: 8px;
    }

    .projects-footer-link:hover svg {
      fill: var(--primary);
    }
  </style>
```

with:

```html
  <style>
    .projects-footer {
      margin-top: 32px;
      margin-bottom: 32px;
    }

    .projects-footer,
    .projects-footer-link {
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .projects-footer-link svg {
      margin-left: 8px;
    }

    .projects-footer-link:hover svg {
      fill: var(--primary);
    }
  </style>
```

- [ ] **Step 5: Remove the now-empty `<style>` block from `contact.html`**

In `contact.html`, remove this entire block (currently lines 13-30):

```html
  <style>
    .contact-item {
      display: flex;
      align-items: center;
      gap: 12px;
      margin-bottom: 16px;
      padding: 8px;
      border-radius: 8px;
    }

    .contact-item:hover {
      background: var(--hover);
    }

    .contact-item:hover .contact-icon {
      fill: var(--primary);
    }
  </style>
```

(delete the block entirely — the line above it is `<link rel="stylesheet" href="global.css" />` and the line after is `</head>`, so after deletion those two lines become adjacent).

- [ ] **Step 6: Run the check to confirm the "after" state**

```bash
cd /Users/brig/dev/portfolio
grep -c '^\.card {' global.css            # expect 1
grep -c '^\.card {' projects.html         # expect 0
grep -c '^\.contact-item {' global.css    # expect 1
grep -c '^\.contact-item {' contact.html  # expect 0
grep -c '\.tech-badges' global.css        # expect 1 (the selector line itself, ".tech-badges {")
```

- [ ] **Step 7: Visually confirm no regression on `projects.html` and `contact.html`**

```bash
cd /Users/brig/dev/portfolio && python3 -m http.server 8080
```

Open `http://localhost:8080/projects.html` and `http://localhost:8080/contact.html` in a browser. Confirm both look exactly as they did before (cards still have background/padding/shadow, contact rows still have hover highlight). Stop the server (Ctrl+C) when done.

- [ ] **Step 8: Commit**

```bash
git add global.css projects.html contact.html
git commit -m "$(cat <<'EOF'
Move shared card/contact styles into global.css, add homepage components

Consolidates .card/.project-*/.links (from projects.html) and
.contact-item (from contact.html) into global.css so the homepage
redesign can reuse them. Adds new components needed by the redesign:
tech badges, engineering highlights, native details/summary "Learn
More" expanders, the Additional Projects mini-card grid, and hero CTA
buttons.

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
EOF
)"
```

---

## Task 2: Hero Section Rewrite

**Files:**
- Modify: `index.html:96-125` (welcome-section)

**Interfaces:**
- Consumes: `.cta-button`, `.hero-ctas`, `.icon` (from Task 1 / existing `global.css`)
- Produces: no new interfaces consumed by later tasks (Featured Projects section is independent markup inserted separately in Task 3)

- [ ] **Step 1: Write a verification check for the "before" state**

```bash
cd /Users/brig/dev/portfolio
grep -c 'hero-ctas' index.html   # expect 0
```

- [ ] **Step 2: Run the check to confirm it fails (class doesn't exist yet)**

Run the command above. Expected: `0`.

- [ ] **Step 3: Replace the welcome-section bio and add the CTA row**

In `index.html`, replace this block (currently lines 97-125):

```html
      <section class="welcome-section">
        <h1 class="page-header">Welcome!</h1>
        <div class="bio-and-profile-pic">
          <div class="bio">
            <p>
              I’m <b>Brigham Andersen</b> and
              <u>I build technology that boosts productivity.</u>
            </p>
            <p>
              I love solving the problem users hate most – wasting time. We all
              detest menial tasks, but computers can automate them, freeing us
              for impactful work. Obsessed with the time-saving potential of
              technology, I’ve created my career in software engineering.
            </p>
            <p>
              My career vision is to build technology that helps users and
              businesses boost their productivity. I’ve assisted numerous
              startups along with Fortune 500 companies like Nike, Oracle,
              Chick-fil-A, McDonald's, Walmart, and Adobe. If you need help
              developing a product that drives productivity, let's talk!
            </p>
          </div>
          <img
            src="./assets/profile-picture.webp"
            alt="Me"
            class="profile-pic"
          />
        </div>
      </section>
```

with:

```html
      <section class="welcome-section">
        <h1 class="page-header">Welcome!</h1>
        <div class="bio-and-profile-pic">
          <div class="bio">
            <p>
              I’m <b>Brigham Andersen</b> and
              <u>I build technology that boosts productivity.</u>
            </p>
            <p>
              I love solving the problem users hate most – wasting time.
              Computers can automate the menial tasks we all detest, freeing
              people for more impactful work, and I've built my career in
              software engineering around that idea.
            </p>
            <p>
              I've helped startups and Fortune 500 companies alike — including
              Nike, Oracle, Chick-fil-A, McDonald's, Walmart, and Adobe —
              build software that drives productivity. Take a look below at
              what I've built, or reach out if you'd like to talk.
            </p>
            <div class="hero-ctas">
              <a
                href="./assets/resume-brigham-andersen.pdf"
                target="_blank"
                rel="noopener noreferrer"
                class="cta-button"
                aria-label="View resume"
              >
                <svg class="icon small resume-icon">
                  <path
                    d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"
                  />
                </svg>
                Resume
              </a>
              <a
                href="https://github.com/brighamandersen"
                target="_blank"
                rel="noopener noreferrer"
                class="cta-button"
                aria-label="Visit GitHub profile"
              >
                <svg class="icon small github-icon" viewBox="0 0 24 24">
                  <path
                    d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"
                  />
                </svg>
                GitHub
              </a>
              <a
                href="https://www.linkedin.com/in/brighamandersen/"
                target="_blank"
                rel="noopener noreferrer"
                class="cta-button"
                aria-label="Visit LinkedIn profile"
              >
                <svg class="icon small linkedin-icon" viewBox="0 0 448 512">
                  <path
                    d="M416 32H31.9C14.3 32 0 46.5 0 64.3v383.4C0 465.5 14.3 480 31.9 480H416c17.6 0 32-14.5 32-32.3V64.3c0-17.8-14.4-32.3-32-32.3zM135.4 416H69V202.2h66.5V416zm-33.2-243c-21.3 0-38.5-17.3-38.5-38.5S80.9 96 102.2 96c21.2 0 38.5 17.3 38.5 38.5 0 21.3-17.2 38.5-38.5 38.5zm282.1 243h-66.4V312c0-24.8-.5-56.7-34.5-56.7-34.6 0-39.9 27-39.9 54.9V416h-66.4V202.2h63.7v29.2h.9c8.9-16.8 30.6-34.5 62.9-34.5 67.2 0 79.7 44.3 79.7 101.9V416z"
                  />
                </svg>
                LinkedIn
              </a>
              <a
                href="contact.html"
                class="cta-button"
                aria-label="Contact me"
              >
                <svg class="icon small contact-icon" viewBox="0 0 24 24">
                  <path
                    d="M19,3H5C3.9,3,3,3.9,3,5v14c0,1.1,0.9,2,2,2h14c1.1,0,2-0.9,2-2V5C21,3.9,20.1,3,19,3z M12,6c1.93,0,3.5,1.57,3.5,3.5 c0,1.93-1.57,3.5-3.5,3.5s-3.5-1.57-3.5-3.5C8.5,7.57,10.07,6,12,6z M19,19H5v-0.23c0-0.62,0.28-1.2,0.76-1.58 C7.47,15.82,9.64,15,12,15s4.53,0.82,6.24,2.19c0.48,0.38,0.76,0.97,0.76,1.58V19z"
                  />
                </svg>
                Contact
              </a>
            </div>
          </div>
          <img
            src="./assets/profile-picture.webp"
            alt="Me"
            class="profile-pic"
          />
        </div>
      </section>
```

- [ ] **Step 4: Run the check to confirm it passes**

```bash
cd /Users/brig/dev/portfolio
grep -c 'hero-ctas' index.html   # expect 1 (the single opening div, grep -c counts matching lines)
grep -c 'cta-button' index.html  # expect 4 (Resume, GitHub, LinkedIn, Contact)
```

- [ ] **Step 5: Visually confirm in a browser**

```bash
cd /Users/brig/dev/portfolio && python3 -m http.server 8080
```

Open `http://localhost:8080/`. Confirm the bio reads correctly, the 4 CTA buttons render with icon + label, and hovering each highlights it (border/text turn to the primary color). Stop the server when done.

- [ ] **Step 6: Commit**

```bash
git add index.html
git commit -m "$(cat <<'EOF'
Tighten hero copy and add Resume/GitHub/LinkedIn/Contact CTAs

Shortens the bio to two punchier paragraphs and adds a labeled CTA
row so visitors have an immediate action beyond reading, per the
homepage redesign spec.

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
EOF
)"
```

---

## Task 3: Featured Projects — Section Shell + Retain Card

**Files:**
- Modify: `index.html` (insert new section immediately before `<section class="latest-content-section">`)

**Interfaces:**
- Consumes: `.card`, `.shadowed`, `.project-text`, `.project-shot`, `.links`, `.icon-button`, `.tech-badges`/`.tech-badge`, `.highlights`, `.learn-more`/`.challenge-callout` (from Task 1)
- Produces: `<section class="featured-projects-section">` and `<div class="project-cards">` wrapper that Tasks 4-7 insert their cards into, immediately before the closing `</div>` of `.project-cards` and before the section's closing `</section>`.

- [ ] **Step 1: Write a verification check for the "before" state**

```bash
cd /Users/brig/dev/portfolio
grep -c 'featured-projects-section' index.html   # expect 0
```

- [ ] **Step 2: Run the check to confirm it fails**

Run the command above. Expected: `0`.

- [ ] **Step 3: Insert the Featured Projects section with the Retain card**

In `index.html`, find this line (the start of the Latest Content section):

```html
      <section class="latest-content-section">
```

Insert the following immediately **before** it:

```html
      <section class="featured-projects-section">
        <h2>Featured Projects</h2>
        <div class="project-cards">
          <div class="card shadowed" id="featured-retain">
            <div class="project-text">
              <h3>Retain</h3>
              <p>
                A full-stack clone of Google Keep — notes with pinning,
                color-coding, archiving, and trash, backed by a React client
                and an Express/Node API.
              </p>
              <ul class="tech-badges">
                <li class="tech-badge">React</li>
                <li class="tech-badge">TypeScript</li>
                <li class="tech-badge">Node.js</li>
                <li class="tech-badge">Express</li>
                <li class="tech-badge">Prisma</li>
              </ul>
              <ul class="highlights">
                <li>
                  Full CRUD note-taking: create, pin, color-code, archive, and
                  trash
                </li>
                <li>
                  Scheduled cleanup with node-cron to auto-purge trashed notes
                  after 7 days
                </li>
                <li>Type-safe client and server, both written in TypeScript</li>
                <li>Prisma ORM for data access</li>
              </ul>
              <details class="learn-more">
                <summary>Learn More</summary>
                <h3>Why I Built It</h3>
                <p>
                  I'd been meaning to build a full-stack website for a while
                  with a client-side React app and a Node.js API to show my
                  skill at that stack, and Google Keep — something I use
                  every day — turned out to be just the project to do it.
                </p>
                <h3>What I Learned</h3>
                <p>
                  Building Retain end-to-end reinforced how much small
                  infrastructure decisions matter day-to-day: I originally
                  set up CSS Modules for styling, but for a project this size
                  it created more organizational overhead than it was worth,
                  so I moved to a single global stylesheet instead. I also
                  learned that scheduling cleanup work directly in the app
                  with node-cron was easier to maintain than standing up a
                  separate server-side cron job.
                </p>
                <h3>Engineering Challenge</h3>
                <p class="challenge-callout">
                  Automatically and permanently deleting notes from the trash
                  after 7 days without a separate infrastructure job — solved
                  with an in-app node-cron schedule instead.
                </p>
              </details>
              <div class="links">
                <a
                  href="https://retain.brighamandersen.com"
                  target="_blank"
                  rel="noopener noreferrer"
                  title="Site: https://retain.brighamandersen.com"
                  class="icon-button"
                >
                  <svg class="icon small site-icon">
                    <path
                      d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2v7zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3h-7z"
                    />
                  </svg>
                </a>
                <a
                  href="https://github.com/brighamandersen/retain"
                  target="_blank"
                  rel="noopener noreferrer"
                  title="Source Code: https://github.com/brighamandersen/retain"
                  class="icon-button"
                >
                  <svg class="icon small github-icon" viewBox="0 0 24 24">
                    <path
                      d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"
                    />
                  </svg>
                </a>
              </div>
            </div>
            <img
              src="./assets/shots/retain1.webp"
              alt="Retain Screenshot"
              title="Retain Screenshot"
              class="project-shot"
              loading="lazy"
            />
          </div>
        </div>
      </section>
```

- [ ] **Step 4: Run the check to confirm it passes**

```bash
cd /Users/brig/dev/portfolio
grep -c 'featured-projects-section' index.html   # expect 1 (the single opening tag)
grep -c 'id="featured-retain"' index.html        # expect 1
```

- [ ] **Step 5: Visually confirm in a browser**

```bash
cd /Users/brig/dev/portfolio && python3 -m http.server 8080
```

Open `http://localhost:8080/`. Confirm the Retain card renders below the hero with screenshot, badges, highlights, a working "Learn More" expander (click to open/close, no JS errors possible since there are none), and working Site/GitHub links. Stop the server when done.

- [ ] **Step 6: Commit**

```bash
git add index.html
git commit -m "$(cat <<'EOF'
Add Featured Projects section with Retain card

First card in the new homepage Featured Projects section, establishing
the card pattern (badges, highlights, expandable Learn More) that
Tasks 4-7 will follow for the remaining 4 featured projects.

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
EOF
)"
```

---

## Task 4: Featured Projects — No End Insight Card

**Files:**
- Modify: `index.html` (append inside the existing `.project-cards` div added in Task 3)

**Interfaces:**
- Consumes: same as Task 3

- [ ] **Step 1: Write a verification check for the "before" state**

```bash
cd /Users/brig/dev/portfolio
grep -c 'id="featured-no-end-insight"' index.html   # expect 0
```

- [ ] **Step 2: Run the check to confirm it fails**

Expected: `0`.

- [ ] **Step 3: Insert the No End Insight card**

In `index.html`, find the closing of the Retain card added in Task 3:

```html
            <img
              src="./assets/shots/retain1.webp"
              alt="Retain Screenshot"
              title="Retain Screenshot"
              class="project-shot"
              loading="lazy"
            />
          </div>
        </div>
      </section>
```

Replace it with (inserting the new card between Retain's closing `</div>` and the `.project-cards` closing `</div>`):

```html
            <img
              src="./assets/shots/retain1.webp"
              alt="Retain Screenshot"
              title="Retain Screenshot"
              class="project-shot"
              loading="lazy"
            />
          </div>
          <div class="card shadowed" id="featured-no-end-insight">
            <div class="project-text">
              <h3>No End Insight</h3>
              <p>
                A social platform for sharing uplifting insights — started as
                a school front-end assignment, then given a real Flask
                backend as a side project.
              </p>
              <ul class="tech-badges">
                <li class="tech-badge">Python</li>
                <li class="tech-badge">Flask</li>
                <li class="tech-badge">SQLite</li>
                <li class="tech-badge">Bootstrap</li>
              </ul>
              <ul class="highlights">
                <li>User authentication (login/register)</li>
                <li>User profiles and a live content feed</li>
                <li>Post creation backed by a real SQLite database</li>
                <li>Deployment scripts for production hosting</li>
              </ul>
              <details class="learn-more">
                <summary>Learn More</summary>
                <h3>Why I Built It</h3>
                <p>
                  Only the front-end (HTML and Bootstrap CSS) was completed
                  for a school assignment, and I've since hooked it up with a
                  real back-end and live data as a fun side project.
                </p>
                <h3>What I Learned</h3>
                <p>
                  This was my first time taking a purely front-end school
                  project and giving it a real backend after the fact — it
                  pushed me to design a Flask and SQLite API that could plug
                  cleanly into HTML/CSS that was never built with a backend
                  in mind, including wiring up authentication and a live
                  feed on top of it.
                </p>
                <h3>Engineering Challenge</h3>
                <p class="challenge-callout">
                  Retrofitting a real Flask/SQLite backend — with
                  authentication and a live feed — onto a front-end that was
                  originally built with no backend in mind.
                </p>
              </details>
              <div class="links">
                <a
                  href="https://insight.brighamandersen.com"
                  target="_blank"
                  rel="noopener noreferrer"
                  title="Site: https://insight.brighamandersen.com"
                  class="icon-button"
                >
                  <svg class="icon small site-icon">
                    <path
                      d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2v7zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3h-7z"
                    />
                  </svg>
                </a>
                <a
                  href="https://github.com/brighamandersen/no-end-insight"
                  target="_blank"
                  rel="noopener noreferrer"
                  title="Source Code: https://github.com/brighamandersen/no-end-insight"
                  class="icon-button"
                >
                  <svg class="icon small github-icon" viewBox="0 0 24 24">
                    <path
                      d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"
                    />
                  </svg>
                </a>
              </div>
            </div>
            <img
              src="./assets/shots/no-end-insight1.webp"
              alt="No End Insight Screenshot"
              title="No End Insight Screenshot"
              class="project-shot"
              loading="lazy"
            />
          </div>
        </div>
      </section>
```

- [ ] **Step 4: Run the check to confirm it passes**

```bash
cd /Users/brig/dev/portfolio
grep -c 'id="featured-no-end-insight"' index.html   # expect 1
```

- [ ] **Step 5: Visually confirm in a browser** (same server/steps as Task 3, Step 5 — confirm the second card renders correctly under Retain)

- [ ] **Step 6: Commit**

```bash
git add index.html
git commit -m "$(cat <<'EOF'
Add No End Insight to Featured Projects

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
EOF
)"
```

---

## Task 5: Featured Projects — Optiplex Web Server Card

**Files:**
- Modify: `index.html` (append inside `.project-cards`)

**Interfaces:**
- Consumes: same as Task 3. Note this card has **no screenshot and no Live Demo/GitHub links** (private repo) — omit the `<img class="project-shot">` and the `.links` div entirely, matching how `projects.html` already handles the Optiplex card.

- [ ] **Step 1: Write a verification check for the "before" state**

```bash
cd /Users/brig/dev/portfolio
grep -c 'id="featured-optiplex"' index.html   # expect 0
```

- [ ] **Step 2: Run the check to confirm it fails**

Expected: `0`.

- [ ] **Step 3: Insert the Optiplex Web Server card**

Find the closing of the No End Insight card added in Task 4:

```html
            <img
              src="./assets/shots/no-end-insight1.webp"
              alt="No End Insight Screenshot"
              title="No End Insight Screenshot"
              class="project-shot"
              loading="lazy"
            />
          </div>
        </div>
      </section>
```

Replace it with:

```html
            <img
              src="./assets/shots/no-end-insight1.webp"
              alt="No End Insight Screenshot"
              title="No End Insight Screenshot"
              class="project-shot"
              loading="lazy"
            />
          </div>
          <div class="card shadowed" id="featured-optiplex">
            <div class="project-text">
              <h3>Optiplex Web Server</h3>
              <p>
                Turned an old Dell Optiplex Mini PC into a self-hosted server
                so I could stop paying recurring hosting fees for personal
                projects — including the one you're looking at right now.
              </p>
              <ul class="tech-badges">
                <li class="tech-badge">Linux</li>
                <li class="tech-badge">NGINX</li>
                <li class="tech-badge">Bash</li>
                <li class="tech-badge">Dynamic DNS</li>
                <li class="tech-badge">HTTPS/Let's Encrypt</li>
              </ul>
              <ul class="highlights">
                <li>
                  Custom router configuration, dynamic DNS, and port
                  forwarding
                </li>
                <li>
                  HTTPS certificates and NGINX reverse-proxy configuration
                  for multiple sites
                </li>
                <li>
                  Bash scripts to pull the latest changes and redeploy every
                  hosted site
                </li>
                <li>
                  Hosts both static and full-stack applications, including
                  this portfolio
                </li>
              </ul>
              <details class="learn-more">
                <summary>Learn More</summary>
                <h3>Why I Built It</h3>
                <p>
                  I got sick of paying AWS, Digital Ocean, Vercel, and other
                  web hosting companies to host my websites. My personal
                  projects don't get a ton of traffic, so paying $5 a month
                  or more per project seemed ridiculous to me.
                </p>
                <h3>What I Learned</h3>
                <p>
                  Getting an old Dell Optiplex Mini PC running as a real
                  server meant learning router configuration, dynamic DNS,
                  exposing IP addresses, port forwarding, HTTPS
                  certification, and NGINX configuration from scratch —
                  concepts I hadn't needed to touch when using managed
                  hosting. It took a while to get everything set up, but now
                  I don't pay recurring fees to host any of my sites, and I
                  have scripts to pull changes and redeploy everything
                  easily.
                </p>
                <h3>Engineering Challenge</h3>
                <p class="challenge-callout">
                  Getting a consumer mini PC to reliably serve HTTPS traffic
                  for multiple domains from a home network — router
                  configuration, dynamic DNS, port forwarding, and
                  certificates, all set up from scratch.
                </p>
              </details>
            </div>
          </div>
        </div>
      </section>
```

- [ ] **Step 4: Run the check to confirm it passes**

```bash
cd /Users/brig/dev/portfolio
grep -c 'id="featured-optiplex"' index.html   # expect 1
```

- [ ] **Step 5: Visually confirm in a browser**

Confirm the Optiplex card renders without a screenshot or link row, and that the text panel fills the full card width (matching how cards without images already behave on `projects.html`, e.g. Handshaker there today).

- [ ] **Step 6: Commit**

```bash
git add index.html
git commit -m "$(cat <<'EOF'
Add Optiplex Web Server to Featured Projects

No live demo or public repo (private infra repo), so this card relies
entirely on the Learn More write-up.

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
EOF
)"
```

---

## Task 6: Featured Projects — Portfolio Card (React → Vanilla Story)

**Files:**
- Create: `assets/shots/portfolio1.webp` (generated from `assets/README-cover-light.jpg`)
- Modify: `index.html` (append inside `.project-cards`)

**Interfaces:**
- Consumes: same as Task 3

- [ ] **Step 1: Generate a square screenshot asset for the Portfolio card**

The existing `assets/README-cover-light.jpg` (3438×2159) is the only current screenshot of this site, but it isn't square/webp like the other shots. Crop it to a square and convert to webp:

```bash
cd /Users/brig/dev/portfolio
magick assets/README-cover-light.jpg -resize 1400x1400^ -gravity center -extent 1400x1400 assets/shots/portfolio1.webp
```

- [ ] **Step 2: Verify the asset was created correctly**

```bash
cd /Users/brig/dev/portfolio
sips -g pixelWidth -g pixelHeight assets/shots/portfolio1.webp
```

Expected: `pixelWidth: 1400` and `pixelHeight: 1400`.

- [ ] **Step 3: Write a verification check for the "before" state of the HTML**

```bash
cd /Users/brig/dev/portfolio
grep -c 'id="featured-portfolio"' index.html   # expect 0
```

- [ ] **Step 4: Run the check to confirm it fails**

Expected: `0`.

- [ ] **Step 5: Insert the Portfolio card**

Find the closing of the Optiplex card added in Task 5:

```html
              </details>
            </div>
          </div>
        </div>
      </section>
```

Replace it with:

```html
              </details>
            </div>
          </div>
          <div class="card shadowed" id="featured-portfolio">
            <div class="project-text">
              <h3>Portfolio (This Website)</h3>
              <p>
                This portfolio itself — originally built in React, then
                deliberately rewritten in vanilla HTML/CSS after realizing a
                single-page app was the wrong tool for a static site.
              </p>
              <ul class="tech-badges">
                <li class="tech-badge">HTML</li>
                <li class="tech-badge">CSS</li>
                <li class="tech-badge">React (legacy)</li>
              </ul>
              <ul class="highlights">
                <li>
                  100% Lighthouse scores across performance, accessibility,
                  best practices, and SEO after the rewrite
                </li>
                <li>
                  Inline SVG icons styled via CSS variables instead of an
                  icon library, avoiding unused downloads
                </li>
                <li>
                  Automatic light/dark mode via <code>prefers-color-scheme</code>
                  — no toggle or JS required
                </li>
                <li>
                  Square, WebP-format screenshots for consistent, fast-loading
                  images
                </li>
              </ul>
              <details class="learn-more">
                <summary>Learn More</summary>
                <h3>Why I Built It</h3>
                <p>
                  This portfolio was built to help prospective clients and
                  employers get a feel for who I am and the work I do. It was
                  originally made in React, styled with Material UI — I'd
                  just learned React at my first job and wanted to practice
                  it, and it's a great showcase of the pros of React, like
                  intuitive, declarative JSX. But over time I realized a
                  single-page app was the wrong choice for a site that's
                  entirely static — loading React and all its packages was
                  killing initial page load times.
                </p>
                <h3>What I Learned</h3>
                <p>
                  Rewriting the site in plain HTML and CSS, then optimizing
                  images and accessibility on top of that, took the site to
                  100% on all four Lighthouse scores. It was a good reminder
                  that your tech stack doesn't have to be complicated — stick
                  to traditional tools when they fit, and only reach for
                  something like React, Next.js, or Astro once the site's
                  complexity actually needs it.
                </p>
                <h3>Engineering Challenge</h3>
                <p class="challenge-callout">
                  Migrating a full site from a React/Material UI SPA to
                  zero-dependency static HTML/CSS without losing any
                  functionality — and getting perfect Lighthouse scores out
                  of the rewrite.
                </p>
              </details>
              <div class="links">
                <a
                  href="https://brighamandersen.com"
                  target="_blank"
                  rel="noopener noreferrer"
                  title="Site: https://brighamandersen.com"
                  class="icon-button"
                >
                  <svg class="icon small site-icon">
                    <path
                      d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2v7zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3h-7z"
                    />
                  </svg>
                </a>
                <a
                  href="https://github.com/brighamandersen/portfolio"
                  target="_blank"
                  rel="noopener noreferrer"
                  title="Source Code (current): https://github.com/brighamandersen/portfolio"
                  class="icon-button"
                >
                  <svg class="icon small github-icon" viewBox="0 0 24 24">
                    <path
                      d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"
                    />
                  </svg>
                </a>
                <a
                  href="https://github.com/brighamandersen/react-portfolio"
                  target="_blank"
                  rel="noopener noreferrer"
                  title="Source Code (original React version): https://github.com/brighamandersen/react-portfolio"
                  class="icon-button"
                >
                  <svg class="icon small github-icon" viewBox="0 0 24 24">
                    <path
                      d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"
                    />
                  </svg>
                </a>
              </div>
            </div>
            <img
              src="./assets/shots/portfolio1.webp"
              alt="Portfolio Screenshot"
              title="Portfolio Screenshot"
              class="project-shot"
              loading="lazy"
            />
          </div>
        </div>
      </section>
```

- [ ] **Step 6: Run the check to confirm it passes**

```bash
cd /Users/brig/dev/portfolio
grep -c 'id="featured-portfolio"' index.html   # expect 1
```

- [ ] **Step 7: Visually confirm in a browser**

Confirm the Portfolio card renders with the new `portfolio1.webp` screenshot, and both GitHub icon-buttons (current repo + `react-portfolio`) have distinct, correct `title` tooltips on hover.

- [ ] **Step 8: Commit**

```bash
git add index.html assets/shots/portfolio1.webp
git commit -m "$(cat <<'EOF'
Add Portfolio (React to vanilla) to Featured Projects

Generates a square webp screenshot from the existing README cover
image and links both the current repo and the archived
react-portfolio repo so the full rewrite story is told in one card.

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
EOF
)"
```

---

## Task 7: Featured Projects — Handshaker Card

**Files:**
- Modify: `index.html` (append inside `.project-cards`)

**Interfaces:**
- Consumes: same as Task 3. No screenshot asset exists for this project — omit `<img class="project-shot">`, matching the Optiplex card's pattern from Task 5.

- [ ] **Step 1: Write a verification check for the "before" state**

```bash
cd /Users/brig/dev/portfolio
grep -c 'id="featured-handshaker"' index.html   # expect 0
```

- [ ] **Step 2: Run the check to confirm it fails**

Expected: `0`.

- [ ] **Step 3: Insert the Handshaker card**

Find the closing of the Portfolio card added in Task 6:

```html
            <img
              src="./assets/shots/portfolio1.webp"
              alt="Portfolio Screenshot"
              title="Portfolio Screenshot"
              class="project-shot"
              loading="lazy"
            />
          </div>
        </div>
      </section>
```

Replace it with:

```html
            <img
              src="./assets/shots/portfolio1.webp"
              alt="Portfolio Screenshot"
              title="Portfolio Screenshot"
              class="project-shot"
              loading="lazy"
            />
          </div>
          <div class="card shadowed" id="featured-handshaker">
            <div class="project-text">
              <h3>Handshaker</h3>
              <p>
                A Python/Selenium bot that automatically finds and applies to
                "quick apply" jobs on BYU's Handshake job board.
              </p>
              <ul class="tech-badges">
                <li class="tech-badge">Python</li>
                <li class="tech-badge">Selenium</li>
              </ul>
              <ul class="highlights">
                <li>
                  Command-line interface with a query flag to search any job
                  title
                </li>
                <li>
                  Automatically identifies and submits every matching "quick
                  apply" listing
                </li>
                <li>Credentials and config managed via a .env file</li>
              </ul>
              <details class="learn-more">
                <summary>Learn More</summary>
                <h3>Why I Built It</h3>
                <p>
                  A script that automatically applies to jobs for me — it
                  web scrapes the BYU Handshake website when you search for
                  any job and applies to all the jobs with quick apply.
                </p>
                <h3>What I Learned</h3>
                <p>
                  Building Handshaker was my first real project using
                  Selenium for browser automation rather than just scripting
                  HTTP requests — it forced me to handle a real, dynamic web
                  UI (locating and clicking through Handshake's actual
                  quick-apply flow) instead of a clean API, which is a
                  different and messier problem than scraping static pages.
                </p>
                <h3>Engineering Challenge</h3>
                <p class="challenge-callout">
                  Reliably locating and driving Handshake's live "quick
                  apply" flow with Selenium across many different job
                  postings, each with slightly different page states.
                </p>
              </details>
              <div class="links">
                <a
                  href="https://youtu.be/34GiNbJ4ECc"
                  target="_blank"
                  rel="noopener noreferrer"
                  title="Site: https://youtu.be/34GiNbJ4ECc"
                  class="icon-button"
                >
                  <svg class="icon small site-icon">
                    <path
                      d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2v7zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3h-7z"
                    />
                  </svg>
                </a>
                <a
                  href="https://github.com/brighamandersen/handshaker"
                  target="_blank"
                  rel="noopener noreferrer"
                  title="Source Code: https://github.com/brighamandersen/handshaker"
                  class="icon-button"
                >
                  <svg class="icon small github-icon" viewBox="0 0 24 24">
                    <path
                      d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"
                    />
                  </svg>
                </a>
              </div>
            </div>
          </div>
        </div>
      </section>
```

- [ ] **Step 4: Run the check to confirm it passes**

```bash
cd /Users/brig/dev/portfolio
grep -c 'id="featured-handshaker"' index.html   # expect 1
grep -c 'id="featured-' index.html              # expect 5 (all five featured cards present)
```

- [ ] **Step 5: Visually confirm in a browser**

Confirm all 5 Featured Project cards now render in order: Retain, No End Insight, Optiplex Web Server, Portfolio, Handshaker.

- [ ] **Step 6: Commit**

```bash
git add index.html
git commit -m "$(cat <<'EOF'
Add Handshaker to Featured Projects

Completes the 5-card Featured Projects section (Retain, No End
Insight, Optiplex Web Server, Portfolio, Handshaker).

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
EOF
)"
```

---

## Task 8: Additional Projects Grid

**Files:**
- Modify: `index.html` (insert new section immediately before `<section class="latest-content-section">`, i.e. immediately after the Featured Projects `</section>` added in Task 3)

**Interfaces:**
- Consumes: `.mini-cards`, `.mini-card`, `.mini-card-shot`, `.tech-badges`/`.tech-badge`, `.links`, `.icon-button` (from Task 1)

- [ ] **Step 1: Write a verification check for the "before" state**

```bash
cd /Users/brig/dev/portfolio
grep -c 'additional-projects-section' index.html   # expect 0
```

- [ ] **Step 2: Run the check to confirm it fails**

Expected: `0`.

- [ ] **Step 3: Insert the Additional Projects section**

Find this line (the start of the Latest Content section):

```html
      <section class="latest-content-section">
```

Insert the following immediately **before** it:

```html
      <section class="additional-projects-section">
        <h2>Additional Projects</h2>
        <div class="mini-cards">
          <div class="mini-card" id="proj-silver-fund">
            <img
              src="./assets/shots/silver-fund1.webp"
              alt="Silver Fund Web App Screenshot"
              title="Silver Fund Web App Screenshot"
              class="mini-card-shot"
              loading="lazy"
            />
            <h3>Silver Fund Web App</h3>
            <p>
              A stocks/trades performance tracker built for BYU's MBA finance
              program, later recreated as a front-end-only side project.
            </p>
            <ul class="tech-badges">
              <li class="tech-badge">React</li>
              <li class="tech-badge">JavaScript</li>
            </ul>
            <div class="links">
              <a
                href="https://silverfund.brighamandersen.com"
                target="_blank"
                rel="noopener noreferrer"
                title="Site: https://silverfund.brighamandersen.com"
                class="icon-button"
              >
                <svg class="icon small site-icon">
                  <path
                    d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2v7zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3h-7z"
                  />
                </svg>
              </a>
              <a
                href="https://github.com/brighamandersen/silver-fund"
                target="_blank"
                rel="noopener noreferrer"
                title="Source Code: https://github.com/brighamandersen/silver-fund"
                class="icon-button"
              >
                <svg class="icon small github-icon" viewBox="0 0 24 24">
                  <path
                    d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"
                  />
                </svg>
              </a>
            </div>
          </div>
          <div class="mini-card" id="proj-pecos">
            <img
              src="./assets/shots/pecos1.webp"
              alt="Pecos Solutions Screenshot"
              title="Pecos Solutions Screenshot"
              class="mini-card-shot"
              loading="lazy"
            />
            <h3>Pecos Solutions</h3>
            <p>
              A full-stack platform to preview and download county records,
              with authentication, an admin dashboard, and dynamic routing.
            </p>
            <ul class="tech-badges">
              <li class="tech-badge">React</li>
              <li class="tech-badge">Styled Components</li>
              <li class="tech-badge">Material UI</li>
              <li class="tech-badge">AWS</li>
            </ul>
            <div class="links">
              <a
                href="https://pecos-solutions.com"
                target="_blank"
                rel="noopener noreferrer"
                title="Site: https://pecos-solutions.com"
                class="icon-button"
              >
                <svg class="icon small site-icon">
                  <path
                    d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2v7zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3h-7z"
                  />
                </svg>
              </a>
            </div>
          </div>
          <div class="mini-card" id="proj-internalize">
            <img
              src="./assets/shots/internalize1.webp"
              alt="Internalize Screenshot"
              title="Internalize Screenshot"
              class="mini-card-shot"
              loading="lazy"
            />
            <h3>Internalize</h3>
            <p>
              An app that helps you memorize passages with fill-in-the-blank
              exercises — built first in Flutter, then rebuilt natively in
              Jetpack Compose.
            </p>
            <ul class="tech-badges">
              <li class="tech-badge">Kotlin</li>
              <li class="tech-badge">Jetpack Compose</li>
              <li class="tech-badge">Flutter</li>
            </ul>
            <div class="links">
              <a
                href="https://github.com/brighamandersen/internalize/releases"
                target="_blank"
                rel="noopener noreferrer"
                title="Download App: https://github.com/brighamandersen/internalize/releases"
                class="icon-button"
              >
                <svg class="icon small site-icon">
                  <path
                    d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2v7zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3h-7z"
                  />
                </svg>
              </a>
              <a
                href="https://github.com/brighamandersen/internalize"
                target="_blank"
                rel="noopener noreferrer"
                title="Source Code: https://github.com/brighamandersen/internalize"
                class="icon-button"
              >
                <svg class="icon small github-icon" viewBox="0 0 24 24">
                  <path
                    d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"
                  />
                </svg>
              </a>
            </div>
          </div>
          <div class="mini-card" id="proj-tweeter">
            <img
              src="./assets/shots/tweeter1.webp"
              alt="Tweeter Screenshot"
              title="Tweeter Screenshot"
              class="mini-card-shot"
              loading="lazy"
            />
            <h3>Tweeter</h3>
            <p>
              A Twitter clone with an Android front-end and a Java/AWS
              serverless back-end, built for BYU's Software Design Patterns
              class.
            </p>
            <ul class="tech-badges">
              <li class="tech-badge">Android</li>
              <li class="tech-badge">Java</li>
              <li class="tech-badge">AWS Lambda</li>
              <li class="tech-badge">DynamoDB</li>
            </ul>
            <div class="links">
              <a
                href="https://github.com/brighamandersen/cs340/tree/main/tweeter"
                target="_blank"
                rel="noopener noreferrer"
                title="Source Code: https://github.com/brighamandersen/cs340/tree/main/tweeter"
                class="icon-button"
              >
                <svg class="icon small github-icon" viewBox="0 0 24 24">
                  <path
                    d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"
                  />
                </svg>
              </a>
            </div>
          </div>
          <div class="mini-card" id="proj-tutorials">
            <img
              src="./assets/shots/tutorials1.webp"
              alt="Tutorials Screenshot"
              title="Tutorials Screenshot"
              class="mini-card-shot"
              loading="lazy"
            />
            <h3>Tutorials</h3>
            <p>
              Coding tutorials and mentorship — from teaching HTML/CSS to
              refugee students to helping college students master
              JavaScript.
            </p>
            <div class="links">
              <a
                href="https://www.youtube.com/channel/UC5h98VfEfhqHkSMlt4ejCeg"
                target="_blank"
                rel="noopener noreferrer"
                title="Site: https://www.youtube.com/channel/UC5h98VfEfhqHkSMlt4ejCeg"
                class="icon-button"
              >
                <svg class="icon small site-icon">
                  <path
                    d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2v7zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3h-7z"
                  />
                </svg>
              </a>
              <a
                href="https://github.com/brighamandersen/tutorials"
                target="_blank"
                rel="noopener noreferrer"
                title="Source Code: https://github.com/brighamandersen/tutorials"
                class="icon-button"
              >
                <svg class="icon small github-icon" viewBox="0 0 24 24">
                  <path
                    d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"
                  />
                </svg>
              </a>
            </div>
          </div>
          <div class="mini-card" id="proj-jolt">
            <img
              src="./assets/shots/jolt1.webp"
              alt="Jolt Screenshot"
              title="Jolt Screenshot"
              class="mini-card-shot"
              loading="lazy"
            />
            <h3>Jolt</h3>
            <p>
              A React Native app used by Chick-fil-A and McDonald's locations
              for timeclocking, food safety checks, and label printing.
            </p>
            <ul class="tech-badges">
              <li class="tech-badge">React Native</li>
            </ul>
            <div class="links">
              <a
                href="https://drive.google.com/file/d/1EQidafXhRUGh56CLcJoGEhrAPRzUSGQC/view?usp=sharing"
                target="_blank"
                rel="noopener noreferrer"
                title="Site: https://drive.google.com/file/d/1EQidafXhRUGh56CLcJoGEhrAPRzUSGQC/view?usp=sharing"
                class="icon-button"
              >
                <svg class="icon small site-icon">
                  <path
                    d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2v7zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3h-7z"
                  />
                </svg>
              </a>
            </div>
          </div>
          <div class="mini-card" id="proj-irecognize">
            <img
              src="./assets/shots/irecognize1.webp"
              alt="iRecognize Screenshot"
              title="iRecognize Screenshot"
              class="mini-card-shot"
              loading="lazy"
            />
            <h3>iRecognize</h3>
            <p>
              A Flutter app concept that uses GPS to help you put names to
              faces of people nearby, built for a UI/UX design class.
            </p>
            <ul class="tech-badges">
              <li class="tech-badge">Flutter</li>
              <li class="tech-badge">Figma</li>
            </ul>
            <div class="links">
              <a
                href="https://drive.google.com/file/d/1xsEqwsDENCCvsRq3Uq4T6nzvK1ElvdfV/view?usp=sharing"
                target="_blank"
                rel="noopener noreferrer"
                title="Site: https://drive.google.com/file/d/1xsEqwsDENCCvsRq3Uq4T6nzvK1ElvdfV/view?usp=sharing"
                class="icon-button"
              >
                <svg class="icon small site-icon">
                  <path
                    d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2v7zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3h-7z"
                  />
                </svg>
              </a>
              <a
                href="https://github.com/brighamandersen/irecognize"
                target="_blank"
                rel="noopener noreferrer"
                title="Source Code: https://github.com/brighamandersen/irecognize"
                class="icon-button"
              >
                <svg class="icon small github-icon" viewBox="0 0 24 24">
                  <path
                    d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"
                  />
                </svg>
              </a>
            </div>
          </div>
          <div class="mini-card" id="proj-instructme">
            <img
              src="./assets/shots/instructme1.webp"
              alt="Instruct.Me Screenshot"
              title="Instruct.Me Screenshot"
              class="mini-card-shot"
              loading="lazy"
            />
            <h3>Instruct.me</h3>
            <p>
              High-fidelity interactive Figma prototypes designed from the
              ground up for the Instruct.me startup.
            </p>
            <ul class="tech-badges">
              <li class="tech-badge">Figma</li>
            </ul>
            <div class="links">
              <a
                href="https://drive.google.com/file/d/1iHpmR9OCVDQchdy5udaxo5SbWqCKYL3V/view?usp=sharing"
                target="_blank"
                rel="noopener noreferrer"
                title="Site: https://drive.google.com/file/d/1iHpmR9OCVDQchdy5udaxo5SbWqCKYL3V/view?usp=sharing"
                class="icon-button"
              >
                <svg class="icon small site-icon">
                  <path
                    d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2v7zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3h-7z"
                  />
                </svg>
              </a>
              <a
                href="https://github.com/brighamandersen/instructme"
                target="_blank"
                rel="noopener noreferrer"
                title="Source Code: https://github.com/brighamandersen/instructme"
                class="icon-button"
              >
                <svg class="icon small github-icon" viewBox="0 0 24 24">
                  <path
                    d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"
                  />
                </svg>
              </a>
            </div>
          </div>
          <div class="mini-card" id="proj-melting-pot">
            <img
              src="./assets/shots/melting-pot1.webp"
              alt="Melting Pot Screenshot"
              title="Melting Pot Screenshot"
              class="mini-card-shot"
              loading="lazy"
            />
            <h3>Melting Pot</h3>
            <p>
              A Figma prototype exploring facial-recognition-based ancestry
              identification for South Africa's Coloured community.
            </p>
            <ul class="tech-badges">
              <li class="tech-badge">Figma</li>
            </ul>
            <div class="links">
              <a
                href="https://www.figma.com/proto/OpqKlkSOyQ4QgO900BjQyb/Melting-Pot?node-id=3%3A53"
                target="_blank"
                rel="noopener noreferrer"
                title="Site: https://www.figma.com/proto/OpqKlkSOyQ4QgO900BjQyb/Melting-Pot?node-id=3%3A53"
                class="icon-button"
              >
                <svg class="icon small site-icon">
                  <path
                    d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2v7zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3h-7z"
                  />
                </svg>
              </a>
              <a
                href="https://github.com/brighamandersen/melting-pot"
                target="_blank"
                rel="noopener noreferrer"
                title="Source Code: https://github.com/brighamandersen/melting-pot"
                class="icon-button"
              >
                <svg class="icon small github-icon" viewBox="0 0 24 24">
                  <path
                    d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"
                  />
                </svg>
              </a>
            </div>
          </div>
          <div class="mini-card" id="proj-venmo-tithing">
            <img
              src="./assets/shots/venmo-tithing1.webp"
              alt="Venmo Tithing Calculator Screenshot"
              title="Venmo Tithing Calculator Screenshot"
              class="mini-card-shot"
              loading="lazy"
            />
            <h3>Venmo Tithing Calculator</h3>
            <p>
              Automatically calculates tithing owed based on your Venmo
              income history.
            </p>
            <ul class="tech-badges">
              <li class="tech-badge">Flask</li>
              <li class="tech-badge">Python</li>
            </ul>
            <div class="links">
              <a
                href="https://venmo-tithing.brighamandersen.com"
                target="_blank"
                rel="noopener noreferrer"
                title="Site: https://venmo-tithing.brighamandersen.com"
                class="icon-button"
              >
                <svg class="icon small site-icon">
                  <path
                    d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2v7zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3h-7z"
                  />
                </svg>
              </a>
              <a
                href="https://github.com/brighamandersen/venmo-tithing"
                target="_blank"
                rel="noopener noreferrer"
                title="Source Code: https://github.com/brighamandersen/venmo-tithing"
                class="icon-button"
              >
                <svg class="icon small github-icon" viewBox="0 0 24 24">
                  <path
                    d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"
                  />
                </svg>
              </a>
            </div>
          </div>
          <div class="mini-card" id="proj-vbb-portal">
            <img
              src="./assets/shots/vbb-portal1.webp"
              alt="VBB Mentoring Portal Screenshot"
              title="VBB Mentoring Portal Screenshot"
              class="mini-card-shot"
              loading="lazy"
            />
            <h3>VBB Mentoring Portal</h3>
            <p>
              A recreation of an international mentoring booking portal used
              by organizations like Nike and Oracle — React front-end,
              Django back-end originally.
            </p>
            <ul class="tech-badges">
              <li class="tech-badge">React</li>
              <li class="tech-badge">Django</li>
            </ul>
            <div class="links">
              <a
                href="https://vbb.brighamandersen.com"
                target="_blank"
                rel="noopener noreferrer"
                title="Site: https://vbb.brighamandersen.com"
                class="icon-button"
              >
                <svg class="icon small site-icon">
                  <path
                    d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2v7zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3h-7z"
                  />
                </svg>
              </a>
              <a
                href="https://github.com/brighamandersen/vbb-portal"
                target="_blank"
                rel="noopener noreferrer"
                title="Source Code: https://github.com/brighamandersen/vbb-portal"
                class="icon-button"
              >
                <svg class="icon small github-icon" viewBox="0 0 24 24">
                  <path
                    d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"
                  />
                </svg>
              </a>
            </div>
          </div>
          <div class="mini-card" id="proj-adobe">
            <img
              src="./assets/shots/adobe1.webp"
              alt="Adobe Screenshot"
              title="Adobe Screenshot"
              class="mini-card-shot"
              loading="lazy"
            />
            <h3>Adobe</h3>
            <p>
              BYU Senior Capstone team project enhancing Adobe Analytics'
              React front-end for building visualizations.
            </p>
            <ul class="tech-badges">
              <li class="tech-badge">React</li>
            </ul>
            <div class="links">
              <a
                href="https://experience.adobe.com/#/@aauniversity/so:adobea8cf/analytics"
                target="_blank"
                rel="noopener noreferrer"
                title="Site: https://experience.adobe.com/#/@aauniversity/so:adobea8cf/analytics"
                class="icon-button"
              >
                <svg class="icon small site-icon">
                  <path
                    d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2v7zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3h-7z"
                  />
                </svg>
              </a>
            </div>
          </div>
        </div>
      </section>
```

- [ ] **Step 4: Run the check to confirm it passes**

```bash
cd /Users/brig/dev/portfolio
grep -c 'additional-projects-section' index.html   # expect 1
grep -c 'class="mini-card"' index.html             # expect 12
```

- [ ] **Step 5: Visually confirm in a browser**

```bash
cd /Users/brig/dev/portfolio && python3 -m http.server 8080
```

Open `http://localhost:8080/`. Confirm the Additional Projects grid renders below Featured Projects with 12 cards, 3 columns wide on desktop. Resize the browser below 960px and below 600px to confirm the grid drops to 2 then 1 column. Stop the server when done.

- [ ] **Step 6: Commit**

```bash
git add index.html
git commit -m "$(cat <<'EOF'
Add Additional Projects grid to homepage

12 lighter-weight cards (thumbnail, one sentence, tech badges, links)
covering every remaining project that already has a screenshot asset,
placed below Featured Projects on the homepage.

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
EOF
)"
```

---

## Task 9: Homepage Contact Section

**Files:**
- Modify: `index.html` (append new section after the existing `latest-content-section`, before the closing `</main>`)

**Interfaces:**
- Consumes: `.contact-item` (from Task 1)

- [ ] **Step 1: Write a verification check for the "before" state**

```bash
cd /Users/brig/dev/portfolio
grep -c 'class="contact-section"' index.html   # expect 0
```

- [ ] **Step 2: Run the check to confirm it fails**

Expected: `0`.

- [ ] **Step 3: Insert the Contact section**

In `index.html`, find the end of the Latest Content section and the start of `</main>`:

```html
      </section>
    </main>
```

Replace it with (this closes Latest Content, then adds the new Contact section, reusing `contact.html`'s existing markup and wording exactly):

```html
      </section>
      <section class="contact-section">
        <h2>Contact</h2>

        <div class="contact-item">
          <svg class="icon small contact-icon email-icon" viewBox="0 0 24 24">
            <path
              d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 14H4V8l8 5 8-5v10zm-8-7L4 6h16l-8 5z"
            />
          </svg>
          <a
            href="mailto:brighambandersen@gmail.com"
            aria-label="Email brighambandersen@gmail.com"
            >brighambandersen@gmail.com</a
          >
        </div>

        <div class="contact-item">
          <svg class="icon small contact-icon phone-icon" viewBox="0 0 24 24">
            <path
              d="M20.01 15.38c-1.23 0-2.42-.2-3.53-.56-.35-.12-.74-.03-1.01.24l-1.57 1.97c-2.83-1.35-5.48-3.9-6.89-6.83l1.95-1.66c.27-.28.35-.67.24-1.02-.37-1.11-.56-2.3-.56-3.53 0-.54-.45-.99-.99-.99H4.19C3.65 3 3 3.24 3 3.99 3 13.28 10.73 21 20.01 21c.71 0 .99-.63.99-1.18v-3.45c0-.54-.45-.99-.99-.99z"
            />
          </svg>
          <a href="tel:3854998277" aria-label="Call 385-499-8277"
            >385-499-8277</a
          >
        </div>

        <div class="contact-item">
          <svg
            class="icon small contact-icon linkedin-icon"
            viewBox="0 0 448 512"
          >
            <path
              d="M416 32H31.9C14.3 32 0 46.5 0 64.3v383.4C0 465.5 14.3 480 31.9 480H416c17.6 0 32-14.5 32-32.3V64.3c0-17.8-14.4-32.3-32-32.3zM135.4 416H69V202.2h66.5V416zm-33.2-243c-21.3 0-38.5-17.3-38.5-38.5S80.9 96 102.2 96c21.2 0 38.5 17.3 38.5 38.5 0 21.3-17.2 38.5-38.5 38.5zm282.1 243h-66.4V312c0-24.8-.5-56.7-34.5-56.7-34.6 0-39.9 27-39.9 54.9V416h-66.4V202.2h63.7v29.2h.9c8.9-16.8 30.6-34.5 62.9-34.5 67.2 0 79.7 44.3 79.7 101.9V416z"
            />
          </svg>
          <a
            href="https://linkedin.com/in/brighamandersen"
            target="_blank"
            rel="noopener noreferrer"
            aria-label="Visit LinkedIn profile"
            >linkedin.com/in/brighamandersen</a
          >
        </div>

        <div class="contact-item">
          <svg class="icon small contact-icon github-icon" viewBox="0 0 24 24">
            <path
              d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"
            />
          </svg>
          <a
            href="https://github.com/brighamandersen"
            target="_blank"
            rel="noopener noreferrer"
            aria-label="Visit GitHub profile"
            >github.com/brighamandersen</a
          >
        </div>
      </section>
    </main>
```

- [ ] **Step 4: Run the check to confirm it passes**

```bash
cd /Users/brig/dev/portfolio
grep -c 'class="contact-section"' index.html   # expect 1
grep -c 'mailto:brighambandersen@gmail.com' index.html   # expect 1
```

- [ ] **Step 5: Visually confirm in a browser**

Confirm the Contact section renders at the bottom of the homepage (after Latest Content, before the corner logos), with the same 4 rows (email, phone, LinkedIn, GitHub) as `contact.html`, each with working hover highlight and correct `href`.

- [ ] **Step 6: Commit**

```bash
git add index.html
git commit -m "$(cat <<'EOF'
Add Contact section to bottom of homepage

Reuses contact.html's existing markup and wording so the homepage
flow ends in a clear way to get in touch, without requiring a click
to a separate page.

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
EOF
)"
```

---

## Task 10: Full Homepage Verification

**Files:**
- None (verification only)

**Interfaces:**
- Consumes: the complete `index.html` produced by Tasks 2-9

- [ ] **Step 1: Verify full section order via grep line numbers**

```bash
cd /Users/brig/dev/portfolio
grep -n 'class="welcome-section"\|class="featured-projects-section"\|class="additional-projects-section"\|class="latest-content-section"\|class="contact-section"' index.html
```

Expected: five lines, in this order top to bottom: `welcome-section`, `featured-projects-section`, `additional-projects-section`, `latest-content-section`, `contact-section`.

- [ ] **Step 2: Verify featured and additional project counts**

```bash
cd /Users/brig/dev/portfolio
grep -c 'id="featured-' index.html      # expect 5
grep -c 'class="mini-card"' index.html  # expect 12
grep -c '<details class="learn-more">' index.html   # expect 5 (only featured cards have expanders)
```

- [ ] **Step 3: Validate HTML structure**

```bash
cd /Users/brig/dev/portfolio
python3 -c "
import xml.etree.ElementTree as ET
import re
with open('index.html') as f:
    content = f.read()
# Quick balanced-tag sanity check on the elements we added
for tag in ['section', 'div', 'details', 'summary']:
    opens = len(re.findall(f'<{tag}[ >]', content))
    closes = len(re.findall(f'</{tag}>', content))
    print(f'{tag}: {opens} open, {closes} close', 'OK' if opens == closes else 'MISMATCH')
"
```

Expected: `OK` for every tag. If any show `MISMATCH`, find the unclosed/extra tag before continuing.

- [ ] **Step 4: Full visual walkthrough in a browser**

```bash
cd /Users/brig/dev/portfolio && python3 -m http.server 8080
```

Open `http://localhost:8080/` and check, in order:
1. Hero renders with tightened copy and all 4 CTA buttons working
2. Featured Projects: all 5 cards, each Learn More expander opens/closes independently, all links open the correct URL in a new tab
3. Additional Projects: all 12 mini-cards, responsive grid (3/2/1 columns as the window narrows)
4. Latest Content still renders (GitHub/YouTube/LinkedIn icons)
5. New Contact section at the bottom with working mailto/tel/LinkedIn/GitHub links
6. Toggle your OS/browser color scheme between light and dark — confirm every new element (badges, highlights, learn-more, mini-cards, CTAs, contact items) respects the theme with no hardcoded colors
7. Re-check `http://localhost:8080/projects.html` and `http://localhost:8080/contact.html` one more time for regressions from the Task 1 CSS move

Stop the server when done. **This step must be performed manually in a real browser — there is no automated visual test harness in this repo, so this cannot be verified by command output alone.**

- [ ] **Step 5: Confirm no local-only artifacts were introduced**

```bash
cd /Users/brig/dev/portfolio
git status
```

Expected: only the files modified by Tasks 1-9 (`global.css`, `index.html`, `projects.html`, `contact.html`, `assets/shots/portfolio1.webp`) should show as tracked/committed — nothing untracked left over (e.g. no stray `__pycache__` from the Step 3 Python check).

No commit needed for this task — it's verification of work already committed in Tasks 1-9.
