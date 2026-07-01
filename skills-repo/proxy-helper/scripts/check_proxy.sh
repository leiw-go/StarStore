#!/bin/bash
# check_proxy.sh - 检测 Shadowrocket 代理/VPN 状态
#
# 用法: ./check_proxy.sh
#
# 检测策略（按优先级）:
#   1. Shadowrocket UI checkbox 状态（最可靠 — 直接读取应用状态）
#      - "未连接" = OFF
#      - 节点名（如 "香港Y04 | IEPL"）= ON
#   2. 真正被墙站点的连通性测试（google.com — 不是 gstatic.com，因为国内有 CDN 镜像）
#   3. HTTP 代理端口监听（兜底 — 仅当用户用 HTTP 代理模式时）
#
# 输出:
#   PROXY_ON  - 代理工作正常
#   PROXY_OFF - 代理未开启或不可达

set -e

PROBE_URL="https://www.google.com/"   # 真正被墙的站点
TIMEOUT=5

# 检测 Shadowrocket UI 状态（最可靠）
check_shadowrocket_ui() {
    if [ ! -d "/Applications/Shadowrocket.app" ]; then
        return 1
    fi
    if ! pgrep -f Shadowrocket.app >/dev/null 2>&1; then
        return 1
    fi

    local result
    result=$(osascript <<'EOF' 2>&1
tell application "System Events"
    tell process "Shadowrocket"
        try
            tell window 1
                set uiElems to entire contents
                repeat with elem in uiElems
                    try
                        if role of elem is "AXCheckBox" then
                            set theLabel to description of elem
                            if theLabel is "未连接" then
                                return "OFF"
                            else
                                return "ON:" & theLabel
                            end if
                        end if
                    end try
                end repeat
                return "no-checkbox"
            end tell
        on error errMsg
            return "error: " & errMsg
        end try
    end tell
end tell
EOF
)

    if [[ "$result" == "OFF" ]]; then
        return 1
    elif [[ "$result" == ON:* ]]; then
        echo "${result#ON:}"
        return 0
    fi
    return 2
}

# 检测常见 HTTP 代理端口
check_proxy_port() {
    local ports=(7890 7891 1080 1087 8118 3128 10809 10808)
    for port in "${ports[@]}"; do
        if lsof -nP -iTCP:"$port" -sTCP:LISTEN >/dev/null 2>&1; then
            local code
            code=$(curl -sS -o /dev/null -w "%{http_code}" \
                -x "http://127.0.0.1:${port}" \
                --max-time "$TIMEOUT" \
                "$PROBE_URL" 2>/dev/null || echo "000")
            if [ "$code" = "200" ] || [ "$code" = "204" ]; then
                echo "http_port:$port"
                return 0
            fi
        fi
    done
    return 1
}

# 直接连通性测试：能访问真正被墙的 google.com = 代理工作
check_connectivity() {
    local code
    code=$(curl -sS -o /dev/null -w "%{http_code}" \
        --max-time "$TIMEOUT" \
        -L \
        "$PROBE_URL" 2>/dev/null || echo "000")
    if [ "$code" = "200" ] || [ "$code" = "204" ]; then
        echo "connectivity"
        return 0
    fi
    return 1
}

# 主流程
if NODE=$(check_shadowrocket_ui); then
    echo "PROXY_ON:ui:$NODE" >&2
    echo "PROXY_ON"
    exit 0
fi

if PORT=$(check_proxy_port); then
    echo "PROXY_ON:$PORT" >&2
    echo "PROXY_ON"
    exit 0
fi

if check_connectivity; then
    echo "PROXY_ON:connectivity" >&2
    echo "PROXY_ON"
    exit 0
fi

echo "PROXY_OFF: 所有检测方法均显示代理未工作" >&2
echo "PROXY_OFF"
exit 1