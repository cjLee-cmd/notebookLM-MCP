#!/bin/bash
# NotebookLM MCP 서버 실행 래퍼
# 어떤 AI 도구(Claude Code, Gemini, Cursor 등)에서도 동일하게 사용 가능

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="/Users/cjlee/Documents/Python/notebooklm-mcp-cli"
UV="/opt/homebrew/bin/uv"

exec "$UV" run --directory "$PROJECT_DIR" notebooklm-mcp "$@"
