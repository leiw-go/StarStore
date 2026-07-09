# Agent-Reach — 给 AI Agent 一键装上互联网能力

> *"Give your AI agent eyes to see the entire internet."*

🔗 **GitHub**: <https://github.com/Panniantong/Agent-Reach>
⭐ **Star**: 🔥 Trendshift #1 Repository of the Day（用户口径 ~7.7K，见末尾「名实核对」）
📜 **License**: MIT | 🎯 **定位**: AI Agent 联网**脚手架**——选型/安装/体检/路由，**不直接读内容**
⚙️ **兼容**: Claude Code、OpenClaw、Cursor、Windsurf

---

## 📖 项目简介

**Agent-Reach** 由 [Panniantong](https://github.com/Panniantong) 开发、MIT 开源，近几个月稳居 GitHub Trending。痛点非常具体：

> AI Agent 帮你写代码、改文档都很顺——但你让它**读推特、看 YouTube、刷小红书、搜 Reddit**，它就抓瞎：Twitter API 月费 $200+，Reddit 官方 API 审批制，B 站 / 小红书 / 抖音要么风控要么必须登录态，任意网页拿回来也常常是一堆 HTML 标签。

**核心理念**：**当下最稳的接入方式，替你选好、装好、体检好**——接入方式会换代（平台封了我们换、工具停更我们换），你不用操心。Agent-Reach **不读内容**，读内容由 Agent 直接调上游工具（twitter-cli、yt-dlp、bili-cli、gh CLI……）。

---

## 🎯 为什么值得关注

### 1. 每个平台 = "首选 + 备选"的有序后端列表

每个平台一个 channel 文件，**真实探测**候选后端。平台改反爬？**调顺序或加后端就行，不用重写**。

```
channels/
├── twitter.py      → twitter-cli ▸ OpenCLI ▸ bird
├── bilibili.py     → bili-cli ▸ OpenCLI（yt-dlp 已被 B 站 412 封死，退役）
├── xiaohongshu.py  → OpenCLI ▸ xiaohongshu-mcp ▸ xhs-cli
└── ...
```

`agent-reach doctor` 永远告诉你**现在走的是哪条路**。

### 2. 一句话安装，连"要不要"都不让你决定

```
帮我安装 Agent Reach：https://raw.githubusercontent.com/Panniantong/agent-reach/main/docs/install.md
```

发给你正在用的 AI Agent，剩下的它自己跑：`pip install agent-reach`、自动装 Node.js / gh CLI / mcporter、通过 MCP 接入 Exa 语义搜索（**免费、无需 Key**）、注册 `SKILL.md` 到 skills 目录——以后遇到"全网调研 / 搜推特 / 看视频"自动知道调哪个工具。

更新也是一句话：`帮我更新 Agent Reach：https://raw.githubusercontent.com/Panniantong/agent-reach/main/docs/update.md`

### 3. 真零成本 + 真隐私

- 💰 **完全免费**——所有上游开源、API 免费；服务器代理也只要 ~$1/月
- 🔒 **Cookie 仅本地**——存 `~/.agent-reach/config.yaml`（权限 600），不上传
- 🛡️ `--safe` 不自动装系统包；`--dry-run` 只预览不执行

---

## 📂 涵盖领域 / 能力清单

| 平台 | 即开即用 | 解锁更多 |
|------|---------|---------|
| 🌐 网页 / 📺 YouTube / 📡 RSS | ✅ Jina Reader / yt-dlp / feedparser | — |
| 🔍 全网搜索 | — | Exa via mcporter（免 Key） |
| 📦 GitHub | ✅ 公开仓库+搜索 | 私有仓库 / Issue / PR |
| 🐦 Twitter/X | ✅ 读单条推文 | 搜索 / Timeline |
| 📺 B站 | ✅ bili-cli 搜索+详情（免登录） | OpenCLI 字幕 |
| 📖 Reddit | — | OpenCLI / rdt-cli（需登录态） |
| 📕 小红书 / 📘 FB / 📷 IG | — | OpenCLI（复用 Chrome 登录态） |
| 💼 LinkedIn | ✅ Jina Reader | Profile / 公司页 |
| 💻 V2EX / 📈 雪球 | ✅ 热门 / 行情 | — |
| 🎙️ 小宇宙播客 | — | Whisper 转录 |

底层都是成熟开源项目：[Jina Reader](https://github.com/jina-ai/reader) · [twitter-cli](https://github.com/public-clis/twitter-cli) · [bili-cli](https://github.com/public-clis/bilibili-cli) · [yt-dlp](https://github.com/yt-dlp/yt-dlp)（154K Star）· [Exa](https://exa.ai) · [mcporter](https://github.com/nicobailon/mcporter) · [gh CLI](https://cli.github.com) · [OpenCLI](https://github.com/jackwener/opencli) · [feedparser](https://github.com/kurtmckee/feedparser)。

> 📌 选型**基于真机实测、定期复核**。某条路失效了换下一条。

---

## 🚀 如何使用

### 方式一：全自动（推荐）

Claude Code / OpenClaw / Cursor / Windsurf 对话框发：

```
帮我安装 Agent Reach：https://raw.githubusercontent.com/Panniantong/agent-reach/main/docs/install.md
```

> ⚠️ **OpenClaw** 默认 `messaging` profile 不允许 shell，要先 `openclaw config set tools.profile "coding"` 重启 Gateway。Claude Code / Cursor / Windsurf 不受此限。

### 方式二：手动安装 / 升级 / 卸载

```bash
pip install agent-reach
agent-reach install --env=auto            # 装全套
agent-reach install --env=auto --dry-run  # 只预览
agent-reach install --env=auto --safe     # 不自动装系统包
pip install -U agent-reach                # 升级
agent-reach uninstall; pip uninstall agent-reach
```

装好跟 Agent 说人话：读链接 / YouTube 字幕 / RSS / V2EX / 雪球 / B 站搜索都是零配置；Exa 跑全网搜索；登录态平台（小红书 / Twitter / Reddit）告诉 Agent「帮我配 XXX」。`agent-reach doctor` 一条命令体检所有渠道。

---

## 💡 推荐用法（由浅入深）

| 阶段 | 动作 | 收益 |
|------|------|------|
| 🟢 **尝鲜** | 装完跑 `agent-reach doctor` | 1 分钟了解能力 |
| 🟢 **吃零配置** | 读网页 / 字幕 / RSS / V2EX / 雪球 | 零成本立刻就有 |
| 🟡 **加搜索** | 让 Agent 用 Exa 跑全网语义搜索 | 调研效率翻倍 |
| 🟡 **解锁登录态** | "帮我配 Twitter / 小红书 / Reddit" | 覆盖面 6 → 15+ |
| 🟠 **多 Agent 共享** | 同一份 `~/.agent-reach/` 在团队复用 | 一处更新、处处生效 |
| 🔴 **生产合规** | `--safe` / `--dry-run` + 专用小号登录 | 上服务器的姿势 |
| ⚫ **做贡献** | 提 Issue、加新 channel 文件 | 作者每天在用 |

> 💬 **核心建议**：先跑 `doctor`，再按你最痛的需求解锁——**别一次性配完**。

---

## ✍️ 写在最后

> 你不需要工具，你需要一个**替你盯着工具的人**。

Agent-Reach 最有价值的地方不在于又整合了什么新渠道，而在于它**把「选型 / 安装 / 体检 / 换代」这四件最烦人的事封进了一个可调顺序的后端列表里**。

B 站风控封死 yt-dlp，它换 bili-cli；Reddit 匿名接口被封，它转登录态；Twitter 改了 API，它排序加后端——**你无感**。

当你装好它、跑过 `doctor`、配好 2-3 个登录态平台，再回头让 Agent 去调研、抓视频摘要、订阅 RSS——会发现，过去你花 30% 时间做的「让 Agent 能联网」这事，被一个开源项目**悄悄解决掉了**。把那个 30% 还给真正重要的工作。

**Install it. Tell your agent. Get back to building. 🚀**

---

## 📝 名实核对

| 你给的线索 | 我查到的事实 |
|-----------|------------|
| 项目名 **Agent-Rich**，Star ~**7.7K** | 仓库实际叫 **Agent-Reach**（`github.com/Panniantong/Agent-Reach`）——"Agent-Rich" 是笔记拼写漂移（Rich ↔ Reach），不是另一个项目 |
| 功能定位「让 AI Agent 免费联网 + 自动处理平台切换」 | ✅ 完全对得上——这正是 Agent-Reach 的核心卖点 |
| Star 数量 | ~7.7K 与实时数据有出入：2026-03 报道约 10.4K，2026-07 已升至 44.1K，当前挂着 **Trendshift #1 Repository of the Day** 徽章。具体以仓库页为准 |

Star 用趋势徽章而非固定值，避免误导。仓库：[github.com/Panniantong/Agent-Reach](https://github.com/Panniantong/Agent-Reach) · 趋势：[trendshift.io/repositories/24387](https://trendshift.io/repositories/24387)。
