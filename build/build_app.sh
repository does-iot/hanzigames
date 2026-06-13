#!/bin/bash
# 把游戏打包成独立的 macOS .app（WKWebView 内置 HTML，不依赖浏览器）
set -e

PROJ="/Users/apple/ClaudeProject"
BUILD="$PROJ/build"
APP="$PROJ/嘟嘟找别字.app"
EXEC_NAME="hanzigame"

echo "==> 清理旧 App"
rm -rf "$APP" "$PROJ/汉字找茬.app"

echo "==> 编译 Swift 启动器（尝试 universal: arm64 + x86_64）"
swiftc "$BUILD/main.swift" -o "$BUILD/${EXEC_NAME}_arm64" \
  -target arm64-apple-macosx11.0 -framework Cocoa -framework WebKit -O
if swiftc "$BUILD/main.swift" -o "$BUILD/${EXEC_NAME}_x86" \
     -target x86_64-apple-macosx11.0 -framework Cocoa -framework WebKit -O 2>/dev/null; then
  lipo -create "$BUILD/${EXEC_NAME}_arm64" "$BUILD/${EXEC_NAME}_x86" -output "$BUILD/$EXEC_NAME"
  echo "   → universal（arm64 + x86_64，Intel 与 Apple 芯片都可运行）"
else
  cp "$BUILD/${EXEC_NAME}_arm64" "$BUILD/$EXEC_NAME"
  echo "   → 仅 arm64（本机无 x86_64 交叉编译 SDK）"
fi
rm -f "$BUILD/${EXEC_NAME}_arm64" "$BUILD/${EXEC_NAME}_x86"

echo "==> 组装 .app bundle"
mkdir -p "$APP/Contents/MacOS"
mkdir -p "$APP/Contents/Resources"

cp "$BUILD/$EXEC_NAME" "$APP/Contents/MacOS/$EXEC_NAME"
cp "$PROJ/汉字找茬游戏.html" "$APP/Contents/Resources/game.html"
cp "$PROJ/appstore/icon/AppIcon.icns" "$APP/Contents/Resources/AppIcon.icns"

cat > "$APP/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key>            <string>嘟嘟找别字</string>
  <key>CFBundleDisplayName</key>     <string>嘟嘟找别字</string>
  <key>CFBundleExecutable</key>      <string>$EXEC_NAME</string>
  <key>CFBundleIconFile</key>        <string>AppIcon</string>
  <key>CFBundleIdentifier</key>      <string>com.kids.dudubiezi</string>
  <key>CFBundlePackageType</key>     <string>APPL</string>
  <key>CFBundleShortVersionString</key> <string>1.0</string>
  <key>CFBundleVersion</key>         <string>1</string>
  <key>LSMinimumSystemVersion</key>  <string>11.0</string>
  <key>NSHighResolutionCapable</key> <true/>
  <key>NSPrincipalClass</key>        <string>NSApplication</string>
</dict>
</plist>
PLIST

echo "==> ad-hoc 签名（避免安全拦截）"
codesign --force --deep --sign - "$APP" 2>/dev/null || echo "（签名跳过，不影响本机运行）"

echo "==> 生成分发用 zip"
rm -f "$PROJ/嘟嘟找别字.zip"
ditto -c -k --keepParent "$APP" "$PROJ/嘟嘟找别字.zip"

echo "==> 完成: $APP"
echo "==> 分发包: $PROJ/嘟嘟找别字.zip"
