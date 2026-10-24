// The Little Safari app opens links as https://little-safari.invalid/?u=<encoded url>
// in a new Safari window. We remember that window as "little" and load the real URL.
const MARKER = "https://little-safari.invalid/";

// Tabs we've already redirected, so onBeforeNavigate and onUpdated don't both act.
const claimedTabs = new Set();

async function getLittleWindows() {
  const { little = [] } = await browser.storage.session.get("little");
  return new Set(little);
}

async function setLittleWindows(set) {
  await browser.storage.session.set({ little: [...set] });
}

function targetFromMarker(url) {
  if (!url || !url.startsWith(MARKER)) return null;
  try {
    const target = new URL(url).searchParams.get("u");
    return target && /^https?:\/\//.test(target) ? target : null;
  } catch {
    return null;
  }
}

async function claim(tabId, url) {
  const target = targetFromMarker(url);
  if (!target || claimedTabs.has(tabId)) return;
  claimedTabs.add(tabId);
  setTimeout(() => claimedTabs.delete(tabId), 5000);

  const tab = await browser.tabs.get(tabId);
  const little = await getLittleWindows();
  little.add(tab.windowId);
  await setLittleWindows(little);
  await browser.tabs.update(tabId, { url: target });
}

browser.webNavigation.onBeforeNavigate.addListener(({ tabId, frameId, url }) => {
  if (frameId === 0) claim(tabId, url);
});

browser.tabs.onUpdated.addListener((tabId, changeInfo) => {
  if (changeInfo.url) claim(tabId, changeInfo.url);
});

// Most recently focused windows first, so "open in main window" picks the one you used last.
browser.windows.onFocusChanged.addListener(async (windowId) => {
  if (windowId === browser.windows.WINDOW_ID_NONE) return;
  const { focusOrder = [] } = await browser.storage.session.get("focusOrder");
  const updated = [windowId, ...focusOrder.filter((id) => id !== windowId)].slice(0, 50);
  await browser.storage.session.set({ focusOrder: updated });
});

browser.windows.onRemoved.addListener(async (windowId) => {
  const little = await getLittleWindows();
  if (little.delete(windowId)) await setLittleWindows(little);
  const { focusOrder = [] } = await browser.storage.session.get("focusOrder");
  await browser.storage.session.set({ focusOrder: focusOrder.filter((id) => id !== windowId) });
});

async function openInMainWindow(tab) {
  const little = await getLittleWindows();
  const { focusOrder = [] } = await browser.storage.session.get("focusOrder");
  const windows = await browser.windows.getAll({ windowTypes: ["normal"] });
  const candidates = windows.filter(
    (w) => w.id !== tab.windowId && !little.has(w.id) && w.incognito === tab.incognito
  );
  const rank = (w) => {
    const index = focusOrder.indexOf(w.id);
    return index === -1 ? Infinity : index;
  };
  candidates.sort((a, b) => rank(a) - rank(b));
  const main = candidates[0];

  if (!main) {
    // No other window: this little window simply becomes a regular one.
    little.delete(tab.windowId);
    await setLittleWindows(little);
    return { moved: false };
  }

  // tabs.move isn't available in Safari, so reopen the page there and close it here.
  await browser.tabs.create({ windowId: main.id, url: tab.url, active: true });
  await browser.windows.update(main.id, { focused: true });
  await browser.tabs.remove(tab.id);
  return { moved: true };
}

// The toolbar button and ⌘⇧O work even where the page button can't appear
// (no website access yet, or pages that block content scripts).
async function openActiveTabInMain() {
  const [tab] = await browser.tabs.query({ active: true, currentWindow: true });
  if (!tab?.url) return;
  if ((await getLittleWindows()).has(tab.windowId)) await openInMainWindow(tab);
}

browser.action.onClicked.addListener(openActiveTabInMain);

browser.commands.onCommand.addListener((command) => {
  if (command === "open-in-main") openActiveTabInMain();
});

browser.runtime.onMessage.addListener(async (message, sender) => {
  if (!sender.tab) return;
  switch (message?.type) {
    case "isLittle":
      return (await getLittleWindows()).has(sender.tab.windowId);
    case "openInMain":
      return openInMainWindow(sender.tab);
  }
});
