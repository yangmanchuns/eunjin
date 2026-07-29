-- ============================================================
-- 소선명 ❤ 이은진 웨딩파티 — Supabase 설정 (sunmyung 전용 프로젝트)
--
-- 사용법: Supabase 새 프로젝트 → 왼쪽 SQL Editor → New query →
--         이 파일 전체 복사·붙여넣기 → Run
--
-- ※ 병민♥보원(wedding) 프로젝트와 완전히 분리된 별도 프로젝트에 실행하세요.
--   버킷 이름도 sunmyung-photos 로 분리되어 있습니다.
-- ============================================================

-- 1) 방명록 (누구나 읽기/쓰기)
create table if not exists public.guestbook_messages (
  id          uuid primary key default gen_random_uuid(),
  author      text not null,
  content     text not null,
  color_index int  not null default 0,
  created_at  timestamptz not null default now()
);

-- 2) 참석여부 RSVP (현재 사이트에서는 입력 UI 비활성, 비밀 공간 조회용으로 유지)
create table if not exists public.rsvp_submissions (
  id              uuid primary key default gen_random_uuid(),
  name            text not null,
  phone           text,
  side            text,       -- 신랑측/신부측
  attendance      text,       -- 참석/불참석
  guest_count     int,
  guest           text,       -- 동행인
  meal_preference text,       -- 예정/안함/미정
  message         text,
  created_at      timestamptz not null default now()
);

-- 3) 하객 사진 메타 (파일은 Storage, 링크는 여기)
create table if not exists public.photos (
  id         uuid primary key default gen_random_uuid(),
  url        text not null,
  path       text not null,
  uploader   text,
  created_at timestamptz not null default now()
);

-- ---------- RLS 켜기 ----------
alter table public.guestbook_messages enable row level security;
alter table public.rsvp_submissions   enable row level security;
alter table public.photos             enable row level security;

-- ---------- 정책 (anon = 하객 브라우저) ----------
-- 방명록: 누구나 읽기 + 쓰기
drop policy if exists "gb_select" on public.guestbook_messages;
drop policy if exists "gb_insert" on public.guestbook_messages;
create policy "gb_select" on public.guestbook_messages for select using (true);
create policy "gb_insert" on public.guestbook_messages for insert with check (true);

-- RSVP: 누구나 쓰기 + 읽기 (비밀 공간에서 조회하므로 select 필요)
drop policy if exists "rsvp_insert" on public.rsvp_submissions;
drop policy if exists "rsvp_select" on public.rsvp_submissions;
create policy "rsvp_insert" on public.rsvp_submissions for insert with check (true);
create policy "rsvp_select" on public.rsvp_submissions for select using (true);

-- 사진 메타: 누구나 읽기 + 쓰기
drop policy if exists "photos_select" on public.photos;
drop policy if exists "photos_insert" on public.photos;
create policy "photos_select" on public.photos for select using (true);
create policy "photos_insert" on public.photos for insert with check (true);

-- ---------- 실시간(Realtime) — 이미 추가돼 있으면 무시 ----------
do $$
begin
  alter publication supabase_realtime add table public.guestbook_messages;
exception when duplicate_object then null;
end $$;

do $$
begin
  alter publication supabase_realtime add table public.photos;
exception when duplicate_object then null;
end $$;

-- ---------- Storage 버킷 (하객 사진 파일 저장소) ----------
insert into storage.buckets (id, name, public)
values ('sunmyung-photos', 'sunmyung-photos', true)
on conflict (id) do nothing;

-- 사진 버킷: 누구나 업로드 + 읽기
drop policy if exists "sunmyung_photo_upload" on storage.objects;
drop policy if exists "sunmyung_photo_read"   on storage.objects;
create policy "sunmyung_photo_upload" on storage.objects for insert to anon
  with check (bucket_id = 'sunmyung-photos');
create policy "sunmyung_photo_read" on storage.objects for select to anon
  using (bucket_id = 'sunmyung-photos');

-- ============================================================
-- 끝. 이제 Settings → API 에서 아래 두 값을 복사해 전달해주세요.
--   Project URL     -> index.html 의 SUPABASE_URL
--   anon public key -> index.html 의 SUPABASE_ANON_KEY
-- (anon key는 원래 공개용 값입니다. 실제 보안은 위 RLS 정책이 담당합니다)
-- ============================================================
