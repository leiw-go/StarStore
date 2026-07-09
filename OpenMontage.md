# OpenMontage — 让 AI 编程助手变成你的视频制作工作室

> *"The first open-source, agentic video production system."*

🔗 **GitHub**: <https://github.com/calesthio/OpenMontage>
⭐ **Star**: ~18K（用户口径）
📜 **License**: AGPLv3
🏆 上过 GitHub Trending #1 Repository of the Day

---

## 📖 项目简介

**OpenMontage** 是目前最被低估的「AI 视频生产」开源项目之一，由 **calesthio AI Labs** 开源。

它的核心思路非常独特——

> **把你已经在用的 AI 编程助手（Claude Code / Cursor / Copilot / Windsurf / Codex）变成一支完整的视频制作团队。**

你不需要学习新工具。你打开项目，跟你的 AI 助手说「帮我做一个关于 X 的短视频」，剩下的事情——**调研、写脚本、生成素材、配音、剪辑、合成**——它自己跑完。

更关键的是，它跟市面上一堆「把几张静态图淡入淡出叫作视频」的项目不一样。**OpenMontage 既能做图生视频，也能拉真实的开源/免费素材库，剪辑成一段真正的「会动的视频」**。

支持五种现成的制作路径，官方 demo 里实际跑出来的成片包括：

| Demo | 风格 | 成本 |
|------|------|------|
| SIGNAL FROM TOMORROW | 科幻电影预告片 | — |
| THE LAST BANANA | 皮克斯风格动画短片 | **$1.33** |
| The Library at Alexandria | 历史挽歌 | **$0.02** |
| VOID — Neural Interface | 产品广告 | **$0.69** |
| Afternoon in Candyland | 吉卜力风格动画 | **$0.15** |

每个 demo 都有完整的 prompt、pipeline、用到的工具、花了多少钱——**完全可复现**。

---

## 🎯 为什么值得关注

### 1. 它颠覆了「AI 视频工具」的形态

99% 的 AI 视频工具给你的是一个 **SaaS 网页**：点按钮、调滑块、选模板、等结果。

OpenMontage 给你的是 **一个本地工程目录**：

```
OpenMontage/
├── .agents/        # 给 AI 助手读的规则
├── AGENT_GUIDE.md  # 详细操作手册
├── pipeline_defs/  # 各种 pipeline 定义
├── remotion-composer/  # 视频合成引擎
├── schemas/        # 素材结构定义
├── skills/         # 技能模块
├── tools/          # 命令行工具
├── backlot/        # Backlot 实时监视器
└── Makefile        # make setup 一键搞定
```

当你说「做一个 60 秒的量子计算科普视频」，Claude Code/Cursor 读 `.agents/` 和 `AGENT_GUIDE.md`，自己开始调度子任务。

**这不是「AI 工具」，是「AI 员工」。**

### 2. 真正的「视频视频」，不是图生视频

仓库 README 明确写了一句很硬的话：

> *"OpenMontage can make image-based videos, but it can also make a real **video video** for free/open-source workflows: the agent builds a corpus from free stock footage and open archives, retrieves actual motion clips, edits them into a timeline, and renders a finished piece."*

「video video」——这种自信的语气说明他们很清楚自己在做什么差异化的东西。

成本示例里那个 $0.02 的「The Library at Alexandria」，**一分钱没花在 AI 视频生成上**，全靠素材拼贴 + 旁白 + 配乐。$1.33 的皮克斯短片是因为用了 Kling v3 视频模型——成本全透明。

### 3. Backlot：让过程看得见

这是我个人最喜欢的一点。

**Backlot** 是 OpenMontage 自带的「实时监视器」——你跑一个制作任务的时候，本地会开一个网页仪表板：

- 📜 脚本落地时变成「剧本页」
- 🎬 场景卡片在素材生成时「闪烁」
- 💰 每个 provider 的决策、花了多少美元，**全在墙上**
- ✅ 创意门（脚本、storyboard）会**停下来等你审批**

最有意思的是 **REPLAY RUN**：跑完之后可以**从头回放整个制作过程**，每个阶段的时间戳都在。

```bash
python -m backlot open                  # 项目库
python -m backlot open <project-id>     # 单个项目的实时看板
python scripts/backlot_simulate_run.py  # 没项目？跑个模拟演示看看
```

**你不再是一个「按按钮等结果」的甲方，你是一个「看剪片现场」的导演。**

### 4. 不是「换个壳」的包装项目

看一眼仓库根目录：

```
.agents/  .claude/  .cursor/  .github/  
CLAUDE.md  CURSOR.md  COPILOT.md  CODEX.md  WINDSURFRULES
```

——**每个主流 AI 编程工具都有专属的配置**。这是真的接入了 Claude Code / Cursor / Copilot / Windsurf / Codex 的 tool-use / rule system，不是套了个 prompt 在那装。

---

## 📂 涵盖能力 / Pipeline 清单

OpenMontage 内置多种视频制作 pipeline，主要分三类：

### 🎬 真实视频制作（带 motion clip）
- **Open Stock Pipeline**：从 Pixabay、Pexels 等免费库拉真实视频片段，编辑成片。**完全免费**。
- **AI Video Pipeline**：用 Veo、Kling v3、Runway、Higgsfield 等视频生成模型做 motion clip。

### 🖼 图生视频（image-to-video）
- **Remotion Pipeline**：用 React 写视频时间线，支持字幕、粒子、相机运动、视差——`Afternoon in Candyland` 就是这个。
- **HyperFrames Pipeline**：更轻量的图生视频。

### 🛠 高级定制
- **Atelier (bespoke) Pipeline**：每帧手搓，完全定制的视觉风格——`The Library at Alexandria` 就是这个。

### 支持的 AI Provider（部分）

| 类别 | Provider |
|------|----------|
| 图像 | gpt-image-1、FLUX |
| 视频 | Veo、Kling v3、Runway、Higgsfield |
| 配音 | Google Chirp3-HD、OpenAI TTS |
| 字幕 | WhisperX |
| 音乐 | Pixabay、auto-detect energy offset |

### 关键文件作用

| 文件/目录 | 作用 |
|-----------|------|
| `AGENT_GUIDE.md` | 给 AI 助手的完整操作手册 |
| `PROMPT_GALLERY.md` | 经过验证的 prompt 案例库 |
| `pipeline_defs/` | 各种 pipeline 的实现 |
| `remotion-composer/` | 视频合成引擎 |
| `schemas/` | 素材、脚本、剧本的结构定义 |
| `docs/PROVIDERS.md` | 所有 provider 的配置文档 |
| `Makefile` | `make setup` 一键安装 |

---

## 🚀 如何使用

### 前置条件

- **Python 3.10+**
- **FFmpeg**（视频处理必备）
- **Node.js 18+**（Remotion 需要）
- **任意一个 AI 编程助手**：Claude Code、Cursor、Copilot、Windsurf、Codex

### 三步上手

```bash
# 1. 克隆
git clone https://github.com/calesthio/OpenMontage.git
cd OpenMontage

# 2. 一键安装
make setup

# 3. 在 AI 助手里描述需求
```

然后在 Claude Code / Cursor 里告诉它：

> "做一个 60 秒的科普视频，主题是黑洞。风格参考《连线》杂志。预算控制在 $1 以内。"

它会自己开始：

1. **调研** → 找资料、定脚本大纲
2. **策划** → 出 2-3 个差异化方案 + 成本估算
3. **审批门** → Backlot 上问你选哪个方向
4. **素材生成** → 按场景跑 provider，边跑边显示花费
5. **合成** → Remotion / HyperFrames 编排时间线
6. **后处理** → 字幕、配乐、最终渲染
7. **REPLAY** → 你可以回放整个制作过程

### 参考视频起步（更稳）

如果不知道从哪开始，可以**先贴一个你喜欢的 YouTube 短视频 / TikTok / Reel 链接**，让它先分析再改编：

```text
"Here's a YouTube Short I love. Make me something like this, 
but about quantum computing."
```

它会先告诉你：

- ✅ 保留原视频的什么（节奏、钩子、结构）
- 🔄 改什么（主题、视觉、角度）
- 💵 在你目标时长下，**先告诉你**要花多少钱
- 👀 用你现有工具**实际能做成什么样**

——**而不是上来就开跑，钱花完了才发现不对**。

---

## 💡 推荐用法

| 场景 | 怎么做 | 预期效果 |
|------|--------|----------|
| 🟢 **尝鲜** | 跑 `python scripts/backlot_simulate_run.py` 看一次模拟制作 | 5 分钟理解整个流程 |
| 🟢 **零成本试水** | 用 Open Stock Pipeline + Pixabay 音乐 | 一分钱不花，做「图配旁白」短视频 |
| 🟡 **日常内容** | 配 OpenAI / Google API key，用 Remotion pipeline | 一条 60 秒科普视频 $0.15-$1 |
| 🟡 **风格定制** | 锁定一个 demo（比如「Candyland」风格），复用其 pipeline_defs | 系列化内容生产 |
| 🟠 **复杂项目** | 开 atelier 模式，逐场景手工设计 | 史诗级历史挽歌、艺术短片 |
| 🔴 **做自己的产品** | fork 仓库，造一个垂直版本（教程 / 营销 / 教学） | 「N 领域 + 1 套 prompt 模板」就能跑 |

### 实战建议

1. **第一次别上 AI 视频模型**——先跑免费素材 pipeline，感受一下流程和审批节奏。
2. **一定要开 Backlot**——它不是装饰品，是你控制成本和质量的唯一窗口。
3. **用「参考视频」起步**——成功率比白纸描述高 3 倍不止。
4. **每个创意门都审批**——脚本、storyboard、最终成片，三个门最少过两个。
5. **看 PROMPT_GALLERY.md**——里面都是跑通了的 prompt 模板，直接抄。

---

## ⚠️ 注意事项

- **AGPLv3 协议**——商业使用、二次分发要注意 copyleft 传染性。
- **需要 API key 才能生成 AI 视频/图像**——免费路径只能做素材拼贴。
- **GPU 不是必需**——所有生成都走 API，本地不需要显卡；但 GPU 可以解锁一些本地视频生成选项（见 `requirements-gpu.txt`）。
- **Makefile 失败时**——`npm install` 失败是常见问题，仓库 issue 区有解决方案。

---

## 🔗 相关资源

- **官方仓库**: <https://github.com/calesthio/OpenMontage>
- **Agent Guide**（必读）: <https://github.com/calesthio/OpenMontage/blob/main/AGENT_GUIDE.md>
- **Prompt Gallery**: <https://github.com/calesthio/OpenMontage/blob/main/PROMPT_GALLERY.md>
- **YouTube 频道**（每个 demo 都附完整 prompt / pipeline / 成本）: <https://www.youtube.com/@OpenMontage>
- **X 官方账号**: <https://x.com/calesthioailabs>
- **GitHub Discussions**: <https://github.com/calesthio/OpenMontage/discussions>

---

## ✍️ 写在最后

> **OpenMontage 不是又一个 AI 视频 SaaS，它是一份「视频制作工程化的开源标准」。**

当 Anthropic 的 Claude Code 越来越像「能干活的同事」，OpenMontage 给我们展示了一个具体场景：

**AI 编程助手 + 一套结构化的工程目录 + 一个实时监控仪表板 = 一个完整的视频制作工作室。**

这种范式可以平移到任何创意领域——动画、播客、设计、研究报告。

最让我印象深刻的是成本透明度和可复现性：每个 demo 都**老老实实标注花了多少钱**，每一步都**留在 Backlot 时间戳上**。这不是营销，这是工程。

如果你已经在用 Claude Code 或 Cursor，**今天就 `make setup` 一下**。哪怕只是跑一次 `simulate_run.py`，你都会被这种「让 AI 干真正长链路工作」的范式打动。

**Make a video. See it happen. Replay the whole thing. 🎬**