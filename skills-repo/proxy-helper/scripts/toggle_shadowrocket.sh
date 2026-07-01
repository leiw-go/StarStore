#!/bin/bash
# toggle_shadowrocket.sh - 切换 Shadowrocket VPN 开关
#
# 用法: ./toggle_shadowrocket.sh [on|off|toggle|status]
#   on     - 开启 VPN
#   off    - 关闭 VPN
#   toggle - 切换当前状态
#   status - 查看当前状态
#
# 工作原理:
#   1. 通过 AppleScript 激活 Shadowrocket 主窗口
#   2. 找到主窗口中的连接状态 checkbox
#      - 未连接时 label = "未连接"
#      - 已连接时 label = 节点名（如 "香港Y04 | IEPL"）
#   3. 点击 checkbox 切换状态
#   4. 通过外网连通性检测验证结果（TUN 模式无需端口）
#
# 前置条件:
#   - macOS「系统设置 → 隐私与安全 → 辅助功能」必须授予 Terminal/iTerm/Claude Code 权限
#   - Shadowrocket 至少配置了一个可用节点
#
# 状态判断:
#   - UI: checkbox label（未连接 / 节点名）
#   - 网络: 能否直连 gstatic.com/generate_204 返回 204

set -e

ACTION="${1:-status}"

# 检查 Shadowrocket 是否安装
if [ ! -d "/Applications/Shadowrocket.app" ]; then
    echo "ERROR: Shadowrocket.app 未安装在 /Applications/" >&2
    exit 1
fi

# 检查 Shadowrocket 进程是否在运行
if ! pgrep -f Shadowrocket.app >/dev/null 2>&1; then
    echo "ERROR: Shadowrocket 进程未运行，请先打开应用" >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$ACTION" in
    status)
        if "$SCRIPT_DIR/check_proxy.sh" >/dev/null 2>&1; then
            echo "ON"
            exit 0
        else
            echo "OFF"
            exit 1
        fi
        ;;

    on)
        if "$SCRIPT_DIR/check_proxy.sh" >/dev/null 2>&1; then
            echo "ALREADY_ON"
            exit 0
        fi

        # 激活 Shadowrocket 主窗口
        osascript <<'EOF' >/dev/null 2>&1 || true
tell application "Shadowrocket"
    activate
end tell
EOF
        sleep 1

        # 点击未连接的 checkbox
        RESULT=$(osascript <<'EOF' 2>&1
tell application "System Events"
    tell process "Shadowrocket"
        try
            tell window 1
                set uiElems to entire contents
                set checkboxLabels to {}
                repeat with elem in uiElems
                    try
                        if role of elem is "AXCheckBox" then
                            set theLabel to description of elem
                            set end of checkboxLabels to theLabel
                            -- 未连接 = 关闭状态，点击会开启
                            if theLabel is "未连接" then
                                click elem
                                return "clicked:off-to-on"
                            end if
                        end if
                    end try
                end repeat
                return "checkbox-not-found:" & (checkboxLabels as text)
            end tell
        on error errMsg
            return "error: " & errMsg
        end try
    end tell
end tell
EOF
)

        if [[ "$RESULT" != "clicked:off-to-on" ]]; then
            echo "FAILED: $RESULT" >&2
            echo "" >&2
            echo "可能原因及解决方案：" >&2
            echo "  1. 辅助功能未授权 → 系统设置 → 隐私与安全 → 辅助功能 → 添加 Terminal" >&2
            echo "  2. Shadowrocket 主窗口未打开 → 已激活应用，请稍后重试" >&2
            echo "  3. UI 元素已变更 → 手动点击菜单栏 Shadowrocket 图标中的开关" >&2
            exit 2
        fi

        # 等待并验证
        echo "已点击，等待连接建立..." >&2
        for i in 1 2 3 4 5 6; do
            sleep 2
            if "$SCRIPT_DIR/check_proxy.sh" >/dev/null 2>&1; then
                echo "ON (等待 ${i}x2 秒后验证通过)"
                exit 0
            fi
        done

        echo "PARTIAL: UI 已点击但 12 秒内代理未连通（节点可能不可用或正在连接中）" >&2
        echo "可在 Shadowrocket 主窗口查看连接状态" >&2
        exit 3
        ;;

    off)
        if ! "$SCRIPT_DIR/check_proxy.sh" >/dev/null 2>&1; then
            echo "ALREADY_OFF"
            exit 0
        fi

        osascript <<'EOF' >/dev/null 2>&1 || true
tell application "Shadowrocket"
    activate
end tell
EOF
        sleep 1

        # 已连接时 checkbox label 是节点名，不是 "未连接"
        # 直接点击任意 checkbox 都会切换状态
        RESULT=$(osascript <<'EOF' 2>&1
tell application "System Events"
    tell process "Shadowrocket"
        try
            tell window 1
                set uiElems to entire contents
                repeat with elem in uiElems
                    try
                        if role of elem is "AXCheckBox" then
                            -- 当前已连接，点击会关闭
                            click elem
                            return "clicked:on-to-off"
                        end if
                    end try
                end repeat
                return "checkbox-not-found"
            end tell
        on error errMsg
            return "error: " & errMsg
        end try
    end tell
end tell
EOF
)

        if [[ "$RESULT" != "clicked:on-to-off" ]]; then
            echo "FAILED: $RESULT" >&2
            exit 2
        fi

        sleep 3
        if ! "$SCRIPT_DIR/check_proxy.sh" >/dev/null 2>&1; then
            echo "OFF"
            exit 0
        else
            echo "PARTIAL: UI 已点击但代理仍连通" >&2
            exit 3
        fi
        ;;

    toggle)
        if "$SCRIPT_DIR/check_proxy.sh" >/dev/null 2>&1; then
            exec "$0" off
        else
            exec "$0" on
        fi
        ;;

    *)
        echo "用法: $0 [on|off|toggle|status]" >&2
        exit 1
        ;;
esac