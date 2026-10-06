#!/usr/bin/env swift

import AppKit
import Foundation

let files = FileManager.default
let root = files.currentDirectoryPath
let iconPath = root + "/AppScope/resources/base/media/startIcon.png"
let outputDirectory = root + "/docs/assets"

guard let appIcon = NSImage(contentsOfFile: iconPath) else {
    fputs("Unable to load app icon at \(iconPath)\n", stderr)
    exit(1)
}

try files.createDirectory(atPath: outputDirectory, withIntermediateDirectories: true)

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

func bitmap(width: Int, height: Int, drawing: () -> Void) -> NSBitmapImageRep {
    guard let result = NSBitmapImageRep(
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
    ), let context = NSGraphicsContext(bitmapImageRep: result) else {
        fatalError("Unable to create bitmap context")
    }
    result.size = NSSize(width: width, height: height)
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = context
    drawing()
    context.flushGraphics()
    NSGraphicsContext.restoreGraphicsState()
    return result
}

func savePNG(_ image: NSBitmapImageRep, name: String) {
    guard let data = image.representation(using: .png, properties: [:]) else {
        fatalError("Unable to encode \(name)")
    }
    do { try data.write(to: URL(fileURLWithPath: outputDirectory + "/" + name)) }
    catch { fatalError("Unable to save \(name): \(error)") }
}

func topRect(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat, canvas: CGFloat) -> NSRect {
    NSRect(x: x, y: canvas - y - height, width: width, height: height)
}

func text(
    _ value: String,
    x: CGFloat,
    y: CGFloat,
    width: CGFloat,
    height: CGFloat,
    size: CGFloat,
    weight: NSFont.Weight = .regular,
    foreground: NSColor,
    canvasHeight: CGFloat,
    alignment: NSTextAlignment = .left
) {
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = alignment
    paragraph.lineBreakMode = .byTruncatingTail
    NSString(string: value).draw(
        in: topRect(x, y, width, height, canvas: canvasHeight),
        withAttributes: [
            .font: font(size, weight: weight),
            .foregroundColor: foreground,
            .paragraphStyle: paragraph
        ]
    )
}

func pill(_ value: String, x: CGFloat, y: CGFloat, width: CGFloat,
          fill: NSColor, stroke: NSColor, foreground: NSColor, canvasHeight: CGFloat) {
    let area = topRect(x, y, width, 46, canvas: canvasHeight)
    let shape = NSBezierPath(roundedRect: area, xRadius: 23, yRadius: 23)
    fill.setFill()
    shape.fill()
    stroke.setStroke()
    shape.lineWidth = 1.5
    shape.stroke()
    text(value, x: x, y: y + 8, width: width, height: 30, size: 17,
         weight: .semibold, foreground: foreground, canvasHeight: canvasHeight,
         alignment: .center)
}

func drawBackground(width: CGFloat, height: CGFloat) {
    for column in 0..<Int(width) {
        let progress = CGFloat(column) / width
        let red = (5 + (18 - 5) * progress) / 255
        let green = (24 + (58 - 24) * progress) / 255
        let blue = (34 + (67 - 34) * progress) / 255
        NSColor(red: red, green: green, blue: blue, alpha: 1).setFill()
        NSBezierPath(rect: NSRect(x: CGFloat(column), y: 0, width: 1.2, height: height)).fill()
    }

    color(0x9dd8d1, alpha: 0.08).setStroke()
    for offset in stride(from: -600, through: 1400, by: 72) {
        let line = NSBezierPath()
        line.move(to: NSPoint(x: CGFloat(offset), y: 0))
        line.line(to: NSPoint(x: CGFloat(offset + 640), y: height))
        line.lineWidth = 1
        line.stroke()
    }

    let center = NSPoint(x: 1080, y: 310)
    for diameter in [280, 420, 580] as [CGFloat] {
        let orbit = NSBezierPath(ovalIn: NSRect(
            x: center.x - diameter / 2,
            y: center.y - diameter / 2,
            width: diameter,
            height: diameter
        ))
        orbit.lineWidth = 1
        orbit.stroke()
    }
}

func drawIconCard(canvasHeight: CGFloat) {
    let card = topRect(72, 100, 340, 340, canvas: canvasHeight)

    NSGraphicsContext.saveGraphicsState()
    let shadow = NSShadow()
    shadow.shadowColor = color(0x000000, alpha: 0.34)
    shadow.shadowBlurRadius = 28
    shadow.shadowOffset = NSSize(width: 0, height: -10)
    shadow.set()
    color(0xffffff).setFill()
    NSBezierPath(roundedRect: card, xRadius: 56, yRadius: 56).fill()
    NSGraphicsContext.restoreGraphicsState()

    NSGraphicsContext.saveGraphicsState()
    NSBezierPath(roundedRect: card, xRadius: 56, yRadius: 56).addClip()
    appIcon.draw(
        in: card.insetBy(dx: 24, dy: 24),
        from: .zero,
        operation: .sourceOver,
        fraction: 1,
        respectFlipped: true,
        hints: [.interpolation: NSImageInterpolation.high]
    )
    NSGraphicsContext.restoreGraphicsState()
}

struct BannerCopy {
    let title: String
    let subtitle: String
    let tagline: String
    let award: String
    let footer: String
    let titleSize: CGFloat
    let subtitleSize: CGFloat
}

func makeBanner(_ copy: BannerCopy) -> NSBitmapImageRep {
    let width: CGFloat = 1280
    let height: CGFloat = 640
    return bitmap(width: Int(width), height: Int(height)) {
        drawBackground(width: width, height: height)
        drawIconCard(canvasHeight: height)

        text(copy.title, x: 472, y: 102, width: 720, height: 104,
             size: copy.titleSize, weight: .bold, foreground: color(0xf7fbfa),
             canvasHeight: height)
        text(copy.subtitle, x: 476, y: 204, width: 700, height: 58,
             size: copy.subtitleSize, weight: .semibold, foreground: color(0x9dd8d1),
             canvasHeight: height)
        text(copy.tagline, x: 476, y: 274, width: 720, height: 48,
             size: 25, foreground: color(0xd8e8e7), canvasHeight: height)

        pill("HarmonyOS 6.0+", x: 476, y: 342, width: 192,
             fill: color(0x0f766e, alpha: 0.34), stroke: color(0x6cc7bc, alpha: 0.65),
             foreground: color(0xd8fffa), canvasHeight: height)
        pill("ArkTS · ArkUI", x: 686, y: 342, width: 174,
             fill: color(0xb7793f, alpha: 0.25), stroke: color(0xd8a46d, alpha: 0.66),
             foreground: color(0xffe4c7), canvasHeight: height)
        pill("Open Source", x: 878, y: 342, width: 158,
             fill: color(0xffffff, alpha: 0.08), stroke: color(0xffffff, alpha: 0.24),
             foreground: color(0xf0f6f5), canvasHeight: height)

        color(0x7fcfc5, alpha: 0.45).setFill()
        NSBezierPath(roundedRect: topRect(476, 438, 660, 2, canvas: height),
                     xRadius: 1, yRadius: 1).fill()

        text(copy.award, x: 476, y: 466, width: 680, height: 36,
             size: 20, weight: .semibold, foreground: color(0xe8c08f),
             canvasHeight: height)
        text("github.com/lzynb0206/WorldMuse-V1.0_HarmonyOS_6.0",
             x: 476, y: 518, width: 690, height: 32, size: 17,
             foreground: color(0xaec5c3), canvasHeight: height)
        text(copy.footer, x: 74, y: 498, width: 340, height: 40, size: 16,
             weight: .semibold, foreground: color(0x9dd8d1), canvasHeight: height,
             alignment: .center)
    }
}

let logo = bitmap(width: 512, height: 512) {
    color(0xffffff).setFill()
    NSBezierPath(rect: NSRect(x: 0, y: 0, width: 512, height: 512)).fill()
    appIcon.draw(
        in: NSRect(x: 30, y: 30, width: 452, height: 452),
        from: .zero,
        operation: .sourceOver,
        fraction: 1,
        respectFlipped: true,
        hints: [.interpolation: NSImageInterpolation.high]
    )
}
savePNG(logo, name: "worldmuse-logo.png")

let english = makeBanner(BannerCopy(
    title: "WorldMuse",
    subtitle: "云览天下",
    tagline: "Explore museums worldwide. Discover culture without borders.",
    award: "2025 HarmonyOS Developer Incentive Program",
    footer: "MUSEUM · CULTURE · TECHNOLOGY",
    titleSize: 74,
    subtitleSize: 34
))

let chinese = makeBanner(BannerCopy(
    title: "云览天下",
    subtitle: "WorldMuse",
    tagline: "探索全球博物馆，开启文化之旅",
    award: "2025 HarmonyOS Developer Incentive Program",
    footer: "博物馆 · 文化 · 科技",
    titleSize: 74,
    subtitleSize: 38
))

savePNG(english, name: "worldmuse-project-card-en.png")
savePNG(chinese, name: "worldmuse-project-card-zh.png")
savePNG(english, name: "worldmuse-project-card.png")

struct CopyrightCopy {
    let title: String
    let subtitle: String
    let softwareLabel: String
    let holderLabel: String
    let holderValue: String
    let registrationLabel: String
    let dateLabel: String
    let rightsLabel: String
    let rightsValue: String
    let authority: String
    let privacyNote: String
    let emblemText: String
}

func copyrightField(_ label: String, value: String, y: CGFloat, canvasHeight: CGFloat) {
    text(label, x: 380, y: y + 1, width: 210, height: 32, size: 16,
         weight: .semibold, foreground: color(0xd9aa63), canvasHeight: canvasHeight)
    text(value, x: 600, y: y - 2, width: 590, height: 38, size: 22,
         weight: .semibold, foreground: color(0xf3f8f7), canvasHeight: canvasHeight)
}

func makeCopyrightCard(_ copy: CopyrightCopy) -> NSBitmapImageRep {
    let width: CGFloat = 1280
    let height: CGFloat = 520
    return bitmap(width: Int(width), height: Int(height)) {
        drawBackground(width: width, height: height)

        let outerBorder = NSBezierPath(roundedRect: topRect(24, 24, 1232, 472, canvas: height),
                                       xRadius: 28, yRadius: 28)
        color(0xc99a54, alpha: 0.82).setStroke()
        outerBorder.lineWidth = 2
        outerBorder.stroke()
        let innerBorder = NSBezierPath(roundedRect: topRect(34, 34, 1212, 452, canvas: height),
                                       xRadius: 22, yRadius: 22)
        color(0xc99a54, alpha: 0.25).setStroke()
        innerBorder.lineWidth = 1
        innerBorder.stroke()

        let iconCard = topRect(72, 92, 248, 248, canvas: height)
        color(0xffffff).setFill()
        NSBezierPath(roundedRect: iconCard, xRadius: 42, yRadius: 42).fill()
        NSGraphicsContext.saveGraphicsState()
        NSBezierPath(roundedRect: iconCard, xRadius: 42, yRadius: 42).addClip()
        appIcon.draw(
            in: iconCard.insetBy(dx: 18, dy: 18),
            from: .zero,
            operation: .sourceOver,
            fraction: 1,
            respectFlipped: true,
            hints: [.interpolation: NSImageInterpolation.high]
        )
        NSGraphicsContext.restoreGraphicsState()

        let mark = topRect(252, 294, 82, 82, canvas: height)
        color(0xb7793f).setFill()
        NSBezierPath(ovalIn: mark).fill()
        text("©", x: 252, y: 303, width: 82, height: 62, size: 44,
             weight: .semibold, foreground: color(0xffffff), canvasHeight: height,
             alignment: .center)
        text(copy.emblemText, x: 66, y: 382, width: 270, height: 40, size: 17,
             weight: .semibold, foreground: color(0x9dd8d1), canvasHeight: height,
             alignment: .center)

        text(copy.title, x: 380, y: 54, width: 810, height: 62, size: 42,
             weight: .bold, foreground: color(0xf7fbfa), canvasHeight: height)
        text(copy.subtitle, x: 382, y: 112, width: 800, height: 42, size: 22,
             weight: .semibold, foreground: color(0x9dd8d1), canvasHeight: height)

        color(0xc99a54, alpha: 0.55).setFill()
        NSBezierPath(roundedRect: topRect(380, 160, 810, 2, canvas: height),
                     xRadius: 1, yRadius: 1).fill()

        copyrightField(copy.softwareLabel, value: "云览天下-博物馆云端漫游平台 V1.0",
                       y: 184, canvasHeight: height)
        copyrightField(copy.holderLabel, value: copy.holderValue, y: 232, canvasHeight: height)
        copyrightField(copy.registrationLabel, value: "2025SR237****",
                       y: 280, canvasHeight: height)
        copyrightField(copy.dateLabel, value: "2025-12-09", y: 328, canvasHeight: height)
        copyrightField(copy.rightsLabel, value: copy.rightsValue, y: 376, canvasHeight: height)

        text(copy.authority, x: 380, y: 432, width: 810, height: 28, size: 17,
             weight: .semibold, foreground: color(0xe8c08f), canvasHeight: height)
        text(copy.privacyNote, x: 380, y: 462, width: 810, height: 24, size: 14,
             foreground: color(0xaec5c3), canvasHeight: height)
    }
}

let copyrightEnglish = makeCopyrightCard(CopyrightCopy(
    title: "Registered Software Copyright",
    subtitle: "WorldMuse · 云览天下",
    softwareLabel: "REGISTERED SOFTWARE",
    holderLabel: "COPYRIGHT HOLDER",
    holderValue: "Registered individual",
    registrationLabel: "REGISTRATION NO.",
    dateLabel: "REGISTERED ON",
    rightsLabel: "RIGHTS",
    rightsValue: "Original acquisition · All rights",
    authority: "Registration authority · China Copyright Protection Center",
    privacyNote: "Public verification card · Certificate serial, barcode and QR code intentionally omitted",
    emblemText: "SOFTWARE COPYRIGHT"
))

let copyrightChinese = makeCopyrightCard(CopyrightCopy(
    title: "计算机软件著作权登记",
    subtitle: "云览天下 · WorldMuse",
    softwareLabel: "登记软件",
    holderLabel: "著作权人",
    holderValue: "已登记个人著作权人",
    registrationLabel: "登记号",
    dateLabel: "登记日期",
    rightsLabel: "权利信息",
    rightsValue: "原始取得 · 全部权利",
    authority: "登记机构 · 中国版权保护中心",
    privacyNote: "公开展示卡 · 证书号、条形码和二维码已主动省略",
    emblemText: "软件著作权"
))

savePNG(copyrightEnglish, name: "worldmuse-copyright-en.png")
savePNG(copyrightChinese, name: "worldmuse-copyright-zh.png")

print("Generated bilingual README and copyright assets in docs/assets")
