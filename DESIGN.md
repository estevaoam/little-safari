---
name: Little Safari
description: Little Arc, for Safari. A pop-up book whose little window stands up off the page.
colors:
  coral: "#e7563a"
  coral-deep: "#c9432a"
  coral-ink: "#3a1209"
  card: "#fffdf9"
  card-shade: "#f1ebe2"
  fold: "#e4dbcd"
  ink: "#1d1b19"
  ink-2: "#5a524a"
  blue: "#1f6feb"
  blue-press: "#1858c4"
  note: "#ffe48f"
  white: "#ffffff"
typography:
  display:
    fontFamily: "ui-rounded, SF Pro Rounded, Nunito Var, system-ui, sans-serif"
    fontSize: "clamp(3.1rem, 8.6vw, 6rem)"
    fontWeight: 800
    lineHeight: 0.95
    letterSpacing: "-0.035em"
  headline:
    fontFamily: "ui-rounded, SF Pro Rounded, Nunito Var, system-ui, sans-serif"
    fontSize: "clamp(2.1rem, 3.6vw, 3.1rem)"
    fontWeight: 800
    lineHeight: 1.02
    letterSpacing: "-0.03em"
  title:
    fontFamily: "ui-rounded, SF Pro Rounded, Nunito Var, system-ui, sans-serif"
    fontSize: "clamp(1.35rem, 2.1vw, 1.7rem)"
    fontWeight: 600
    lineHeight: 1.3
    letterSpacing: "-0.01em"
  body:
    fontFamily: "-apple-system, BlinkMacSystemFont, Nunito Var, system-ui, sans-serif"
    fontSize: "1.125rem"
    fontWeight: 400
    lineHeight: 1.55
  body-small:
    fontFamily: "-apple-system, BlinkMacSystemFont, Nunito Var, system-ui, sans-serif"
    fontSize: "0.9375rem"
    fontWeight: 400
    lineHeight: 1.45
  label:
    fontFamily: "ui-rounded, SF Pro Rounded, Nunito Var, system-ui, sans-serif"
    fontSize: "1.0625rem"
    fontWeight: 800
    lineHeight: 1
rounded:
  xs: "4px"
  sm: "6px"
  md: "8px"
  page: "12px"
  pill: "999px"
spacing:
  page-pad: "clamp(24px, 4.2vw, 60px)"
  gap-sm: "12px"
  gap-md: "18px"
  chapter: "clamp(56px, 9vw, 120px)"
components:
  button-ink:
    backgroundColor: "{colors.ink}"
    textColor: "{colors.white}"
    typography: "{typography.label}"
    rounded: "{rounded.pill}"
    padding: "14px 22px"
  button-ink-hover:
    backgroundColor: "#000000"
    textColor: "{colors.white}"
  button-quiet:
    backgroundColor: "transparent"
    textColor: "{colors.ink}"
    typography: "{typography.label}"
    rounded: "{rounded.pill}"
    padding: "14px 22px"
  button-quiet-hover:
    backgroundColor: "{colors.card-shade}"
  replay-pill:
    backgroundColor: "{colors.card-shade}"
    textColor: "{colors.ink}"
    rounded: "{rounded.pill}"
    padding: "8px 14px"
  replay-pill-hover:
    backgroundColor: "{colors.fold}"
  toast:
    backgroundColor: "{colors.ink}"
    textColor: "{colors.white}"
    rounded: "{rounded.pill}"
    padding: "8px 12px"
  spread:
    backgroundColor: "{colors.card}"
    rounded: "{rounded.page}"
    padding: "{spacing.page-pad}"
  flap-front:
    backgroundColor: "{colors.card}"
    textColor: "{colors.ink}"
    rounded: "{rounded.md}"
  sticky-note:
    backgroundColor: "{colors.note}"
    textColor: "#3b3112"
    rounded: "{rounded.xs}"
    padding: "18px 22px"
---

# Design System: Little Safari

## Overview

**Creative North Star: "The Pop-Up Book"**

The whole site is one pop-up book. A drenched coral cover board is the ground. Every chapter is an open two-page spread of warm white card stock lying on it, with a gutter fold down the middle and a stack of pages showing underneath. Demos are pasted onto the pages as little Mac screens, and the little Safari window stands up off them on a crease and two glue tabs, the same spring the app performs. Controls are paper mechanics: lift-flaps hinged at the top, check boxes you tick, a sticky note slapped on at an angle.

Density is relaxed and bookish: one idea per spread, a heading and a short paragraph on the left page, the thing that moves on the right. The signature is demonstration rather than claims. The hero plays the whole flow once on load (click a link, the window pops up, send it to Safari), with numbered steps lighting up under it. The Spaces chapter runs a side-by-side Without/With comparison when it scrolls into view. Depth is physical, made with warm-tinted cast shadows and fold shading, never glow or glass. Motion follows one grammar: things hinge on a scored edge and spring past their rest angle before settling. The single sanctioned slide is the macOS Space switch.

**Key Characteristics:**
- Coral cover board as the page ground; white card-stock spreads carry all content.
- Two-page spreads with a shaded gutter; they collapse to a single page under 820px.
- Rounded display type (SF Rounded, Nunito fallback) at weight 800 with tight tracking, over SF body text.
- Demos are pasted mini Mac screens that autoplay once and offer a quiet Play again pill.
- Shadows on paper are tinted with the coral's own brown (rgb 72 26 12), never neutral grey.
- Hinge-and-spring motion with an overshoot; reduced motion collapses it to an instant change.

## Colors

A drenched warm palette: one loud coral board, warm off-white paper, a warm near-black ink, and one cool blue kept for links.

### Primary
- **Cover Board Coral** (#e7563a): the page background for the cover, the gaps between spreads and the back cover. On paper it marks state: checked install boxes, the active demo step's numeral disc, and the ring that flashes on the Safari window in the Without comparison. Also the favicon ground. It is the ground, not a decorative accent.
- **Deep Coral** (#c9432a): coral that has to read as text on paper: emphasis inside the lede, install step numerals, fine-print list markers, and the "With Little Safari" comparison label. Also the scrollbar thumb.
- **Coral Ink** (#3a1209): small text set directly on the coral board (the colophon and its links).

### Secondary
- **Safari Blue** (#1f6feb): text links, the link being clicked inside demos, and the focus ring on paper. Hovered links go to **Blue Press** (#1858c4).

### Tertiary
- **Sticky-Note Yellow** (#ffe48f): the one sticky note that carries a caveat. Its text is a dark olive (#3b3112).

### Neutral
- **Card Stock** (#fffdf9): every page and every flap front.
- **Card Shade** (#f1ebe2): the recessed paper under flaps, the page directly beneath the spread, glue tabs, inactive demo-step discs, the Play again pill and the quiet button's hover.
- **Fold** (#e4dbcd): the deepest page in the stack, and the Play again pill on hover.
- **Ink** (#1d1b19): body text, headings on paper, nav on the coral, the download button, the demo toast, the active page dot.
- **Ink Soft** (#5a524a): secondary text, captions, meta lines, Space names, the "Without Little Safari" label, struck-off install steps.
- **White** (#ffffff): the display headline on the coral, text on ink, and the surfaces of the faux macOS windows.

Demo desktops use their own pale tints (the hero screen #dfe6ec, Space backgrounds #dbe5ef / #e6e0ef / #dfece3, a chat sidebar #33404b). They depict macOS scenery and are not palette tokens.

### Named Rules
**The Blue Is a Link Rule.** Safari Blue only marks text you can follow (or the link being clicked in a demo) and the focus ring on paper. Buttons, including both Download for Mac buttons, are Ink. A blue button is drift.

**The Board Is Not Paper Rule.** Content lives on Card Stock. The only things set straight on the coral board are the nav, the white display headline and the colophon.

**The Warm Shadow Rule.** Every shadow on paper uses the coral-brown tint (rgb 72 26 12) at varying alpha. Neutral black shadows belong only inside the faux macOS scenery (app windows, the pill, the cursor), because they copy the real OS.

## Typography

**Display Font:** ui-rounded / SF Pro Rounded (with self-hosted Nunito variable, then system-ui)
**Body Font:** -apple-system / SF Pro (with Nunito variable, then system-ui)

**Character:** A soft, rounded heavy display next to plain SF body text. It reads as friendly and Mac-native without copying an Apple page.

### Hierarchy
- **Display** (800, clamp(3.1rem, 8.6vw, 6rem), 0.95, -0.035em): the single headline in white across the coral cover.
- **Headline** (800, clamp(2.1rem, 3.6vw, 3.1rem), 1.02, -0.03em): one chapter heading per spread, top of the left page. A closing call (800, clamp(2.3rem, 4.4vw, 3.5rem), 1) uses the same voice a step larger.
- **Title** (600 rounded, clamp(1.35rem, 2.1vw, 1.7rem), 1.3): the hero lede; its emphasis goes to 900 in Deep Coral.
- **Body** (400, 1.125rem, 1.55): paragraphs, capped at 62ch.
- **Body small** (400, 0.9375rem, 1.45): flap backs, meta lines, comparison captions.
- **Label** (800 rounded, 1.0625rem, 1): buttons. The rest of the rounded small type sits between 0.75rem and 1.25rem at 700 to 800: demo steps (700, 1rem), comparison labels (800, 0.9375rem), the Play again pill (700, 0.9375rem), flap fronts (800, 1.25rem), the toast and Space names (700, 0.75rem).

### Named Rules
**The Rounded Voice Rule.** Everything that is a heading, a button, a label or a paper mechanism is set in the rounded display face at 700 to 900. Running text is never rounded.

**The White Is Big Rule.** White text on coral is about 3.3:1, so it is used only at display size. Anything smaller on coral is Ink or Coral Ink.

## Layout

The page is a single column of books, max 1180px, centered with 16px side gutters on the coral. Each chapter is one spread: a two-column grid of equal pages with page padding clamp(24px, 4.2vw, 60px), and spacing between chapters of clamp(56px, 9vw, 120px). The left page holds the heading, the prose and (for demos) a Play again pill. The right page holds the moving object: the hero screen with its step list, the stacked Without/With comparison (26px apart), the flaps, the install checklist, or the closing pop-up. Install and the fine print are full two-page spreads like the rest. The coral back cover below the last spread holds only the colophon, centered at 64ch.

Under 820px a spread becomes one page (left page first) and the gutter shading disappears. The hero screen gets taller (4:3.6) and the popped window wider. Under 480px the flaps stack to one column and the demo chat app drops its sidebar.

## Elevation & Depth

Depth is physical paper. Card stock lies on the board with a soft cast shadow; pages stack under the spread with small offsets; the gutter is shaded with a horizontal gradient that darkens toward the fold and catches a highlight just past it. Pasted screens and viewports sit on the page with a printed-card shadow. Pop-up parts throw a blurred tinted shadow back onto the page. Recessed paper (under the flaps) gets an inset shadow. There is no glass, glow or neutral drop shadow on paper.

### Shadow Vocabulary
- **Spread rest** (`0 1px 1px rgb(72 26 12 / 0.08), 0 14px 28px -12px rgb(72 26 12 / 0.35)`): the open spread on the board.
- **Page stack** (`0 30px 50px -24px rgb(72 26 12 / 0.55)`): the page beneath the spread, offset 6px; a second page at 12px in Fold.
- **Pasted screen** (`0 1px 1px rgb(72 26 12 / 0.1), 0 8px 16px -10px rgb(72 26 12 / 0.45)`): the hero screen and the comparison viewports. Flap fronts use the same family (0 8px 14px -8px at 0.45).
- **Standing window** (`0 1px 2px rgb(72 26 12 / 0.12), 0 18px 36px -14px rgb(72 26 12 / 0.45)`): the popped-up window, plus a blurred cast plate (rgb 72 26 12 / 0.22, blur 16px) behind it.
- **Ink button** (`0 10px 22px -10px rgb(72 26 12 / 0.8)`): the download button lifting off the paper.
- **Recess** (`inset 0 2px 6px rgb(72 26 12 / 0.12)`): the well a flap lifts out of.

### Named Rules
**The Hinge Rule.** Things that appear rotate on a scored edge. The window pops from rotateX(87deg) through -24deg to rest at rotateX(-10deg) over 1000ms, fading in during the first 12%. It leaves by folding flat to 87deg as it fades out. Flaps open on their top edge to rotateX(-150deg) and lean to -14deg on hover. Small nudges (a 1px button lift, the toast dropping 6px into place) and shadow fades that follow a fold are fine.

**The One Slide Rule.** The only thing that slides is a Space switch, because it copies the macOS gesture: a three-Space track moves sideways over 900ms on cubic-bezier(0.65, 0, 0.35, 1). Nothing else slides in from offscreen.

## Shapes

Paper corners are gently rounded: pages 12px, pasted screens 10px, flaps, viewports and check boxes 8px, faux app windows and mini Safari windows 6px, the sticky note 4px. Anything you press, and any status chip, is a full pill (999px): buttons, Play again, the toast, the Open in Safari pill. Demo step numerals sit in 26px circles. Scored folds are 1.5px dashed lines in a warm grey (#ddd2c3 to #e3d9cb): the crease a window stands on and the hinge line across each flap. Glue tabs are small trapezoids in Card Shade under the standing window.

## Components

### Buttons
Tactile, heavy, rounded.
- **Shape:** full pill (999px), 14px by 22px padding, a 19px stroke icon before the label.
- **Ink (primary):** Ink fill, white rounded label at 800, warm lift shadow. Hover goes to pure black and lifts 1px; active drops 1px. Used for every Download for Mac.
- **Quiet:** transparent with a 1.5px inset ink ring at 22% alpha; hover fills with Card Shade. Used for View on GitHub.
- **Play again:** a smaller Card Shade pill (8px by 14px, rounded 700 at 0.9375rem) with a 16px replay icon; hover deepens to Fold. It replays a demo and never competes with Download.
- **Focus:** a 3px Safari Blue outline 3px off (Ink on the coral board).

### Hero demo (signature)
A mini Mac desktop (#dfe6ec, 16:11, 10px radius) pasted on the right page, with a translucent menubar and a chat app window. On load it plays once: a cursor clicks the blue link, the little Safari window springs up from a crease over the screen, the cursor presses its Open in Safari pill, the window folds flat and fades, and an Ink toast pill ("Sent to your main Safari window") drops in, then everything returns to rest. Under the screen, a three-step numbered list follows along: while the demo plays, the inactive steps dim to 45% and the active step's numeral disc turns from Card Shade to Coral. A Play again pill sits below.

### Space comparison (signature)
Two stacked figures on the right page, labeled in rounded 800: "Without Little Safari" in Ink Soft, "With Little Safari" in Deep Coral. Each is a 16:8 viewport (8px radius, pasted-screen shadow) holding a three-Space track, with 7px page dots under it (the current Space in Ink, the rest #d8cdbd) and a centered Ink Soft caption. Both play together when half the block scrolls into view. Without slides to Space 1 and flashes a 4px Coral ring around the Safari window; With stays on Space 3 and pops a mini Safari window there. The left page carries a Play again pill.

### Pop-up window
A faux Safari window (white, 12px radius, #f4f1ec title bar with traffic lights and a centered URL field) standing on a dashed crease on two glue tabs, carrying the Open in Safari pill. The pill presses to 95% scale. It is the only place macOS chrome is copied, and it never pretends to be a screenshot. A smaller version (6px radius) pops up in the comparison and on the closing page.

### Lift-flaps
A recessed Card Shade well holds the answer text. A Card Stock lid sits over it, hinged at the top with a dashed scored line and a small lip at the bottom edge. The lid opens to -150deg on a 750ms spring, showing its darker underside (#e9e0d3). Keycaps appear on the lid as the label.

### Install checklist
Numbered rows between hairlines (#eee6da), numerals in rounded 800 Deep Coral. 26px check boxes (8px radius, 1.5px warm border) fill Coral with a white check that springs in from 40% scale; checked text drops to Ink Soft.

### Sticky note
Sticky-Note Yellow, 4px radius, rotated -1.2deg, with a warm cast shadow, max 440px. Reserved for one honest caveat per spread.

### Keycaps
Card Stock caps, 6px radius, 1px warm border with a 2.5px bottom edge, SF 600 at 0.85em.

### Navigation
Sits on the coral: the brand mark and rounded 800 wordmark on the left, SF 600 Ink links on the right that underline on hover. Under 820px only the GitHub link stays.

## Do's and Don'ts

### Do:
- **Do** put every block of content on a Card Stock spread with the gutter shading and page stack beneath it.
- **Do** make Download buttons Ink (#1d1b19) pills; keep Safari Blue (#1f6feb) for text links.
- **Do** show the product by playing it in a pasted mini screen, once, with a Play again pill.
- **Do** tint every shadow on paper with rgb(72 26 12).
- **Do** move things on hinges with the spring curve cubic-bezier(0.2, 0.9, 0.25, 1) and a visible overshoot, and collapse it under prefers-reduced-motion.
- **Do** set headings, buttons, labels and paper mechanisms in the rounded face at 700 to 900.
- **Do** use dashed 1.5px warm lines for scores and creases.

### Don't:
- **Don't** color a button blue.
- **Don't** set small text in white on coral; use Ink or Coral Ink.
- **Don't** slide anything in except a Space switch.
- **Don't** use neutral grey or black shadows on paper; they belong only to the copied macOS scenery.
- **Don't** show fake screenshots; demos are built in HTML and CSS and look like paper.
- **Don't** add content to the coral back cover beyond the colophon.
