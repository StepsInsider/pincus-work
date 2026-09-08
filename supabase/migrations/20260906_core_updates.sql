create table if not exists public.customers (
    id text primary key,
    name text not null,
    address text not null default '',
    contact_person text not null default '',
    phone text not null default '',
    created_at timestamptz not null default timezone('utc'::text, now())
);

create table if not exists public.sites (
    id text primary key,
    name text not null,
    customer text not null default '',
    address text not null default '',
    status text not null default 'Geplant',
    contact_person text not null default '',
    phone text not null default '',
    created_at timestamptz not null default timezone('utc'::text, now())
);

create table if not exists public.time_entries (
    id text primary key,
    project_id text not null,
    project_name text not null,
    employee_name text not null,
    hours double precision not null,
    date timestamptz not null,
    description text not null default '',
    created_at timestamptz not null default timezone('utc'::text, now())
);

alter table public.sites add column if not exists customer_id text;

alter table public.customers enable row level security;
alter table public.sites enable row level security;
alter table public.time_entries enable row level security;

drop policy if exists "Authenticated users can access customers" on public.customers;
create policy "Authenticated users can access customers" on public.customers
for all to authenticated using (true) with check (true);

drop policy if exists "Authenticated users can access sites" on public.sites;
create policy "Authenticated users can access sites" on public.sites
for all to authenticated using (true) with check (true);

drop policy if exists "Authenticated users can access time_entries" on public.time_entries;
create policy "Authenticated users can access time_entries" on public.time_entries
for all to authenticated using (true) with check (true);