create schema ss10b4;
create table ss10b4.products (
id serial primary key,
name varchar(100),
stock int
);
create table ss10b4.orders (
id serial primary key,
product_id int references ss10b4.products(id),
quantity int
);

insert into ss10b4.products (name, stock) values
('Iphone 15', 50),
('Macbook Air', 20);

create or replace function ss10b4.sync_inventory()
returns trigger as $$
begin
if (tg_op = 'INSERT') then
update ss10b4.products 
set stock = stock - new.quantity 
where id = new.product_id;
return new;

elsif (tg_op = 'UPDATE') then
update ss10b4.products 
set stock = stock + old.quantity - new.quantity 
where id = new.product_id;
return new;

elsif (tg_op = 'DELETE') then
update ss10b4.products 
set stock = stock + old.quantity 
where id = old.product_id;
return old;
end if;
return null;
end;
$$ language plpgsql;

create trigger trg_inventory_update
after insert or update or delete on ss10b4.orders
for each row
execute function ss10b4.sync_inventory();

insert into ss10b4.orders (product_id, quantity) values (1, 5);
select * from ss10b4.products where id = 1;

update ss10b4.orders set quantity = 2 where id = 1;
select * from ss10b4.products where id = 1;

delete from ss10b4.orders where id = 1;
select * from ss10b4.products where id = 1;