@echo off
REM NotebookLM MCP 설치 스크립트 (Windows)
REM Copyright (c) 2026 이창준, (주)파워솔루션
REM MIT License
REM
REM 사용법: 터미널(CMD 또는 PowerShell)에서 실행
REM   install.bat

setlocal enabledelayedexpansion

set REPO_URL=https://github.com/cjLee-cmd/notebookLM-MCP.git
set INSTALL_DIR=%USERPROFILE%\notebookLM-MCP
set WRAPPER=%INSTALL_DIR%\run_server.bat

echo ======================================
echo  NotebookLM MCP 설치
echo  Copyright (c) 2026 이창준, (주)파워솔루션
echo ======================================
echo.

REM ── 1. uv 설치 확인 ──────────────────────────────────────────
where uv >nul 2>&1
if errorlevel 1 (
    echo ▶ uv 설치 중...
    powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
    if errorlevel 1 (
        echo 오류: uv 설치에 실패했습니다.
        exit /b 1
    )
    REM PATH 갱신
    set "PATH=%USERPROFILE%\.cargo\bin;%USERPROFILE%\.local\bin;%PATH%"
)
where uv >nul 2>&1
if errorlevel 1 (
    echo 오류: uv 설치 후에도 uv를 찾을 수 없습니다. 터미널을 재시작한 뒤 다시 실행하세요.
    exit /b 1
)
echo ✓ uv 확인됨

REM ── 2. git 확인 ───────────────────────────────────────────────
where git >nul 2>&1
if errorlevel 1 (
    echo 오류: git이 설치되어 있지 않습니다.
    echo 설치: https://git-scm.com/download/win
    exit /b 1
)

REM ── 3. 소스 클론 또는 업데이트 ────────────────────────────────
if exist "%INSTALL_DIR%\.git" (
    echo ▶ 기존 설치 업데이트 중...
    git -C "%INSTALL_DIR%" pull
) else (
    echo ▶ 소스 다운로드 중...
    git clone %REPO_URL% "%INSTALL_DIR%"
)
echo ✓ 설치 경로: %INSTALL_DIR%

REM ── 4. 의존성 설치 ────────────────────────────────────────────
echo ▶ 의존성 설치 중...
cd /d "%INSTALL_DIR%"
uv sync
echo ✓ 의존성 설치 완료

REM ── 5. Claude Code MCP 자동 등록 ──────────────────────────────
set CLAUDE_JSON=%USERPROFILE%\.claude.json
where claude >nul 2>&1
if not errorlevel 1 (
    if not exist "%CLAUDE_JSON%" echo {} > "%CLAUDE_JSON%"
)
if exist "%CLAUDE_JSON%" (
    echo ▶ Claude Code MCP 등록 중...
    uv run python -c "import json,os; p=r'%CLAUDE_JSON%'; d=json.load(open(p)); d.setdefault('mcpServers',{})['notebooklm']={'type':'stdio','command':'uv','args':['run','--directory',r'%INSTALL_DIR%'.replace(os.sep,'/'),'notebooklm-mcp']}; json.dump(d,open(p,'w'),indent=2,ensure_ascii=False); print('✓ Claude Code MCP 등록 완료')"
    if errorlevel 1 (
        echo ⚠ Claude Code MCP 자동 등록 실패. 수동으로 추가해 주세요.
    )
) else (
    echo - Claude Code 미설치 (건너뜀^)
)

REM ── 5b. Claude Desktop MCP 자동 등록 ────────────────────────────
set CLAUDE_DESKTOP=%APPDATA%\Claude\claude_desktop_config.json
if exist "%APPDATA%\Claude" (
    echo ▶ Claude Desktop MCP 등록 중...
    if not exist "%CLAUDE_DESKTOP%" echo {} > "%CLAUDE_DESKTOP%"
    uv run python -c "import json,os; p=r'%CLAUDE_DESKTOP%'; d=json.load(open(p)); d.setdefault('mcpServers',{})['notebooklm']={'command':'uv','args':['run','--directory',r'%INSTALL_DIR%'.replace(os.sep,'/'),'notebooklm-mcp']}; json.dump(d,open(p,'w'),indent=2,ensure_ascii=False); print('✓ Claude Desktop MCP 등록 완료')"
    if errorlevel 1 (
        echo ⚠ Claude Desktop MCP 자동 등록 실패. 수동으로 추가해 주세요.
    )
) else (
    echo - Claude Desktop 미설치 (건너뜀^)
)

REM ── 6. Gemini CLI MCP 자동 등록 ─────────────────────────────────
set GEMINI_SETTINGS=%USERPROFILE%\.gemini\settings.json
if exist "%USERPROFILE%\.gemini" (
    echo ▶ Gemini CLI MCP 등록 중...
    if not exist "%GEMINI_SETTINGS%" echo {} > "%GEMINI_SETTINGS%"
    uv run python -c "import json; p=r'%GEMINI_SETTINGS%'; d=json.load(open(p)); d.setdefault('mcpServers',{})['notebooklm']={'command':r'%WRAPPER%','args':[]}; json.dump(d,open(p,'w'),indent=2,ensure_ascii=False); print('✓ Gemini CLI MCP 등록 완료')"
    if errorlevel 1 (
        echo ⚠ Gemini CLI MCP 자동 등록 실패. 수동으로 추가해 주세요.
    )
) else (
    echo - Gemini CLI 미설치 (건너뜀^)
)

REM ── 7. Google 계정 인증 ───────────────────────────────────────
echo.
echo ▶ Google 계정 인증 중... (Chrome이 자동으로 열립니다)
uv run nlm login

REM ── 8. 완료 ───────────────────────────────────────────────────
echo.
echo ======================================
echo  설치 완료!
echo ======================================
echo.
echo ✓ 설치 경로    : %INSTALL_DIR%
echo ✓ Claude Code  : 자동 등록됨 (설치된 경우)
echo ✓ Claude Desktop: 자동 등록됨 (설치된 경우)
echo ✓ Gemini CLI   : 자동 등록됨 (설치된 경우)
echo.
echo ▶ 다음 단계:
echo   1. Claude Code / Gemini 를 재시작하세요.
echo   2. '노트북 목록 보여줘' 라고 입력해보세요.
echo.
echo ▶ Cursor / Cline 등 기타 도구는 MCP 설정에 아래를 추가하세요:
echo   "notebooklm": {
echo     "command": "%WRAPPER%",
echo     "args": []
echo   }
echo.
echo 자세한 내용: %INSTALL_DIR%\README.md

endlocal
