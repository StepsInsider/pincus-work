create table if not exists public.site_materials_equipment (
    id uuid default gen_random_uuid() primary key,
    project_id text not null,
    item_name text not null,
    type text check (type in ('material', 'geraet')) not null,
    quantity double precision check (quantity > 0) not null,
    unit text not null,
    notes text,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.site_materials_equipment enable row level security;

drop policy if exists "Authenticated users can access site_materials_equipment"
  on public.site_materials_equipment;

create policy "Authenticated users can access site_materials_equipment"
on public.site_materials_equipment
for all
using (auth.role() = 'authenticated')
with check (auth.role() = 'authenticated');
