# Voicebox — 本地优先的开源 AI 语音工作室

> *"The open-source AI voice studio. Clone any voice. Generate speech. Dictate into any app. Talk to agents in voices you own."*

🔗 **GitHub**: <https://github.com/jamiepine/voicebox>
⭐ **Star**: ~38k
📜 **License**: MIT
🌐 **官网**: <https://voicebox.sh>
🛠 **作者**: [Jamie Pine](https://github.com/jamiepine)（[Spacedrive](https://github.com/spacedriveapp/spacedrive) 同款作者）

---

## 📖 项目简介

> **同名的 Voicebox 在 GitHub 上不止一个**——Meta 论文、`myshell-ai/OpenVoice`、各种 TTS 单点项目全都撞名。

本文讲的是 **Jamie Pine 的 [`jamiepine/voicebox`](https://github.com/jamiepine/voicebox)**——2026 年 1 月发布、上线不到半年就拿到 **~38k Star、4.5k+ Fork** 的那个项目。判断依据：

- README 一句话定位写得很硬：**「The open-source AI voice studio」**，强调 **23 种语言 × 7 个 TTS 引擎 × 本地运行**
- 唯一同时覆盖 **语音输入（听写）+ 语音输出（克隆/TTS）+ Agent 语音接口（MCP）** 的项目
- 其它同名项目要么是论文代码（Meta Voicebox）、要么只做克隆（OpenVoice）、要么只是个录音 App

Voicebox 一句话讲完：

> **本地版、免费版、开源版的 ElevenLabs + WisprFlow，再加一个让 AI Agent 用你克隆的声音说话的 MCP 接口。**

ElevenLabs 主攻语音输出、WisprFlow 主攻语音输入——两家各占一边。Voicebox **两边都做了**，中间用一个本地 LLM 把改写、人格化串起来。所有模型、录音、克隆音色**全程不离开你这台电脑**。

---

## 🎯 为什么值得关注

### 1. 它把"语音"做成了完整的本地 I/O 栈

不是又一个 TTS demo，而是一个**真正能替代付费方案的工作流**：

| 环节 | Voicebox | 对标付费方案 |
|------|----------|------------|
| **语音输出（TTS / 克隆）** | 7 个引擎、本地推理 | ElevenLabs（$5–$330/月） |
| **语音输入（听写）** | 全局热键 + Whisper + LLM 润色 | WisprFlow（$15/月） |
| **Agent 发声** | 内置 MCP，一键调用 | 没现成方案 |
| **音频后期** | 8 个效果器 + 多轨时间线 | 单独开个 DAW |

而且是 **Tauri + Rust 桌面 App**，不是网页工具。装上即用，不依赖服务器。

### 2. 真正的"本地优先"

- 模型、声音数据、听写录音**全部留在本机**
- macOS 走 MLX/Metal（Apple Silicon 加速 4-5x），Windows/Linux 走 PyTorch（CUDA/ROCm/DirectML/IPEX）
- **CPU 也能跑**：Kokoro 模型只有 **82M**，无独显本子无压力
- 内置 Qwen3 0.6B/1.7B/4B 本地 LLM 做听写润色和人格化改写，**和 TTS 共享 runtime**——一份显存、一份模型缓存

### 3. 7 个 TTS 引擎，按场景切换

不绑定单家厂商，把主流开源 TTS 装在一起：Qwen3-TTS（10 语种，支持自然语言指令"慢一点""用耳语"）、Qwen CustomVoice（9 个预设音色，免参考音频）、LuxTTS（CPU 150x 实时）、Chatterbox Multilingual（**23 语种覆盖最广**）、Chatterbox Turbo（**唯一支持 `[laugh]`/`[sigh]`/`[gasp]` 情绪标签**）、TADA（700s+ 长音频一致性）、Kokoro（50 预设音色，**82M 模型**）。

### 4. 给 AI Agent 接上声音——MCP 才是杀手锏

```ts
await voicebox.speak({
  text: "部署完成。",
  profile: "Morgan",
});
```

Agent 跑完任务，**直接用你克隆的声音念出来**。Claude Code 一行命令接入：

```bash
claude mcp add voicebox \
  --transport http \
  --url http://127.0.0.1:17493/mcp \
  --header "X-Voicebox-Client-Id: claude-code"
```

**Voicebox → Settings → MCP** 里可以给每个 Agent 单独绑声音——Claude Code 用 Morgan、Cursor 用 Scarlett，**听声辨 Agent**。

---

## 📂 涵盖能力

| 模块 | 能力要点 |
|------|---------|
| 🎙 **语音生成 / 克隆** | 零样本克隆（几秒参考音频）；50+ 预设音色；**23 种语言**；情绪标签 + 自然语言指令；50,000 字符长文自动分句 + 交叉淡入；多版本 + lineage 跟踪 |
| 🎚 **音频后期 / 编辑** | 8 个效果器（Pitch Shift、Reverb、Delay、Chorus、Compressor、Gain、HP/LP，基于 Spotify pedalboard）；4 个内置预设（Robotic/Radio/Echo/Deep Voice）；**Stories Editor** 多轨时间线编辑器 |
| 🎤 **语音输入 / 听写** | 全局热键听写（macOS 辅助功能注入，**剪贴板原子保存/恢复**）；LLM 润色（去"嗯""啊"口误）；On-screen pill 浮窗；Captures Tab 统一管理 |
| 🗣 **语音转文字（STT）** | OpenAI Whisper 全家桶（Base/Small/Medium/Large + Turbo，Turbo 比 Large 快 8x）；macOS 走 MLX，Windows/Linux 走 PyTorch |
| 🤖 **Agent 语音接口（MCP）** | 内置 FastMCP（Streamable HTTP）于 `/mcp`；4 个工具：`speak`/`transcribe`/`list_captures`/`list_profiles`；提供 stdio fallback；仓库自带 `.mcp.json`，Claude Code 开箱即用 |
| 🎭 **人格化（Personality）** | 给 Profile 附加自由文本人格描述；两个动作：**Compose**（摇台词）/ **Speak in character**（输入经本地 LLM 改写再 TTS）；Agent 可通过 `personality: true` 走同一管线 |
| 🖥 **跨平台** | macOS (MLX)、Windows/Linux (CUDA)、Linux AMD (ROCm)、Windows (DirectML)、Intel Arc (IPEX)、任何平台 CPU（Kokoro 推荐） |

---

## 🚀 如何使用

### 方式一：装桌面 App（推荐新手）

| 平台 | 装法 |
|------|------|
| **macOS** | <https://voicebox.sh/download/mac-arm> 或 `/mac-intel` 下载 DMG |
| **Windows** | <https://voicebox.sh/download/windows> 下载 MSI |
| **Docker** | `docker compose up` |
| **Linux** | 暂无预编译，按 [voicebox.sh/linux-install](https://voicebox.sh/linux-install) 源码构建 |

App 内首次启动会引导下模型（下完即用）。

### 方式二：从源码跑（开发者）

前置：[Bun](https://bun.sh) · [Rust](https://rustup.rs) · [Python 3.11+](https://python.org) · [Tauri 依赖](https://v2.tauri.app/start/prerequisites/)

```bash
git clone https://github.com/jamiepine/voicebox.git
cd voicebox
brew install just          # 或 cargo install just
just setup                 # 创建 venv + 装依赖
just dev                   # 启动后端 + 桌面 App
```

### 方式三：MCP 接入 Claude Code

Voicebox 启动后（`127.0.0.1:17493`），跑：

```bash
claude mcp add voicebox --transport http --url http://127.0.0.1:17493/mcp --header "X-Voicebox-Client-Id: claude-code"
```

Claude Code 里直接说："用 Morgan 的声音说一句'测试通过'"。

### 方式四：调 REST API

```bash
curl -X POST http://127.0.0.1:17493/speak \
  -H "Content-Type: application/json" \
  -d '{"text": "Deploy complete.", "profile": "Morgan"}'
```

完整 OpenAPI：<http://127.0.0.1:17493/docs>

### 最小可玩示例：30 秒克隆自己

1. 装 App → 启动自动下 Kokoro（82M）
2. **Profiles** → `+` → 录 10 秒自己念一段
3. **Generate** → 输入任意文本 → 选你的 Profile + 引擎 → **Generate**
4. 听到的就是**你自己的声音**

---

## 💡 推荐用法（由浅入深）

| 阶段 | 动作 | 收益 |
|------|------|------|
| 🟢 **尝鲜** | 装 App，录 10 秒音色，生成第一段话 | 30 秒体验本地克隆 |
| 🟢 **尝鲜** | 试全局热键听写 | 替代 WisprFlow，省订阅费 |
| 🟡 **日常** | Kokoro CPU 跑批量听写 | 没显卡也丝滑 |
| 🟡 **日常** | 接 MCP，给各 Agent 各绑一个声音 | **听声辨 Agent** |
| 🟠 **专项** | Stories Editor 做个 2 分钟多角色播客 | 多轨时间线 + 多 Profile |
| 🟠 **专项** | 给 Profile 加 Personality，"Speak in character" | 看本地 LLM 改写多自然 |
| 🔴 **进阶** | 调 `/speak` API：CI 通过 → Voicebox 念出来 | 语音反馈进工程流 |
| 🔴 **进阶** | 加新 TTS 引擎（参考 [TTS 引擎接入指南](docs/content/docs/developer/tts-engines.mdx)） | 给项目贡献引擎 |

> 💬 **建议**：**先跑起来再选引擎**。新机器没显卡就先装 Kokoro 把流程跑通。

---

## 🛠 技术栈

| 层 | 技术 |
|----|------|
| 桌面 App | Tauri (Rust) |
| 前端 | React + TypeScript + Tailwind CSS |
| 后端 | FastAPI (Python) |
| TTS | Qwen3-TTS、LuxTTS、Chatterbox（×2）、TADA、Kokoro 等 7 个 |
| STT | Whisper / Whisper Turbo |
| 本地 LLM | Qwen3 (0.6B/1.7B/4B)，与 TTS/STT 共享 runtime |
| MCP | FastMCP（HTTP）+ stdio shim |
| 效果器 | Pedalboard (Spotify) |
| 推理 | MLX / PyTorch (CUDA/ROCm/XPU/CPU) |

---

## 🔗 相关资源

- **官方仓库**: <https://github.com/jamiepine/voicebox>
- **官网 / Demo 视频**: <https://voicebox.sh>
- **文档站**: <https://docs.voicebox.sh>
- **最新版下载**: <https://github.com/jamiepine/voicebox/releases/latest>
- **MCP 集成指南**: <https://docs.voicebox.sh/overview/mcp-server>
- **作者同款项目**: [Spacedrive](https://github.com/spacedriveapp/spacedrive)——开源文件管理器

### 同名项目区分

| 仓库 | 性质 | 是否本文主角 |
|------|------|------------|
| [`jamiepine/voicebox`](https://github.com/jamiepine/voicebox) | 本地 AI 语音工作室 | ✅ |
| [`myshell-ai/OpenVoice`](https://github.com/myshell-ai/OpenVoice) | MIT+MyShell 的瞬时克隆库（**OpenVoice**，不是 Voicebox） | ❌ |
| Meta Voicebox（论文） | 2023 Meta 研究，**没有完整开源** | ❌ |
| [`Render-AI/Voicebox`](https://github.com/Render-AI/Voicebox) | Voicebox 论文的非官方复现 | ❌ |

---

## ✍️ 写在最后

> **ElevenLabs 告诉你"声音值得花钱"，Voicebox 告诉你"声音属于你自己"。**

Qwen3-TTS、Chatterbox Turbo、Kokoro 这一波开源引擎，质量已经追平甚至局部超过商用方案。剩下的差距只剩三件事：**工程化封装、隐私、和 Agent 集成**。

Voicebox 一次性解决：

- **工程化**：桌面 App，开箱即用，**不是 notebook demo**
- **隐私**：所有声音、听写、克隆数据全程留在本机，**数据不上传**
- **Agent 集成**：MCP 一行命令接 Claude Code，**让 AI 用你的声音跟你说话**

你今天不需要它也活得挺好。但哪天你发现：

- 每月给 ElevenLabs 续费 $22 只是为了偶尔克隆一段旁白
- 同事都开 WisprFlow 听写，你还在手动敲字
- Agent 跑完任务后，**你希望它真的"开口告诉你"** 而不是弹个 notification

那一天，你就会打开 `voicebox.sh`，跑一行 `claude mcp add voicebox`。

**Clone it. Clone your voice. Talk to your agents. 🎙️**