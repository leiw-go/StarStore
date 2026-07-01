---
name: proxy-helper
description: 当用户在中国大陆访问 GitHub、Google 等被墙或响应慢的域名时，提示并自动开启 Shadowrocket 代理；在任务完成后提示关闭代理。**Use this skill whenever the user is about to run a Bash command that touches a known blocked or slow domain in mainland China** — this includes git clone/pull/push against github.com, curl/wget against google.com or other blocked endpoints, npm/pip/docker pulls from blocked registries, gh CLI operations, or any Bash command where the URL contains a known-blocked host. **For git commands specifically, prefer converting HTTPS URLs to SSH first** — SSH to GitHub/GitLab usually works without proxy in China, saving a Shadowrocket round-trip. Do NOT wait for the command to time out and fail — proactively invoke this skill before running such commands.
---

# Proxy Helper

为中国大陆用户设计的代理辅助 skill。
- 对于 **git 命令**：优先尝试 SSH 协议（通常无需代理）；只有 SSH 不通时才回落到 HTTPS + Shadowrocket。
- 对于 **其他命令**（curl/wget/npm/docker 等）：直接开 Shadowrocket 走代理。

## 何时触发

**主动触发** —— 在以下情况**之前**调用此 skill，不要等命令超时：

- `git clone/pull/push/fetch` 涉及 `github.com`、`gitlab.com`、`bitbucket.org` 等 → **优先 SSH**
- `curl`/`wget` 访问 `google.com`、`youtube.com`、`facebook.com` 等
- `gh` CLI 的任何操作
- `npm install`/`pip install` 涉及被墙的源
- `docker pull` 从 `docker.io`/`ghcr.io`
- `brew install` 拉取 GitHub 上的 formula
- 用户**明确提到**要访问境外网站

## 默认代理配置

- **应用**: Shadowrocket (macOS)
- **运行模式**: TUN 模式 — 也兼容 HTTP 代理模式
- **检测脚本**: `scripts/check_proxy.sh` 通过 Shadowrocket 主窗口 checkbox 状态判断

## 手动备用方案

当 AppleScript 无法点击 checkbox 时，告诉用户：

1. **点击菜单栏图标** — 屏幕右上角的飞行物/火箭图标，点一下即可切换开关
2. **或打开主窗口** — 点击菜单栏图标 → 在主窗口点击 "未连接/已连接" 那个圆圈
3. **快捷键**（需在 Shadowrocket 设置中自定义）

不要绕过用户的明确意图（如改 `networksetup`、kill Shadowrocket 进程等）。

## 工作流程

### 第 0 步：判断命令类型

扫描即将执行的 Bash 命令：
- 包含 `git` 且目标是远程仓库 → 走「**Git SSH 优先流程**」
- 其他命令 → 走「**常规代理流程****

### Git SSH 优先流程（推荐）

#### A. 提取并转换 URL

提取命令中的 URL：
- `git clone https://github.com/user/repo.git` → `https://github.com/user/repo.git`
- `git clone git@github.com:user/repo.git` → `git@github.com:user/repo.git`（已是 SSH）

用 `scripts/git_url_to_ssh.sh <url>` 转为 SSH 形式。如果原本就是 SSH，跳过转换。

#### B. 检查 SSH key 与连通性

执行 `scripts/check_ssh_git.sh <host>`：
- 返回 `SSH_OK` → 进入 C
- 返回 `SSH_FAIL:no-key` → 提示用户生成 SSH key：
  > "未检测到 SSH key。需要先生成：\n```\nssh-keygen -t ed25519 -C \"your_email@example.com\"\n```\n然后把 `~/.ssh/id_ed25519.pub` 添加到 GitHub Settings → SSH and GPG keys"
- 返回 `SSH_FAIL:auth-failed` → 提示用户把 key 添加到目标主机
- 返回 `SSH_FAIL:connection-failed` → 网络问题，**回落到 HTTPS + 代理**

#### C. 用 SSH 执行命令（无需代理）

告诉用户：

> "已确认 SSH 到 github.com 可用，直接用 SSH 协议（无需开代理）。\n
> 命令将从 `git clone https://github.com/...` 改为 `git clone git@github.com:...`"

然后用转换后的 URL 执行原 git 命令。**整个流程无需触碰 Shadowrocket**。

#### D. 已 clone 仓库的转换

如果用户已经在本地有 HTTPS clone 的仓库，想切换到 SSH：

```bash
git remote set-url origin git@github.com:user/repo.git
```

或全局 URL 重写（自动把所有 https 改写为 ssh，推荐用于频繁切换）：

```bash
git config --global url."git@github.com:".insteadOf "https://github.com/"
```

### 常规代理流程（非 git 命令）

#### 第 1 步：检测是否需要代理

读取 `references/blocked-domains.md`，匹配命令中的 URL/域名。不匹配则直接执行。

#### 第 2 步：检查代理状态

执行 `scripts/check_proxy.sh`：
- `PROXY_ON` → 直接执行
- `PROXY_OFF` → 进入第 3 步

#### 第 3 步：开启 Shadowrocket

执行 `scripts/toggle_shadowrocket.sh on`，等 2-12 秒验证。

明确告知用户：

> "接下来要访问 google.com（被墙），需要开启 Shadowrocket。我会自动帮你打开，命令完成后会提醒你关闭。"

#### 第 4 步：执行命令

通过环境变量方式：

```bash
HTTPS_PROXY=http://127.0.0.1:7890 HTTP_PROXY=http://127.0.0.1:7890 \
  curl https://www.google.com
```

工具特定配置（更持久）：
- `git`：`git config --global http.proxy http://127.0.0.1:7890`
- `curl`：`curl -x http://127.0.0.1:7890 ...`
- `npm`：`npm config set proxy http://127.0.0.1:7890`

### 第 5 步：任务完成 → 提醒关闭代理

任务成功后，**主动询问**用户：

> "任务完成。是否关闭 Shadowrocket 代理？"

执行 `scripts/toggle_shadowrocket.sh off`。**不要强行关闭**——用户可能还有其他操作。

## 不在触发范围的场景

- 已经是 SSH 形式（如 `git@github.com:...`）→ 无需操作
- 目标明确是国内域名（`baidu.com`、`gitee.com`、`bilibili.com`）→ 不触发
- 用户明确说"现在不需要代理"→ 不触发
- SSH 已通过且命令不需要 HTTPS → 完全跳过代理流程

## 故障排查

### toggle_shadowrocket.sh 无效

1. `pgrep -lf Shadowrocket` — 检查应用是否运行
2. 菜单栏手动点击开关
3. 检查订阅节点是否可用
4. **不要**擅自改 `networksetup` 或 kill 进程

### 检测误判

- **gstatic.com 在国内有 CDN 镜像** — 不要用作检测（已用 google.com）
- **其他 VPN（Tailscale、WARP、公司 VPN）也会让 google.com 可达** — 检测的是 Shadowrocket 自身的 checkbox 状态，不受影响
- **辅助功能权限被重置** — 系统升级或清理工具可能重置，需要重新授权

### SSH 检测误判

- `SSH_FAIL:auth-failed` 但实际 key 是对的 → 可能是 `~/.ssh/config` 配置错误或 `KnownHosts` 问题
- `SSH_FAIL:connection-failed` 但实际网络可达 → 检查防火墙是否拦截了 22 端口

## 参考文件

- `references/blocked-domains.md` — 被墙/慢速域名清单
- `references/git-ssh-conversion.md` — Git HTTPS → SSH 转换规则
- `scripts/check_proxy.sh` — 代理状态检测
- `scripts/toggle_shadowrocket.sh` — Shadowrocket 开关控制
- `scripts/git_url_to_ssh.sh` — Git URL 转换
- `scripts/check_ssh_git.sh` — SSH 连通性检测