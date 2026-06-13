import Cocoa
import WebKit

// 嘟嘟找别字 —— Mac App Store 版（WKWebView 加载内置 game.html，无私有 API、App Sandbox 兼容）
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var webView: WKWebView!

    func applicationDidFinishLaunching(_ notification: Notification) {
        let screen = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 1000, height: 720)
        let w = min(960, screen.width * 0.8)
        let h = min(720, screen.height * 0.85)
        let rect = NSRect(x: 0, y: 0, width: w, height: h)

        window = NSWindow(
            contentRect: rect,
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered, defer: false)
        window.title = "嘟嘟找别字"
        window.minSize = NSSize(width: 480, height: 420)
        window.center()

        webView = WKWebView(frame: rect, configuration: WKWebViewConfiguration())
        webView.autoresizingMask = [.width, .height]
        window.contentView = webView

        if let url = Bundle.main.url(forResource: "game", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }

        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }
}
