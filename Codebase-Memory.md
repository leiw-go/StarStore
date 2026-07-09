# Codebase-Memory — 给 AI Agent 一张代码库的「知识图谱」

> *"The fastest and most efficient code intelligence engine for AI coding agents."*

🔗 **GitHub**: <https://github.com/DeusData/codebase-memory-mcp>
⭐ **Star**: ~7.7K
📄 **论文**: <https://arxiv.org/abs/2603.27277>

---

## 📖 项目简介

**Codebase-Memory**（仓库名 `codebase-memory-mcp`）是 [DeusData](https://github.com/DeusData) 开源的**面向 AI 编程 Agent 的高性能代码智能 MCP 服务器**。

它干一件事：**把整个代码库解析成持久化的知识图谱（knowledge graph），存进本地 SQLite，让 Agent 通过结构化查询而非读文件来理解代码。**

> 别再让 Agent 一个文件一个文件 grep + read 了。把代码结构先提取成一张图，Agent 查图就行。

工程指标做到极致：

- **158 种语言**（内嵌 tree-sitter）
- 平均仓库**毫秒级**索引；**Linux 内核**（28M LOC / 75K 文件）**3 分钟**
- **亚毫秒级**结构化查询（< 1ms）
- 比 file-by-file 节省 **99.2% token**（5 查询 ~3,400 vs ~412,000）
- 单一静态二进制，**零依赖**，全平台
- 自动识别并配置 **11 个 coding agent**

背后 [arXiv 2603.27277](https://arxiv.org/abs/2603.27277) 论文支撑：31 个真实仓库评估——**答案质量 83%、token 减 10×、工具调用减 2.1×**。

---

## 🎯 为什么值得关注

### 1. 解决「上下文爆炸」

现状：任务 → LLM 一通 grep + read → 拼上下文 → 回答。代价是巨量 token 浪费 + 高延迟。

Codebase-Memory 换成：任务 → Agent 调一次图查询 → 拿到**结构化的函数/类/调用链** → 直接回答。一次 `trace_path` 胜过几十次 grep + read。

### 2. 14 个 MCP 工具，真正的「结构分析后端」

| 工具 | 用途 |
|------|------|
| `get_architecture` | 一口吐出语言/包/入口/路由/热点/分层/模块聚类 |
| `trace_path` | 函数调用链追踪（inbound / outbound） |
| `detect_changes` | uncommitted diff → 受影响符号 + 风险分级 |
| `find_dead_code` | 找零调用者函数（自动排除入口点） |
| `semantic_query` | 内嵌 Nomic nomic-embed-code 向量搜索，**无 API key / Ollama / Docker** |
| `search_graph` | 结构化搜索（regex / 标签 / 度数范围） |
| `manage_adr` | 架构决策记录跨会话持久化 |
| Cypher 工具 | `MATCH (f)-[:CALLS]->(g) WHERE f.name = 'main' RETURN g.name` |

### 3. Hybrid LSP：语法 → 语义

只靠 tree-sitter 只能拿 AST。Codebase-Memory 内嵌**轻量级 C 实现的语义类型解析**（灵感来自 tsserver / pyright / gopls / Roslyn / rust-analyzer），覆盖 **Python / TS / JS / JSX / TSX / PHP / C# / Go / C / C++ / Java / Kotlin / Rust**。

支持：参数绑定、返回类型推断、泛型替换、JSX 组件分派、JSDoc 推断、PHP trait、Java 类继承 + 重载、Kotlin 扩展函数、Rust UFCS。

### 4. 跨语言 / 跨仓库 / 跨服务 + 团队协作

- HTTP 路由 ↔ 调用点匹配（带置信度）
- gRPC / GraphQL / tRPC 服务检测（含 protobuf Route）
- Socket.IO / EventEmitter / pub-sub 通道检测（`EMITS` / `LISTENS_ON` 边，跨 8 语言）
- IaC 索引：Dockerfile / K8s manifest / Kustomize overlay 都进图谱
- 跨仓库 `CROSS_*` 边：多仓库挂同一 store，画「多星系」3D 架构图
- **共享图谱**：`.codebase-memory/graph.db.zst` 是 zstd 压缩快照，可直接提交 git，队友 clone 后自动 import + 增量索引

---

## 📂 能力清单

| 能力 | 说明 |
|------|------|
| **158 语言** | tree-sitter 内嵌进二进制 |
| **Hybrid LSP** | 11 种主流语言的类型推断 |
| **持久化图谱** | 节点：函数/类/包/模块/路由/资源；边：`CALLS` / `IMPORTS` / `DEFINES` / `IMPLEMENTS` / `INHERITS` / `HTTP_CALLS` / `ASYNC_CALLS` / `EMITS` / `LISTENS_ON` / `DATA_FLOWS` / `SIMILAR_TO` / `SEMANTICALLY_RELATED` |
| **RAM-first pipeline** | LZ4 HC → 内存 SQLite → 一次性 dump；索引完内存还给 OS |
| **后台 watcher** | 文件变动自动增量重索引 |

**11 个自动接入的 agent**：Claude Code · Codex CLI · Gemini CLI · Zed · OpenCode · Antigravity · Aider · KiloCode · VS Code · OpenClaw · Kiro

**分发**：npm · PyPI · Homebrew · Scoop · Winget · Chocolatey · AUR · go install

**安全**：SLSA Level 3 · Sigstore 签名 · 70+ 杀毒引擎扫描 · 100% 本地运行零遥测

---

## 🚀 如何使用

### 一行命令安装（推荐）

**macOS / Linux：**

```bash
curl -fsSL https://raw.githubusercontent.com/DeusData/codebase-memory-mcp/main/install.sh | bash
```

带 3D 可视化 UI：

```bash
curl -fsSL https://raw.githubusercontent.com/DeusData/codebase-memory-mcp/main/install.sh | bash -s -- --ui
```

**Windows（PowerShell）：**

```powershell
Invoke-WebRequest -Uri https://raw.githubusercontent.com/DeusData/codebase-memory-mcp/main/install.ps1 -OutFile install.ps1
notepad .\install.ps1              # 建议先看脚本
Unblock-File .\install.ps1         # 解除浏览器 MoW 限制
.\install.ps1
```

> ⚠ 遇到执行策略报错？`Set-ExecutionPolicy -Scope Process Bypass`，或 `PowerShell -ExecutionPolicy Bypass -File .\install.ps1`。

通用选项：`--ui` / `--skip-config`（只装二进制，不动 agent 配置）/ `--dir=<path>`。

### 跑起来

```bash
# 重启 coding agent，然后对它说：
> Index this project

# 或 CLI 模式：
codebase-memory-mcp cli search_graph '{"name_pattern": ".*Handler.*"}'
```

### 自动索引与维护

```bash
codebase-memory-mcp config set auto_index true   # 新项目首次连接自动索引
codebase-memory-mcp config set auto_watch false  # 不挂后台 watcher
codebase-memory-mcp --ui=true --port=9749        # 启 3D 可视化（UI 变体）
codebase-memory-mcp update                       # 升级
codebase-memory-mcp uninstall                    # 清掉 agent 配置（保留二进制和数据库）
```

---

## 💡 推荐用法（由浅入深）

| 阶段 | 动作 | 收益 |
|------|------|------|
| 🟢 **尝鲜** | 一行命令装上，Agent 跑「Index this project」 | 直观感受「查图 vs grep」的速度差 |
| 🟢 **试一次新任务** | 让 Agent 做 `trace_path(function_name="X", direction="inbound")` | 一次拿到完整调用链 |
| 🟡 **日常** | `auto_index=true` + `auto_watch=true` | 后台自动维护图谱，零心智负担 |
| 🟡 **复杂任务** | `get_architecture` 起手再深入 | 比「ls + grep」快 10 倍 |
| 🟠 **大重构前** | `detect_changes` 看影响面 | 改动前知道「这一刀动哪些符号」 |
| 🟠 **跨服务** | 多仓库挂同一 store，看 `CROSS_*` 边 | 微服务全局视角 |
| 🔴 **团队协作** | 把 `.codebase-memory/graph.db.zst` 提交到 git | 队友 clone 完秒级进入工作状态 |
| 🔴 **自定义查询** | 直接写 Cypher：循环依赖、未测函数、按层切片 | 任何 grep 难以表达的结构性问题都能查 |
| ⚫ **写进工作流** | 把 `search_graph` / `trace_path` 编进 slash commands | 强制走图谱，不再退化到文件读取 |

> 💬 **核心建议**：**先装上，让 Agent 跑一次「Index this project」**。看到一次 Cypher 查询 <1ms 返回，你会立刻意识到过去所有 grep + read 都是在浪费时间。

---

## 🔗 相关资源

- **官方仓库**: <https://github.com/DeusData/codebase-memory-mcp>
- **Releases**: <https://github.com/DeusData/codebase-memory-mcp/releases/latest>
- **论文**: [arXiv:2603.27277](https://arxiv.org/abs/2603.27277)
- **中文实战**: <https://blog.csdn.net/chendongqi2007/article/details/162129084>

---

## ✍️ 写在最后

> Agent 不应是「拿着 grep 满世界乱跑的程序」——它应该拿着一张**已经建好的地图**做事。

Codebase-Memory 的野心很直接：**把代码库从「一堆文本文件」变成「一张可查询的结构化图」**。它不内置 LLM、不抢 Agent 的活，只把「理解代码」的**成本**和**速度**压到极致——99.2% token reduction、亚毫秒查询、单二进制零依赖。

如果你正在用 Claude Code / Codex / Cursor 这种 Agent 写代码，**装一个试试**。一旦习惯了「让 Agent 查图而不是读文件」，你会发现过去的工作流有多低效。

**Index once. Query forever. 🚀**