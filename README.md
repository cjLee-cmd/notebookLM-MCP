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

## 설치 (macOS / Linux)

아래 한 줄을 터미널에서 실행하면 **모든 설정이 자동으로 완료**됩니다:

```bash
curl -LsSf https://raw.githubusercontent.com/cjLee-cmd/notebookLM-MCP/main/install.sh | sh
```

설치 스크립트가 자동으로 처리하는 것:
1. `uv` 설치 (없을 경우)
2. 소스 코드 다운로드 (`~/notebookLM-MCP`)
3. 의존성 설치
4. **Claude Code MCP 자동 등록** (`~/.claude.json`)
5. **Gemini MCP 자동 등록** (설치된 경우)
6. Google 계정 인증 (Chrome 팝업)

설치 완료 후 Claude Code / Gemini를 **재시작**하면 바로 사용 가능합니다.

---

## 설치 (Windows)

Windows는 수동으로 진행합니다:

**1. uv 설치 (PowerShell):**
```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

**2. 소스 다운로드:**
```bat
git clone https://github.com/cjLee-cmd/notebookLM-MCP.git %USERPROFILE%\notebookLM-MCP
cd %USERPROFILE%\notebookLM-MCP
uv sync
```

**3. Google 인증:**
```bat
uv run nlm login
```

**4. MCP 설정 — Claude Code (`%USERPROFILE%\.claude.json`):**
```json
"notebooklm": {
  "type": "stdio",
  "command": "uv",
  "args": ["run", "--directory", "C:\\Users\\본인계정\\notebookLM-MCP", "notebooklm-mcp"]
}
```

**5. MCP 설정 — Gemini / Cursor / Cline 등:**
```json
"notebooklm": {
  "command": "C:\\Users\\본인계정\\notebookLM-MCP\\run_server.bat",
  "args": []
}
```

---

## 인증 만료 시

MCP에서 `refresh_auth` 도구를 호출하면 자동으로 재인증됩니다.
수동으로 재인증이 필요할 경우:

macOS/Linux:
```bash
cd ~/notebookLM-MCP && uv run nlm login
```

Windows:
```bat
cd %USERPROFILE%\notebookLM-MCP && uv run nlm login
```

> 인증은 약 1주일간 유지됩니다.

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
