# PMPOT（≈ Penpot）— 团队级开源设计与原型协作平台

> *"The open-source design platform for Product teams that need scalable collaboration."*

🔗 **GitHub**: <https://github.com/penpot/penpot>
⭐ **Star**: 55k+（Penpot 实际数据）
🍴 **Fork**: 3.6k
📜 **License**: MPL-2.0
🌐 **官方 SAAS**: <https://design.penpot.app>

> ⚠️ **关于名字 "PMPOT"**：GitHub 仓库 / API / 用户直访均**未找到名为 PMPOT 的项目**。结合「对标 Figma + ~3.3K」线索，最匹配的是 **[Penpot](https://github.com/penpot/penpot)**——P-E-N-P-O-T 的字母重排，且 ~3.3K 接近 Penpot 的 **3.6k forks**。若不是 Penpot，告诉我名字再补一篇。**正文以 Penpot 为正主。**

---

## 📖 项目简介

**Penpot** 是 GitHub 上**最主流的开源设计 + 原型协作平台**，由西班牙合作制公司 **Kaleidos** 维护，已被 [Digital Public Goods](https://www.digitalpublicgoods.net/r/penpot) 认证为「数字公共产品」。它**从头设计**而非 Figma fork，是一个面向团队的完整 Figma 替代品。

它对两类人**一视同仁**：

- 🎨 **设计师**：矢量、组件库、变体、SVG、自动布局、原型跳转——全链路齐
- 💻 **开发者**：**真的能跑的设计稿**——Inspect 一键复制 SVG / CSS / HTML，Design Tokens 直接对接代码库

**核心理念**：设计应该是**可读的**——Penpot 的设计数据基于 **SVG / CSS / HTML / JSON** 等开放标准，画出来就是代码，AI / CI / IDE 都能直接消费。

---

## 🎯 为什么值得关注

### 1. Figma 之后，你的设计资产不应再被锁死

Figma 在云端、Adobe 收购风波、订阅价格、地区政策、协作人数限制——任何一条都足以让一个成长中的团队考虑替代品。

Penpot 提供**和 Figma 同级**的三个核心能力：

- ✅ **在线设计器**：钢笔、矢量、布尔、图层样式、自动布局（Flex / CSS Grid）
- ✅ **实时多人协作**：多光标编辑、评论、版本历史、@提醒
- ✅ **组件 / 变体 / Design Tokens**：建团队级设计系统不缺任何一块拼图

同时多给两样**Figma 没给你的东西**：

- 🔓 **完全自托管**：Docker / Kubernetes / Helm 一键起
- 💸 **核心能力完全免费**：团队版无席位费，企业版按年订阅

### 2. 「设计 = 代码」是真家伙，不是营销话术

别的设计工具也喊这句话，Penpot 是真的把设计数据**当代码对待**：

- 原生支持 **Flexbox / CSS Grid**，组件布局就是真实网页布局，没有「Figma 翻译层」那种失真
- 官方 **MCP Server**（[penpot-mcp-server](https://penpot.app/penpot-mcp-server)）让 Cursor / Claude Code / Codex 直接读懂设计稿、对齐 tokens、生成组件
- **Open API + Webhooks + Plugins**：可以塞进 CI、接告警、串联 JIRA / Slack / 自研系统

对前端来说，这意味着 **Figma Inspect 那种「凭眼力量间距」的工作流可以彻底淘汰**。

### 3. Design Tokens 是一等公民

Penpot 把 **Tokens**（颜色 / 字号 / 圆角 / 阴影 / 间距）做成 native 概念：

- 设计稿改 token，下游组件自动更新
- 同一份 token 可导出 **CSS / SCSS / JSON**，前端直接消费
- [penpot-export](https://github.com/penpot/penpot-export) 能从文件级一键导出到代码仓

做设计系统时**最值钱的一块拼图**，它给齐了。

### 4. 商业模式经得起推敲

- 主体 **MPL-2.0**，可商用、可自托管
- **Kaleidos** 是合作社模式（不是 VC 烧钱跑路式开源）
- 有付费企业版支撑开发，但**核心能力不锁门**

---

## 📂 涵盖能力清单

| 模块 | 能力要点 |
|------|---------|
| 🖌 **矢量设计** | 钢笔、布尔运算、布尔分组、图层样式、蒙版、网格、参考线 |
| 🧱 **组件与变体** | Components、Variants、Properties、Slots（接近 Figma 的 Component Set） |
| 📐 **布局系统** | **Flexbox**、**CSS Grid**、Constraints——和真实网页一致 |
| 🎨 **Design Tokens** | 颜色 / 字号 / 圆角 / 间距——一处改全局变；可导出 CSS / SCSS / JSON |
| 🔗 **原型交互** | 多状态跳转、Hotspot、Overlay、Flow 演示 |
| 👥 **实时协作** | 多光标、评论、视频、@提醒、版本历史 |
| 🔍 **Inspect（开发交付）** | SVG / CSS / HTML 一键复制，间距、颜色、字号直接拾取 |
| 🧩 **插件体系** | [PenpotHub](https://penpot.app/penpothub/plugins) 官方插件市场，可自研 |
| 🤖 **AI / MCP** | 官方 MCP Server，把设计稿喂给 IDE AI 写代码 |
| 🔌 **API & Webhooks** | Open API + Access Token + Webhook，能塞进任何 DevOps 流水线 |
| 📦 **导入导出** | 可导入 Figma / Sketch 文件；可导出 SVG / PNG / PDF / Zeplin 兼容 |
| 🌐 **自托管** | Docker / Kubernetes / Helm Chart 一键起 |

---

## 🚀 如何使用

### 方式一：先用官方 SAAS（最快上手）

1. 打开 <https://design.penpot.app>
2. 用邮箱注册 → 创建团队 → 创建项目 → 新建文件
3. 基础快捷键：`F` 开 Frame（画板），`R` 开矩形，`T` 开文字，`P` 开钢笔

> 💡 上手后强烈建议跟 [Learning Center](https://penpot.app/learning-center) 跑一遍基础教程，比直接摸索快得多。

### 方式二：本地自托管（团队 / 私有化）

官方提供 **Docker Compose** 一键部署，至少 **4 核 8GB**（Clojure 后端偏吃内存）：

```bash
mkdir -p /opt/penpot && cd /opt/penpot
curl -O https://raw.githubusercontent.com/penpot/penpot/main/docker/images/docker-compose.yaml
curl -O https://raw.githubusercontent.com/penpot/penpot/main/docker/images/config.env
# 按需改 config.env（域名 / 邮箱 / 密钥）
docker compose up -d
```

- 默认前端端口：`9001`
- K8s 用户可直接用 [penpot-helm](https://github.com/penpot/penpot-helm)

### 方式三：接 MCP，写「设计 → 代码」自动化

```json
// Cursor / Claude Code 的 mcp 配置示例
{
  "mcpServers": {
    "penpot": {
      "url": "https://design.penpot.app/mcp",
      "headers": { "Authorization": "Bearer <YOUR_ACCESS_TOKEN>" }
    }
  }
}
```

之后在 IDE 里说「把这份 Penpot 设计稿实现成 React 组件」，AI 会直接读 tokens、拿 SVG 结构、对齐 grid。

---

## 💡 推荐用法（由浅入深）

| 阶段 | 动作 | 收获 |
|------|------|------|
| 🟢 **尝鲜** | 去 SAAS 注册账号，跟 Learning Center 做一个 onboarding | 确认能不能替代日常 |
| 🟡 **熟悉布局** | 主动用 **Flex / CSS Grid** 替代 absolute 定位 | 工作流对齐网页 |
| 🟠 **搭设计系统** | Design Tokens + Components 建规范，导出 CSS 库 | 一次搭好，N 个项目复用 |
| 🔴 **接开发** | 装 MCP Server，接 Cursor / Claude Code | 设计稿 → 可运行代码 |
| ⚫ **自托管** | Docker Compose 在内网起一套 | 数据主权归团队 |
| ⚫ **造插件** | 看 [PenpotHub](https://penpot.app/penpothub/plugins) 写小插件 | 长期收益最大 |

> 💬 **核心建议**：**别一上来就自托管**——先用 SAAS 跑通工作流，确认离不开再迁。

---

## ✍️ 写在最后

> **检索结论**：GitHub 上**没有 PMPOT 这个仓库 / 用户 / 组织**——所有路径、API、关键词组合均已穷举。最匹配你描述（对标 Figma + 开源 + ~3.3K）的是 **[Penpot](https://github.com/penpot/penpot)**——名字是 P-E-N-P-O-T 的字母重排，数据接近其 **3.6k forks**。若不是 Penpot，告诉我名字我再补一篇。

设计工具的下一步不该还是 SaaS——而是一个你**真正拥有、能改、能迁出去**的工具。Penpot 把这件事做到了 Figma 的级别，这正是它值得花时间看的原因。

**Clone it, spin up the docker compose, ship a design system. 🚀**
