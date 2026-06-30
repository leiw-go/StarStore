# Anthropic Skills — Claude 官方 Agent Skills 仓库

> *"Public repository for Agent Skills — the open standard for packaging Claude's specialized capabilities."*

🔗 **GitHub**: <https://github.com/anthropics/skills>
📜 **协议标准**: <https://agentskills.io>
📦 **许可**: 大部分 Apache 2.0；文档类技能（docx/pdf/pptx/xlsx）为 Source-Available
🎯 **定位**: Anthropic 官方维护的 Skills 示例 + 规范定义 + 模板

---

## 📖 项目简介

**Anthropic Skills** 是 Anthropic 官方在 GitHub 上**开源**的 Skills 仓库，定位有三层：

1. **示例库（skills/）** — 展示 Skills 能做什么的真实案例
2. **规范定义（spec/）** — Agent Skills 开放标准的官方说明
3. **起步模板（template/）** — 拿来即用的 Skill 骨架

它和 [`msitarzewski/agency-agents`](https://github.com/msitarzewski/agency-agents) 的区别在于：

| | agency-agents | **anthropics/skills** |
|---|---|---|
| 来源 | 社区驱动（Reddit 讨论 → 开源） | **Anthropic 官方** |
| 风格 | 角色人格化（SOUL.md） | 任务工作流化（SKILL.md） |
| 焦点 | 团队 / 部门 / 角色 | 单点能力 + 通用规范 |
| 协议 | 自定义 | **Agent Skills 开放标准** |
| 装在哪 | 各种 AI 工具 | Claude Code / Claude.ai / Claude API |

**核心理念**：

> Skills 是 **Anthropic 力推的开放标准**——同一份 `SKILL.md`，理论上能跑在 Claude.ai、Claude API、Claude Code、Cursor、Windsurf 等任何支持该标准的 Agent 运行时上。

---

## 🎯 为什么值得关注

### 1. 这是「官方版参考答案」

你想自己造 Skill，最头疼的就是**格式对不对、字段怎么填、要不要引号**。这个仓库里有：

- ✅ **官方模板**（`template/`）— 严格符合规范的 SKILL.md 骨架
- ✅ **真实例子**（`skills/`）— 从创意到企业级的完整案例
- ✅ **规范文档**（`spec/`，指向 https://agentskills.io）— frontmatter 每个字段的约束、长度限制、命名规则

等于 Anthropic 把**「怎么写好一个 Skill」**这件事直接摊开给你看。

### 2. 你用的文档能力背后就是这些 Skill

Claude.ai 上传 PDF、Word、PPT、Excel 时，**底层调用的就是这四个 Skill**：

- `skills/docx` — Word 文档创建 / 编辑
- `skills/pdf` — PDF 表单填写 / 文本提取 / 合并
- `skills/pptx` — PPT 创建 / 排版
- `skills/xlsx` — Excel 公式 / 图表 / 数据透视

这四个是 **source-available**（不是 Apache 2.0）——Anthropic 特意开放给你**参考实现思路**，但不能拿去改一改就商用。

### 3. 渐进式披露（Progressive Disclosure）的工程范式

这是 Skills 体系最聪明的地方：

| 加载层级 | 内容 | Token 量级 |
|---------|------|-----------|
| **L1：启动时** | 所有 Skill 的 `name` + `description` | ~100 token / 个 |
| **L2：激活时** | 相关 Skill 的 SKILL.md 正文 | < 5000 token |
| **L3：用到时** | `scripts/`、`references/`、`assets/` 里的具体文件 | 按需 |

**写 1000 个 Skill 也不会污染上下文**——Claude 只在判断「这个任务和哪个 Skill 相关」时才加载相应内容。这是 Skills 区别于"超长 system prompt"的关键架构优势。

---

## 📂 仓库结构

```
anthropics/skills/
├── skills/                ← 示例 Skills
│   ├── docx/              ⚠ Source-Available（生产环境在用）
│   ├── pdf/               ⚠ Source-Available
│   ├── pptx/              ⚠ Source-Available
│   ├── xlsx/              ⚠ Source-Available
│   ├── creative/          ← 创意类（艺术、音乐、设计）
│   ├── development/       ← 技术类（Web 测试、MCP 生成）
│   └── enterprise/        ← 企业类（品牌指南、沟通模板）
│
├── spec/                  ← Agent Skills 规范（已迁移到 agentskills.io）
│
└── template/              ← 标准 SKILL.md 模板，拿来即用
```

### 涵盖的 Skill 类别

| 类别 | 代表 Skill |
|------|----------|
| 🎨 **Creative & Design** | Art generation、Music composition、Brand design |
| ⚙️ **Development & Technical** | Web app testing、MCP server generation |
| 🏢 **Enterprise & Communication** | Brand guidelines、Internal comms templates |
| 📄 **Document Skills** | docx、pdf、pptx、xlsx（生产级） |

---

## 🚀 如何使用

### 方式一：作为 Claude Code 插件市场（最简单）

```bash
# 1. 添加这个仓库作为插件市场
/plugin marketplace add anthropics/skills

# 2. 在 Claude Code 里：
#    - 浏览并安装插件
#    - 选择 anthropic-agent-skills
#    - 选择 document-skills 或 example-skills
#    - 点击 Install now

# 或者直接命令行安装：
/plugin install document-skills@anthropic-agent-skills
/plugin install example-skills@anthropic-agent-skills
```

安装后，**直接提需求就行**，Claude 会自动调用相关 Skill：

```
"Use the PDF skill to extract the form fields from path/to/some-file.pdf"
```

### 方式二：Claude.ai（付费版内置）

`example-skills` 里的所有示例 Skill 在 Claude.ai 付费版里**已经预装可用**，直接上传对应文件就能触发。

### 方式三：Claude API（Skills API）

```python
# 参考：https://docs.claude.com/en/api/skills-guide#creating-a-skill
# 通过 Skills API 上传自定义 Skill
```

### 方式四：作为模板自己造

```bash
# 克隆仓库
git clone https://github.com/anthropics/skills.git

# 复制 template 作为起点
cp -r skills/template my-skill

# 编辑 my-skill/SKILL.md
```

---

## 📋 Agent Skills 规范速查

### `SKILL.md` frontmatter 必填字段

| 字段 | 必填 | 约束 |
|------|------|------|
| `name` | ✅ | 1-64 字符，小写字母+数字+连字符，**不能以连字符开头/结尾**，**不能有连续连字符**，**必须和父目录同名** |
| `description` | ✅ | 1-1024 字符，描述「做什么 + 何时用」，含关键词帮助 Agent 触发 |

### 可选字段

| 字段 | 用途 |
|------|------|
| `license` | 协议名或协议文件引用 |
| `compatibility` | 最多 500 字符，说明环境要求（如"Designed for Claude Code"、"Requires Python 3.14+ and uv"） |
| `metadata` | 任意 key-value（`author`、`version` 等） |
| `allowed-tools` | 空格分隔的预批准工具列表（实验性），如 `Bash(git:*) Read` |

### 规范要点

- **SKILL.md 建议 < 500 行**——超出就拆到 `references/`
- **引用文件用相对路径**，且**尽量只引用一层**（避免深层链）
- **`scripts/`** 放确定性脚本（Python / Bash / JS 都可以）
- **`references/`** 放详细文档（`REFERENCE.md`、`FORMS.md`、领域专用如 `finance.md`）
- **`assets/`** 放模板、图片、查找表

### 最小示例

```markdown
---
name: my-skill-name
description: A clear description of what this skill does and when to use it.
---

# My Skill Name

[Instructions for Claude when this skill is active]

## Examples
- Example 1

## Guidelines
- Guideline 1
```

### 校验工具

```bash
# 官方校验器：https://github.com/agentskills/agentskills
skills-ref validate ./my-skill
```

---

## 💡 实战建议（由浅入深）

| 阶段 | 动作 | 收益 |
|------|------|------|
| 🟢 **看** | 把 `skills/template` 通读一遍 | 理解规范要求 |
| 🟢 **装** | Claude Code 里 `/plugin marketplace add anthropics/skills`，装 `example-skills` | 体验现成能力 |
| 🟡 **抄** | 挑一个最像你需求的 Skill（比如 `pdf`），完整读一遍它的 SKILL.md | 学习真实 Skill 怎么写 |
| 🟡 **改** | fork 一个 Skill，改 description 和 workflow 跑你自己的任务 | 跑通整个流程 |
| 🟠 **造** | 基于 `template/` 写一个你自己领域的 Skill | 形成可复用资产 |
| 🔴 **进阶** | 写 Skill + 配套脚本（`scripts/`）+ 参考文档（`references/`） | 达到 source-available 级别 |
| ⚫ **生态** | 把你的 Skill 整理成 Claude Code 插件或 API 上传 | 分发给团队 / 社区 |

> 💬 **核心建议**：**先抄后造**。直接看 `pdf/` 或 `xlsx/` 这种生产级 Skill，比读十篇教程有用。

---

## 🔗 相关资源

- **官方仓库**: <https://github.com/anthropics/skills>
- **官方插件市场命令**: `/plugin marketplace add anthropics/skills`
- **规范站点**: <https://agentskills.io>
- **规范文档**: <https://agentskills.io/specification>
- **Skills API 文档**: <https://docs.claude.com/en/api/skills-guide#creating-a-skill>
- **官方博客**: <https://anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills>
- **支持文档**:
  - [What are skills?](https://support.claude.com/en/articles/12512176-what-are-skills)
  - [Using skills in Claude](https://support.claude.com/en/articles/12512180-using-skills-in-claude)
  - [How to create custom skills](https://support.claude.com/en/articles/12512198-creating-custom-skills)
- **校验工具**: <https://github.com/agentskills/agentskills/tree/main/skills-ref>
- **相关项目**:
  - [`msitarzewski/agency-agents`](https://github.com/msitarzewski/agency-agents) — 角色化 Agent 库
  - [`jnMetaCode/agency-agents-zh`](https://github.com/jnMetaCode/agency-agents-zh) — 中文社区版（215 个角色）

---

## ✍️ 写在最后

> Skills 不只是「更结构化的 prompt」——它是 **Anthropic 力推的开放标准**。

它的野心是：**让任何 Agent 运行时（Claude、Cursor、Windsurf、自研系统）都能消费同一份 Skill**。

当一个标准由模型厂商主动推动、并把规范文档、实现例子、参考实现、校验工具**全部开源**——这是一个**生态级别的布局**，而不只是一个功能。

你今天写的每一个 Skill，未来都可能是**跨平台、跨模型可复用**的数字资产。

**Read the spec. Study the template. Ship your first skill. 🚀**