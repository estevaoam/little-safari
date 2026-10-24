import AppKit
import SafariServices
import SwiftUI

final class SetupWindowController {
    private let window: NSWindow
    private let model = SetupModel()

    init() {
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 440, height: 400),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = "Little Safari"
        window.isReleasedWhenClosed = false
        window.contentView = NSHostingView(rootView: SetupView(model: model))
        window.center()
    }

    func show() {
        model.refresh()
        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(nil)
    }
}

final class SetupModel: ObservableObject {
    @Published var isDefaultBrowser = false
    @Published var isExtensionEnabled = false

    func refresh() {
        let handler = NSWorkspace.shared.urlForApplication(toOpen: URL(string: "https://example.com")!)
        isDefaultBrowser = handler?.standardizedFileURL == Bundle.main.bundleURL.standardizedFileURL
        SFSafariExtensionManager.getStateOfSafariExtension(withIdentifier: LinkRouter.extensionIdentifier) { state, _ in
            DispatchQueue.main.async { self.isExtensionEnabled = state?.isEnabled ?? false }
        }
    }

    func makeDefaultBrowser() {
        let app = Bundle.main.bundleURL
        // macOS asks the user to confirm each change.
        NSWorkspace.shared.setDefaultApplication(at: app, toOpenURLsWithScheme: "http") { _ in
            NSWorkspace.shared.setDefaultApplication(at: app, toOpenURLsWithScheme: "https") { _ in
                DispatchQueue.main.async { self.refresh() }
            }
        }
    }

    func openExtensionSettings() {
        SFSafariApplication.showPreferencesForExtension(withIdentifier: LinkRouter.extensionIdentifier) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { self.refresh() }
        }
    }

    func restoreSafariAsDefault() {
        guard let safari = LinkRouter.safariURL else { return }
        NSWorkspace.shared.setDefaultApplication(at: safari, toOpenURLsWithScheme: "http") { _ in
            NSWorkspace.shared.setDefaultApplication(at: safari, toOpenURLsWithScheme: "https") { _ in
                DispatchQueue.main.async { self.refresh() }
            }
        }
    }
}

struct SetupView: View {
    @ObservedObject var model: SetupModel

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Links from other apps open in a small Safari window on the Space you're on.")
                .fixedSize(horizontal: false, vertical: true)

            step(
                done: model.isDefaultBrowser,
                title: "Set Little Safari as the default browser",
                detail: "It only routes links. Pages always open in Safari.",
                action: model.isDefaultBrowser ? nil : ("Make Default", model.makeDefaultBrowser)
            )
            step(
                done: model.isExtensionEnabled,
                title: "Turn on the Little Safari extension",
                detail: "First turn on Safari → Settings → Developer → Allow unsigned extensions (Safari turns it off when it quits). Then enable Little Safari and allow it on all websites.",
                action: ("Safari Settings…", model.openExtensionSettings)
            )

            Text("Hold ⌥ while clicking a link to skip the little window. In a little window, press ⌘O, ⌘⇧O or the toolbar button to move the page to your main Safari window.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()

            HStack {
                Button("Try It") {
                    LinkRouter.route(URL(string: "https://www.apple.com/safari/")!, skipLittleWindow: false)
                }
                Button("Refresh") { model.refresh() }
                Spacer()
                if model.isDefaultBrowser {
                    Button("Restore Safari as Default") { model.restoreSafariAsDefault() }
                }
                Button("Quit") { NSApp.terminate(nil) }
            }
        }
        .padding(22)
        .frame(width: 440, height: 400)
    }

    private func step(done: Bool, title: String, detail: String, action: (String, () -> Void)?) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: done ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(done ? .green : .secondary)
                .font(.title3)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).fontWeight(.semibold)
                Text(detail).font(.callout).foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                if let action {
                    Button(action.0, action: action.1).padding(.top, 2)
                }
            }
        }
    }
}
