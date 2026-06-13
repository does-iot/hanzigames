# 嘟嘟找别字 🐯🔍

一款给小学生的汉字"找别字"游戏：一堆相同的汉字里藏着一个长得很像的"别字"，限时找出它，再选对拼音才能闯关。汉字取自人教版一~三年级语文二会字，约 100 组形近字。

**▶️ 在线试玩：** https://does-iot.github.io/hanzigames/
**🔒 隐私政策：** https://does-iot.github.io/hanzigames/privacy.html

## 玩法
- 在一堆相同的字里找出唯一不同的"别字"
- 限时挑战，关卡越高字越多、时间越短
- 找到后选对拼音才能进下一关
- 连续无错触发"连击奖励"

## 特点
- 卡通糖果风界面，自适应窗口
- Web Audio 合成的多首儿歌背景音乐（可静音）
- 纯本地运行，无需联网、无广告、不收集任何数据

## 目录结构
```
index.html        网页版游戏（GitHub Pages 在线可玩）
privacy.html      隐私政策网页
xcodeproj/        可直接 Archive 上传 Mac App Store 的 Xcode 项目
appstore/         上架资料：图标、截图、商店文案、隐私/分级答卷、提交指南
build/            构建脚本：打独立 .app、生成图标、生成截图
```

## 构建 Mac App
打开 `xcodeproj/DuDuHanzi.xcodeproj`，配置签名 Team 后 Product → Archive 即可。
上架完整流程见 [`appstore/README.md`](appstore/README.md)。

---
© 2026 嘟嘟的哥哥叫铛铛
