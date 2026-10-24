# Little Safari

A Little Arc–style mini window for Safari.

Click a link in Slack, Mail, Notes or any other app, and it opens in a small Safari window on the Space you're
on, instead of pulling you over to whichever Space your main Safari window lives in. If you want to keep
the page, send it to your main Safari window with one click.

- **Opens on your current Space**, centered on the screen you're using, with a short opening animation.
- **Open in Safari ↗**: a button on the page, the toolbar button, ⌘O or ⌘⇧O moves the page to the Safari
  window you used last.
- **Hold ⌥** while clicking a link to skip the little window.
- **It's still Safari**: your logins, passwords, extensions and Reader mode all work.

Requires macOS 14 or later.

## Install

1. Download `LittleSafari-<version>.zip` from the
   [latest release](https://github.com/estevaoam/little-safari/releases/latest), unzip it, and move
   **Little Safari.app** to your **Applications** folder.
2. Open it. This build isn't signed by Apple, so macOS will block it the first time. Go to
   **System Settings → Privacy & Security**, scroll down, and click **Open Anyway**. Alternatively, run
   `xattr -dr com.apple.quarantine "/Applications/Little Safari.app"` and then open it.
3. In Safari, go to **Settings → Advanced** and turn on **Show features for web developers**.
4. In **Settings → Developer**, turn on **Allow unsigned extensions**.
5. In **Settings → Extensions**, enable **Little Safari** and set it to **Always Allow on Every Website**.
6. Back in the Little Safari window, click **Make Default** and confirm.
7. Click **Try It**. The first time, macOS asks whether Little Safari may control Safari. Click **Allow**.

> **Note:** Safari turns **Allow unsigned extensions** off every time it quits. Links still open in the
> little window when it's off, but you won't get the Open in Safari button until you turn it back on.
> This goes away only with a build signed through Apple's paid developer program.

Open Little Safari from your Applications folder at any time to see its setup window again.

**Uninstall:** click **Restore Safari as Default** in the setup window, or choose Safari under
System Settings → Desktop & Dock → Default web browser. Then delete the app.

## How it works

macOS sends links from other apps only to the default browser. So Little Safari is a small app that
registers as the default browser but never shows pages itself:

1. When a link arrives, the app asks Safari (via AppleScript) for a new, small window. Safari creates new
   windows on the active Space, so you stay where you are.
2. The app opens `https://little-safari.invalid/?u=<url>`. The bundled Safari extension uses that address
   to recognize the window as "little", then loads the real page.
3. In little windows, the extension adds the **Open in Safari ↗** button. It reopens the page in your most
   recently used Safari window and closes the little one.

The opening animation is drawn by the app over the spot where Safari's window appears, because one app
can't animate another app's windows.

## Build from source

You only need the Xcode Command Line Tools (`xcode-select --install`). Xcode itself is not required.

```sh
scripts/build.sh            # builds build/Little Safari.app (Apple Silicon + Intel)
scripts/build.sh --install  # also copies it to ~/Applications and launches it
scripts/release.sh          # builds and zips it for a release
```

Pushing a `v*` tag runs the GitHub Action that builds the zip and publishes the release.

The extension's toolbar icons are generated with `swift scripts/make-icons.swift Extension/Resources/images`.

## License

[MIT](LICENSE)
