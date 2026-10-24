// Renders the extension's icons from an SF Symbol. Usage: swift make-icons.swift <output dir>
import AppKit

let outputDir = URL(fileURLWithPath: CommandLine.arguments[1])
let symbol = "macwindow.on.rectangle"

for size in [16, 32, 48, 64, 96, 128, 256, 512] {
    let config = NSImage.SymbolConfiguration(pointSize: CGFloat(size) * 0.7, weight: .regular)
    guard let image = NSImage(systemSymbolName: symbol, accessibilityDescription: nil)?.withSymbolConfiguration(config),
          let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: size, pixelsHigh: size, bitsPerSample: 8,
                                     samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB,
                                     bytesPerRow: 0, bitsPerPixel: 0)
    else { fatalError("Could not render \(symbol)") }

    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    let fit = min(CGFloat(size) / image.size.width, CGFloat(size) / image.size.height) * 0.9
    let drawSize = NSSize(width: image.size.width * fit, height: image.size.height * fit)
    let origin = NSPoint(x: (CGFloat(size) - drawSize.width) / 2, y: (CGFloat(size) - drawSize.height) / 2)
    image.draw(in: NSRect(origin: origin, size: drawSize))
    NSGraphicsContext.restoreGraphicsState()

    let png = rep.representation(using: .png, properties: [:])!
    try png.write(to: outputDir.appendingPathComponent("icon-\(size).png"))
}
