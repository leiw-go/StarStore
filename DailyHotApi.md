# DailyHotApi

> 🔥 今日热榜 API · 一个聚合热门数据的 API 接口
>
> GitHub：<https://github.com/imsyy/DailyHotApi>
> 作者：imsyy · 语言：TypeScript · License：MIT
> Stars ~3.9k · Forks ~1.3k · 持续维护中（最近更新 2026-07）

---

## 简介

**DailyHotApi**（今日热榜）是一个聚合全网热门数据的开源 API 服务。它把微博热搜、知乎热榜、B站热门、抖音热点、36氪、IT之家、稀土掘金等 **30+ 国内主流平台** 的实时热榜数据，统一成 **JSON API + RSS Feed** 两种输出格式，单个仓库一份 Docker 镜像就能跑起来。

背后作者 `imsyy` 还配套做了一个**前端页面**项目 `imsyy/DailyHot`，可以直接拿来当 UI 用，也可以调用本仓库的 API 自己渲染。

项目的核心定位不是"做一个网站"，而是"做一个**可被任意前端/脚本/工作流调用**的热榜数据源"。这意味着你可以把它当成一个轻量级的"每日热点 API 网关"接入自己的项目里。

## 为什么值得关注

在国内做"热点聚合"的小项目很多，但这个有几个**结构性的优势**让它值得收藏：

- **覆盖面集中**：30+ 平台覆盖了**主流资讯、社交、二次元、科技、游戏** 五个赛道，一个 API 就能拿到 80% 的国内热点
- **双格式输出**：同时支持 **JSON**（程序调用）和 **RSS**（RSS 阅读器订阅），程序员和内容创作者两边都好用
- **部署极简**：原生支持 **Vercel 一键部署**（白嫖 + 免运维）和 **Docker 自部署**（私有化、可控性强）两条路
- **路由清晰**：每个平台对应一个独立路由（如 `/weibo`、`/zhihu`、`/bilibili`），新增平台只要照模板写一份 adapter 即可
- **配套前端**：作者另开的 `imsyy/DailyHot` 仓库已经做好了可视化页面，clone 下来改改配置就能上线
- **MIT License + 持续维护**：3 年老项目，至今保持活跃，issue 处理及时

**一句话定位：** 想给项目加一个"每日热点"模块、又不想维护一堆散装爬虫时，**这是最低成本的现成方案**。

## 涵盖领域

按类别整理当前已支持的平台（部分），全部走同一个 API 命名约定：

| 类别 | 平台 | 调用名 |
|------|------|--------|
| **资讯** | 百度、抖音、快手、澎湃新闻、今日头条、36 氪、腾讯新闻、新浪网、新浪新闻、网易新闻 | `baidu` / `douyin` / `kuaishou` / `thepaper` / `toutiao` / `36kr` / `qq-news` / `sina` / `sina-news` / `netease-news` |
| **社交** | 微博、知乎、知乎日报、百度贴吧 | `weibo` / `zhihu` / `zhihu-daily` / `tieba` |
| **视频 / 二次元** | 哔哩哔哩、AcFun | `bilibili` / `acfun` |
| **社区 / 论坛** | 豆瓣电影、豆瓣讨论小组、虎扑、V2EX、NGA、NodeSeek | `douban-movie` / `douban-group` / `hupu` / `v2ex` / `ngabbs` / `nodeseek` |
| **科技 / 技术** | 少数派、IT之家、IT之家「喜加一」、简书、果壳、爱范儿、虎嗅、酷安、52 破解、hostloc、51CTO、CSDN、稀土掘金 | `sspai` / `ithome` / `ithome-xijiayi` / `jianshu` / `guokr` / `ifanr` / `huxiu` / `coolapk` / `52pojie` / `hostloc` / `51cto` / `csdn` / `juejin` |
| **游戏** | 英雄联盟、米游社、原神、崩坏3、崩坏：星穹铁道 | `lol` / `miyoushe` / `genshin` / `honkai` / `starrail` |
| **阅读** | 微信读书 | `weread` |

> 完整列表以仓库 README 为准，平台数随版本增长——上面是当前快照。

**一个明显的取向：** 这份清单**几乎全是国内平台**，海外（HN、Reddit、Product Hunt 等）需要另外接别的项目（比如 `DIYgod/RSSHub`）。两者互补，海外用 RSSHub、国内用 DailyHotApi。

## 如何使用

### 方式 1：直接调官方公共 API（最快）

作者公开了一个**演示站点**（海外服务器），可以直接请求：

```bash
# JSON 模式
curl https://api-hot.imsyy.top/weibo
curl https://api-hot.imsyy.top/zhihu
curl https://api-hot.imsyy.top/bilibili

# RSS 模式
curl https://api-hot.imsyy.top/weibo/rss
```

返回结构（JSON 示例）：

```json
{
  "success": true,
  "name": "weibo",
  "title": "微博",
  "subtitle": "热搜榜",
  "update_time": 1751343600000,
  "data": [
    { "id": "...", "title": "...", "url": "...", "hot": { "value": 1234567 } }
  ]
}
```

> ⚠️ 公共 API 是**作者自费维护的演示服务**，不要拿来做生产环境高频调用。

### 方式 2：Vercel 一键部署（白嫖）

```bash
# 1. fork 仓库到自己的 GitHub
# 2. 在 Vercel 导入项目
# 3. 一路 Next 不填任何环境变量
# 4. 部署完成，你的 API 域名是 <project>.vercel.app
```

部署后访问 `https://<your-domain>.vercel.app/zhihu` 即可。**免费层**足够自用和小团队用。

### 方式 3：Docker 自部署（推荐给生产/内网用）

```bash
docker run -d \
  --name dailyhot-api \
  -p 6688:6688 \
  imsyy/dailyhot-api:latest
```

启动后访问 `http://localhost:6688` 看到 Web UI（如果装了前端项目），或者直接调 `http://localhost:6688/<platform>`。

### 方式 4：本地开发（Node.js 18+）

```bash
git clone https://github.com/imsyy/DailyHotApi.git
cd DailyHotApi
pnpm install
pnpm dev
```

### 新增一个平台

仓库目录结构按平台拆分，每个平台一个文件夹，里面是抓取逻辑 + 路由注册。照着模板写一份 adapter 提交 PR 就行——这是社区贡献的主要入口。

## 推荐用法

### 1. 个人 RSS 阅读器订阅

最轻量的用法——把 `https://<your-domain>.vercel.app/zhihu/rss` 加入 Inoreader / Feedly / NetNewsWire，每天刷一遍 RSS 即可，不用装任何客户端。

### 2. 个人站 / 博客的"今日热点"模块

接 5-10 个你关心的平台（如知乎、36氪、稀土掘金、IT之家），每天定时拉一次，前端展示成侧边栏 widget。比自己写爬虫省 N 倍时间。

### 3. 群机器人 / 邮件日报

```python
import requests, smtplib
from datetime import datetime

PLATFORMS = ["weibo", "zhihu", "bilibili", "36kr", "sspai"]
items = []
for p in PLATFORMS:
    resp = requests.get(f"https://<your-api>/{p}").json()
    items.extend([f"[{p}] {x['title']} (热度 {x['hot']['value']})" for x in resp["data"][:5]])

# 发邮件 / 推到群机器人 / 存数据库 / 啥都行
```

### 4. 数据存档 / 趋势分析

每天定时把所有平台数据落到数据库，长期积累后可以做：

- 跨平台热度对比
- 关键词热度时间序列
- 行业话题演化追踪
- 个人兴趣推荐（基于长期阅读数据）

### 5. 组合 RSSHub 覆盖海外

国内用 DailyHotApi、海外用 RSSHub，两边接口风格类似（都是平台路由），整合到一个统一代理里很顺手。

## 写在最后

DailyHotApi 是一个**典型的"小而美"基础设施型项目**——它不炫技、不做平台梦、不收费、不强行做 SaaS，就是老老实实把"抓取热榜"这件事做成一个可复用的 API，让别人拿去用。

在 GitHub 上 3.9k stars / 1.3k forks 的量级不算顶流，但**这恰好是它的甜区**：

- 太小 → 没人维护、接口随平台变更而失效
- 太大 → 商业化、收费、限流
- 当前这个体量 → 作者有动力维护、社区有贡献、License 友好

**如果你是：** 想做内容站、想做日报机器人、想做趋势分析、想给项目加个"热点 widget"——收藏这个仓库，能省你至少 1-2 周的爬虫维护时间。

> 🇨🇳 提醒：调用第三方平台数据时，务必关注目标平台的 `robots.txt`、接口频率限制和 ToS。本项目作为聚合层，**二次开发时仍需自行评估合规性**。

---

**仓库地址：** <https://github.com/imsyy/DailyHotApi>
**配套前端：** <https://github.com/imsyy/DailyHot>
**演示站点：** <https://hot.imsyy.top/>
**示例 API：** <https://api-hot.imsyy.top/zhihu>