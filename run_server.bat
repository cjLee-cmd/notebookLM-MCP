@echo off
REM NotebookLM MCP 서버 실행 래퍼 (Windows)
REM Copyright (c) 2026 이창준, (주)파워솔루션
set SCRIPT_DIR=%~dp0
uv run --directory "%SCRIPT_DIR%" notebooklm-mcp %*
