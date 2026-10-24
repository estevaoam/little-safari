// Adds an "Open in Safari" pill (and ⌘O) to pages shown in a little window.
(async () => {
  if (window.top !== window) return;

  let isLittle = false;
  try {
    isLittle = await browser.runtime.sendMessage({ type: "isLittle" });
  } catch {
    return;
  }
  if (!isLittle) return;

  const host = document.createElement("little-safari-pill");
  const shadow = host.attachShadow({ mode: "closed" });
  shadow.innerHTML = `
    <style>
      :host { all: initial; }
      button {
        position: fixed;
        right: 16px;
        bottom: 16px;
        z-index: 2147483647;
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 8px 12px;
        border: 0.5px solid rgba(0, 0, 0, 0.15);
        border-radius: 999px;
        background: rgba(255, 255, 255, 0.82);
        color: #1d1d1f;
        font: 500 13px/1 -apple-system, BlinkMacSystemFont, sans-serif;
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.18);
        -webkit-backdrop-filter: blur(20px);
        backdrop-filter: blur(20px);
        cursor: pointer;
        opacity: 0.75;
        transition: opacity 0.15s, transform 0.15s;
      }
      button:hover { opacity: 1; transform: translateY(-1px); }
      kbd {
        font: 500 11px/1 -apple-system, BlinkMacSystemFont, sans-serif;
        color: #6e6e73;
      }
      @media (prefers-color-scheme: dark) {
        button {
          background: rgba(40, 40, 42, 0.82);
          color: #f5f5f7;
          border-color: rgba(255, 255, 255, 0.15);
        }
        kbd { color: #a1a1a6; }
      }
    </style>
    <button type="button" title="Move this page to your main Safari window">
      Open in Safari ↗ <kbd>⌘O</kbd>
    </button>
  `;

  async function openInMain() {
    const result = await browser.runtime.sendMessage({ type: "openInMain" });
    if (result && !result.moved) host.remove();
  }

  shadow.querySelector("button").addEventListener("click", openInMain);
  document.addEventListener(
    "keydown",
    (event) => {
      if (!host.isConnected) return;
      if (event.metaKey && !event.shiftKey && !event.altKey && !event.ctrlKey && event.key.toLowerCase() === "o") {
        event.preventDefault();
        event.stopPropagation();
        openInMain();
      }
    },
    true
  );

  document.documentElement.appendChild(host);
})();
