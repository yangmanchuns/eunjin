-- ============================================================
-- 소선명 ❤ 이은진 — 0920 전주 <연가> 청첩장 (eunjin) Supabase 설정
--
-- 사용법: Supabase → 기존 sunmyung 프로젝트 → SQL Editor → New query →
--         이 파일 전체 복사·붙여넣기 → Run
--
-- ※ 0823 사이트(sunmyung)와 "같은 프로젝트"를 쓰되, 방명록 테이블만
--   guestbook_messages2 로 따로 둬서 글이 섞이지 않게 한다.
--   (무료 플랜은 조직당 프로젝트 2개 제한이 있어 프로젝트를 늘리지 않음)
--   기존 sunmyung 테이블·정책·버킷은 이 스크립트가 건드리지 않는다.
--
-- ※ 이 사이트에는 RSVP 와 하객 사진 업로드 기능이 없다.
--   나중에 쓰게 되면 rsvp_submissions2 / photos2 테이블과 전용 버킷을
--   같은 방식으로 추가하면 된다.
-- ============================================================

-- 방명록 (누구나 읽기/쓰기)
create table if not exists public.guestbook_messages2 (
  id          uuid primary key default gen_random_uuid(),
  author      text not null,
  content     text not null,
  color_index int  not null default 0,
  created_at  timestamptz not null default now()
);

-- ---------- RLS 켜기 ----------
alter table public.guestbook_messages2 enable row level security;

-- ---------- 정책 (anon = 하객 브라우저) ----------
-- 정책 이름을 sunmyung 쪽(gb_select/gb_insert)과 다르게 둬야 기존 정책이 지워지지 않는다
drop policy if exists "gb2_select" on public.guestbook_messages2;
drop policy if exists "gb2_insert" on public.guestbook_messages2;
create policy "gb2_select" on public.guestbook_messages2 for select using (true);
create policy "gb2_insert" on public.guestbook_messages2 for insert with check (true);

-- ---------- 실시간(Realtime) — 이미 추가돼 있으면 무시 ----------
do $$
begin
  alter publication supabase_realtime add table public.guestbook_messages2;
exception when duplicate_object then null;
end $$;

-- ============================================================
-- 끝. SUPABASE_URL / SUPABASE_ANON_KEY 는 sunmyung 프로젝트 값을 그대로 쓰고,
-- index.html 상단의 T_GUESTBOOK 이 위 테이블 이름을 가리킨다.
-- ============================================================
