# Git HTTPS → SSH URL 转换规则

## 为什么优先 SSH

- SSH 连接（端口 22）通常不被墙 / 较少被 QoS 限速
- HTTPS（端口 443）的 github.com 在国内大部分地区被墙
- SSH 无需代理，免去开/关 Shadowrocket 的开销

## 转换规则

### GitHub

| HTTPS | SSH |
|---|---|
| `https://github.com/user/repo.git` | `git@github.com:user/repo.git` |
| `https://github.com/user/repo` | `git@github.com:user/repo.git` |
| `git://github.com/user/repo.git` | `git@github.com:user/repo.git` |

### GitLab

| HTTPS | SSH |
|---|---|
| `https://gitlab.com/user/repo.git` | `git@gitlab.com:user/repo.git` |
| `https://gitlab.com/user/repo` | `git@gitlab.com:user/repo.git` |
| 自建 `https://gitlab.example.com/user/repo.git` | `git@gitlab.example.com:user/repo.git` |

### Bitbucket

| HTTPS | SSH |
|---|---|
| `https://bitbucket.org/user/repo.git` | `git@bitbucket.org:user/repo.git` |
| `https://user@bitbucket.org/user/repo.git` | `git@bitbucket.org:user/repo.git` |

### Gitee（国内，无需转换）

`https://gitee.com/user/repo.git` — 国内可达，保持 HTTPS 即可。

### 其他自建 Gitea/Forgejo

`https://git.example.com/user/repo.git` → `git@git.example.com:user/repo.git`

## 不做转换的情况

- 已经是 SSH 形式（`git@github.com:...`）→ 直接使用
- 目标主机在「国内域名」列表（gitee、coding.net 等）→ 保持 HTTPS
- 命令是 `git clone git://...`（旧 git 协议）→ 转换为 SSH

## SSH key 检查

转换前先确认用户有可用的 SSH key：

```bash
ls ~/.ssh/id_ed25519 ~/.ssh/id_rsa 2>/dev/null
ssh-add -l  # 检查是否已添加到 keychain
```

如果都没有，提示用户：

> "未检测到 SSH key。建议先生成一个：\n```\nssh-keygen -t ed25519 -C \"your_email@example.com\"\n```\n然后把 `~/.ssh/id_ed25519.pub` 添加到 GitHub Settings → SSH and GPG keys"

## SSH 连接测试

执行 `scripts/check_ssh_github.sh <host>`：
- 返回 `SSH_OK` → 用 SSH，无需代理
- 返回 `SSH_FAIL:<原因>` → 询问是否改用 HTTPS + 代理

## 修改已有仓库的 remote

如果仓库已存在（已经用 HTTPS clone 下来），转换命令为：

```bash
git remote set-url origin git@github.com:user/repo.git
```

## 已知陷阱

1. **子模块**：仓库包含子模块时，子模块的 URL 也需要转换。`git clone --recurse-submodules` 会在克隆时尝试 fetch 所有子模块。如果某个子模块用 HTTPS，可能需要：

   ```bash
   git config --global url."git@github.com:".insteadOf "https://github.com/"
   ```

   这一行让 git 自动把所有 `https://github.com/` 开头的 URL 重写为 SSH。

2. **多个 GitHub 账号**：通过 `~/.ssh/config` 配置 Host 别名：

   ```
   Host github.com-work
       HostName github.com
       User git
       IdentityFile ~/.ssh/id_ed25519_work
   ```

3. **首次连接的 host key 验证**：如果用户开启 `StrictHostKeyChecking=yes`，第一次连会卡住。建议在脚本里用 `-o StrictHostKeyChecking=accept-new`。