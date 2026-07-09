# DeerFlow — 字节跳动的开源 Super Agent 框架

> *"An open-source long-horizon SuperAgent harness that researches, codes, and creates."*

🔗 **GitHub**: <https://github.com/bytedance/deer-flow>
🌐 **官网**: <https://deerflow.tech>
⭐ **Star**: ~33K+（截至 2026 年中，数字每天在涨）
📜 **协议**: MIT
🐍 **技术栈**: Python · LangGraph 1.0 · LangChain · Docker

> ⚠️ **名字澄清**："Dify-Flow" 多半是 **DeerFlow** 的口语化记忆。DeerFlow 隶属 `bytedance/`；`langgenius/dify` 是另一家公司的 LLM 编排平台 —— 名字相近但**完全无关**。

---

## 📖 项目简介

**DeerFlow**（**D**eep **E**xploration and **E**fficient **R**esearch **Flow**）是字节跳动 2025 年 5 月首次开源、**2026 年 2 月 28 日发布 2.0 彻底重写**的 Super Agent 框架。它的定位不是聊天机器人，也不是普通 Agent SDK，而是 **"Super Agent Harness"** —— 一台让多个 AI Sub-Agent 协作、能实际执行代码、直接产出报告 / 网页 / PPT / 视频 / 播客的完整运行环境。

官方一句话总结：**1.0 是"帮你查资料写报告"，2.0 是"给 AI 一台带大脑的电脑，让它自己干完一个完整项目"**。2.0 上线当天即登顶 **GitHub Trending 全球第一**，官方推荐模型是 **Doubao-Seed-2.0-Code / DeepSeek v3.2 / Kimi 2.5**（均走 OpenAI 兼容接口）。它没锁定任何模型厂商，2.0 与 1.0 没有共用一行代码，旧版 Deep Research 仍保留在 `main-1.x` 分支。

---

## 🎯 为什么值得关注

### 1. 给 Agent "一台真正的电脑"

多数 Agent 框架止步于调 API、写文件、跑脚本。DeerFlow 通过 **Docker 沙箱**给每个任务独立容器，Agent 进去可任意 Bash、写文件、跑 Python / 长任务 / 后台进程、浏览器自动化。而且**默认关掉 `allow_host_bash`**，配合路径检测 + 多层隔离，LLM 基本搞不坏宿主机。是目前开源 Agent 框架里**工程化最完整**的沙箱。

### 2. Lead Agent + Sub-Agents 并行编排

主 Agent 理解意图、拆计划；**子 Agent 在隔离上下文里并行执行**（搜资料 / 写代码 / 跑分析），结果汇总。社区文章称这种并行能把复杂任务提效 3-5 倍。所有 Sub-Agent 共享持久记忆 + Skills 库 + 文件系统，但各自的对话上下文互不污染。

### 3. Skills = 一个 Markdown 文件

**一个 Skill = 一个 `.md` 文件**，描述工作流、最佳实践和参考资源。仓库内置研究、报告、PPT、前端、视频等公共 Skill；你可以在 `skills/custom/` 下扔一份 Markdown 造一个新能力，Agent **按需加载**，不污染主上下文。和 [`anthropics/skills`](../Anthropic-Skills.md) 的 SKILL.md 设计几乎同源，但 DeerFlow 自带多模型兼容层。

### 4. 出厂级工程细节

- **统一网关**：nginx（默认 2026）+ LangGraph 服务器 + FastAPI REST API
- **部署模式**：本地 / Docker Dev / Docker Prod + 单 daemon / 多 worker
- **数据后端**：`sqlite` 或 `postgres`（checkpointer、Store、应用数据共用）
- **可观测性**：LangSmith / Langfuse 开箱即用
- **MCP + IM 渠道**：HTTP/SSE/OAuth 全支持；Telegram、Slack、Feishu/Lark、企业微信、钉钉、微信 **无需公网 IP**
- 配套：调度任务、终端 TUI、Embedded Python Client

### 5. 一行 prompt 让别的 AI 帮你装

```
Help me clone DeerFlow if needed, then bootstrap it for local development
by following https://raw.githubusercontent.com/bytedance/deer-flow/main/Install.md
```

直接发给 Claude Code / Codex / Cursor / Windsurf，对方会自动 clone → 选 Docker → 停在下一步等 API Key。

---

## 📂 涵盖能力清单

| 模块 | 要点 |
|------|------|
| 🧠 Skills & Tools | Markdown 定义的技能 + MCP 扩展，按需加载 |
| 🤝 Coding Agent 集成 | 一行 prompt 引导 Claude Code / Codex / Cursor / Windsurf 自动部署 |
| 🎯 Session Goals | 长跑任务的目标追踪、子任务管理 |
| 👥 Sub-Agents | 并行调度 + 上下文隔离 + 结果汇总 |
| 🛡 Sandbox & File System | Local / Docker / K8s 三种沙箱；挂载点 `/mnt/user-data/{uploads,workspace,outputs}` |
| 🧩 Context Engineering | 短期 + 长期记忆 + 上下文压缩防失忆 |
| 🧪 多模型兼容 | OpenAI 兼容协议；Doubao / DeepSeek / Kimi / Qwen / Claude / GPT 全支持 |
| 🐍 Embedded Python Client | 把 DeerFlow 当 SDK 嵌入自家 Python 应用 |
| ⏰ Scheduled Tasks | 定时 / 周期任务 |
| 💻 Terminal Workbench (TUI) | CLI 派友好的终端 UI |
| 💬 IM 渠道 | Telegram / Slack / Feishu / Lark / WeCom / DingTalk / WeChat |
| 📈 Tracing | LangSmith / Langfuse 一键开启 |
| 🌐 多语言文档 | 英 / 中 / 日 / 法 / 俄 |

---

## 🚀 如何使用

### 方式一：让 AI 编程助手一键装（最省事）

```
Help me clone DeerFlow if needed, then bootstrap it for local development
by following https://raw.githubusercontent.com/bytedance/deer-flow/main/Install.md
```

### 方式二：手动装（推荐先跑通一次）

```bash
git clone https://github.com/bytedance/deer-flow.git
cd deer-flow

make setup        # 交互式向导，选 LLM / 沙箱 / API key
make doctor       # 验证环境；出问题可跑 make support-bundle 生成 debug 包
make docker-init  # 首次或镜像更新才需要
make docker-start # 起本地服务 + 沙箱
# 浏览器开 http://localhost:2026 即可使用
```

> 🇨🇳 **国内网络**：受限网络先 export：`export UV_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple` 和 `export NPM_REGISTRY=https://registry.npmmirror.com`

不想用 Docker 就 `make install && make dev`（**Windows 仅在 Git Bash 下支持**）。

### 生产部署 / 最小任务示例

```bash
make up    # 构建镜像 + 启动全部服务（持久化建议 database.backend: postgres）
make down
```

打开 `http://localhost:2026` 跑个中等任务试试：「研究『2026 年 AI Agent 框架』前 5 个开源项目，对比架构 / 扩展性 / 社区活跃度，产出带图表的中文网页报告。」DeerFlow 会自动拆计划 → 并行 Sub-Agent 搜索 → 沙箱跑代码生成图表 → 输出到 `/mnt/user-data/outputs/`。

---

## 💡 推荐用法（按场景）

| 场景 | 做法 | 收益 |
|------|------|------|
| 🟢 尝鲜 | Web UI 直接发任务（调研 / 写代码 / 写报告） | 体感比闭源 Deep Research 更能干活 |
| 🟢 学架构 | 读 `backend/docs/CONFIGURATION.md` 和 `SANDBOX_*.md` | 吃透 LangGraph + Docker 沙箱套路 |
| 🟡 自托管 | 切 `postgres` + nginx 反代 + 域名 + HTTPS | 企业内网可用的私有 AI Agent |
| 🟡 接 IM | 启 Feishu / Slack / Telegram channel | 群里直接派任务 |
| 🟠 造 Skill | 在 `skills/custom/` 扔 Markdown | 领域能力零代码扩展 |
| 🟠 嵌产品 | 用 Embedded Python Client 或 `/api/*` | 把 DeerFlow 当引擎接 SaaS |
| 🔴 进生产 | 多 worker + Redis Stream Bridge + K8s 沙箱 | 扛多人 / 长跑 / 审计 |

> ⚠️ **小提醒**：第一次跑别开宿主机 bash。保留默认 Docker 沙箱 + `allow_host_bash: false`，跑熟再按需放开。

---

## 🔗 相关资源

- **官方仓库**: <https://github.com/bytedance/deer-flow>
- **官网 / Demo**: <https://deerflow.tech>
- **中文 README**: `bytedance/deer-flow/blob/main/README_zh.md`
- **1.x 分支**（旧版 Deep Research）: <https://github.com/bytedance/deer-flow/tree/main-1.x>
- **同类 / 易混项目**:
  - `langgenius/dify` —— Dify 官方 LLM 编排平台，**和 DeerFlow 完全无关**
  - `msitarzewski/agency-agents` —— 角色化 Agent Prompt 合集
  - `anthropics/skills` —— Anthropic 官方的 SKILL.md 仓库
  - OpenAI Deep Research —— 闭源对应物

---

## ✍️ 写在最后

> 2026 年 AI Agent 框架已经审美疲劳，但 DeerFlow 试着回答的是一个**工程问题**：

> **怎么让一群 AI 像真团队，把"分钟到小时"量级的项目从计划到交付跑完？**

把 Sub-Agents、持久记忆、沙箱执行、Markdown Skills、IM 渠道这些**原本每个都要自己拼**的基础设施打包好，是 DeerFlow 最朴素、也最"硬核"的价值。

它不一定最优雅，但大概率是**最像"出厂级 Agent Harness"** 的那一个。

**Clone it, run `make setup`, ship your first super-agent. 🦌🚀**
