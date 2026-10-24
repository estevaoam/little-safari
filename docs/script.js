document.documentElement.classList.add("js");
const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
const wait = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

/* Moves a demo cursor (positioned inside `box`) to the middle-left of `target`. */
function cursorTo(cursor, box, target, { instant = false, dx = 0.35, dy = 0.4 } = {}) {
  const b = box.getBoundingClientRect();
  const t = target.getBoundingClientRect();
  const x = t.left - b.left + Math.min(t.width * dx, 80);
  const y = t.top - b.top + t.height * dy;
  if (instant) cursor.style.transition = "none";
  cursor.style.transform = `translate(${x}px, ${y}px)`;
  if (instant) {
    cursor.getBoundingClientRect();
    cursor.style.transition = "";
  }
}

function cursorFromCorner(cursor, box) {
  const b = box.getBoundingClientRect();
  cursor.style.transition = "none";
  cursor.style.transform = `translate(${b.width * 0.92}px, ${b.height * 0.95}px)`;
  cursor.getBoundingClientRect();
  cursor.style.transition = "";
  cursor.classList.add("is-visible");
}

async function press(cursor, target) {
  cursor.classList.add("is-pressing");
  target.classList.add("is-pressed");
  await wait(160);
  cursor.classList.remove("is-pressing");
  target.classList.remove("is-pressed");
}

/* ---------- Hero: click a link, a little window pops up, send it to Safari ---------- */

const demo = document.querySelector("[data-demo]");
const screen = demo.querySelector("[data-screen]");
const popup = demo.querySelector("[data-popup]");
const heroCursor = demo.querySelector("[data-cursor]");
const heroLink = demo.querySelector("[data-link]");
const pill = demo.querySelector("[data-pill]");
const toast = demo.querySelector("[data-toast]");
const steps = [...demo.querySelectorAll("[data-step]")];
let heroPlaying = false;

function setStep(n) {
  steps.forEach((step) => step.classList.toggle("is-active", Number(step.dataset.step) === n));
}

async function playHero() {
  if (heroPlaying) return;
  heroPlaying = true;
  demo.classList.add("is-playing");

  // Start from the chat app alone.
  popup.classList.remove("is-popping");
  popup.classList.add("is-flat");
  toast.classList.remove("is-on");
  setStep(1);
  cursorFromCorner(heroCursor, screen);
  await wait(350);

  // 1. Click the link.
  cursorTo(heroCursor, screen, heroLink);
  await wait(750);
  await press(heroCursor, heroLink);

  // 2. The little window pops up on this screen.
  setStep(2);
  popup.classList.remove("is-flat");
  popup.classList.add("is-popping");
  cursorTo(heroCursor, screen, screen, { dx: 0.5, dy: 0.25 });
  await wait(2000);

  // 3. Click the pill: the page goes to the main Safari window.
  setStep(3);
  cursorTo(heroCursor, screen, pill, { dx: 0.3, dy: 0.5 });
  await wait(800);
  await press(heroCursor, pill);
  popup.classList.remove("is-popping");
  popup.classList.add("is-folding", "is-flat");
  toast.classList.add("is-on");
  await wait(320);
  popup.classList.remove("is-folding");
  await wait(1900);

  // Back to rest.
  toast.classList.remove("is-on");
  heroCursor.classList.remove("is-visible");
  await wait(400);
  popup.classList.remove("is-flat");
  popup.classList.add("is-popping");
  demo.classList.remove("is-playing");
  setStep(0);
  heroPlaying = false;
}

demo.querySelector("[data-replay]").addEventListener("click", playHero);
if (!reduceMotion) window.addEventListener("load", () => setTimeout(playHero, 500));

/* ---------- Spaces: the same click, without and with Little Safari ---------- */

const compares = [...document.querySelectorAll("[data-compare]")];
let comparePlaying = false;

function setSpace(figure, n, instant = false) {
  const track = figure.querySelector("[data-track]");
  track.classList.toggle("is-instant", instant);
  track.style.transform = `translateX(${-(n - 1) * 33.3333}%)`;
  if (instant) {
    track.getBoundingClientRect();
    track.classList.remove("is-instant");
  }
  figure.querySelectorAll(".dots i").forEach((dot, i) => dot.classList.toggle("is-on", i === n - 1));
}

async function playOne(figure) {
  const kind = figure.dataset.compare;
  const viewport = figure.querySelector(".viewport");
  const cursor = figure.querySelector("[data-cursor]");
  const link = figure.querySelector("[data-mini-link]");
  const caption = figure.querySelector("[data-compare-caption]");
  const desk3 = figure.querySelector(".desk-3");

  desk3.classList.remove("is-open");
  setSpace(figure, 3, true);
  caption.textContent = "You’re on Space 3, in Slack.";
  cursorFromCorner(cursor, viewport);
  await wait(300);
  cursorTo(cursor, viewport, link, { dx: 0.4, dy: 0.5 });
  await wait(750);
  await press(cursor, link);
  caption.textContent = "You click a link…";
  await wait(250);

  if (kind === "without") {
    cursor.classList.remove("is-visible");
    setSpace(figure, 1);
    await wait(950);
    figure.querySelector(".big-safari").classList.add("is-new");
    caption.textContent = "…and macOS throws you over to Space 1, where Safari lives. Slack is two Spaces away.";
    await wait(1100);
    figure.querySelector(".big-safari").classList.remove("is-new");
  } else {
    desk3.classList.add("is-open");
    caption.textContent = "…and a little Safari window opens right here. You’re still on Space 3.";
    await wait(600);
    cursor.classList.remove("is-visible");
  }
}

async function playCompare() {
  if (comparePlaying) return;
  comparePlaying = true;
  await Promise.all(compares.map(playOne));
  comparePlaying = false;
}

document.querySelector("[data-compare-replay]").addEventListener("click", playCompare);
if ("IntersectionObserver" in window) {
  new IntersectionObserver((entries, observer) => {
    if (entries.some((entry) => entry.isIntersecting)) {
      observer.disconnect();
      setTimeout(playCompare, 300);
    }
  }, { threshold: 0.5 }).observe(document.querySelector(".compares"));
}

/* ---------- Flaps ---------- */

document.querySelectorAll("[data-flap]").forEach((flap) => {
  flap.addEventListener("click", () => {
    flap.setAttribute("aria-expanded", String(flap.getAttribute("aria-expanded") !== "true"));
  });
});

/* ---------- Install checklist (remembered on this device only) ---------- */

const boxes = [...document.querySelectorAll("[data-steps] input")];
let saved = [];
try {
  saved = JSON.parse(localStorage.getItem("little-safari-steps") || "[]");
} catch {}
boxes.forEach((box, index) => {
  box.checked = Boolean(saved[index]);
  box.addEventListener("change", () => {
    try {
      localStorage.setItem("little-safari-steps", JSON.stringify(boxes.map((b) => b.checked)));
    } catch {}
  });
});

/* ---------- Closing page: one more pop as it comes into view ---------- */

const closePop = document.querySelector("[data-close-pop]");
if ("IntersectionObserver" in window) {
  new IntersectionObserver((entries, observer) => {
    if (entries.some((entry) => entry.isIntersecting)) {
      closePop.classList.add("is-popped");
      observer.disconnect();
    }
  }, { threshold: 0.6 }).observe(closePop.parentElement);
} else {
  closePop.classList.add("is-popped");
}
