import AppKit

// 绘制 1024x1024 App 图标：橙红渐变圆角底 + 白色"字" + 放大镜
let size = 1024
let outPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "icon_1024.png"

let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: size, pixelsHigh: size,
    bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
    colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!

NSGraphicsContext.saveGraphicsState()
let gctx = NSGraphicsContext(bitmapImageRep: rep)!
NSGraphicsContext.current = gctx
let cg = gctx.cgContext
let W = CGFloat(size)

// 圆角裁剪 + 渐变背景（macOS squircle 风格）
let radius = W * 0.2237
cg.addPath(CGPath(roundedRect: CGRect(x: 0, y: 0, width: W, height: W),
                  cornerWidth: radius, cornerHeight: radius, transform: nil))
cg.clip()
let cols = [NSColor(srgbRed: 1.0, green: 0.68, blue: 0.32, alpha: 1).cgColor,
            NSColor(srgbRed: 1.0, green: 0.42, blue: 0.42, alpha: 1).cgColor] as CFArray
let grad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cols, locations: [0, 1])!
cg.drawLinearGradient(grad, start: CGPoint(x: 0, y: W), end: CGPoint(x: W, y: 0), options: [])

let brown = NSColor(srgbRed: 0.36, green: 0.27, blue: 0.21, alpha: 1)

// 汉字"字"
let para = NSMutableParagraphStyle(); para.alignment = .center
let font = NSFont(name: "PingFangSC-Semibold", size: 600) ?? NSFont.boldSystemFont(ofSize: 600)
let shadow = NSShadow()
shadow.shadowColor = NSColor(white: 0, alpha: 0.18)
shadow.shadowOffset = NSSize(width: 0, height: -10)
shadow.shadowBlurRadius = 18
let attrs: [NSAttributedString.Key: Any] = [
    .font: font, .foregroundColor: NSColor.white,
    .strokeColor: brown, .strokeWidth: -6.0,
    .paragraphStyle: para, .shadow: shadow
]
let str = NSAttributedString(string: "字", attributes: attrs)
let ts = str.size()
str.draw(at: CGPoint(x: (W - ts.width) / 2, y: (W - ts.height) / 2 - W * 0.03))

// 放大镜（右下角）
let cx = W * 0.70, cy = W * 0.285, rr = W * 0.155
cg.setFillColor(NSColor(white: 1, alpha: 0.20).cgColor)
cg.fillEllipse(in: CGRect(x: cx - rr, y: cy - rr, width: rr * 2, height: rr * 2))
// 手柄
let a = -CGFloat.pi / 4
let p1 = CGPoint(x: cx + cos(a) * rr, y: cy + sin(a) * rr)
let p2 = CGPoint(x: cx + cos(a) * (rr + W * 0.135), y: cy + sin(a) * (rr + W * 0.135))
cg.setStrokeColor(brown.cgColor); cg.setLineCap(.round); cg.setLineWidth(W * 0.062)
cg.move(to: p1); cg.addLine(to: p2); cg.strokePath()
// 镜框
cg.setLineWidth(W * 0.05)
cg.strokeEllipse(in: CGRect(x: cx - rr, y: cy - rr, width: rr * 2, height: rr * 2))

NSGraphicsContext.restoreGraphicsState()

let data = rep.representation(using: .png, properties: [:])!
try! data.write(to: URL(fileURLWithPath: outPath))
print("icon written: \(outPath)")
