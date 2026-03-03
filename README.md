# NotebookLM MCP 래퍼

> **작성자**: 이창준 / (주)파워솔루션
> **라이선스**: [MIT License](./LICENSE) — 자유롭게 사용, 수정, 배포 가능
> **사용 알림**: 법적 의무는 아니지만, 사용 시 작성자에게 알려주시면 감사합니다. ([NOTICE.md](./NOTICE.md) 참고)

---

## 개요

Google NotebookLM을 Claude Code, Gemini, Cursor 등 **모든 MCP 지원 AI 도구**에서 사용할 수 있도록 만든 래퍼입니다.

원본 오픈소스(`notebooklm-mcp-cli`)를 기반으로 아래 기능을 개선했습니다:
- `refresh_auth`: 인증 만료 시 `nlm login`을 자동 실행하여 Chrome 팝업으로 재인증

---

## 저작권 안내

이 소프트웨어는 **MIT 라이선스**로 배포됩니다. 누구나 자유롭게 사용, 수정, 재배포할 수 있습니다.

```
Copyright (c) 2026 이창준, (주)파워솔루션
```

단, 사용 시 저작권 표시(`Copyright (c) 2026 이창준, (주)파워솔루션`)를 유지해 주세요.

> **사용 알림 요청 (권고사항)**
> 법적 의무는 아니지만, 사용하실 경우 작성자에게 알려주시면 소프트웨어 개선에 큰 도움이 됩니다.

---

## 파일 구성

```
notebooklm-mcp/
├── run_server.sh    ← macOS / Linux 실행 래퍼
├── run_server.bat   ← Windows 실행 래퍼
└── README.md        ← 이 파일
```

---

## 사전 준비

### 1. uv 설치 (Python 패키지 매니저)

**macOS / Linux:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Windows (PowerShell):**
```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

설치 확인:
```bash
uv --version
```

### 2. 래퍼 파일 다운로드

이 저장소를 클론합니다:
```bash
git clone https://github.com/cjLee-cmd/notebookLM-MCP.git
cd notebookLM-MCP
```

---

## 실행 파일 경로 설정

각자의 환경에 맞게 소스 경로를 수정해야 합니다.

### macOS (`run_server.sh`)

파일을 열어 `PROJECT_DIR` 경로를 본인 환경에 맞게 수정:
```bash
PROJECT_DIR="/Users/본인계정/Documents/Python/notebooklm-mcp-cli"
```

실행 권한 부여:
```bash
chmod +x run_server.sh
```

### Windows (`run_server.bat`)

파일을 열어 `PROJECT_DIR` 경로를 본인 환경에 맞게 수정:
```bat
set PROJECT_DIR=C:\Users\본인계정\Documents\Python\notebooklm-mcp-cli
```

---

## Google 인증

NotebookLM은 Google 계정 인증이 필요합니다.

**최초 인증 (또는 만료 시):**

macOS:
```bash
cd ~/Documents/Python/notebooklm-mcp-cli
uv run nlm login
```

Windows:
```bat
cd %USERPROFILE%\Documents\Python\notebooklm-mcp-cli
uv run nlm login
```

Chrome 브라우저가 자동으로 열리고, Google 계정으로 로그인하면 완료됩니다.

> 인증은 약 1주일간 유지됩니다. 만료 시 MCP에서 `refresh_auth` 도구를 호출하면 자동으로 재인증됩니다.

---

## AI 도구별 MCP 설정

### Claude Code

`~/.claude.json` 파일의 `mcpServers` 항목에 추가:

**macOS:**
```json
"notebooklm": {
  "type": "stdio",
  "command": "/opt/homebrew/bin/uv",
  "args": [
    "run",
    "--directory",
    "/Users/본인계정/Documents/Python/notebooklm-mcp-cli",
    "notebooklm-mcp"
  ]
}
```

**Windows:**
```json
"notebooklm": {
  "type": "stdio",
  "command": "uv",
  "args": [
    "run",
    "--directory",
    "C:\\Users\\본인계정\\Documents\\Python\\notebooklm-mcp-cli",
    "notebooklm-mcp"
  ]
}
```

Claude Code 재시작 후 `/mcp` 명령으로 `notebooklm` 서버 확인.

---

### Gemini (Antigravity)

`~/.gemini/antigravity/mcp_config.json` 파일에 추가:

**macOS:**
```json
"notebooklm": {
  "command": "/path/to/notebooklm-mcp/run_server.sh",
  "args": [],
  "disabled": false
}
```

**Windows:**
```json
"notebooklm": {
  "command": "C:\\path\\to\\notebooklm-mcp\\run_server.bat",
  "args": [],
  "disabled": false
}
```

---

### Cursor / Cline / 기타 MCP 지원 도구

MCP 설정 파일에 아래 형식으로 추가:

**macOS:**
```json
"notebooklm": {
  "command": "/path/to/notebooklm-mcp/run_server.sh",
  "args": []
}
```

**Windows:**
```json
"notebooklm": {
  "command": "C:\\path\\to\\notebooklm-mcp\\run_server.bat",
  "args": []
}
```

---

## 사용 가능한 MCP 도구 (30개)

| 분류 | 도구 | 설명 |
|------|------|------|
| 인증 | `refresh_auth` | 인증 갱신 (만료 시 자동 재로그인) |
| 인증 | `save_auth_tokens` | 쿠키 수동 저장 |
| 노트북 | `notebook_list` | 노트북 목록 조회 |
| 노트북 | `notebook_get` | 노트북 상세 조회 |
| 노트북 | `notebook_create` | 노트북 생성 |
| 노트북 | `notebook_rename` | 노트북 이름 변경 |
| 노트북 | `notebook_delete` | 노트북 삭제 |
| 노트북 | `notebook_describe` | AI 요약 생성 |
| 노트북 | `notebook_query` | AI 질의 (인용 포함) |
| 소스 | `source_add` | URL/텍스트/파일 소스 추가 |
| 소스 | `source_list_drive` | Drive 소스 목록 |
| 소스 | `source_sync_drive` | Drive 소스 동기화 |
| 소스 | `source_delete` | 소스 삭제 |
| 소스 | `source_describe` | 소스 AI 요약 |
| 소스 | `source_get_content` | 소스 원문 조회 |
| 리서치 | `research_start` | 웹 리서치 시작 |
| 리서치 | `research_status` | 리서치 상태 확인 |
| 리서치 | `research_import` | 리서치 결과 가져오기 |
| Studio | `studio_create` | 오디오/비디오/인포그래픽/슬라이드 등 생성 |
| Studio | `studio_status` | 생성 상태 확인 |
| Studio | `studio_delete` | 아티팩트 삭제 |
| Studio | `studio_revise` | 슬라이드 수정 |
| 채팅 | `chat_configure` | 채팅 설정 변경 |
| 다운로드 | `download_artifact` | 아티팩트 다운로드 |
| 내보내기 | `export_artifact` | Google Docs/Sheets 내보내기 |
| 공유 | `notebook_share_status` | 공유 상태 확인 |
| 공유 | `notebook_share_public` | 공개 링크 활성화 |
| 공유 | `notebook_share_invite` | 협업자 초대 |
| 노트 | `note` | 노트 생성/수정/삭제 |
| 서버 | `server_info` | 서버 정보 확인 |

---

## 문의

이슈는 [GitHub Issues](https://github.com/cjLee-cmd/notebookLM-MCP/issues)에 등록해 주세요.

---

## 참고

[NOTICE.md](./NOTICE.md) 참고 / 원본 프로젝트: [jacob-bd/notebooklm-mcp-cli](https://github.com/jacob-bd/notebooklm-mcp-cli) (MIT License)
