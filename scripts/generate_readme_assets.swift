#!/usr/bin/env swift

import AppKit
import Foundation

let fileManager = FileManager.default
let projectRoot = fileManager.currentDirectoryPath
let sourcePath = projectRoot + "/AppScope/resources/base/media/startIcon.png"
let outputDirectory = projectRoot + "/docs/assets"

guard let sourceImage = NSImage(contentsOfFile: sourcePath) else {
    fputs("Unable to load app icon at \(sourcePath)\n", stderr)
    exit(1)
}

try fileManager.createDirectory(atPath: outputDirectory, withIntermediateDirectories: true)

func color(_ hex: UInt32, alpha: CGFloat = 1) -> NSColor {
    NSColor(
        red: CGFloat((hex >> 16) & 0xff) / 255,
        green: CGFloat((hex >> 8) & 0xff) / 255,
        blue: CGFloat(hex & 0xff) / 255,
        alpha: alpha
    )
}

func font(_ size: CGFloat, weight: NSFont.Weight = .regular) -> NSFont {
    let names = weight == .bold || weight == .semibold
        ? ["PingFangSC-Semibold", "PingFang SC Semibold", "Songti SC Bold"]
        : ["PingFangSC-Regular", "PingFang SC", "Songti SC"]
    for name in names {
        if let selected = NSFont(name: name, size: size) { return selected }
    }
    return NSFont.systemFont(ofSize: size, weight: weight)
}

func canvas(width: Int, height: Int, draw: () -> Void) -> NSBitmapImageRep {
    guard let bitmap = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: width,
        pixelsHigh: height,
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    ), let context = NSGraphicsContext(bitmapImageRep: bitmap) else {
        fatalError("Unable to create drawing canvas")
    }
    bitmap.size = NSSize(width: width, height: height)
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = context
    draw()
    context.flushGraphics()
    NSGraphicsContext.restoreGraphicsState()
    return bitmap
}

func savePNG(_ bitmap: NSBitmapImageRep, to path: String) {
    guard let data = bitmap.representation(using: .png, properties: [:]) else {
        fatalError("Unable to encode PNG")
    }
    do { try data.write(to: URL(fileURLWithPath: path)) }
    catch { fatalError("Unable to save PNG: \(error)") }
}

func topRect(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, canvasHeight: CGFloat) -> NSRect {
    NSRect(x: x, y: canvasHeight - y - height, width: width, height: height)
}

func drawText(
    _ value: String,
    x: CGFloat,
    y: CGFloat,
    width: CGFloat,
    height: CGFloat,
    size: CGFloat,
    weight: NSFont.Weight = .regular,
    textColor: NSColor,
    canvasHeight: CGFloat,
    alignment: NSTextAlignment = .left
) {
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = alignment
    paragraph.lineBreakMode = .byTruncatingTail
    NSString(string: value).draw(
        in: topRect(x: x, y: y, width: width, height: height, canvasHeight: canvasHeight),
        withAttributes: [
            .font: font(size, weight: weight),
            .foregroundColor: textColor,
            .paragraphStyle: paragraph
        ]
    )
}

func drawPill(
    _ value: String,
    x: CGFloat,
    y: CGFloat,
    width: CGFloat,
    fill: NSColor,
    stroke: NSColor,
    textColor: NSColor,
    canvasHeight: CGFloat
) {
    let rect = topRect(x: x, y: y, width: width, height: 46, canvasHeight: canvasHeight)
    let path = NSBezierPath(roundedRect: rect, xRadius: 23, yRadius: 23)
    fill.setFill()
    path.fill()
    stroke.setStroke()
    path.lineWidth = 1.5
    path.stroke()
    drawText(value, x: x, y: y + 8, width: width, height: 30, size: 17,
             weight: .semibold, textColor: textColor, canvasHeight: canvasHeight,
             alignment: .center)
}

let logoBitmap = canvas(width: 512, height: 512) {
    color(0xffffff).setFill()
    NSBezierPath(rect: NSRect(x: 0, y: 0, width: 512, height: 512)).fill()
    sourceImage.draw(
        in: NSRect(x: 30, y: 30, width: 452, height: 452),
        from: .zero,
        operation: .sourceOver,
        fraction: 1,
        respectFlipped: true,
        hints: [.interpolation: NSImageInterpolation.high]
    )
}
savePNG(logoBitmap, to: outputDirectory + "/worldmuse-logo.png")

let width: CGFloat = 1280
let height: CGFloat = 640
let bannerBitmap = canvas(width: Int(width), height: Int(height)) {
    // Deep museum-inspired teal gradient.
    for column in 0..<Int(width) {
        let progress = CGFloat(column) / width
        let red = (5 + (18 - 5) * progress) / 255
        let green = (24 + (58 - 24) * progress) / 255
        let blue = (34 + (67 - 34) * progress) / 255
        NSColor(red: red, green: green, blue: blue, alpha: 1).setFill()
        NSBezierPath(rect: NSRect(x: CGFloat(column), y: 0, width: 1.2, height: height)).fill()
    }

    // Subtle architectural grid and orbit lines.
    color(0x9dd8d1, alpha: 0.08).setStroke()
    for offset in stride(from: -600, through: 1400, by: 72) {
        let line = NSBezierPath()
        line.move(to: NSPoint(x: CGFloat(offset), y: 0))
        line.line(to: NSPoint(x: CGFloat(offset + 640), y: height))
        line.lineWidth = 1
        line.stroke()
    }
    let orbitCenter = NSPoint(x: 1080, y: 310)
    for diameter in [280, 420, 580] as [CGFloat] {
        let orbit = NSBezierPath(ovalIn: NSRect(
            x: orbitCenter.x - diameter / 2,
            y: orbitCenter.y - diameter / 2,
            width: diameter,
            height: diameter
        ))
        orbit.lineWidth = 1
        orbit.stroke()
    }

    // App icon card.
    let cardRect = topRect(x: 72, y: 100, width: 340, height: 340, canvasHeight: height)
    NSGraphicsContext.saveGraphicsState()
    let shadow = NSShadow()
    shadow.shadowColor = color(0x000000, alpha: 0.34)
    shadow.shadowBlurRadius = 28
    shadow.shadowOffset = NSSize(width: 0, height: -10)
    shadow.set()
    color(0xffffff).setFill()
    NSBezierPath(roundedRect: cardRect, xRadius: 56, yRadius: 56).fill()
    NSGraphicsContext.restoreGraphicsState()

    NSGraphicsContext.saveGraphicsState()
    NSBezierPath(roundedRect: cardRect, xRadius: 56, yRadius: 56).addClip()
    sourceImage.draw(
        in: cardRect.insetBy(dx: 24, dy: 24),
        from: .zero,
        operation: .sourceOver,
        fraction: 1,
        respectFlipped: true,
        hints: [.interpolation: NSImageInterpolation.high]
    )
    NSGraphicsContext.restoreGraphicsState()

    drawText("云览天下", x: 472, y: 102, width: 700, height: 102, size: 74,
             weight: .bold, textColor: color(0xf7fbfa), canvasHeight: height)
    drawText("WorldMuse", x: 476, y: 200, width: 700, height: 58, size: 38,
             weight: .semibold, textColor: color(0x9dd8d1), canvasHeight: height)
    drawText("探索全球博物馆，开启文化之旅", x: 476, y: 270, width: 720, height: 48,
             size: 27, textColor: color(0xd8e8e7), canvasHeight: height)

    drawPill("HarmonyOS 6.0+", x: 476, y: 342, width: 192,
             fill: color(0x0f766e, alpha: 0.34), stroke: color(0x6cc7bc, alpha: 0.65),
             textColor: color(0xd8fffa), canvasHeight: height)
    drawPill("ArkTS · ArkUI", x: 686, y: 342, width: 174,
             fill: color(0xb7793f, alpha: 0.25), stroke: color(0xd8a46d, alpha: 0.66),
             textColor: color(0xffe4c7), canvasHeight: height)
    drawPill("Open Source", x: 878, y: 342, width: 158,
             fill: color(0xffffff, alpha: 0.08), stroke: color(0xffffff, alpha: 0.24),
             textColor: color(0xf0f6f5), canvasHeight: height)

    color(0x7fcfc5, alpha: 0.45).setFill()
    let divider = topRect(x: 476, y: 438, width: 660, height: 2, canvasHeight: height)
    NSBezierPath(roundedRect: divider, xRadius: 1, yRadius: 1).fill()

    drawText("2025 HarmonyOS Developer Incentive Program", x: 476, y: 466,
             width: 650, height: 36, size: 20, weight: .semibold,
             textColor: color(0xe8c08f), canvasHeight: height)
    drawText("github.com/lzynb0206/WorldMuse-V1.0_HarmonyOS_6.0", x: 476, y: 518,
             width: 690, height: 32, size: 17, textColor: color(0xaec5c3),
             canvasHeight: height)
    drawText("MUSEUM · CULTURE · TECHNOLOGY", x: 74, y: 498, width: 340,
             height: 40, size: 16, weight: .semibold, textColor: color(0x9dd8d1),
             canvasHeight: height, alignment: .center)
}

savePNG(bannerBitmap, to: outputDirectory + "/worldmuse-project-card.png")
print("Generated README assets in docs/assets")
