-- Run this once in Supabase SQL Editor to populate the portfolio demo.
insert into public.categories (name) values
  ('Coffee'),
  ('Accessories'),
  ('Home')
on conflict (name) do nothing;

insert into public.products (sku, name, description, category_id, status, price, cost, reorder_point)
select 'CB-001', 'Cold Brew Concentrate', 'Small-batch cold brew concentrate for retail and food service.', id, 'active', 18.00, 6.40, 18
from public.categories where name = 'Coffee'
on conflict (sku) do update set name = excluded.name, status = excluded.status, price = excluded.price, cost = excluded.cost, reorder_point = excluded.reorder_point;

insert into public.products (sku, name, description, category_id, status, price, cost, reorder_point)
select 'MB-220', 'Insulated Travel Mug', 'Double-wall stainless steel mug with leak-resistant lid.', id, 'active', 28.00, 10.50, 20
from public.categories where name = 'Accessories'
on conflict (sku) do update set name = excluded.name, status = excluded.status, price = excluded.price, cost = excluded.cost, reorder_point = excluded.reorder_point;

insert into public.products (sku, name, description, category_id, status, price, cost, reorder_point)
select 'GM-050', 'Ceramic Grinder', 'Adjustable manual burr grinder for an even, consistent grind.', id, 'draft', 42.00, 17.25, 12
from public.categories where name = 'Accessories'
on conflict (sku) do update set name = excluded.name, status = excluded.status, price = excluded.price, cost = excluded.cost, reorder_point = excluded.reorder_point;

insert into public.products (sku, name, description, category_id, status, price, cost, reorder_point)
select 'ST-100', 'Stoneware Pour-Over Set', 'Minimal ceramic dripper and serving carafe set.', id, 'active', 64.00, 26.00, 8
from public.categories where name = 'Home'
on conflict (sku) do update set name = excluded.name, status = excluded.status, price = excluded.price, cost = excluded.cost, reorder_point = excluded.reorder_point;

insert into public.products (sku, name, description, category_id, status, price, cost, reorder_point)
select 'ES-040', 'Espresso Blend 1kg', 'Dark chocolate and caramel profile, roasted for espresso.', id, 'active', 31.00, 12.80, 25
from public.categories where name = 'Coffee'
on conflict (sku) do update set name = excluded.name, status = excluded.status, price = excluded.price, cost = excluded.cost, reorder_point = excluded.reorder_point;

insert into public.inventory_movements (product_id, movement_type, quantity, reference)
select id, 'receipt', quantity, reference from (
  values ('CB-001', 34, 'PO-1042'), ('MB-220', 12, 'PO-1043'), ('GM-050', 28, 'PO-1044'), ('ST-100', 7, 'PO-1045'), ('ES-040', 18, 'PO-1046')
) as seed(sku, quantity, reference)
join public.products on products.sku = seed.sku
where not exists (select 1 from public.inventory_movements where inventory_movements.reference = seed.reference);

insert into public.inventory_movements (product_id, movement_type, quantity, reference)
select products.id, 'sale', -2, 'SO-2084' from public.products
where products.sku = 'CB-001'
  and not exists (select 1 from public.inventory_movements where reference = 'SO-2084');

insert into public.orders (order_number, customer_name, status, total, ordered_at) values
  ('SO-2084', 'Juniper House', 'fulfilled', 72.00, current_date - 2),
  ('SO-2085', 'Fieldwork Studio', 'confirmed', 196.00, current_date - 1),
  ('SO-2086', 'Morrow & Co.', 'draft', 128.00, current_date)
on conflict (order_number) do update set customer_name = excluded.customer_name, status = excluded.status, total = excluded.total, ordered_at = excluded.ordered_at;
