#!/bin/bash
# NotebookLM MCP 설치 스크립트 (macOS / Linux)
# Copyright (c) 2026 이창준, (주)파워솔루션
# MIT License
#
# 사용법:
#   curl -LsSf https://raw.githubusercontent.com/cjLee-cmd/notebookLM-MCP/main/install.sh | bash

set -e

REPO_URL="https://github.com/cjLee-cmd/notebookLM-MCP.git"
INSTALL_DIR="$HOME/notebookLM-MCP"
WRAPPER="$INSTALL_DIR/run_server.sh"

echo "======================================"
echo " NotebookLM MCP 설치"
echo " Copyright (c) 2026 이창준, (주)파워솔루션"
echo "======================================"
echo ""

# ── 1. uv 탐지 및 설치 ────────────────────────────────────────────
if [ -f "/opt/homebrew/bin/uv" ]; then
    UV="/opt/homebrew/bin/uv"
elif [ -f "$HOME/.local/bin/uv" ]; then
    UV="$HOME/.local/bin/uv"
elif command -v uv &>/dev/null; then
    UV="uv"
else
    echo "▶ uv 설치 중..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
    UV="$HOME/.local/bin/uv"
fi
echo "✓ uv: $UV"

# ── 2. git 확인 ───────────────────────────────────────────────────
if ! command -v git &>/dev/null; then
    echo "오류: git이 설치되어 있지 않습니다. git을 먼저 설치해 주세요."
    exit 1
fi

# ── 3. 소스 클론 또는 업데이트 ───────────────────────────────────
if [ -d "$INSTALL_DIR/.git" ]; then
    echo "▶ 기존 설치 업데이트 중..."
    git -C "$INSTALL_DIR" pull
else
    echo "▶ 소스 다운로드 중..."
    git clone "$REPO_URL" "$INSTALL_DIR"
fi
echo "✓ 설치 경로: $INSTALL_DIR"

# ── 4. 의존성 설치 ────────────────────────────────────────────────
echo "▶ 의존성 설치 중..."
cd "$INSTALL_DIR"
"$UV" sync
echo "✓ 의존성 설치 완료"

# ── 5. 실행 권한 ──────────────────────────────────────────────────
chmod +x "$WRAPPER"

# ── 6. Claude Code MCP 자동 등록 ─────────────────────────────────
CLAUDE_JSON="$HOME/.claude.json"
if command -v claude &>/dev/null || [ -f "$CLAUDE_JSON" ]; then
    if [ ! -f "$CLAUDE_JSON" ]; then
        echo '{}' > "$CLAUDE_JSON"
    fi
    "$UV" run python - <<PYEOF
import json
path = '$CLAUDE_JSON'
with open(path, 'r') as f:
    d = json.load(f)
d.setdefault('mcpServers', {})['notebooklm'] = {
    "type": "stdio",
    "command": "$UV",
    "args": ["run", "--directory", "$INSTALL_DIR", "notebooklm-mcp"]
}
with open(path, 'w') as f:
    json.dump(d, f, indent=2, ensure_ascii=False)
print("✓ Claude Code MCP 등록 완료: " + path)
PYEOF
else
    echo "- Claude Code 미설치 (건너뜀)"
fi

# ── 6b. Claude Desktop MCP 자동 등록 ────────────────────────────
CLAUDE_DESKTOP=""
if [ "$(uname)" = "Darwin" ]; then
    CLAUDE_DESKTOP="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
elif [ "$(uname)" = "Linux" ]; then
    CLAUDE_DESKTOP="$HOME/.config/Claude/claude_desktop_config.json"
fi
if [ -n "$CLAUDE_DESKTOP" ] && [ -d "$(dirname "$CLAUDE_DESKTOP")" ]; then
    if [ ! -f "$CLAUDE_DESKTOP" ]; then
        echo '{}' > "$CLAUDE_DESKTOP"
    fi
    "$UV" run python - <<PYEOF
import json
path = '''$CLAUDE_DESKTOP'''
with open(path, 'r') as f:
    d = json.load(f)
d.setdefault('mcpServers', {})['notebooklm'] = {
    "command": "$UV",
    "args": ["run", "--directory", "$INSTALL_DIR", "notebooklm-mcp"]
}
with open(path, 'w') as f:
    json.dump(d, f, indent=2, ensure_ascii=False)
print("✓ Claude Desktop MCP 등록 완료: " + path)
PYEOF
else
    echo "- Claude Desktop 미설치 (건너뜀)"
fi

# ── 7. Gemini CLI MCP 자동 등록 ────────────────────────────────────
GEMINI_SETTINGS="$HOME/.gemini/settings.json"
if command -v gemini &>/dev/null || [ -d "$HOME/.gemini" ]; then
    if [ ! -f "$GEMINI_SETTINGS" ]; then
        echo '{}' > "$GEMINI_SETTINGS"
    fi
    "$UV" run python - <<PYEOF
import json
path = '$GEMINI_SETTINGS'
with open(path, 'r') as f:
    d = json.load(f)
d.setdefault('mcpServers', {})['notebooklm'] = {
    "command": "$WRAPPER",
    "args": []
}
with open(path, 'w') as f:
    json.dump(d, f, indent=2, ensure_ascii=False)
print("✓ Gemini CLI MCP 등록 완료: " + path)
PYEOF
else
    echo "- Gemini CLI 미설치 (건너뜀)"
fi

# ── 8. Google 계정 인증 ───────────────────────────────────────────
echo ""
echo "▶ Google 계정 인증 중... (Chrome이 자동으로 열립니다)"
"$UV" run --directory "$INSTALL_DIR" nlm login

# ── 9. 완료 메시지 ────────────────────────────────────────────────
echo ""
echo "======================================"
echo " 설치 완료!"
echo "======================================"
echo ""
echo "✓ 설치 경로   : $INSTALL_DIR"
echo "✓ Claude Code : ~/.claude.json (설치된 경우 자동 등록됨)"
echo "✓ Claude Desktop: ~/Library/.../claude_desktop_config.json (설치된 경우 자동 등록됨)"
echo "✓ Gemini CLI  : ~/.gemini/settings.json (설치된 경우 자동 등록됨)"
echo ""
echo "▶ 다음 단계:"
echo "  1. Claude Code / Gemini 를 재시작하세요."
echo "  2. '노트북 목록 보여줘' 라고 입력해보세요."
echo ""
echo "▶ Cursor / Cline 등 기타 도구는 MCP 설정에 아래를 추가하세요:"
echo "  macOS/Linux:"
echo "    \"notebooklm\": {"
echo "      \"command\": \"$WRAPPER\","
echo "      \"args\": []"
echo "    }"
echo ""
echo "자세한 내용: $INSTALL_DIR/README.md"
