#!/bin/bash
# NotebookLM MCP 설치 스크립트 (macOS / Linux)
# Copyright (c) 2026 이창준, (주)파워솔루션
# MIT License
#
# 사용법:
#   curl -LsSf https://raw.githubusercontent.com/cjLee-cmd/notebookLM-MCP/main/install.sh | sh

set -e

REPO_URL="https://github.com/cjLee-cmd/notebookLM-MCP.git"
INSTALL_DIR="$HOME/notebookLM-MCP"
WRAPPER="$INSTALL_DIR/mcp-wrapper/run_server.sh"

echo "======================================"
echo " NotebookLM MCP 설치"
echo " Copyright (c) 2026 이창준, (주)파워솔루션"
echo "======================================"
echo ""

# 1. uv 설치 확인
if ! command -v uv &>/dev/null && ! [ -f "/opt/homebrew/bin/uv" ] && ! [ -f "$HOME/.local/bin/uv" ]; then
    echo "▶ uv 설치 중..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "✓ uv 확인됨"
fi

# 2. 소스 클론
if [ -d "$INSTALL_DIR" ]; then
    echo "▶ 기존 설치 업데이트 중..."
    git -C "$INSTALL_DIR" pull
else
    echo "▶ 소스 다운로드 중..."
    git clone "$REPO_URL" "$INSTALL_DIR"
fi

# 3. 의존성 설치
echo "▶ 의존성 설치 중..."
cd "$INSTALL_DIR"
uv sync

# 4. 실행 권한
chmod +x "$WRAPPER"

# 5. 인증
echo ""
echo "▶ Google 계정 인증 중... (Chrome이 자동으로 열립니다)"
uv run nlm login

echo ""
echo "======================================"
echo " 설치 완료!"
echo "======================================"
echo ""
echo "▶ MCP 설정 방법:"
echo ""
echo "[Claude Code] ~/.claude.json 에 추가:"
echo '  "notebooklm": {'
echo '    "type": "stdio",'
echo '    "command": "/opt/homebrew/bin/uv",'
echo "    \"args\": [\"run\", \"--directory\", \"$INSTALL_DIR\", \"notebooklm-mcp\"]"
echo '  }'
echo ""
echo "[Gemini / Cursor / 기타] MCP 설정에 추가:"
echo '  "notebooklm": {'
echo "    \"command\": \"$WRAPPER\","
echo '    "args": []'
echo '  }'
echo ""
echo "자세한 설정은 README를 참고하세요:"
echo "  $INSTALL_DIR/mcp-wrapper/README.md"
