# Cognee — 给 AI Agent 装上「真记忆」

> *"The open-source AI memory platform for agents."*

🔗 **GitHub**: <https://github.com/topoteretes/cognee>
⭐ **Star**: ~5.5K（按用户口径核实）
📄 **论文**: [Optimizing the Interface Between Knowledge Graphs and LLMs for Complex Reasoning](https://arxiv.org/abs/2505.24478) — Markovic et al., 2025
🌐 **官网 / 文档**: <https://cognee.ai> · <https://docs.cognee.ai>
📦 **License**: 见仓库 `LICENSE`（默认 Apache 2.0）

---

## 📖 项目简介

**Cognee** 是一个**为 AI Agent 而生的开源长期记忆平台**，GitHub 上 `topoteretes` 组织维护。它解决的是 LLM 时代最朴素、也最头疼的问题：

> 你让 agent 帮你做研究、写代码、管项目，结果它**每次开新会话就完全失忆**——上一轮的口味、踩过的坑、做过的决策，统统归零。

Cognee 的答案是：把任何格式的数据（PDF、Markdown、代码、图片转录、聊天记录、Notion 导出……）摄取进来，**持续构建一个自托管的知识图谱**，让 agent 在每一次新会话里都能"想起"该想起的东西。

它把 **向量嵌入（vector embeddings）+ 图谱推理（graph reasoning）+ 认知科学本体生成（cognitive-science ontology）** 三件套焊到一起——文档不仅按"意义"被搜到，还按"关系"被连起来。

**核心理念**：

> 别让 agent 每轮重建世界观。把记忆**沉淀**进图谱，让它**按需召回**——而不是塞满上下文窗口。

---

## 🎯 为什么值得关注

### 1. RAG 的天花板只是「语义匹配」

传统 RAG（如 vector DB）能找**相似**的内容，但回答不了「X 和 Y 之间是什么关系」。Cognee 把向量、图谱、本体三件事一次性解决——文档按「意义」被搜到，按「关系」被连起来。

### 2. 一个 API，四种操作

整条 pipeline 浓缩成 4 个动词：

| 操作 | 做什么 |
|------|--------|
| `remember` | 把数据写入知识图谱（永久 / 临时 session 两种粒度） |
| `recall`   | 按问题召回，自动选最佳检索策略 |
| `forget`   | 精准删除某段记忆或整个 dataset |
| `improve`  | 让系统从反馈中持续学习 |

不需要自己拼 embedding、建图、写同步任务——`pip install cognee` 三行 Python 就能跑起来。

### 3. Agent 生态的「通用底座」

Cognee 不是某家 agent 的私货，**多个生态都接了它**：

- 🟦 **Claude Code** — 一行命令装 plugin，跨会话自动注入相关上下文
- 🟦 **Cursor** — IDE 内直接调用
- 🟦 **LangGraph** — 作为 stateful memory layer
- 🟦 **OpenClaw** — 有官方 MCP server，不用自己写胶水
- 🟦 **n8n** — 已有 community node，可视化编排
- 🟦 **Rust / TypeScript SDK** — 多语言集成

### 4. 背后是有论文的工程

不是又一个「好想法 demo」——项目配套发了 arXiv 论文（**2505.24478**），讲清楚 LLM 和 Knowledge Graph 之间的接口该怎么设计。API 是有理论兜底的，不容易半年后推翻。

### 5. 有学习能力的 Agent

记忆系统不是死水。Cognee 通过 `improve` 操作和 feedback loop，让 agent **越用越懂你**——结合 OTEL collector 和 audit trail，可观测、可追溯、可上线。

---

## 📂 涵盖能力清单

| 类别 | 能力 |
|------|------|
| 🧠 **记忆模型** | 向量召回 + 图谱推理 + 认知科学本体生成 |
| 📥 **数据摄取** | PDF、Markdown、纯文本、代码、图片转录、聊天记录（任何非结构化数据） |
| 🔍 **检索** | 语义相似度搜索、关系查询、自动路由 |
| 💾 **存储后端** | Postgres + PGVector / Neo4j / 内置 Kuzu，按需切换 |
| 🔌 **集成** | Claude Code plugin、Cursor、LangGraph、OpenClaw MCP、n8n |
| 🛠 **多语言 SDK** | Python（核心）、TypeScript、Rust |
| 🐳 **部署形态** | pip 包、CLI、Docker compose、Hub 预构建镜像 |
| ☁️ **托管** | Cognee Cloud（不想自运维也能用） |
| 📊 **可观测** | OTEL collector、多租户隔离、审计 trail |

### 典型适用场景

- 🏢 **公司大脑** — 把内部文档、Notion、Confluence、Slack 历史喂进去，agent「知道公司」在干嘛
- 📓 **个人助理长期记忆** — 跨会话记住你的偏好、未完成的任务、踩过的坑
- 📚 **学术 / 研究助手** — 读 100 篇 paper，自动建可推理的知识图谱
- 💻 **Coding Agent 上下文延续** — 跨项目、跨会话记住架构决策和命名约定

---

## 🚀 如何使用

### 方式一：Python SDK（最快上手，5 分钟）

需要 **Python 3.10 ~ 3.14**。

```bash
uv pip install cognee
export LLM_API_KEY="sk-..."
```

```python
import cognee, asyncio

async def main():
    # 永久记忆
    await cognee.remember("Cognee turns documents into AI memory.")
    # Session 记忆（fast cache，后台 sync 到永久图谱）
    await cognee.remember("User prefers detailed explanations.", session_id="chat_1")

    # 自动选最佳检索策略
    for r in await cognee.recall("What does Cognee do?"):
        print(r)

    # 删除
    await cognee.forget(dataset="main_dataset")

asyncio.run(main())
```

### 方式二：CLI

```bash
cognee-cli remember "Cognee turns documents into AI memory."
cognee-cli recall "What does Cognee do?"
cognee-cli forget --all

cognee-cli -ui   # 起 Docker MCP server + 本地 UI（需 docker）
```

### 方式三：Docker Compose（生产 / 团队用）

```bash
cp .env.template .env   # 至少填 LLM_API_KEY

docker compose up                            # API server on :8000
docker compose --profile ui up               # + 前端 :3000
docker compose --profile mcp up              # + MCP server :8001
docker compose --profile postgres up         # + Postgres / PGVector
docker compose --profile neo4j up            # + Neo4j
```

不克隆仓库也能跑——直接拉镜像：

```bash
docker run --env-file ./.env -p 8000:8000 --rm -it cognee/cognee:main
```

### 方式四：Claude Code Plugin（开发者最常用）

```bash
# 在启动 Claude Code 之前装好
claude plugin marketplace add topoteretes/cognee-integrations
claude plugin install cognee-memory@cognee

export LLM_API_KEY="sk-..."
claude
```

启动后会看到 `Cognee Memory Connected`。之后 Claude Code 每次会话：

- `UserPromptSubmit` 钩子 → 自动注入 dataset 上下文
- `PostToolUse` → 捕获工具调用轨迹
- `Stop` → 写回助手回复
- `PreCompact` → 上下文压缩前保留记忆
- `SessionEnd` → 把整段对话同步进永久知识图谱

你的 coding agent **真的有了记性**——而不是每轮从零开始。

---

## 💡 推荐用法（由浅入深）

| 阶段 | 动作 | 收益 |
|------|------|------|
| 🟢 **尝鲜** | `pip install cognee`，跑上面那段 SDK 示例 | 5 分钟看到图谱建起来 |
| 🟢 **上手** | 在 Claude Code 装 plugin，跨会话跑两次 coding 任务 | 直观感受 agent 自动回忆 |
| 🟡 **整合** | 把项目里的文档 / 设计稿 / Notion 全部 `remember` 进同一个 dataset | 团队级「公司大脑」雏形 |
| 🟡 **生产化** | 切 Postgres + Neo4j profile，开 OTEL 和多租户隔离 | 满足审计 / 合规 / 上规模 |
| 🟠 **扩展** | 接 LangGraph / OpenClaw MCP / 自研 agent 框架 | Cognee 变成统一记忆层 |
| 🔴 **造轮子** | 读 arXiv 论文，写自己的 ontology 抽取 prompt | 业务专属知识建模 |

> 💬 **建议**：先别一上来就 Cloud / Neo4j。**本地 + 内置 Kuzu + Claude Code plugin** 是 90% 用户的甜蜜点。

---

## 🔗 相关资源

- 🏠 **官方仓库**: <https://github.com/topoteretes/cognee>
- 📚 **官方文档**: <https://docs.cognee.ai>
- 🌐 **官网**: <https://cognee.ai>
- 📄 **论文**: <https://arxiv.org/abs/2505.24478>
- 💬 **Discord**: <https://discord.gg/NQPKmU5CCg>
- 🧩 **Claude Code Plugin 仓库**: <https://github.com/topoteretes/cognee-integrations/tree/main/integrations/claude-code>
- 🦀 **Rust SDK**: <https://github.com/topoteretes/cognee-rs>
- 🐳 **Docker Hub**: `cognee/cognee`、`cognee/cognee-mcp`
- 📦 **PyPI（下载量）**: <https://pepy.tech/project/cognee>

---

## ✍️ 写在最后

> 记忆是智能的基石，不是 prompt 的附庸。

**先说一个拼写差异**——你给的项目名是 **「Cogny」**，但 GitHub 上查无此仓。最匹配你描述（"AI Agent 的长期记忆平台、~5.5K 星"）的实际仓库叫 **Cognee**（`topoteretes/cognee`），上面整篇介绍都是基于它写的。如果你找的就是这个名字，可以直接进；如果不是，告诉我，我再换一个候选。

Cognee 真正有意思的地方，不是它「又一个 RAG 工具」，而是它回答了一个 RAG 一直在回避的问题：

> **「记忆」和「检索」不是一回事。**

RAG 解决的是「找相似」，但真正的 agent 需要的是「记得发生过什么、关系是什么、为什么那样决定」。一旦把图谱拽进 stack，agent 的输出质量会**断崖式**跟别人拉开差距——不是因为模型更聪明，而是它终于有了**上下文**。

把这玩意儿装在 Claude Code 里跑一周，你会发现很难再回到「每次清空」的体验。

**`pip install cognee`，先 remember 一段，再 recall 看看。🚀**
