create schema ss10b1;
create table ss10b1.products (
id serial primary key,
name varchar(100),
price numeric,
last_modified timestamp default current_timestamp
);

create or replace function ss10b1.update_last_modified()
returns trigger as $$
begin
new.last_modified := current_timestamp;
return new;
end;
$$ language plpgsql;

create trigger trg_update_last_modified
before update on ss10b1.products
for each row
execute function ss10b1.update_last_modified();

insert into ss10b1.products (name, price) values
('Laptop Dell Xps', 35000000),
('Chuột Logitech Mx', 2500000);

select * from ss10b1.products;

update ss10b1.products 
set price = 33000000 
where name = 'laptop dell xps';

select * from ss10b1.products;