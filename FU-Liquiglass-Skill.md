# FU—Liquiglass — 把 AI 生成的网页升级成 Apple 风格液态玻璃

> *"一个面向 Codex 的开源 UI 美化 Skill，把普通网页升级为克制、清晰、可访问的 Apple 风格液态玻璃体验。"*

🔗 **GitHub**: <https://github.com/gerrywrittenhousea76-design/fu-liquiglass-skill>
📜 **License**: MIT
🌐 **中英双语**: 完整中文介绍 + English introduction
🎯 **定位**: 专注于「液态玻璃」美学的 Codex Skill

---

## 📖 项目简介

**FU—Liquiglass** 是一个为 Codex（以及所有兼容 [Agent Skills 规范](https://agentskills.io) 的 Agent 运行时）打造的 **UI 美化 Skill**。

它的目标不是「加个 `backdrop-filter` 就算液态玻璃」，而是把**液态玻璃当成一套完整的设计 + 工程系统**：

- ✅ 半透明导航、下拉菜单、卡片、浮层、按钮的统一语言
- ✅ 背景模糊、折射感、玻璃染色、边缘高光、空间阴影
- ✅ 克制的 hover、展开、收起、状态切换动效
- ✅ 桌面 / 平板 / 移动端触屏交互适配
- ✅ 键盘操作、焦点样式、`prefers-reduced-motion`、强制颜色模式
- ✅ 浏览器降级方案 + 模糊性能审计
- ✅ **保留原有框架和内容**，不做整体重写

最特别的是：**自带一个对比演示页 + 故意做坏的 AI 练习页**，让你能直观看到 Before / After 差距，并用来测试 Skill 效果。

---

## 🎯 为什么值得关注

### 1. 直击「劣质 AI 网页」的痛点

现在用 AI 生成落地页，最大的问题是**「能用但难看」**——大量半透明卡片、毫无章法的模糊、千篇一律的渐变。

FU—Liquiglass 的解法：

> 把玻璃当成一种**材料**，而不是一个属性。

它强迫 Codex **先想清楚**：
- 背景是什么？（决定折射方向）
- 玻璃有哪几层？（决定 z-index / 阴影梯度）
- 文字怎么读？（决定对比度策略）
- 鼠标怎么动？（决定 hover 状态机）

然后再写代码。结果是**从「AI slop」变成「官网质感」**。

仓库里的 `assets/demo/ai-slop.html` 是一个故意做坏的 AI 生成页，用 `使用 $fu-liquiglass 优化 ai-slop.html` 一句话就能把整个页面重新设计。

### 2. 自带审计脚本，质量有保证

```bash
node skill/fu-liquiglass/scripts/liquiglass-audit.mjs /path/to/project
node skill/fu-liquiglass/scripts/liquiglass-audit.mjs /path/to/project --strict
```

审计项包括：

- `backdrop-filter` 与 Safari 兼容性
- 模糊不支持时的清晰降级
- `prefers-reduced-motion` 适配
- 键盘焦点样式
- 响应式布局
- 玻璃设计变量（tokens）是否抽出
- 边缘高光是否存在
- `forced-colors` 模式支持

**这种「Skill + 静态审计工具」的组合**，在同类项目中很少见——大多数 Skill 只管「怎么写」，不管「写完对不对」。

### 3. 双语 + 设计声明，规避商标风险

README 里有一节叫**「设计声明」**：

> FU—Liquiglass 使用原创代码和原创演示素材复现液态玻璃的材质、层级、交互与动效原则，**不包含 Apple 商标、产品图片、专有字体文件或受保护的网站内容**。

这种「我致敬但不抄」的边界感，是负责任的开源姿态。

---

## 📂 项目结构

```
fu-liquiglass-skill/
└── skill/fu-liquiglass/
    ├── SKILL.md                          ← Skill 主体定义
    ├── agents/openai.yaml                ← OpenAI 兼容的 agent 元数据
    ├── assets/demo/                      ← 演示页面
    │   ├── before-after.html             ← 左右对比演示
    │   ├── ai-slop.html                  ← 故意做坏的"劣质 AI"练习页
    │   └── index.html                    ← 无依赖的完整效果页
    ├── references/
    │   ├── visual-system.md              ← 视觉系统设计规范
    │   ├── implementation.md             ← 实现细节（CSS / 动效 / 响应式）
    │   └── qa-checklist.md               ← 质量检查清单
    └── scripts/
        └── liquiglass-audit.mjs          ← 静态审计脚本
```

| 模块 | 用途 |
|------|------|
| **SKILL.md** | Codex 加载后看到的工作流定义 |
| **agents/openai.yaml** | OpenAI 生态（Codex、Cursor 等）的元数据 |
| **visual-system.md** | 设计语言：层级、材质、色板、阴影规则 |
| **implementation.md** | 工程落地：CSS 变量、动效曲线、响应式断点 |
| **qa-checklist.md** | 上线前自检表 |
| **liquiglass-audit.mjs** | 自动化审计工具，CI 可集成 |

---

## 🚀 如何使用

### 方式一：作为 Codex Skill 加载

```bash
# 克隆仓库
git clone https://github.com/gerrywrittenhousea76-design/fu-liquiglass-skill.git

# 复制到 Codex Skills 目录
cp -R fu-liquiglass-skill/skill/fu-liquiglass ~/.codex/skills/

# 重启 Codex
```

加载后用 `$fu-liquiglass` 前缀显式调用：

```
使用 $fu-liquiglass，把当前网页的导航栏改造成响应式 Apple 风格液态玻璃导航。
```

或者直接描述目标，Codex 会自动触发：

```
优化这个网页的整体 UI。使用克制的液态玻璃设计，加入半透明导航、背景折射、
边缘高光、hover 展开和移动端菜单，同时保证文字清晰和性能。
```

### 方式二：作为参考模板（适用于任何 Agent 运行时）

直接把 `skill/fu-liquiglass/` 这个文件夹的 SKILL.md 模板拷过来，把 `references/` 改成你自己领域的内容——你就有了一个**结构化、含审计、含演示页**的高质量 Skill 模板。

### 方式三：纯前端方案

即使不用 Skill，也可以照抄 `references/implementation.md` 和 `qa-checklist.md` 到自己的项目里：

```css
/* 玻璃材质示例（来自 SKILL.md） */
.glass-surface {
  background: hsl(var(--glass-tint) / 0.55);
  backdrop-filter: blur(20px) saturate(180%);
  border: 1px solid hsl(var(--glass-edge) / 0.3);
  box-shadow:
    0 1px 0 hsl(0 0% 100% / 0.5) inset,        /* 边缘高光 */
    0 8px 24px hsl(220 30% 10% / 0.12);       /* 空间阴影 */
}
```

---

## 💡 推荐用法（由浅入深）

| 阶段 | 用法 | 收益 |
|------|------|------|
| 🟢 **尝鲜** | 打开 `assets/demo/before-after.html`，左右对比感受差距 | 直观理解「液态玻璃」真不是加个 blur |
| 🟢 **尝试** | 用 `$fu-liquiglass 优化 ai-slop.html` 跑一次 | 看 Skill 怎么把劣质 AI 页升级成官网质感 |
| 🟡 **日常** | 在自己的落地页 / 仪表盘 / 控制中心引入 | 立刻提升品牌感，半天就能改完 |
| 🟡 **接入** | 把 `liquiglass-audit.mjs` 加到 CI | 防止后续 PR 把玻璃效果搞坏 |
| 🟠 **适配** | 把 `references/visual-system.md` 的设计语言挪到 React/Vue 组件库 | 沉淀为团队 Design System |
| 🔴 **定制** | 基于它的 SKILL.md 模板，写自己领域的 UI Skill（仪表盘 / 表单 / 设置中心…） | 形成可复用资产 |
| ⚫ **二开** | fork 项目，新增「深色模式」/ 「无障碍专项」/ 「WebGL 折射增强」 | 给社区贡献 |

> 💬 **核心建议**：先去 `ai-slop.html` 跑一次，**看 Skill 怎么思考**比看 Skill 怎么写代码更有价值。

---

## 🔗 相关资源

- **官方仓库**: <https://github.com/gerrywrittenhousea76-design/fu-liquiglass-skill>
- **问题反馈**: <https://github.com/gerrywrittenhousea76-design/fu-liquiglass-skill/issues>
- **同类 Skill（推荐对比阅读）**:
  - [`xchacha20-poly1305/liquid-glass-css-skill`](https://github.com/xchacha20-poly1305/liquid-glass-css-skill) — 同主题的 CSS 方向版本
  - [`anthropics/skills`](https://github.com/anthropics/skills) — Agent Skills 官方规范仓库
- **液态玻璃生态**:
  - [`DavidAlphaFox/liquid-glass-react`](https://github.com/DavidAlphaFox/liquid-glass-react) — WebGL 位移贴图实现（视觉最强）
  - iOS 26 官方 Liquid Glass、Flutter Liquid Glass、Compose LiquidGlass 等不同平台实现

---

## ✍️ 写在最后

> 液态玻璃的本质不是 `backdrop-filter`，而是**对材料、层级、光影、动效的系统化设计**。

FU—Liquiglass 最有价值的地方，不是它给的 CSS 片段，而是它**改变了你和 AI 协作的方式**：

以前你说「加个毛玻璃」，AI 就糊一层 `blur(20px)`。

现在你说「`$fu-liquiglass` 这个交互」，AI 会先问自己：
- 玻璃有几层？
- 光从哪边来？
- 文字对比度够吗？
- 移动端怎么折叠？

**你不是在调 CSS，是在引导 AI 按专家的工作流思考。**

这也是 Skills 体系真正的威力——它把**专家的方法论**打包成可复用的资产，让每个人都能用顶尖设计师的脑子干活。

**Clone it. Run the audit on your own site. $fu-liquiglass 🍸**