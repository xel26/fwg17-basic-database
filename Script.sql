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






--query Product berdasarkan nama, kategori, promo dan harga :
select p.name, p.category, pro.name as promo, p.price, o.id as order_id from "products" as p
join "orders_products" as op on (p.id = op.products_id)
join "orders" as o on (op.orders_id = o.id)
join "promo" as pro on (o.promo_id = pro.id)
where p.name = 'Americano' and p.category = 'drink' and pro.name = 'Save10' and p.price = 60000;






--pagination = membatasi data yang di tampilkan per-halaman :
--tampilkan 5 product pertama lewati 0 product urutkan berdasarkan nama secara ascending :
select * from products order by name asc limit 5 offset 0;

--tampilkan 5 product terakhir lewati 5 product pertama urutkan berdasarkan harga secara ascending lalu id secara ascending jika ada data harga yang sama:
select * from products order by price asc, id asc limit 5 offset 5;





--ganti nama column "max_discon" jadi "max_discount" di table "promo :
alter table "promo" rename column "max_discon" to "max_discount"





--update table products, mengganti type column deskripsi dari varchar menjadi text, menambah column is_available dengan type boolean:
alter table "products" alter column "description" type text;
alter table "products" add column "is_available" boolean;





--update table products, mengganti type data price dari int menjadi numeric, menghapus column category, menghapus constraint not null di column stock:
alter table "products" alter column "price" type numeric(12,2)
alter table "products" drop column "category"
alter table "products" alter column "stock" drop not null;




--tambah generic column created_at, updated_at di semua table :
alter table "orders" add column "created_at" timestamp default now();
alter table "orders" add column "updated_at" timestamp;
alter table "promo" add column "created_at" timestamp default now();
alter table "promo" add column "updated_at" timestamp;
alter table "users" add column "created_at" timestamp default now();
alter table "users" add column "updated_at" timestamp;





--update table promo, ganti type min_price dan max_discount dengan numeric, ganti nama column promo dengan percentage, ganti type data column percentage dari numeric menjadi float :
alter table "promo" alter column "min_price" type numeric(12,2);
alter table "promo" alter column "max_discount" type numeric(12,2);
alter table "promo" rename column "promo" to "percentage";
alter table "promo" alter column "percentage" type float;



--menghapus tipe data enum untuk product :
drop type category_product;




--membuat table categories :
create table "categories"(
	"id" serial primary key,
	"name" varchar(50),
	"description" text,
	"created_at" timestamp default now(),
	"updated_at" timestamp
)




--input data table categories :
insert into "categories"("name", "description") values 
('Coffe', 'Savor a variety of expertly crafted coffees, from cappuccinos to espressos'),
('Beverages', 'Explore a range of drinks to suit every taste, along with our coffee specialties'),
('Sweet Delight', 'Indulge in delectable desserts, including a variety of cakes, for the perfect sweet ending');



insert into "categories"("name", "description") values 
('ready to serve', 'Quick and convenient options for coffee and food.'),
('made to order', 'Personalized dishes prepared just for you')


select * from "categories";



--membuat table penghubung many to many untuk products dan categories :
create table "products_categories"(
	"id" serial primary key,
	"categories_id" int references "categories" ("id"),
	"products_id" int references "products" ("id"),
	"created_at" timestamp default now(),
	"updated_at" timestamp
)




--input data products :
insert into "products"("name", "price", "description") values 
('Canned Coffee', 45000, 'A convenient coffee boost in a can'),
('Bottled Water', 25000, 'Pure hydration on the go')




--input data table products_categories :
insert into "products_categories"("categories_id", "products_id")values 
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 12),
(2, 1),
(2, 2),
(2, 3),
(2, 3),
(2, 4),
(2, 5),
(2, 12),
(2, 13),
(3, 6),
(3, 7),
(3, 8),
(3, 9),
(3, 10),
(4, 6),
(4, 7),
(4, 8),
(4, 9),
(4, 10),
(4, 12),
(4, 13),
(5, 1),
(5, 2),
(5, 3),
(5, 4),
(5, 5)

select * from "products_categories";





--update table products, jika category made to order stock menjadi null :
update "products" set "stock" = 30;

--cara membaca = in (id, id, id, id) => id bekerja seperti or, proses dalam kurung akan menghasilkan beberapa id
update "products" set "stock" = null where id in (
	select "p"."id" from "products" "p"
	join "products_categories" "pc" on ("pc"."products_id" = "p"."id")
	join "categories" "c" on ("c"."id" = "pc"."categories_id")
	where "c"."name" = 'made to order'
)

select "p"."name", "p"."stock", "c"."name" as "category" from "products" "p"
join "products_categories" "pc" on ("pc"."products_id" = "p"."id")
join "categories" "c" on ("c"."id" = "pc"."categories_id");





--update table users, menambah column gender :
create type "gender_category" as enum ('female', 'male');

alter table "users" add column "gender" gender_category;

update "users" set "gender" = 'male';

update "users" set "gender" = 'female' where id = 4 or id = 2;








--aggregate function :
select "c"."name" as "category", 
		count("p"."id") as "total products",
		round(avg("p"."price"), 0) as "average price",
		min("p"."price") as "minimun price",
		max("p"."price") as "maximun price"
from "products" "p"
join "products_categories" "pc" on ("pc"."products_id" = "p"."id")
join "categories" "c" on ("c"."id" = "pc"."categories_id")
group by "c"."name";





--left join = mengembalikan semua nilai dari table kiri (table pertama yg di sebutkan) dan hanya mengembalikan nilai yang sesuai di dari table kanan
insert into "promo"("name", "min_price")





--mengambil/query semua data table products :
select * from "products" order by "id";

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

--mengambil/query semua data tabel products_categories :
select * from "products_categories";
