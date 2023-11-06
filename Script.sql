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





--membuat table order dengan relasi many to one:
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





--input table users :
insert into "users"("full_name", "username", "password", "email") values 
('John Doe', 'johndoe123', 'P@ssw0rd1', 'johndoe123@example.com'),
('Jane Smith', 'janesmith456', 'P@ssw0rd2', 'janesmith456@example.com'),
('Michael Johnson', 'mikejohn789', 'P@ssw0rd3', 'mikejohn789@example.com'),
('Emily Davis', 'emilydavis101', 'P@ssw0rd4', 'emilydavis101@example.com'),
('David Wilson', 'davewilson2022', 'P@ssw0rd5', 'davewilson2022@example.com')




--input table orders :
insert into "orders"("total", "total_payment") values 
(60000, 60000),
(90000, 90000),
(90000, 90000),
(150000, 150000),
(120000, 120000)





--hapus not null dari column total_payment di table orders :
alter table "orders" alter column "total_payment" drop not null;




insert into "orders"("total") values 
(250000),
(300000);





--update table orders tambah foreign key promo_id untuk relasi many to one ke table promo = beberapa order menggunakan satu promo yang sama atau satu promo yang sama di gunakan di beberapa order :


update "orders" set promo_id = 1, discount = total * 0.1, total_payment = total - discount
where id = 5 or id = 10 or id = 11

update "orders" set promo_id = 2, discount = total * 0.25, total_payment = total - discount
where id > 5 and id <= 9;


--jika potongan melebihi max discount promo maka potongan adalah max discount : 
update "orders" set discount = 30000, total_payment = total - discount
where promo_id = 2 and discount >= 30000;

update "orders" set discount = 20000, total_payment = total - discount 
where promo_id= 1 and discount >= 20000;

update "orders" set total = 270000 where id = 10

delete from "orders" where id = 18 or id = 19





--menambah foreign key user_id di table orders untuk relasi many to one ke table users = satu users bisa memiliki beberapa orders atau beberapa orders bisa di miliki oleh satu users :
alter table "orders" add column "user_id" int;

alter table "orders" add constraint fk_user_id foreign key (user_id) references "users" (id)

update "orders" set user_id = 1 where id = 6 or id = 7;

update "orders" set user_id = 5 where id = 10 or id = 11;

update "orders" set user_id = 2 where id = 5;

update "orders" set user_id = 3 where id = 8;

update "orders" set user_id = 4 where id = 9;





--membuat table untuk relasi many to many orders dan products = satu orders bisa memiliki lebih dari satu product atau satu product bisa ada di beberapa order :
create table "orders_products"(
	id serial primary key,
	orders_id int not null,
	products_id int not null, 
	foreign key ("orders_id") references "orders" (id),
	foreign key ("products_id") references "products" (id)
)






--input table orders_products :
insert into "orders_products"("orders_id", "products_id") values 
(5, 4),
(5, 10),
(6, 5),
(6, 10),
(7, 1),
(7, 6),
(8, 1),
(8, 6),
(8, 5),
(9, 9),
(9, 10),
(10, 1),
(10, 10),
(10, 8),
(10, 2),
(10, 7),
(11, 3),
(11, 8),
(11, 9),
(11, 2)






--mengambil/query semua data table products :
select * from "products";

--query table products berdasarkan nama :
select * from "products" where name = 'Latte';

--mengambil/query semua data table users :
select * from "users";

--mengambil/query semua data table orders :
select * from "orders";

--mengambil/query semua data table promo :
select * from "promo";

--mengambil/query semua data tabel orders_products :
select * from "orders_products";

--query Product berdasarkan nama, kategori, promo dan harga :
select p.name, p.category, pro.name as promo, p.price, o.id as order_id from "products" as p
join "orders_products" as op on (p.id = op.products_id)
join "orders" as o on (op.orders_id = o.id)
join "promo" as pro on (o.promo_id = pro.id)




--pagination = membatasi data yang di tampilkan per-halaman :
--tampilkan 5 product pertama lewati 0 product urutkan berdasarkan nama secara ascending :
select * from products order by name asc limit 5 offset 0;

--tampilkan 5 product terakhir lewati 5 product pertama urutkan berdasarkan harga secara ascending lalu id secara ascending jika ada data harga yang sama:
select * from products order by price asc, id asc limit 5 offset 5;
