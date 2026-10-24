import AppKit
import QuartzCore

/// A window-shaped card that springs open from the mouse while Safari creates the real window
/// underneath, then fades out to reveal it. We can't animate Safari's window, so we fake it.
final class OpenAnimation {
    private static var current: OpenAnimation?

    private let window: NSWindow
    private let card = CALayer()

    /// `frame` is the little window's final frame in screen coordinates.
    init(frame: NSRect, from point: NSPoint) {
        let margin: CGFloat = 80  // room for the shadow
        window = NSWindow(
            contentRect: frame.insetBy(dx: -margin, dy: -margin),
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = false
        window.ignoresMouseEvents = true
        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .transient, .ignoresCycle]
        window.isReleasedWhenClosed = false

        let view = NSView(frame: NSRect(origin: .zero, size: window.frame.size))
        view.wantsLayer = true
        window.contentView = view

        // Grow out of the point where the link was clicked (clamped to the card).
        let anchorX = min(max((point.x - frame.minX) / frame.width, 0), 1)
        let anchorY = min(max((point.y - frame.minY) / frame.height, 0), 1)
        card.anchorPoint = CGPoint(x: anchorX, y: anchorY)
        card.frame = CGRect(x: margin, y: margin, width: frame.width, height: frame.height)
        card.cornerRadius = 16
        card.cornerCurve = .continuous
        card.borderWidth = 0.5
        card.shadowOpacity = 0.3
        card.shadowRadius = 28
        card.shadowOffset = CGSize(width: 0, height: -14)
        view.effectiveAppearance.performAsCurrentDrawingAppearance {
            card.backgroundColor = NSColor.windowBackgroundColor.cgColor
            card.borderColor = NSColor.separatorColor.cgColor
        }
        view.layer?.addSublayer(card)
    }

    /// Starts the animation, runs `work` (which opens the Safari window), then reveals it.
    func play(during work: @escaping () -> Void) {
        OpenAnimation.current = self
        let reduceMotion = NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
        window.orderFrontRegardless()

        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.fromValue = 0
        fadeIn.toValue = 1
        fadeIn.duration = reduceMotion ? 0.15 : 0.1
        card.add(fadeIn, forKey: "fadeIn")

        var settleTime = fadeIn.duration
        if !reduceMotion {
            let spring = CASpringAnimation(keyPath: "transform.scale")
            spring.fromValue = 0.4
            spring.toValue = 1
            spring.stiffness = 280
            spring.damping = 24
            spring.duration = spring.settlingDuration
            card.add(spring, forKey: "scale")
            settleTime = 0.34  // visually settled well before settlingDuration
        }
        CATransaction.flush()

        // Core Animation runs in the render server, so the card keeps animating
        // while the AppleScript call below blocks the main thread.
        let start = CACurrentMediaTime()
        DispatchQueue.main.async {
            work()
            let elapsed = CACurrentMediaTime() - start
            // A short pause after Safari's window exists lets it draw before we reveal it.
            let delay = max(settleTime - elapsed, 0) + 0.1
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { self.reveal() }
        }
    }

    private func reveal() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.2)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeOut))
        CATransaction.setCompletionBlock {
            self.window.orderOut(nil)
            if OpenAnimation.current === self { OpenAnimation.current = nil }
        }
        card.opacity = 0
        CATransaction.commit()
    }
}
