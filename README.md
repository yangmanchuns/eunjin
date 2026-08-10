# 모바일 청첩장 — 소선명 ❤ 이은진

2026. 09. 20. SUN PM 12:30 · 전주 **<연가>** 3층 백합홀 (전북 전주시 완산구 어은로 28)

https://yangmanchuns.github.io/eunjin/

## 구성
- `index.html` — 청첩장 본체 (HTML+CSS+JS 전부 인라인, 단일 파일 정적 사이트)
- `map.html` — 카카오 공유 카드의 "위치 보기" → 네이버 지도 경유 페이지
- `supabase_setup.sql` — 방명록 테이블/정책/실시간 생성 SQL
- `images/`, `music/`, `fonts/` — 사진·배경음악·폰트

## 배포 (GitHub Pages)
1. 저장소 → Settings → Pages → Source **Deploy from a branch** → Branch `main` / `/ (root)` → Save
2. push 하면 약 1분 뒤 자동 반영. 옛 버전이 보이면 시크릿창 또는 하드 새로고침.

## 방명록 (Supabase)
0823 서울 웨딩파티 사이트([sunmyung](https://github.com/yangmanchuns/sunmyung))와 **같은 Supabase 프로젝트**를 쓰고,
테이블만 `guestbook_messages2` 로 분리해 두 청첩장의 글이 섞이지 않게 했습니다.

- 테이블/정책을 바꿨다면 Supabase → **SQL Editor** 에서 `supabase_setup.sql` 을 실행해야 실제 DB에 반영됩니다.
- 테이블 이름은 `index.html` 상단 `var T_GUESTBOOK` 한 곳에서 관리합니다.
- 남겨진 글 확인: Supabase → Table Editor → `guestbook_messages2`

> `SUPABASE_ANON_KEY` 는 원래 브라우저에 넣는 공개용 값이라 노출돼도 안전합니다. 데이터 보호는 RLS 정책이 담당합니다.
> `SUPABASE_URL`/`SUPABASE_ANON_KEY` 가 비어 있으면 사이트는 "브라우저 로컬 저장" 모드로 동작합니다(공유 안 됨).

## 참고
이 사이트에는 RSVP·하객 사진 업로드·비밀 공간 기능이 없습니다. 자세한 작업 규칙은 `CLAUDE.md` 참고.
