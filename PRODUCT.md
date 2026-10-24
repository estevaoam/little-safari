# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

The product itself is a native macOS app (agent app + Safari web extension). The surfaces Impeccable designs
are its web presence (the GitHub Pages site); the app's SwiftUI setup window follows macOS conventions.

## Stack

Static HTML/CSS/JS with no build step, served by GitHub Pages from the `/docs` folder on `main`
at the default URL `https://estevaoam.github.io/little-safari/`.

## Users

Mac users who used Arc's Little Arc and miss it after moving (back) to Safari. They know the feature by name:
click a link in another app, get a small throwaway window right where they are, promote it to the main browser
only if it's worth keeping. They work across several macOS Spaces and hate being yanked to whichever Space their
browser window lives on.

## Product Purpose

Little Safari brings Little Arc's behavior to Safari. Links opened from other apps land in a small Safari window
on the current Space; an "Open in Safari" button (also ⌘O, ⌘⇧O, toolbar button) moves the page into the main
Safari window. Success: the user forgets it's installed and simply never gets pulled across Spaces again.

## Positioning

It is real Safari, not a separate mini browser: logins, passwords, extensions and Reader mode keep working,
because the little window is a genuine Safari window. A tiny helper app routes links (it registers as the default
browser but renders nothing), and a bundled Safari extension supplies the little-window behavior.
Free and open source (MIT).

## Operating Context

- Install: download a zip from GitHub Releases, move the app to Applications, get past Gatekeeper ("Open Anyway"),
  enable "Allow unsigned extensions" in Safari's Developer settings, enable the extension on all websites,
  make Little Safari the default browser, allow Automation of Safari.
- Daily use: click links in Slack, Mail, Notes, etc. Hold ⌥ to skip the little window.
- Opening animation: a window-shaped card springs out from the click point while Safari's window appears beneath.

## Capabilities and Constraints

- macOS 14 or later, Apple Silicon and Intel.
- Builds are ad-hoc signed (no paid Apple Developer membership). Safari turns "Allow unsigned extensions" off every
  time it quits; links still open in little windows, but the Open in Safari button needs the setting re-enabled.
  The site must state this honestly.
- Cannot float over full-screen apps (macOS won't let one app raise another app's windows); the little window
  takes you out of a full-screen Space.
- Moving a page to the main window reloads it (Safari extensions can't move tabs between windows).
- No App Store distribution.

## Brand Commitments

- Name: "Little Safari". Independent project, not affiliated with Apple or The Browser Company; the site must say so
  and must not use Apple's or Arc's logos.
- Voice: plain, friendly, a little playful; no hype.

## Evidence on Hand

- Repo and releases: https://github.com/estevaoam/little-safari (v0.1.0 released 2026-10-24).
- Extension icon: SF Symbol `macwindow.on.rectangle` rendered to `Extension/Resources/images/`.
- No screenshots, screen recordings, testimonials, user counts or press exist. Do not fabricate any. The site shows
  the feature with a built-in HTML/CSS animated demo instead.
- No app icon yet.

## Product Principles

1. Stay where you are: never move the user to another Space without them asking.
2. It's just Safari: add the smallest layer possible; don't replace the browser.
3. Honest about the rough edges: unsigned-build friction and limits are stated plainly, not hidden.
4. Zero ceremony: one click to keep a page, one keystroke to skip the little window.
