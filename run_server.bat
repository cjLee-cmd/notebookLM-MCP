@echo off
REM NotebookLM MCP 서버 실행 래퍼 (Windows)
REM 어떤 AI 도구(Claude Code, Gemini, Cursor 등)에서도 동일하게 사용 가능

REM notebooklm-mcp-cli 소스 경로 (본인 환경에 맞게 수정)
set PROJECT_DIR=%USERPROFILE%\Documents\Python\notebooklm-mcp-cli

uv run --directory "%PROJECT_DIR%" notebooklm-mcp %*
