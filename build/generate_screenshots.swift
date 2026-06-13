import Cocoa
import WebKit

// 用 WKWebView 渲染游戏并截取 App Store 规格截图（1440x900 逻辑，输出 2x = 2880x1800）
let outDir = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "."
let gamePath = CommandLine.arguments.count > 2 ? CommandLine.arguments[2] : "game.html"
let uiLang = CommandLine.arguments.count > 3 ? CommandLine.arguments[3] : "zh"   // zh | en
let WIDTH: CGFloat = 1440, HEIGHT: CGFloat = 900

final class Shooter: NSObject, WKNavigationDelegate {
    let web: WKWebView
    let window: NSWindow
    var steps: [(String, String)] = []
    var idx = 0

    override init() {
        let rect = NSRect(x: 0, y: 0, width: WIDTH, height: HEIGHT)
        web = WKWebView(frame: rect, configuration: WKWebViewConfiguration())
        window = NSWindow(contentRect: rect, styleMask: [.borderless], backing: .buffered, defer: false)
        super.init()
        window.contentView = web
        window.makeKeyAndOrderFront(nil)
        web.navigationDelegate = self
    }
    func load(_ path: String) {
        let url = URL(fileURLWithPath: path)
        web.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
    }
    func webView(_ w: WKWebView, didFinish nav: WKNavigation!) {
        // 移除启动画面、清掉存档（截图取干净的首启菜单）；需要英文界面时先切换语言
        let common = "var sp=document.getElementById('splash'); if(sp) sp.remove(); try{localStorage.removeItem('dudu_save_v1')}catch(e){} "
        let prep = common + (uiLang == "en" ? "lang='en';" : "") + " applyLang();"
        web.evaluateJavaScript(prep) { _, _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { self.runStep() }
        }
    }
    func runStep() {
        if idx >= steps.count { NSApp.terminate(nil); return }
        let (file, js) = steps[idx]
        web.evaluateJavaScript(js.isEmpty ? "true" : js) { _, _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                let cfg = WKSnapshotConfiguration()
                cfg.rect = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT)
                self.web.takeSnapshot(with: cfg) { image, _ in
                    if let image = image { self.save(image, file) }
                    self.idx += 1
                    self.runStep()
                }
            }
        }
    }
    func save(_ image: NSImage, _ name: String) {
        let scale: CGFloat = 2
        let rep = NSBitmapImageRep(bitmapDataPlanes: nil,
            pixelsWide: Int(WIDTH*scale), pixelsHigh: Int(HEIGHT*scale),
            bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
            colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
        rep.size = NSSize(width: WIDTH, height: HEIGHT)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
        image.draw(in: NSRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
        NSGraphicsContext.restoreGraphicsState()
        let data = rep.representation(using: .png, properties: [:])!
        try! data.write(to: URL(fileURLWithPath: "\(outDir)/\(name)"))
        print("saved \(name)  \(Int(WIDTH*scale))x\(Int(HEIGHT*scale))")
    }
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)
let s = Shooter()
s.steps = [
    ("01-start.png", ""),
    ("02-find.png", "startGame();"),
    ("03-pinyin.png", "showPinyinQuiz();"),
    ("04-combo.png", "pinyinOverlay.classList.add('hidden'); showCombo(5,25);"),
    ("05-timesup.png", "document.getElementById('comboPop').classList.remove('show'); gameOver();"),
]
s.load(gamePath)
app.run()
