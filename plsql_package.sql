create table products(product_id int DEFAULT pro_seq.NEXTVAL PRIMARY KEY,product_name varchar2(20),description varchar2(30),standard_cost number(10),list_price number(10),category_id int);
create sequence pro_seq increment by 1;
drop table products CASCADE CONSTRAINTS;
select * from products;

create table employees(employee_id int DEFAULT emp_seq.NEXTVAL PRIMARY KEY,first_name varchar2(20),last_name varchar2(20),email varchar2(20),phone varchar2(15),hire_date date,manager_id int,job_title varchar2(20));
drop table employees CASCADE CONSTRAINTS;
create sequence emp_seq increment by 1;
select * from employees;

create table customers(customer_id int DEFAULT cus_seq.NEXTVAL PRIMARY KEY,customer_name varchar2(15),address varchar2(30),website varchar2(30),credit_limit int);
drop table customers CASCADE CONSTRAINTS;
create sequence cus_seq increment by 1;
select * from customers;
create table orders(order_id int DEFAULT order_seq.nextval PRIMARY KEY,customer_id int,status varchar2(30),salesman_id int,
order_date date,FOREIGN KEY (customer_id) REFERENCES customers(customer_id));
drop table orders cascade constraints;
create sequence order_seq increment by 1;
select * from orders;
create table order_items(order_id int,item_id int ,product_id int,quantity number(10),unit_price number(10),
FOREIGN KEY (order_id) REFERENCES orders(order_id),FOREIGN KEY (product_id) REFERENCES products(product_id));
drop table order_items CASCADE CONSTRAINTS;
select * from order_items;
create table product_categories(category_id int PRIMARY KEY,category_name varchar2(50));
create sequence ca_seq increment by 1;
select * from product_categories;
drop table product_categories;