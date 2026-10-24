import AppKit
import SafariServices

enum LinkRouter {
    static let extensionIdentifier = "dev.estevao.LittleSafari.Extension"
    static let safariIdentifier = "com.apple.Safari"
    /// The extension recognizes this host, marks the window as "little" and redirects to `u`.
    static let markerPrefix = "https://little-safari.invalid/?u="

    static var safariURL: URL? {
        NSWorkspace.shared.urlForApplication(withBundleIdentifier: safariIdentifier)
    }

    static func route(_ url: URL, skipLittleWindow: Bool) {
        let isWeb = url.scheme == "http" || url.scheme == "https"
        if !isWeb || skipLittleWindow {
            openInSafari(url)
            return
        }
        SFSafariExtensionManager.getStateOfSafariExtension(withIdentifier: extensionIdentifier) { state, _ in
            let extensionEnabled = state?.isEnabled ?? false
            DispatchQueue.main.async {
                openLittleWindow(url, viaExtension: extensionEnabled)
            }
        }
    }

    /// Hands the URL to Safari the regular way (new tab in its frontmost window).
    static func openInSafari(_ url: URL) {
        guard let safari = safariURL else {
            NSLog("Little Safari: Safari not found")
            return
        }
        NSWorkspace.shared.open([url], withApplicationAt: safari, configuration: NSWorkspace.OpenConfiguration())
    }

    /// Asks Safari for a brand new window. New windows are created on the active Space,
    /// so activating Safari afterwards doesn't jump to another Space.
    static func openLittleWindow(_ url: URL, viaExtension: Bool) {
        var target = url.absoluteString
        if viaExtension,
           let encoded = target.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
            target = markerPrefix + encoded
        }
        let mouse = NSEvent.mouseLocation
        let frame = littleWindowFrame(around: mouse)
        let bounds = appleScriptBounds(for: frame)
        let source = """
        tell application id "\(safariIdentifier)"
            make new document with properties {URL:"\(escapeForAppleScript(target))"}
            set bounds of front window to {\(bounds.left), \(bounds.top), \(bounds.right), \(bounds.bottom)}
            activate
        end tell
        """
        OpenAnimation(frame: frame, from: mouse).play {
            var error: NSDictionary?
            NSAppleScript(source: source)?.executeAndReturnError(&error)
            if let error {
                NSLog("Little Safari: AppleScript failed: \(error)")
                openInSafari(url)
            }
        }
    }

    /// A centered window on the screen under the mouse, in Cocoa screen coordinates.
    static func littleWindowFrame(around mouse: NSPoint) -> NSRect {
        let screen = NSScreen.screens.first { NSMouseInRect(mouse, $0.frame, false) } ?? NSScreen.main ?? NSScreen.screens[0]
        let visible = screen.visibleFrame
        let width = min(1100, visible.width * 0.7)
        let height = min(900, visible.height * 0.85)
        return NSRect(x: visible.midX - width / 2, y: visible.midY - height / 2, width: width, height: height).integral
    }

    /// AppleScript bounds use a top-left origin on the primary screen.
    static func appleScriptBounds(for frame: NSRect) -> (left: Int, top: Int, right: Int, bottom: Int) {
        let primaryHeight = NSScreen.screens[0].frame.height
        let top = primaryHeight - frame.maxY
        return (Int(frame.minX), Int(top), Int(frame.maxX), Int(top + frame.height))
    }

    private static func escapeForAppleScript(_ string: String) -> String {
        string.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\"")
    }
}

