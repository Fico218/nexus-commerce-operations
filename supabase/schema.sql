create type public.product_status as enum ('draft', 'active', 'archived');
create type public.asset_status as enum ('draft', 'approved', 'expired');
create type public.order_status as enum ('draft', 'confirmed', 'fulfilled', 'cancelled');
create type public.movement_type as enum ('receipt', 'sale', 'adjustment');

create table public.categories (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  created_at timestamptz not null default now()
);

create table public.products (
  id uuid primary key default gen_random_uuid(),
  sku text not null unique,
  name text not null,
  description text,
  category_id uuid references public.categories(id) on delete set null,
  status public.product_status not null default 'draft',
  price numeric(12,2) not null default 0 check (price >= 0),
  cost numeric(12,2) not null default 0 check (cost >= 0),
  reorder_point integer not null default 10 check (reorder_point >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.digital_assets (
  id uuid primary key default gen_random_uuid(),
  product_id uuid references public.products(id) on delete cascade,
  name text not null,
  storage_path text not null,
  mime_type text,
  status public.asset_status not null default 'draft',
  is_primary boolean not null default false,
  created_at timestamptz not null default now()
);

create table public.inventory_movements (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products(id) on delete cascade,
  movement_type public.movement_type not null,
  quantity integer not null check (quantity <> 0),
  reference text,
  created_at timestamptz not null default now()
);

create table public.orders (
  id uuid primary key default gen_random_uuid(),
  order_number text not null unique,
  customer_name text not null,
  status public.order_status not null default 'draft',
  total numeric(12,2) not null default 0 check (total >= 0),
  ordered_at date not null default current_date,
  created_at timestamptz not null default now()
);

create view public.product_inventory as
select p.id as product_id, coalesce(sum(im.quantity), 0)::integer as quantity_on_hand
from public.products p
left join public.inventory_movements im on im.product_id = p.id
group by p.id;

alter table public.categories enable row level security;
alter table public.products enable row level security;
alter table public.digital_assets enable row level security;
alter table public.inventory_movements enable row level security;
alter table public.orders enable row level security;

create policy "Authenticated users manage categories" on public.categories for all to authenticated using (true) with check (true);
create policy "Authenticated users manage products" on public.products for all to authenticated using (true) with check (true);
create policy "Authenticated users manage assets" on public.digital_assets for all to authenticated using (true) with check (true);
create policy "Authenticated users manage inventory" on public.inventory_movements for all to authenticated using (true) with check (true);
create policy "Authenticated users manage orders" on public.orders for all to authenticated using (true) with check (true);

insert into storage.buckets (id, name, public) values ('product-assets', 'product-assets', true)
on conflict (id) do nothing;

create policy "Authenticated users upload product assets" on storage.objects for insert to authenticated with check (bucket_id = 'product-assets');
create policy "Public product assets are readable" on storage.objects for select to public using (bucket_id = 'product-assets');

insert into public.categories (name) values ('Coffee', 'Accessories', 'Home') on conflict do nothing;
