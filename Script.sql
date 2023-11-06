--membuat table products :
create table "products"(
	"id" serial primary key,
	"name" varchar(50) not null unique,
	"price" int not null,
	"stock" int not null,
	"description" varchar(250) not null,
	"created_at" timestamp default now(),
	"updated_at" timestamp default now()
);





--input data products :
insert into "products" ("name", "price", "stock", "description") values
('Espresso', 45000, 100, 'A classic, concentrated coffee served in a small cup'),
('Americano', 60000, 100, 'Coffee made by diluting espresso with hot water, resulting in a lighter coffee'),
('Latte', 75000, 100, 'Espresso mixed with steamed milk, often topped with milk froth'),
('Cappuccino', 30000, 100, 'A coffee with equal parts espresso, steamed milk, and milk froth'),
('Macchiato', 60000, 100, 'Espresso "stained" with a small amount of milk or milk froth');





--mengambil/query semua data products :
select * from "products";





--membuat type data enum custom :
create type "category_product" as enum('drink', 'food');





--update table products, menambahkan column category dengna tipe data enum custom yang sebelumnya dibuat dengan nama category_product:
alter table "products" add column "category" category_product;





--update table products,  mengatur semua data coffee dengan category drink :
update "products" set category = 'drink';





--input data category food :
insert into "products" ("name", "price", "stock", "description", "category") values
('Croissant', 45000, 100, 'A croissant coated with a delicious layer of chocolate', 'food'),
('Red Velvet', 60000, 100, 'Red cake with a rich cream cheese frosting', 'food'),
('Tiramisu', 75000, 100, 'A classic Italian dessert made with layers of coffee-soaked ladyfingers', 'food'),
('Cheesecake', 90000, 100, 'A cake with a creamy cheesecake layer on a graham cracker crust', 'food'),
('muffin', 30000, 100, 'A delicious muffin made with fresh blueberries and a moist, fluffy texture. Perfectly sweet and bursting with blueberry flavor', 'food');





--update table, mengatur column category agar tidak boleh null :
alter table "products" alter column "category" set not null;





--query berdasarkan nama :
select * from "products" where name = 'Latte';





--membuat table promo :
create table "promo"(
	"id" serial primary key,
	"name" varchar(50) not null unique,
	"min_price" int not null,
	"max_discon" int not null,
	"promo" numeric(3,2) not null
);





--input data promo :
insert into "promo"("name", "min_price", "max_discon", "promo") values
('Save10', 60000, 20000, 0.1),
('CoffeeDay25', 90000, 30000, 0.25);





--membuat table order :
create table "order"(
	"id" serial primary key,
	"total" int not null,
	"discount" int default 0,
	"total_payment" int not null,
	"promo_id" int,
	foreign key ("promo_id") references promo (id)
)




--membuat table users :
create table "users"(
	"id" serial primary key,
	"full_name" varchar(255) not null,
	"username" varchar(50) not null unique,
	"password" varchar(50) not null,
	"email" varchar(255) not null unique
)





--update nama order jadi jamak :
alter table "order" rename to "orders"







