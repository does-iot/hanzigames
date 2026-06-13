import Cocoa
import WebKit

// 火眼金睛 · 汉字找茬 —— 独立桌面 App（WKWebView 加载内置 HTML）
class AppDelegate: NSObject, NSApplicationDelegate, WKNavigationDelegate {
    var window: NSWindow!
    var webView: WKWebView!

    func applicationDidFinishLaunching(_ notification: Notification) {
        let screen = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 1000, height: 720)
        let w: CGFloat = min(960, screen.width * 0.8)
        let h: CGFloat = min(720, screen.height * 0.85)
        let rect = NSRect(x: 0, y: 0, width: w, height: h)

        window = NSWindow(
            contentRect: rect,
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "嘟嘟找别字"
        window.minSize = NSSize(width: 480, height: 420)
        window.center()

        let config = WKWebViewConfiguration()
        config.preferences.setValue(true, forKey: "developerExtrasEnabled")
        webView = WKWebView(frame: rect, configuration: config)
        webView.navigationDelegate = self
        webView.autoresizingMask = [.width, .height]
        webView.setValue(false, forKey: "drawsBackground")  // 透明背景，避免白边
        window.contentView = webView

        // 加载内置在 App Resources 里的 game.html
        if let url = Bundle.main.url(forResource: "game", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        } else {
            webView.loadHTMLString("<h1 style='font-family:sans-serif'>找不到 game.html</h1>", baseURL: nil)
        }

        window.makeKeyAndOrderFront(nil)
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
