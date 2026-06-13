#!/bin/bash
# 生成 1024 主图标 → 全套尺寸 PNG → .icns + Xcode AppIcon.appiconset
set -e
PROJ="/Users/apple/ClaudeProject"
BUILD="$PROJ/build"
ICON_DIR="$PROJ/appstore/icon"
ICONSET="$ICON_DIR/AppIcon.iconset"
APPICONSET="$PROJ/xcodeproj/DuDuHanzi/Assets.xcassets/AppIcon.appiconset"

echo "==> 渲染 1024 主图标"
swift "$BUILD/generate_icon.swift" "$ICON_DIR/icon_1024.png"

echo "==> 生成 .iconset 各尺寸"
rm -rf "$ICONSET"; mkdir -p "$ICONSET"
gen() { sips -z "$1" "$1" "$ICON_DIR/icon_1024.png" --out "$ICONSET/$2" >/dev/null; }
gen 16   icon_16x16.png
gen 32   icon_16x16@2x.png
gen 32   icon_32x32.png
gen 64   icon_32x32@2x.png
gen 128  icon_128x128.png
gen 256  icon_128x128@2x.png
gen 256  icon_256x256.png
gen 512  icon_256x256@2x.png
gen 512  icon_512x512.png
cp "$ICON_DIR/icon_1024.png" "$ICONSET/icon_512x512@2x.png"

echo "==> 打包 .icns"
iconutil -c icns "$ICONSET" -o "$ICON_DIR/AppIcon.icns"

echo "==> 同步到 Xcode AppIcon.appiconset"
mkdir -p "$APPICONSET"
cp "$ICONSET/"*.png "$APPICONSET/"

cat > "$APPICONSET/Contents.json" <<'JSON'
{
  "images" : [
    {"size":"16x16","idiom":"mac","filename":"icon_16x16.png","scale":"1x"},
    {"size":"16x16","idiom":"mac","filename":"icon_16x16@2x.png","scale":"2x"},
    {"size":"32x32","idiom":"mac","filename":"icon_32x32.png","scale":"1x"},
    {"size":"32x32","idiom":"mac","filename":"icon_32x32@2x.png","scale":"2x"},
    {"size":"128x128","idiom":"mac","filename":"icon_128x128.png","scale":"1x"},
    {"size":"128x128","idiom":"mac","filename":"icon_128x128@2x.png","scale":"2x"},
    {"size":"256x256","idiom":"mac","filename":"icon_256x256.png","scale":"1x"},
    {"size":"256x256","idiom":"mac","filename":"icon_256x256@2x.png","scale":"2x"},
    {"size":"512x512","idiom":"mac","filename":"icon_512x512.png","scale":"1x"},
    {"size":"512x512","idiom":"mac","filename":"icon_512x512@2x.png","scale":"2x"}
  ],
  "info" : {"version":1,"author":"xcode"}
}
JSON

echo "==> 图标完成"
ls -1 "$ICON_DIR"
