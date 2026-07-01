# Blocked / Slow Domains in Mainland China

以下域名在中国大陆访问受限或响应极慢，需要通过代理访问。

## 完全被墙（无法直连）

### 搜索引擎 & 工具
- `google.com` / `google.co.jp` / `google.co.uk`
- `youtube.com` / `youtu.be`
- `facebook.com` / `fb.com` / `fb.me`
- `twitter.com` / `t.co` / `x.com`
- `instagram.com`
- `whatsapp.com` / `whatsapp.net`
- `telegram.org` / `t.me`
- `wikipedia.org` (维基百科)
- `reddit.com`
- `pinterest.com`
- `discord.com` / `discord.gg`
- `medium.com`
- `quora.com`

### 开发者平台
- `github.com` / `github.io` / `githubusercontent.com`
- `raw.githubusercontent.com` / `gist.github.com`
- `api.github.com`
- `gitlab.com` (不稳定)
- `bitbucket.org` (不稳定)
- `heroku.com`
- `vercel.com` (部分)
- `netlify.com` (部分)
- `dropbox.com`
- `drive.google.com` (Google Drive)

### 包管理 / 镜像源
- `npmjs.com` (部分包)
- `pypi.org` / `files.pythonhosted.org` (部分)
- `rubygems.org`
- `crates.io`
- `packagist.org`
- `docker.io` / `registry-1.docker.io` / `hub.docker.com`
- `ghcr.io` (GitHub Container Registry)
- `quay.io`
- `gcr.io` (Google Container Registry)

### AI / ML
- `openai.com` / `chat.openai.com`
- `anthropic.com` / `api.anthropic.com`
- `claude.ai`
- `huggingface.co`
- `replicate.com`

### 其他
- `cloudflare.com` (部分功能)
- `aws.amazon.com` / `amazon.com` (购物)
- `gmail.com` (邮件)
- `notion.so`
- `figma.com`
- `slack.com`

## 响应慢但可达（建议代理加速）

- `docker.io` / Docker Hub
- `github.com` (偶尔直连可达但慢)
- `npmjs.com` (npm 官方 registry)
- `pypi.org`
- `golang.org` / `proxy.golang.org`
- `crates.io`
- `archlinux.org` (镜像源除外)
- `kernel.org`
- `sourceforge.net`

## 国内域名（不需要代理）

- `baidu.com` / `baidu.cn`
- `qq.com` / `weixin.qq.com`
- `weibo.com` / `weibo.cn`
- `bilibili.com`
- `taobao.com` / `tmall.com` / `jd.com`
- `douban.com`
- `zhihu.com`
- `csdn.net` / `cnblogs.com` / `jianshu.com`
- `gitee.com` (码云)
- `aliyun.com` / `tencent.com`
- `npm.taobao.org` / `registry.npmmirror.com` (淘宝镜像)

## 匹配规则

在使用 Bash 工具前，扫描命令字符串中的域名：
- `https?://([a-zA-Z0-9.-]+)` → 提取 host
- `git@host:path` SSH 形式 → 检查 host 部分
- `git@github.com:user/repo.git` → `github.com` 匹配

如果 host 命中"完全被墙"或"响应慢"列表，则触发代理开启流程。