# Daily Stock Analysis — LLM 驱动的多市场股票分析系统

> *"LLM-powered multi-market stock analysis system with multi-source market data, real-time news, decision dashboard, automated notifications, and cost-free scheduled runs."*

🔗 **GitHub**: <https://github.com/ZhuLinsen/daily_stock_analysis>
⭐ **Star**: ~54.8K（54,776）
🍴 **Fork**: ~47.4K
📜 **License**: MIT
🌐 **项目主页**: <https://dsa.zhulinsen.tech>
🏷 **Topics**: llm · ai-agent · a-stock · quant · quantitative-finance

---

## 📖 项目简介

**Daily Stock Analysis**（仓库 `ZhuLinsen/daily_stock_analysis`）是 2026 年 GitHub 上最火的 **AI 投研自动化项目** 之一。它做的事情听起来朴素——**每天自动帮你分析自选股，推送一份「决策仪表盘」到手机上**——但做得极其彻底：

- 多数据源行情聚合（A 股 / 港股 / 美股 / ETF）
- 实时新闻 + 舆情情绪 + 公告基本面
- LLM 综合判断 → 结构化分析报告
- Web 工作台 + Agent 策略问股 + 6+ 推送渠道
- **GitHub Actions 免费运行，不需要自己的服务器**

从 2026 年 1 月 10 日创建到现在大约 6 个月，已经拿到 **5 万多 Star、4 万多 Fork**，长期霸榜 GitHub Trending，被 HelloGitHub 选为推荐项目。

**核心理念**：

> 散户每天看行情、查 K 线、算技术指标、翻新闻、读公告——重复、低效、容易遗漏。**把脏活累活交给脚本，把判断交给 LLM，把报告推送到你口袋里**。

你收到的不是一堆数据表格，而是一份**结构化的「决策仪表盘」**：核心结论一句话、买入/观望/卖出动作、评分、风险警报、利好催化、操作检查清单。不是那种「后市看好」的废话，是**有具体数据、有信号来源**的报告。

---

## 🎯 为什么值得关注

### 1. 「零成本」是真的零成本

很多项目挂「零成本」招牌，其实需要你买 VPS、配 Docker、跑定时任务。这个项目的杀手锏是：

> **Fork 一下，配两个 Secret（AI Key + 自选股），每天 18:00 自动跑，自动推送到微信/飞书。**

跑在 GitHub Actions 上，**免费额度完全够用个人使用**——对非交易日的处理（自动跳过 A/H/US 节假日）也都做好了。这是它能病毒式扩散的根本原因：没有部署门槛。

### 2. 「来者不拒」的 LLM 兼容

不像某些项目绑死某一家模型，这个项目走的是 **OpenAI 兼容接口路线**——任何提供 OpenAI 格式 API 的服务都能接入：

| 模型来源 | 典型选择 |
|---------|---------|
| ☁️ 云端 API | Anspire（中文优化、一键多模型）、AIHubMix、Gemini（免费额度）、Claude、DeepSeek、通义千问 |
| 🏠 本地模型 | Ollama（隐私/离线场景） |

默认推荐 **Anspire** 或 **AIHubMix**——一个 Key 同时拿到主流模型 + 中文搜索能力，对国内用户特别友好。

### 3. 「多源冗余」的数据架构

行情数据不是单点依赖，而是 **7 个数据源 + 自动降级**：

- **A 股**: AkShare（免费）、Tushare、Pytdx（通达信协议）、Baostock、TickFlow
- **港股 / 美股**: YFinance、Longbridge

新闻搜索也接了 **8 个后端**（Anspire AI Search、SerpAPI、Tavily、博查、Brave、SearXNG 等），美股还有 **Stock Sentiment API** 聚合 Reddit、X（Twitter）、Polymarket 的情绪数据。

**一个源挂了自动切下一个**，对个人用户来说这就是「不怕某个接口失效」的兜底。

### 4. 「Agent 策略问股」不是噱头

这是项目最有 **AI 原生味道** 的功能——不是简单的「问一只股票怎么样」，而是带 **策略框架** 的多轮对话：

内置 15 种策略：均线金叉、多头趋势、缠论、波浪、热点题材、事件驱动、成长质量、预期重估、A 股复盘、美股 Regime……

Web 工作台的 `/chat` 页面直接用，支持**实时调行情和 K 线、会话导出、发送到通知渠道**。实验性还提供了自定义策略文件和多 Agent 编排——你可以写自己的分析 framework 让 AI 按规范执行。

### 5. 完整的产品矩阵

它不是个 demo，而是一整套**可投产的系统**：

- **Web 工作台**（React + 深色/浅色主题）：手动分析、配置管理、任务进度、历史报告、回测、持仓管理
- **FastAPI 后端服务**：可以本地起一个 API
- **Bot 交互模块**：命令行/Telegram 等
- **Docker 部署**：docker/ 目录一键起
- **GitHub Actions**：零成本定时
- **桌面端支持**：跑在本地当工具用

---

## 📂 涵盖领域 / 能力清单

| 模块 | 能力 |
|------|------|
| 🤖 **AI 决策报告** | 一句话核心结论 + 评分 + 趋势 + 买卖点位 + 风险警报 + 催化因素 + 操作检查清单 |
| 📊 **多市场数据** | A 股、港股、美股、美股指数、ETF；行情、K 线、技术指标、资金流、筹码分布 |
| 📰 **舆情基本面** | 实时新闻、公告、舆情情绪、社交媒体（美股 Reddit/X/Polymarket） |
| 🌐 **Web 工作台** | 手动分析、任务进度、历史报告、完整 Markdown、回测、持仓管理、深色/浅色主题 |
| 🤖 **Agent 策略问股** | 多轮追问；15 种内置策略（均线/缠论/波浪/题材/事件驱动/基本面等） |
| 📥 **智能导入** | 图片 OCR、CSV/Excel、剪贴板导入；股票代码/名称/拼音/别名自动补全 |
| 📤 **多渠道推送** | 企业微信、飞书、Telegram、Discord、Slack、邮件、PushPlus、ServerChan、ntfy、Gotify、AstrBot、自定义 Webhook |
| 🛰 **大盘复盘** | 每日市场概览、指数表现、涨跌统计、板块强弱、北向资金（cn / hk / us / both） |
| 🌐 **多语言报告** | 中文（默认）/ 英文 / 韩文 |
| ⏱ **自动化** | GitHub Actions、Docker、本地定时任务、FastAPI 服务、Web 桌面 |

---

## 🚀 如何使用

### 方式一：GitHub Actions 零成本（推荐小白）

```bash
# 1. Fork 仓库
#    https://github.com/ZhuLinsen/daily_stock_analysis 点击右上角 Fork

# 2. 配置 Secrets（最少两个）
#    Settings → Secrets and variables → Actions → New repository secret
#    STOCK_LIST=600519,hk00700,AAPL,TSLA
#    ANSPIRE_API_KEYS=sk-xxx   # 或 GEMINI_API_KEY / OPENAI_API_KEY 任选其一

# 3. 启用 Actions
#    Actions 标签 → I understand my workflows, go ahead and enable them

# 4. 手动测试一次
#    Actions → 每日股票分析 → Run workflow
```

完成。默认每个工作日北京时间 18:00 自动执行，自动跳过非交易日（含 A/H/US 节假日）。

### 方式二：本地 Python（开发调试）

```bash
# 环境要求：Python 3.10+
git clone https://github.com/ZhuLinsen/daily_stock_analysis.git
cd daily_stock_analysis

pip install -r requirements.txt
cp .env.example .env
vim .env   # 至少配置：STOCK_LIST + 一个 AI Key + 一个推送渠道

python main.py
```

### 方式三：Docker

```bash
# 项目自带 docker/ 配置目录
docker compose up -d
```

### 最小示例：配置自选股 + Gemini 推送飞书

```bash
# .env 最小配置
STOCK_LIST=600519,000001,hk00700,AAPL,TSLA
GEMINI_API_KEY=your_gemini_key
FEISHU_WEBHOOK_URL=https://open.feishu.cn/open-apis/bot/v2/hook/xxxx
```

跑完 `python main.py`，你会在飞书群收到类似这样的报告：

```
⚪ 中钨高新 (000657)
  舆情情绪: 市场关注其 AI 属性与业绩高增长，情绪偏积极
  业绩预期: 前三季度扣非净利润同比暴涨 407.52%
  风险警报: 主力资金大幅净卖出 3.63 亿元
  ✨ 利好催化: AI 服务器 HDI 核心供应商
```

---

## 💡 推荐用法（由浅入深）

| 阶段 | 动作 | 收益 |
|------|------|------|
| 🟢 **尝鲜** | Fork 仓库 + 配 2 个 Secret + 跑一次 | 5 分钟拿到第一份自动报告 |
| 🟢 **跑通** | 配置 5-10 只自选股 + 飞书/企微推送 | 形成「每天下班前看手机」的习惯 |
| 🟡 **日常** | 调 `REPORT_TYPE=brief`、打开静默时段、合理推送频率 | 不再被通知骚扰 |
| 🟡 **进阶** | 切到 `full` 报告看完整分析；用 `/chat` 问策略 | 从「被动接收」升级到「主动追问」 |
| 🟠 **扩展** | 接入自有数据源（Longbridge 港股 / TickFlow A 股） | 覆盖更全的市场 |
| 🟠 **二次开发** | 读 `src/analyzer.py`、`data_provider/`、写自己的策略文件 | 把这个项目当框架用 |
| 🔴 **组合** | 接入作者同系列 [AlphaSift](https://github.com/ZhuLinsen/alphasift)（选股）+ [AlphaEvo](https://github.com/ZhuLinsen/alphaevo)（回测进化） | 构成「选股 → 分析 → 验证」完整量化工具链 |
| ⚫ **生态** | fork 改造成自己的版本（私有 / 团队） | MIT 协议，可以放心改 |

> 💬 **建议**：**先 Fork 跑起来，再决定要不要深入**。这个项目最大的价值是「开箱即用」，别陷入配置地狱。

---

## 🔗 相关资源

- **官方仓库**: <https://github.com/ZhuLinsen/daily_stock_analysis>
- **项目主页**: <https://dsa.zhulinsen.tech>
- **完整配置文档（英文）**: `docs/full-guide_EN.md`
- **作者 GitHub**: <https://github.com/ZhuLinsen>
- **同系列项目**:
  - [AlphaSift](https://github.com/ZhuLinsen/alphasift) — 多因子选股与全市场扫描
  - [AlphaEvo](https://github.com/ZhuLinsen/alphaevo) — 策略回测与自我进化
- **协议**: MIT（允许商用、修改、私用）

---

## ✍️ 写在最后

> **散户不是输在信息不够，是输在「没时间处理信息」。**

这个项目的真正价值不在「AI 多聪明」，而在它把**「盯盘 → 分析 → 决策」**这条链路上**所有脏活累活**都接住了——你只需要在最后一步**用常识 + 自己的判断**去验证它给的结论。

把它当成**一个不会累的初级投研助理**，不是当成「股市预测神器」。

**Fork it, pick 5 stocks, ship the first report. 📈**

---

### ⚠️ 关于任务命名的说明（坦白）

用户最初给出的项目名为 **`Daily-Stock-LLM`**，但经 `web_search` + `web_fetch` 多角度核实（含 `"Daily-Stock-LLM" site:github.com` 限定检索），GitHub 上**不存在名为 `Daily-Stock-LLM` 的仓库**。

按照用户描述「LLM 驱动的多市场股票分析系统」匹配的真实项目是 **`ZhuLinsen/daily_stock_analysis`**（本文所写）。两者关系：

| 用户给的口径 | 实际查到的事实 |
|------------|--------------|
| 项目名：Daily-Stock-LLM | 仓库名：daily_stock_analysis（owner: ZhuLinsen） |
| Stars：~7.1K | Stars：**54,776**（~54.8K），取自 GitHub API `stargazers_count` 字段 |
| LLM 驱动多市场分析 | ✅ 完全匹配（含 A/H/美股） |

数据来源：GitHub REST API `https://api.github.com/repos/ZhuLinsen/daily_stock_analysis`（取数时间 2026-07-06）。

Star 数我按用户硬性要求「不编造」原则，**使用真实数据 ~54.8K**，没有沿用 7.1K 这个明显偏低的数字。如果你原本想找的是另一个项目，请告诉我名字，我再核对。