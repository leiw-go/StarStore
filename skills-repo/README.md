# Skills 备份

本目录是 **skill 备份** —— 每个 skill 的真正生效位置在 `~/.claude/skills/`。Claude Code 启动时只扫描 `~/.claude/skills/`，不会自动加载此目录。

> 用途：在 iCloud 仓库里留一份副本，方便跨机器同步和版本管理。

---

## 🏷️ 兼容性标签说明

| 标签                              | 含义                                                                                     |
| ------------------------------- | -------------------------------------------------------------------------------------- |
| 🔴 **Claude 专属**                | 只在 Claude（Code / API / .ai）下有意义，移植到其他 agent 几乎肯定失效                                     |
| 🟡 **需 Claude Code / Codex 环境** | 依赖 Claude Code 或 Codex 的 subagent / MCP / Skill 工具链。在其他支持 Agent Skills 标准的 agent 上需要适配 |
| 🟢 **平台/工具特定**                  | 不是 Claude 专属，但锁定特定平台或外部工具（如 macOS、Shadowrocket）                                        |
| 🔵 **基本可移植**                    | 内容是任务型指令，不依赖特定 agent 能力，任何遵守 Agent Skills 标准的 agent 都能用                                |

---

## 🔴 Claude 专属（2 个）

- **claude-api** — Claude API / Anthropic SDK 参考（模型 ID、定价、参数、token 计算、API 迁移）。内容本身就是 Claude 平台，**完全无法移植**
- **web-artifacts-builder** — 用 React、Tailwind、shadcn/ui 构建复杂的 **claude.ai HTML artifact**。artifact 是 claude.ai 的专有概念，其他 agent 没有

## 🟡 需 Claude Code / Codex 环境（3 个）

- **skill-creator** — 创建 / 改进 / 衡量 skill 性能。**大量使用 Claude Code 的 subagent 跑测试**（`claude -p`、TaskOutput、Workflow 工具）。移植需要重写测试流程
- **webapp-testing** — 用 Playwright 测试本地 Web 应用。**依赖 Claude Code 的 Playwright MCP 集成**（工具名 `mcp__playwright__*`）。其他 agent 需要先实现同样的 MCP server
- **mcp-builder** — 创建 MCP（Model Context Protocol）server。**默认目标平台是 Claude Code**，导出的工具命名遵循 Claude Code 习惯（`mcp__servername__toolname`）

## 🟢 平台/工具特定（1 个）

- **proxy-helper** — 中国大陆代理辅助。**依赖 macOS + Shadowrocket + 辅助功能权限**（AppleScript 控制菜单栏）。脚本里都是 macOS 命令（`osascript`、`lsof`、`ifconfig`），不能直接用在 Linux/Windows

## 🔵 基本可移植（13 个）

这些 skill 的内容是任务型指引（"做某事时按这个流程"），不依赖任何特定 agent 的工具。可以直接复制到任何支持 Agent Skills 标准的 agent（Cursor、Windsurf、Codex、Aider 等）的 skills 目录：

| Skill             | 一句话作用                                |
| ----------------- | ------------------------------------ |
| algorithmic-art   | 用 p5.js 和种子随机数生成算法艺术，支持交互式参数探索       |
| brand-guidelines  | 应用 Anthropic 品牌色和字体到 artifact        |
| canvas-design     | 用设计哲学创建精美的视觉艺术作品（.png 和 .pdf）        |
| doc-coauthoring   | 协作撰写文档的结构化工作流（提案、技术规格、决策文档）          |
| docx              | 创建、读取、编辑 Word 文档（含格式、表格、图片、跟踪更改）     |
| frontend-design   | 新 UI 或重构现有 UI 的视觉设计指导                |
| fu-liquiglass     | Apple 风格的液态玻璃 UI 设计（半透明、模糊、折射）       |
| internal-comms    | 写内部沟通文档（状态报告、领导更新、事件报告）              |
| pdf               | PDF 处理（合并拆分、旋转、加密、文本提取、OCR）          |
| pptx              | PPT 演示文稿创建、解析、修改                     |
| slack-gif-creator | 创建针对 Slack 优化的动画 GIF                 |
| theme-factory     | 给幻灯片、文档、HTML 等 artifact 应用主题（10 个预设） |
| xlsx              | Excel 电子表格处理（公式、格式化、图表、数据清洗）         |

> brand-guidelines 虽带 Anthropic 品牌色，但**应用方式**（"匹配背景色"、"字体层级"）是通用设计原则，可以替换品牌色用于任何品牌。

---

## 🔧 同步到 Claude skills 目录

```bash
# 一键链接全部（注意：可能覆盖同名 skill）
ln -s "/Users/leiw/Library/Mobile Documents/iCloud~md~obsidian/Documents/MyEbrain/StarStore/skills/"*/ ~/.claude/skills/

# 选择性安装某个
ln -s "/Users/leiw/Library/Mobile Documents/iCloud~md~obsidian/Documents/MyEbrain/StarStore/skills/proxy-helper" ~/.claude/skills/proxy-helper
```

> ⚠️ 如果 `~/.claude/skills/` 已存在同名 skill，软链接会失败（目录已存在）。先 `rm -rf` 旧的再链接，或者用 `cp -R` 复制。

---

## 📊 元信息

| 项目 | 数值 |
|---|---|
| Skill 总数 | 19 |
| 🔴 Claude 专属 | 2 |
| 🟡 需 Claude Code / Codex | 3 |
| 🟢 平台特定 | 1 |
| 🔵 可移植 | 13 |
| 数据来源 | `~/.claude/skills/` |
| 汇总时间 | 2026-07-02 |