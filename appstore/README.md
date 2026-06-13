# 嘟嘟找别字 · App Store 上架资料包

本目录是「嘟嘟找别字」上架 Mac App Store 所需的**全部资料**。下面分三部分：📦 资料清单、🔒 你必须本人完成的事、🚀 提交步骤。

---

## 📦 一、资料清单（已生成）

| 文件 | 用途 |
|---|---|
| `metadata/listing-zh.md` | 中文商店文案：名称/副标题/描述/推广语/分类/版权 |
| `metadata/listing-en.md` | 英文商店文案（全球区） |
| `metadata/keywords.md` | 中英关键词（已控制在 100 字符内） |
| `metadata/age-rating.md` | 年龄分级问卷答案（评级 4+） |
| `metadata/app-privacy.md` | 隐私"营养标签"答卷（不收集数据） |
| `metadata/review-notes.md` | 给审核员的测试说明（英文，可直接粘贴） |
| `legal/privacy-policy-zh.md` / `-en.md` | 隐私政策中英全文 |
| `legal/privacy.html` | 可直接托管的隐私政策网页（用作 Privacy Policy URL）|
| `icon/icon_1024.png` | 1024×1024 App 图标主图 |
| `icon/AppIcon.icns` | 全尺寸 icns |
| `screenshots/01~04 .png` | 4 张 2880×1800 App Store 截图 |
| `../xcodeproj/DuDuHanzi.xcodeproj` | **可直接 Archive 上传的 Xcode 项目**（已实测编译通过）|

**关键信息**
- App 名称：嘟嘟找别字 / DuDu: Spot the Hanzi
- Bundle ID（已设定）：`com.doesiot.duduhanzi`
- 版本：1.0（build 1）
- 价格：付费下载（具体价格你在 App Store Connect 选档位）
- 版权 / 联系：© 2026 嘟嘟的哥哥叫铛铛 · xadoo@gmail.com

---

## 🔒 二、必须你本人完成（涉及账号、付款、私钥，无法代办）

1. **注册 Apple Developer Program**（¥688/年）— developer.apple.com
2. 等账号激活后，因为是**付费 App**，在 App Store Connect →「协议、税务和银行业务」里：
   - 签署 *Paid Applications Agreement*
   - 填写**银行账户**和**税务信息**（中国区个人通常需身份证+银行卡）
   - ⚠️ 这一步不完成，付费 App 无法销售
3. 上架需要一个能公开访问的 **Privacy Policy URL** 和 **Support URL**：
   - 最简单：把 `legal/privacy.html` 传到 GitHub Pages 或任意静态托管，得到一个网址
   - Support URL 可以用同一个页面，或一个写了联系邮箱的简单页面

---

## 🚀 三、提交步骤（拿到开发者账号后）

### 第 1 步：在 Xcode 里配置签名
1. 双击打开 `xcodeproj/DuDuHanzi.xcodeproj`
2. 选中左侧 TARGETS → **DuDuHanzi** → **Signing & Capabilities**
3. 勾选 **Automatically manage signing**，**Team** 选你的开发者账号
4. （可选）把 **Bundle Identifier** 改成你想要的，如 `com.你的名字.duduhanzi`
   - 注意：改了要和 App Store Connect 里创建的 App 一致
5. 确认 **App Sandbox** 已存在（项目已内置 `DuDuHanzi.entitlements`，无需额外权限）

### 第 2 步：在 App Store Connect 创建 App
1. 登录 appstoreconnect.apple.com →「我的 App」→ ➕ 新建 App（平台选 macOS）
2. 填写：名称「嘟嘟找别字」、主要语言、Bundle ID（与 Xcode 一致）、SKU（随便起个唯一串如 `duduhanzi001`）
3. 进入 App 页面，按 `metadata/` 和 `legal/` 里的内容逐项填：
   - 描述、推广文本、关键词、分类 → 见 `listing-zh/en.md`、`keywords.md`
   - 隐私政策 URL → 你托管的 `privacy.html` 网址
   - App 隐私 → 见 `app-privacy.md`（选"不收集任何数据"）
   - 年龄分级 → 见 `age-rating.md`
   - 价格与销售范围 → 选付费档位、选地区
   - 截图 → 上传 `screenshots/` 里 4 张（macOS 截图栏）
   - 审核备注 → 见 `review-notes.md`

### 第 3 步：打包上传
1. Xcode 顶部目标选 **Any Mac (Apple Silicon, Intel)**
2. 菜单 **Product → Archive**（首次会编译一会儿）
3. Archive 完成后在 Organizer 窗口点 **Distribute App → App Store Connect → Upload**
4. 按向导一路 Next（自动签名会处理证书/描述文件），上传成功
5. 回 App Store Connect，等构建版本处理完（几分钟~1 小时），在 App 版本页「构建版本」里选中它
6. 点 **提交以供审核**

### 第 4 步：等待审核
- 通常 24–48 小时。被拒会收到邮件说明原因，改完重新提交即可。

---

## 🔁 重新生成资料的命令（改了游戏后）

```bash
# 重新生成图标（改了图标设计时）
bash build/build_icons.sh

# 重新生成截图（改了游戏 UI 时，先把最新 HTML 同步进 Xcode 项目）
cp 汉字找茬游戏.html xcodeproj/DuDuHanzi/game.html
swift build/generate_screenshots.swift appstore/screenshots xcodeproj/DuDuHanzi/game.html
```

> 注：`xcodeproj/DuDuHanzi/game.html` 是上架版游戏，和根目录的 `汉字找茬游戏.html` 内容一致；改了游戏记得同步过去。
