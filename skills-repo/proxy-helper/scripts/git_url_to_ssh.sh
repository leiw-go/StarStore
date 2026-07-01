#!/bin/bash
# git_url_to_ssh.sh - 将 HTTPS git URL 转换为 SSH 形式
#
# 用法: ./git_url_to_ssh.sh <https_url>
#   https_url: 完整的 https:// 开头的 git URL
#
# 输出: SSH URL（如 git@github.com:user/repo.git）
#       已经是 SSH 形式则原样输出
#       国内域名（如 gitee.com）则原样输出 HTTPS
#
# 退出码:
#   0 - 转换成功
#   1 - 无法识别的主机

set -e

URL="$1"

if [ -z "$URL" ]; then
    echo "用法: $0 <https_url>" >&2
    exit 1
fi

# 已经是 SSH 形式
if [[ "$URL" == git@* ]] || [[ "$URL" == ssh://* ]]; then
    echo "$URL"
    exit 0
fi

# 国内域名 — 不转换
if [[ "$URL" =~ gitee\.com|coding\.net|coding\.tencent\.com|cnblogs\.com ]]; then
    echo "$URL"
    exit 0
fi

# 提取主机和路径
# 支持: https://github.com/user/repo.git
#       https://github.com/user/repo
#       https://user@github.com/user/repo.git  (user@ 认证)
if [[ "$URL" =~ ^https?://(([^@/]+)@)?([^/]+)(/.*)?$ ]]; then
    AUTH="${BASH_REMATCH[2]}"
    HOST="${BASH_REMATCH[3]}"
    PATH_PART="${BASH_REMATCH[4]}"
else
    echo "ERROR: 无法解析 URL: $URL" >&2
    exit 1
fi

# 去掉路径前的 /，并确保以 .git 结尾
PATH_PART="${PATH_PART#/}"
if [[ "$PATH_PART" != *.git ]]; then
    PATH_PART="${PATH_PART}.git"
fi

# 检查已知主机
case "$HOST" in
    github.com|gitlab.com|bitbucket.org)
        echo "git@${HOST}:${PATH_PART}"
        exit 0
        ;;
    *)
        # 自建 git 服务（GitHub Enterprise、GitLab Self-hosted、Gitea/Forgejo）
        # 只要不是已知被墙的，就尝试 SSH
        echo "git@${HOST}:${PATH_PART}"
        exit 0
        ;;
esac