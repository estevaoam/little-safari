import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var receivedURL = false
    private var setupWindow: SetupWindowController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // When macOS launches us to handle a link, the URL arrives right after launch.
        // Only show the setup window when the user opened the app directly.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            guard let self, !self.receivedURL else { return }
            self.showSetup()
        }
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        showSetup()
        return true
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        receivedURL = true
        let skipLittleWindow = NSEvent.modifierFlags.contains(.option)
        for url in urls {
            LinkRouter.route(url, skipLittleWindow: skipLittleWindow)
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }

    private func showSetup() {
        if setupWindow == nil {
            setupWindow = SetupWindowController()
        }
        setupWindow?.show()
    }
}
