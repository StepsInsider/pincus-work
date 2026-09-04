create table if not exists public.site_documentations (
    id uuid default gen_random_uuid() primary key,
    project_id text not null,
    image_url text not null,
    latitude double precision,
    longitude double precision,
    note text,
    category text check (category in ('vorher', 'nachher', 'fortschritt')) not null,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.site_documentations enable row level security;

drop policy if exists "Authenticated users can access site_documentations"
  on public.site_documentations;

create policy "Authenticated users can access site_documentations"
on public.site_documentations
for all
using (auth.role() = 'authenticated')
with check (auth.role() = 'authenticated');

insert into storage.buckets (id, name, public)
values ('site-photos', 'site-photos', true)
on conflict (id) do nothing;

drop policy if exists "Authenticated users can upload site photos"
  on storage.objects;

create policy "Authenticated users can upload site photos"
on storage.objects
for insert
to authenticated
with check (bucket_id = 'site-photos');

drop policy if exists "Authenticated users can update site photos"
  on storage.objects;

create policy "Authenticated users can update site photos"
on storage.objects
for update
to authenticated
using (bucket_id = 'site-photos')
with check (bucket_id = 'site-photos');
