# Agency Agents — 一支随叫随到的 AI 专家团队

> *"A complete AI agency at your fingertips — from frontend wizards to Reddit community ninjas, from whimsy injectors to conversion optimizers."*

🔗 **GitHub**: <https://github.com/msitarzewski/agency-agents>
⭐ **Star**: 30k+
📜 **License**: MIT
🌐 **中文社区版**: <https://github.com/jnMetaCode/agency-agents-zh>

---

## 📖 项目简介

**Agency Agents** 是 GitHub 上最火的「AI 角色提示词合集」之一，最初源自 Reddit 上 *"如果你想开一家一人公司 / solo agency，需要哪些 AI 角色"* 的讨论，由 [msitarzewski](https://github.com/msitarzewski) 整理并开源。

它收录了 **55+ 个** 高度专业化的 AI Agent 角色提示词，**覆盖工程、设计、营销、产品、增长、运营、测试、学术、空间计算等 9 大职能部门**，每个 Agent 都拥有：

- **独特的人格设定**（性格、口头禅、工作风格）
- **完整的工作流**（从接收需求到交付物的全流程）
- **可量化的交付标准**（不是空话，是真能拿来用的 checklist）
- **配套命令 / Slash commands**（`/build-landing-page`、`/ship-mvp` 等）

**核心理念**：

> 别再用一个通用 prompt 指挥 AI 干所有事。让它**扮演一个真正的专家**——有自己的审美、流程、产出标准——效果会完全不一样。

---

## 🎯 为什么值得关注

### 1. 通用 Prompt 的天花板很明显

你写一段：

> "帮我写个登录页面"

AI 给你一段**能用但平庸**的 HTML。

但你换成 `Frontend Designer` Agent：

> "I need a conversion-optimized SaaS landing page. Target: indie hackers. Tone: confident but not corporate. Reference: Linear's homepage structure."

它会给你：
- 完整信息架构（Hero → Social Proof → Features → CTA）
- 排版细节（字距、行高、断点）
- A/B 测试建议
- 还能直接拆分成 3 个可执行的 PR

**「专家角色 + 工作流 + 交付标准」三件套**，是 Agency Agents 最有杀伤力的设计。

### 2. 真正的「一人公司」范式

这个项目的隐含野心是：

> **未来一个人 + 一套 Agent = 一家完整的数字机构**

- 产品调研 → `Reddit Community Ninja` 翻 Reddit / HN / X 找痛点
- 落地页 → `Frontend Designer` 出设计稿和代码
- 文案 → `Conversion Rate Optimizer` 改 hero copy
- SEO → `SEO Specialist` 铺关键词
- 增长 → `Growth Hacker` 设计 referral 机制
- 客服 → `Customer Support Lead` 写 SOP

一个人就能跑起一家 SaaS。

### 3. 学习顶尖专家的「思维模板」

读 `Frontend Designer` 的 SOUL.md，本质上是在读一份**浓缩的资深前端方法论**：

- 它会怎么拆分组件？
- 它在意哪些设计细节？
- 它交付前会做哪些检查？

这些**「内化的专业标准」**比读 10 篇博客都有用。

---

## 📂 涵盖领域（部分）

| 部门 | 代表 Agent |
|------|-----------|
| 🎨 **Design** | Frontend Designer、UI Engineer、Brand Strategist、Illustrator |
| ⚙️ **Engineering** | Backend Engineer、DevOps、Code Reviewer、QA Engineer、Tech Writer |
| 📈 **Marketing** | Reddit Community Ninja、Content Strategist、Copywriter、SEO Specialist |
| 💼 **Product** | Product Manager、UX Researcher、User Researcher |
| 📊 **Growth** | Growth Hacker、Conversion Optimizer、Analyst |
| 🛠 **Operations** | Project Manager、Customer Support Lead |
| 🎓 **Academic** | Research Assistant、Literature Reviewer |
| 🥽 **Spatial** | XR Designer、3D Asset Creator |
| 🎭 **Specialists** | Whimsy Injector、Brand Storyteller、Meme Expert |

完整列表见仓库目录树（按部门组织）。

---

## 🚀 如何使用

### 方式一：Claude Code（推荐）

```bash
# 1. 克隆仓库
git clone https://github.com/msitarzewski/agency-agents.git

# 2. 运行集成脚本（自动复制到对应工具的配置目录）
./scripts/install.sh --tool claude-code    # Claude Code
./scripts/install.sh --tool cursor         # Cursor
./scripts/install.sh --tool copilot        # GitHub Copilot
./scripts/install.sh --tool codex          # Codex
./scripts/install.sh --tool gemini         # Gemini CLI
./scripts/install.sh --tool aider          # Aider
./scripts/install.sh --tool windsurf       # Windsurf
./scripts/install.sh --tool trae           # Trae
./scripts/install.sh --tool kiro           # Kiro

# 也支持 OpenClaw、Codebuff 等
```

重启 IDE 后，输入 `/agents` 就能看到所有角色。

### 方式二：手动参考

直接打开 `engineering/frontend-designer/SOUL.md` 这类文件，读它的：

- **IDENTITY** — 这个角色是谁、信什么、反对什么
- **WORKFLOW** — 接到任务后第一步做什么、第二步做什么
- **DELIVERABLES** — 交付前必须满足的 checklist
- **COMMANDS** — 可以用的 slash commands

把里面的工作流提取出来，套到自己的项目里。

### 方式三：自定义新角色

仓库的 `examples/` 目录里有完整的角色模板，按格式填空就能造自己的 Agent。社区已经贡献了上百个自定义角色。

---

## 💡 推荐用法（由浅入深）

| 阶段 | 用法 | 收益 |
|------|------|------|
| 🟢 **尝鲜** | 在 Cursor 里加载 1-2 个 Agent，用 `/build-landing-page` 跑一次 | 直观感受「专家 prompt vs 通用 prompt」 |
| 🟡 **日常** | 把 `Code Reviewer`、`SEO Specialist`、`Tech Writer` 这类高频角色常驻 | 日常开发效率立竿见影 |
| 🟠 **专项** | 接一个新项目时，按部门招募 5-8 个 Agent 组成临时团队 | 模拟真实 agency 的协作流 |
| 🔴 **进阶** | 读完所有 SOUL.md，提炼出**属于自己的工作流模板** | 把外部最佳实践内化成自己的能力 |
| ⚫ **造轮子** | fork 项目，造一个自己的 `agency-agents-cn` / `agency-agents-X` | 已经有中文社区版（215 agents），动手门槛不高 |

> 💬 **建议**：先别全装，挑**当前项目最缺的 1 个角色**开始用，效果立竿见影后再扩展。

---

## 🌏 中文社区版

如果英文阅读吃力，可以直接看中文社区版：

- **仓库**: <https://github.com/jnMetaCode/agency-agents-zh>
- **规模**: **215 个智能体 · 18 个部门 · 17 种 AI 工具支持**
- **特点**:
  - 完整翻译了上游 165 个英文 Agent
  - **新增 50 个中国市场原创 Agent**（小红书运营、抖音脚本、私域 SOP 等）
  - 部门划分更细，新增游戏、安全、金融、电商等

---

## 🔗 相关资源

- **官方仓库**: <https://github.com/msitarzewski/agency-agents>
- **中文社区版**: <https://github.com/jnMetaCode/agency-agents-zh>
- **作者的灵感来源**: Reddit r/ArtificialIntelligence 上的 "If you had to staff a one-person agency with AI agents..." 讨论
- **配套工具**: Cursor / Claude Code / Windsurf / Aider / Trae / Kiro / OpenClaw 等

---

## ✍️ 写在最后

> 通用 AI 是工具，专家 AI 是同事。

Agency Agents 真正的价值，不是「**下载更多 prompt**」，而是强迫你**用专家的标准来要求 AI 的产出**。

当你习惯了 `Frontend Designer` 那种「动效必须顺滑、间距必须 8 的倍数、移动端必须测过 3 个断点」的交付标准，再回到通用 prompt，你反而会**不习惯**。

这是一种**被 AI 专家反向训练**的过程——你的品味也在被带高。

**Clone it, pick one agent, ship something. 🚀**