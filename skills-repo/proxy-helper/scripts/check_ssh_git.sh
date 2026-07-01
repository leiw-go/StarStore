#!/bin/bash
# check_ssh_git.sh - 检测 SSH 到 git 主机是否可用（无需代理）
#
# 用法: ./check_ssh_git.sh [host] [--check-key]
#   host: git 主机名，默认 github.com
#   --check-key: 先检查 ~/.ssh 下是否有可用 key
#
# 输出:
#   SSH_OK              - SSH 连接正常（认证成功）
#   SSH_OK:no-shell     - 连接成功但主机无 shell（git 场景正常，如 github.com）
#   SSH_FAIL:<原因>     - 连接失败
#
# 工作原理:
#   用 ssh -T 模拟 git 的连接方式（无 shell 分配），5 秒超时
#   - GitHub/GitLab/Bitbucket 对 SSH git 操作返回 "successfully authenticated" 但拒绝 shell
#     → 这是正常的，等同于 SSH_OK
#   - 连接超时/拒绝 → SSH_FAIL

set -e

HOST="${1:-github.com}"
CHECK_KEY_ONLY=false

for arg in "$@"; do
    if [ "$arg" = "--check-key" ]; then
        CHECK_KEY_ONLY=true
    fi
done

# 检查本地 SSH key
if [ "$CHECK_KEY_ONLY" = true ] || true; then
    HAS_KEY=false
    for key in ~/.ssh/id_ed25519 ~/.ssh/id_rsa ~/.ssh/id_ecdsa ~/.ssh/id_dsa; do
        if [ -f "$key" ]; then
            HAS_KEY=true
            break
        fi
    done
    if [ "$HAS_KEY" = false ]; then
        echo "SSH_FAIL:no-key in ~/.ssh/" >&2
        echo "  生成新 key: ssh-keygen -t ed25519 -C \"your@email.com\"" >&2
        echo "SSH_FAIL"
        exit 1
    fi
fi

# 测试 SSH 连接
OUTPUT=$(ssh -T \
    -o ConnectTimeout=5 \
    -o StrictHostKeyChecking=accept-new \
    -o BatchMode=yes \
    -o PasswordAuthentication=no \
    "git@${HOST}" 2>&1) || SSH_EXIT=$?
SSH_EXIT="${SSH_EXIT:-0}"

# GitHub/GitLab 等返回 "successfully authenticated" 但 exit code 非 0（因为无 shell）
if echo "$OUTPUT" | grep -qiE "successfully authenticated|Hi [a-zA-Z0-9_-]+"; then
    echo "SSH_OK:authenticated as $(echo "$OUTPUT" | grep -oE 'Hi [a-zA-Z0-9_-]+' | head -1 | cut -d' ' -f2)" >&2
    echo "SSH_OK"
    exit 0
fi

# 其他情况
case "$SSH_EXIT" in
    0)
        echo "SSH_OK" >&2
        echo "SSH_OK"
        exit 0
        ;;
    255)
        if echo "$OUTPUT" | grep -qiE "connection (timed out|refused|closed)|no route to host|operation timed out"; then
            echo "SSH_FAIL:connection-failed ($HOST 不可达)" >&2
        elif echo "$OUTPUT" | grep -qiE "permission denied|authentication failed"; then
            echo "SSH_FAIL:auth-failed (key 未添加到 ${HOST} 或权限错误)" >&2
        else
            echo "SSH_FAIL:ssh-error: $OUTPUT" >&2
        fi
        echo "SSH_FAIL"
        exit 1
        ;;
    *)
        echo "SSH_FAIL:exit-$SSH_EXIT: $OUTPUT" >&2
        echo "SSH_FAIL"
        exit 1
        ;;
esac