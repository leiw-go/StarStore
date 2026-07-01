# mattpocock/skills

> Skills for Real Engineers. Straight from my .claude directory.
>
> GitHub：<https://github.com/mattpocock/skills>
> 作者：[Matt Pocock](https://github.com/mattpocock)（Total TypeScript 创始人 · AI 教育界大 V）
> Stars ~152k · Forks ~13k · Language: Shell · License: MIT
> 创建 2026-02-03 · 持续更新中（最近更新 2026-07-01）

---

## 简介

**mattpocock/skills** 是 Matt Pocock 直接从他本人在用的 `.claude/` 目录里抽出来的一套**面向真实工程师**的 Claude Code / Codex 等 AI 编程 agent **技能集（skills）**。它的核心立场是**反对"vibe coding"** —— 反对把 AI 当"接话机"，主张让 agent 像真正的工程师一样**对齐需求 → 共享语言 → 反馈循环 → 控制架构腐化**。

和当下流行的 GSD、BMAD、Spec-Kit 等"端到端接管流程"的方法不一样，这套 skills 的设计哲学是**小而精、可适配、可组合**：

- 每条 skill 只解决一个具体的失败模式
- 不绑死任何模型（Claude Code、Codex、其他都能用）
- 用户可以 hack、改造、二次创作
- 全部基于 Matt 几十年工程经验浓缩

它解决的不是一个"AI 写代码"的问题，而是 **"你和 agent 之间不断重复的错位"** 的问题。

## 为什么值得关注

在 AI 编程工具疯狂发展的 2026 年，这个仓库能到 ~15 万 stars 不是因为噱头，而是因为它**戳中了几乎所有 AI 编程用户的真实痛点**：

- **痛点 1：错位（Misalignment）** — 你以为说清楚了，agent 理解错了，产出和需求完全两回事
- **痛点 2：术语不一致（No Ubiquitous Language）** — agent 用 20 个字描述你用一个名词就能概括的东西，每次会话都要重新解释
- **痛点 3：没有反馈循环（No Feedback Loops）** — agent 看不到自己写的代码跑起来什么样，等于蒙眼飞行
- **痛点 4：代码腐化加速（Software Entropy）** — agent 让写代码变快，也让复杂度变快，codebase 几天就成大泥球

每条 skill 对应一个失败模式，并且背后都有**经典软件工程名著**支撑（《The Pragmatic Programmer》、《Domain-Driven Design》、《Extreme Programming Explained》、《A Philosophy of Software Design》）。这不是"AI 新概念炒作"，是**把几十年工程实践压缩成 agent 能执行的 prompt**。

**结构性优势：**
- **作者背书强** — Matt Pocock 的 Total TypeScript 是 TS 圈头部教育品牌，newsletter 6 万订阅者
- **每条 skill 都对应经典原则** — 不是黑魔法，是工程哲学的具体化
- **零依赖、纯 prompt** — 不绑模型、不绑工作流，跨 agent 可移植
- **配套 setup** — `setup-matt-pocock-skills` 一次性配置即可
- **更新频率极高** — 5 个月涨 15 万 stars，CHANGELOG 频繁更新

## 涵盖领域

仓库用一条主线来组织 skills —— **用户触发 vs Agent 触发**：

### User-invoked Skills（用户主动调用）

| Skill | 解决什么问题 | 何时用 |
|-------|--------------|--------|
| **`/setup-matt-pocock-skills`** | 一次性配置 issue tracker、triage 标签、文档布局 | 第一次安装时 |
| **`/ask-matt`** | 路由器：问"我这种情况该用哪个 skill" | 不知道用啥时 |
| **`/grill-me`** | 非代码场景的质问式需求对齐 | 写文档、做规划 |
| **`/grill-with-docs`** | 升级版质问：顺便建立 CONTEXT.md 和 ADR | **最推荐的起点**，每次大改动前 |
| **`/to-prd`** | 把当前对话直接转成 PRD | 你已经和 agent 讨论过需求 |
| **`/to-issues`** | 把 PRD 拆成可独立处理的 issues | PRD 写完后 |
| **`/triage`** | 按状态机处理 issues | issue 涌入时 |
| **`/improve-codebase-architecture`** | 架构体检 + HTML 报告 + 改进讨论 | 定期跑，建议每几天一次 |

### Model-invoked Skills（Agent 自动调用）

| Skill | 作用 | 何时被 agent 触发 |
|-------|------|-------------------|
| **`/prototype`** | 临时跑通的原型，回答"应该这样设计吗？" | 你或 user-invoked skill 觉得需要先验证时 |
| **`/diagnosing-bugs`** | 把调试最佳实践包成一个循环 | 任何报 bug 时 |
| **`/tdd`** | 红绿重构 TDD 循环 | 写新功能或修 bug 时 |

### 配套文档系统

- **`CONTEXT.md`** — 项目共享词汇表（"materialization cascade" 替代 "lesson 变成 spot in file system"）
- **`ADR`** — Architecture Decision Records，记录不易解释的设计决策
- **`CHANGELOG.md`** — 项目自身的变更日志
- **`CLAUDE.md`** — agent 启动时读取的项目指南

## 如何使用

### 30 秒起步

```bash
# 1. 用 skills.sh 安装器安装（推荐）
npx skills@latest add mattpocock/skills

# 2. 选择想要的 skills 和 agent
# 3. 一定要选 /setup-matt-pocock-skills
```

`setup-matt-pocock-skills` 会问你 3 个问题：
- 用哪个 issue tracker（GitHub / Linear / 本地文件）？
- triage 时用哪些标签？
- 把生成的文档存到哪儿？

完成后你就可以用其他 skills 了。

### 典型工作流

```text
1. 你有新想法
   ↓
2. /grill-with-docs     ← agent 质问细节 + 帮你建 CONTEXT.md / ADR
   ↓
3. /to-prd              ← 把对话转成 PRD，发布到 issue tracker
   ↓
4. /to-issues           ← 把 PRD 拆成可独立处理的 issues
   ↓
5. /triage              ← 按状态机管理
   ↓
6. 每次写新功能:
   ↓
7. /tdd（自动）         ← 红绿重构
   ↓
8. 出现 bug:
   ↓
9. /diagnosing-bugs（自动）← 系统化调试
   ↓
10. 定期（每几天）：
    ↓
11. /improve-codebase-architecture  ← 架构体检
```

### 不是 Claude Code 专属

虽然最常和 Claude Code 一起用，但 skills 是**纯 prompt**，不绑模型。Codex、Aider、其他 agent 都能装。Matt 在 README 里强调"These work with any model."

## 推荐用法

### 给"AI 编程上瘾但产出不稳定"的人

如果你经常觉得"agent 写了一大堆，但不对"，**最大的问题不是 agent 笨，是你们的对齐过程没做**。直接装 `/grill-with-docs`，每个大改动前跑一次。它会：

- 问你 10-30 个尖锐问题
- 让你建立项目专属术语表（CONTEXT.md）
- 顺便生成 ADR 记录关键决策

这一个 skill 能解决你 70% 的"agent 写不对"问题。

### 给"代码越来越烂"的人

如果你感觉 codebase 在 AI 加持下复杂度指数增长，装 `/improve-codebase-architecture`，每几天跑一次。它会：

- 扫描代码库，生成可视化 HTML 报告
- 标出"应该拆分"、"应该合并"、"应该删掉"的模块
- 让你和 agent 讨论每个改进点

这是**给 agent 加速度装上刹车片**的唯一办法。

### 给"每次会话都从零开始"的人

如果你厌倦了每次跟 agent 重复解释项目，装这一套后：

- `CONTEXT.md` 写好共享语言 → agent 自动懂术语
- `CLAUDE.md` 写好项目规范 → agent 自动遵守
- `ADR` 记录历史决策 → agent 不再重复犯同样错误

长期下来，你的"AI 上下文资产"会越攒越厚，agent 越用越顺手。

### 给"团队协作"的人

- `/triage` + issue tracker 集成 → 团队所有人都能用同一套 issue 处理流程
- `/to-issues` + `/to-prd` → 把模糊需求转成清晰、可分配的工程任务
- ADR + CONTEXT.md → 新人 onboarding 成本大降

## 写在最后

mattpocock/skills 不是又一个"AI 神器"，它更像**一本压缩成 prompt 的工程手册**。

在 2026 年 AI 编程工具同质化严重的当下，它的差异化不是"更聪明的 agent"，而是**更对齐的协作方式**：

- 它不接管你的工作流，让你保留控制权
- 它不卖 SaaS，开箱即用、完全本地
- 它不绑死模型，跨 agent 可移植
- 它不故弄玄虚，每条 skill 背后都有经典著作支撑

如果你已经在用 Claude Code / Codex 等 AI 编程工具，**但产出不稳定、代码质量下滑、和 agent 对话越来越累**——这一套 skills 是少有的、立刻能起作用的解药。

它不会让你变快 10 倍，但会让你**变稳 10 倍**。在 AI 时代，**稳定比速度更稀缺**。

> 💡 中文社区已经有 `vinvcn/mattpocock-skills-zh-CN` 仓库在做本地化翻译，对中文用户友好。

---

**仓库地址：** <https://github.com/mattpocock/skills>
**作者主页：** <https://www.aihero.dev/>
**Newsletter：** 6 万订阅者，可订阅获取 skill 更新通知
**安装命令：** `npx skills@latest add mattpocock/skills`