-- Keeps the first Ceramic Grinder receipt with reference PO-1050 and removes later duplicates.
delete from public.inventory_movements
where id in (
  select id from (
    select im.id,
      row_number() over (partition by im.product_id, im.reference order by im.created_at, im.id) as position
    from public.inventory_movements im
    join public.products p on p.id = im.product_id
    where p.sku = 'GM-050' and im.reference = 'PO-1050'
  ) duplicates
  where position > 1
);
