# 모바일 청첩장 — 소선명 ❤ 이은진 (0920 전주 <연가>) 작업 가이드

> 클로드 코드가 자동으로 읽는 프로젝트 컨텍스트. 다른 PC에서 클론해 이어서 작업할 때 이 문서를 기준으로 진행하세요.

## 1. 개요
- **무엇**: 소선명 ♥ 이은진 모바일 청첩장 (1인용 정적 웹사이트)
- **예식**: 2026. 09. 20.(일) 오후 12:30 · 전주 **<연가>** 3층 백합홀 (전북 전주시 완산구 어은로 28)
- **컨셉**: 위에서 아래로 **쭉 스크롤하는 한 장짜리** 청첩장 (480px 프레임 중앙정렬)
- **핵심 파일**: `index.html` 하나에 HTML+CSS+JS 전부 인라인 (프레임워크/빌드 없음)

### 자매 프로젝트 — 헷갈리지 말 것
같은 커플의 **0823 서울 웨딩파티** 청첩장이 따로 있습니다.

| | 이 저장소 | 자매 저장소 |
|---|---|---|
| 행사 | 2026.09.20 전주 <연가> | 2026.08.23 서울 화양동 <선명> |
| GitHub | `yangmanchuns/eunjin` | `yangmanchuns/sunmyung` |
| URL | https://yangmanchuns.github.io/eunjin/ | https://yangmanchuns.github.io/sunmyung/ |
| 로컬 | `D:\GitLabRoot\DAAF\sunmyung_ver2` | `D:\GitLabRoot\DAAF\sunmyung` |

- 이 폴더 이름이 `sunmyung_ver2` 지만 **origin 은 eunjin** 입니다. (0823 사이트를 복제해 만든 흔적)
- **Supabase 프로젝트는 둘이 공유**합니다. 무료 플랜이 조직당 프로젝트 2개 제한이라 늘리지 않고, 테이블 이름으로 분리했습니다. → 5장 참고
- 두 사이트가 `yangmanchuns.github.io` 로 **같은 도메인**이라 localStorage 도 겹칩니다. 새 키를 쓸 땐 반드시 접두어를 붙이세요.

## 2. 호스팅 & 배포
- **GitHub Pages**. 저장소 `yangmanchuns/eunjin`, 계정 **yangmanchuns**, 이 폴더가 곧 저장소 루트.
- 배포 = **커밋 후 push**. 재배포 ~1분. 캐시로 옛 버전 보이면 **시크릿창/하드 새로고침**.
- Pages 최초 활성화: Settings → Pages → Source **Deploy from a branch** → **main / (root)** → Save.
  - 켜졌는지 확인: `curl -s -o /dev/null -w "%{http_code}" https://yangmanchuns.github.io/eunjin/` → 200
  - `https://api.github.com/repos/yangmanchuns/eunjin/pages` 가 404 면 아직 사이트가 만들어지지 않은 것.
- 커밋은 자유롭게, **push 는 사용자(양병민)에게 확인** 후.

## 3. 파일 구조
- `index.html` — 전체 사이트 (수정 대부분 여기)
- `map.html` — 카카오 공유 카드의 "위치 보기" 경유 페이지 → 네이버 지도(연가)로 리다이렉트
  - 카카오는 공유 버튼 링크를 **등록된 도메인만** 허용해서 `map.naver.com` 을 직접 넣으면 404 가 남. 그래서 우리 도메인에 이 페이지를 두고 넘긴다.
- `supabase_setup.sql` — 방명록 테이블/정책/실시간 생성 SQL
- `manifest.webmanifest` — PWA용. **현재 index.html 에서 링크하지 않음**(참조하는 `images/app-icon.png` 도 없음)
- `images/` — main.jpg, outro.jpg, gallery-01~25.jpg, story-groom-child.jpg, story-bride-child.jpg (29장)
- `music/bgm.mp3` — 배경음악 (첫 터치 시 자동재생 + 우상단 토글)
- `fonts/` — 실제 사용 3종(DM Serif Display, ONE Mobile Title/Regular)
- git 추적 안 함: `backup/`, `원본picture/`, `font/`(원본 폰트)

## 4. 화면 구성 (index.html, 위→아래 순서)
1. **히어로** `.hero` — 배경사진 + `SMALL WEDDING` + 이름 + 일시/장소 + SCROLL 인디케이터
2. **초대장** `.invite` — 부모님 표기(소일혁·전성예의 아들 선명 / 한정인·권명희의 딸 은진) + 초대글
3. **우리의 어린 시절** — 신랑/신부 폴라로이드 + 캡션
4. **갤러리** — 3열 그리드 25장(9장 노출 + 더보기), 라이트박스(스와이프/좌우 버튼)
5. **Save the Date** — 2026.09 달력(20일 하이라이트) + 카운트다운 + D-day 문구
6. **오시는 길** `#location` — 카카오맵 + 주소 + 네이버/카카오 지도 링크 + 버스/택시/주차
7. **방명록** — Supabase 실시간, 포스트잇 2열 메이슨리, 6개 노출 + 더보기
8. **마무리** `.closing` — 배경사진 + 감사 인사
9. **푸터** — 카카오톡 공유 / 링크 복사 + 서명

### 지금은 없는 기능
RSVP 참석여부, 하객 사진 업로드, **비밀 공간**(히어로 ✦ 7번 클릭 → 비밀번호 → 하객사진/RSVP 조회), 사진 일괄 ZIP 저장.
CSS 는 일부 남아 있으나 마크업/JS 는 제거된 상태입니다.
- 되살리려면 커밋 `223761e` 에서 해당 부분만 꺼내 오세요. 이 커밋에는 **방명록 테이블 분리도 함께** 들어 있어서 통째로 `git revert` 하면 방명록이 0823 테이블로 되돌아갑니다.
- 되살릴 때는 `supabase_setup.sql` 에 `rsvp_submissions2` / `photos2` 테이블과 전용 스토리지 버킷도 추가해 실행해야 합니다.

## 5. 외부 서비스
### Supabase (0823 sunmyung 과 **같은 프로젝트** 공유)
- URL/anon key 는 `index.html` 상단 `SUPABASE_URL`/`SUPABASE_ANON_KEY`. anon key 는 원래 공개용(보안은 RLS 담당).
- **이 사이트가 쓰는 것은 방명록 테이블 하나뿐**:
  - 테이블 `guestbook_messages2` — `index.html` 의 `var T_GUESTBOOK` 한 곳에서 관리
  - 실시간 채널 `gb-eunjin` / 로컬저장 폴백 키 `guestbook_eunjin`
  - 0823 사이트는 `guestbook_messages`, `rsvp_submissions`, `photos`, 버킷 `sunmyung-photos` 를 씀 — **건드리지 말 것**
- **테이블/정책을 바꾸면 `supabase_setup.sql` 을 Supabase → SQL Editor 에서 실행**해야 실제 DB에 반영됩니다. 로컬 파일만 고쳐선 아무 일도 안 일어납니다.
- 정책 이름은 `gb2_*` 로 0823 쪽(`gb_*`)과 겹치지 않게 둘 것. 겹치면 `drop policy if exists` 가 남의 정책을 지웁니다.

### Kakao
- 공유용 JS 키: `index.html` 의 `KAKAO_JS_KEY` (이 사이트 전용 앱). Web 플랫폼에 `https://yangmanchuns.github.io` 등록돼 있어야 공유 작동.
- 지도 SDK 키는 head `<script src=...dapi.kakao.com...appkey=>` 에 따로 있고, **0823 앱 키를 그대로 씀**(같은 도메인이라 동작). 통일하려면 새 앱에서 카카오맵을 켠 뒤 교체.
- 연가 좌표 `35.8167873, 127.1260305` (카카오플레이스 17015525) 고정. 네이버 장소 `21030800`.

## 6. 편집 규칙 (중요)
- **개행은 CRLF**: `index.html` 은 CRLF 입니다. 여러 줄 패턴을 `\n` 으로 매칭하면 **0건**이 나옵니다. 패치 스크립트에서 `\n` → `\r\n` 변환을 꼭 넣으세요.
- **한글 인코딩**: `Edit` 도구로 한글 포함 라인을 고치면 깨질 수 있음. **Node `fs` 로 utf8 읽고/쓰는 패치 스크립트** 방식을 쓸 것.
  - 패턴: 스크래치패드에 `patch_*.js` → `fs.readFileSync(f,'utf8')` → `s.split(old).join(new)` → `fs.writeFileSync(f,s,'utf8')`
  - 치환마다 **매칭 건수가 1인지 검사**하고 아니면 throw. 조용히 어긋나는 게 제일 위험합니다.
- **JS 문법 검사**: 수정 후 `<script>` 블록만 뽑아 `node --check`. 정규식 `/<script>([\s\S]*)<\/script>\s*<\/body>/` (본문 마지막 스크립트만 노릴 것 — head 의 src 스크립트까지 오염되면 안 됨).
- **기능 삭제 시**: 삭제한 함수를 참조하는 곳이 남아있지 않은지 문자열 스캔으로 확인.
- **커밋 메시지**: 무엇을 왜 바꿨는지 한국어로 구체적으로.
- 디자인: 480px 프레임 중앙정렬, 아이보리+딥민트(`--lime:#43836D`), 폰트 DM Serif Display / ONE Mobile / Noto Sans KR.

## 7. 남은 작업(TODO)
- [ ] 사진이 아직 0823(서울 <선명>) 촬영본 그대로 — main/gallery/outro/어린시절 교체 여부 확인
- [ ] 초대글·마무리 글이 0823 웨딩파티 기준 문장(심야식당·식탁 등) — 0920 기준으로 다듬을지 확인
- [ ] `manifest.webmanifest` 를 쓸지 결정 (쓰려면 index.html 에 `<link rel="manifest">` + `images/app-icon.png` 필요)
- [ ] 축의금 계좌 / 연락처 섹션은 현재 없음 (CSS 만 남아있음) — 필요하면 되살리기

## 8. 참고
- 정적 사이트라 소스/이미지는 F12 로 다 보입니다. 진짜 보호가 필요하면 Supabase RPC 로 서버측 검증이 필요.
- 사용 안 하는 CSS(`.venue-cards`, `.pola-card`, `.sgrid`, `.pw-input`, `.acc`, `.person` 등)가 남아 있습니다. 기능을 되살릴 때 그대로 쓸 수 있게 둔 것.
