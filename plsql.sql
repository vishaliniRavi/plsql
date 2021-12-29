SET SERVEROUTPUT ON
DECLARE
     emp_number INTEGER := 1;
     emp_name varchar2(20);
BEGIN
     select first_name into emp_name from employee where id=emp_number;
     DBMS_OUTPUT.PUT_LINE('Employee name is '|| emp_name);
end;


SET SERVEROUTPUT ON
DECLARE
  Grade CHAR(1):=UPPER('&Enter_the_Grade');
  apprisal varchar(20);
BEGIN
apprisal:=
   Case Grade
   When 'A' then 'Excellent'
   when 'B' then 'good'
   when 'C' then 'fair'
   else 'No such grades'
end ;
DBMS_OUTPUT.PUT_LINE(apprisal);
end;

--Bind variables
variable name varchar2(50); 
BEGIN
    select first_name into :name from employee
    where id=1;
    DBMS_OUTPUT.put_line(:name);
end;
 
SET SERVEROUTPUT ON 
DECLARE
    emp_id integer:=&Enter_emp_id;
    deptid integer;
    sal integer;
    emp_name varchar2(30);
BEGIN
    select first_name,salary,department_id into emp_name,sal,deptid from employee where id=emp_id;
    --DBMS_OUTPUT.PUT_LINE(sal||':'|| deptid);
    if deptid=3 then 
         sal:=sal+1000;
    elsif deptid=4 then
         sal:=sal+500;
    else 
         sal:=sal+300;
end if;
   DBMS_OUTPUT.PUT_LINE('employee name='||emp_name||' salary='||sal||' department is '|| deptid);
   Exception
     when no_data_found then 
     DBMS_OUTPUT.PUT_LINE('employee id does not found');
end;


set serveroutput on
DECLARE 
     n number:=1;
Begin
   while n<=10
    loop
    DBMS_OUTPUT.PUT_LINE(n);
    n:=n+1;
    end loop; 
end;
  
DECLARE  
BEGIN  
  FOR var IN 1..5
  LOOP    
    DBMS_OUTPUT.PUT_LINE(var);  
  END LOOP;  
END;

set serveroutput on
DECLARE  
BEGIN  
  FOR var IN REVERSE 1..10
  LOOP    
    DBMS_OUTPUT.PUT_LINE(var);  
  END LOOP;  
END;      

 --Explict cursor
 set serveroutput on
 Declare
 mem_id lms_members.member_id%type;
 mem_name lms_members.member_name%type;
 place lms_members.city%type;
 cursor lms_cursor is
 select member_id,member_name  from lms_members where city=place;                      
 begin
    place:='&city';
    open lms_cursor;
    loop
        fetch lms_cursor into mem_id,mem_name;
        exit when lms_cursor%notfound;
        DBMS_OUTPUT.PUT_LINE('member id = '||mem_id||' member name= '||mem_name||' city= '||place);
         DBMS_OUTPUT.PUT_LINE(lms_cursor%rowcount||'record fetched');
end loop;
close lms_cursor;
end;
--For loop cursor
DECLARE cursor emp_cursor is 
select  id from employee where department_id=3;
BEGIN
for emp_record in emp_cursor
loop
update employee set salary=salary+500
where id=emp_record.id;
end loop;
end;

--functions




  
create table user2(u_id number(10) primary key,u_name varchar2(100));  
select * from user2;
desc  user2;
--procedure
set serveroutput on
create or replace procedure insert_user    
(user_id IN int,    
user_name IN varchar2)    
is  
begin    
   insert into user2 values(user_id,user_name);
end  ;   

begin
insert_user(3,'meena');
DBMS_OUTPUT.PUT_LINE('record inserted');
end;

--function
CREATE FUNCTION get_bal(acc_no IN NUMBER) 
   RETURN NUMBER 
   IS acc_bal NUMBER(11,2);
   BEGIN 
      SELECT order_total 
      INTO acc_bal 
      FROM orders 
      WHERE customer_id = acc_no; 
      RETURN(acc_bal); 
    END;
    

create or replace function comm(v_sal in number)
return number 
is 
begin 
return(v_sal*0.10);
end comm;

select * from employee;
select first_name,comm(salary) from employee ;
--package
set serveroutput on
CREATE OR REPLACE PACKAGE sales AS 
   --add product
   PROCEDURE add_products( 
   p_name products.product_name%type, 
   p_desc  products.description%type, 
   p_cost products.standard_cost%type,  
   p_price  products.list_price%type, 
   p_catagory products.category_id%type,p_status out varchar2,p_error out varchar2);
   -- Removes a product
   PROCEDURE remove_product(p_id   products.product_id%type,p_status out varchar2,p_error out varchar2); 
   --add employees
   PROCEDURE add_employees(
   e_fname employees.first_name%type,
   e_lname employees.last_name%type,
   e_mail employees.email%type,
   p_num employees.phone%type,
   e_hire employees.hire_date%type,
   m_id employees.manager_id%type,
   j_title employees.job_title%type,e_status out varchar2,e_error out varchar2);
   --remove employees
   PROCEDURE remove_employees(e_id employees.employee_id%type,e_status out varchar2,e_error out varchar2);
   --add customer
   PROCEDURE add_customer(
   c_name customers.customer_name%type,
   c_ad customers.address%type,
   c_website customers.website%type,
   c_limit customers.credit_limit%type,c_status out varchar2,c_error out varchar2);
  --remove customer
  PROCEDURE remove_customer(c_id customers.customer_id%type,c_status out varchar2,c_error out varchar2);
   
  --add orders
  PROCEDURE add_orders(
  c_id in number,o_status in varchar2,s_id in number,
 o_date in date,status out varchar2,or_error out varchar2);
 --cancel orders
 PROCEDURE cancel_order(o_id in number,status out varchar2,or_error out varchar2);
 --add order_items
 PROCEDURE add_order_items(o_id in number,i_id in number ,p_id in number,quan in number,u_price in number,status out varchar2,o_error out varchar2);
 --delete order_items
 PROCEDURE remove_order_items(o_id in number,status out varchar2,o_error out varchar2);
 --add category
 PROCEDURE add_category(ca_id in number,ca_name in varchar2,ca_status out varchar2,ca_error out varchar2);
 --remove category
 PROCEDURE remove_category(ca_id in number,ca_status out varchar2,ca_error out varchar2);
 END sales;

CREATE OR REPLACE PACKAGE BODY sales AS 
    PROCEDURE add_products( 
   p_name products.product_name%type, 
   p_desc  products.description%type, 
   p_cost products.standard_cost%type,  
  p_price  products.list_price%type, 
   p_catagory products.category_id%type,p_status out varchar2,p_error out varchar2)
   IS 
   BEGIN 
      INSERT INTO products (product_name,description,standard_cost,list_price,category_id) 
         VALUES( p_name, p_desc, p_cost, p_price,p_catagory);
         if sql%rowcount>0
         then p_status:='product inserted';
         end if;
         commit;
         EXCEPTION 
         when others then
         p_status:='product not inserted';
         p_error:=sqlcode||sqlerrm;
   END add_products; 
   
   PROCEDURE remove_product(p_id   products.product_id%type,p_status out varchar2,p_error out varchar2) IS 
   BEGIN 
      DELETE FROM products
      WHERE product_id = p_id; 
      if sql%rowcount>0
      then p_status:='product deleted';
      end if;
      if sql%rowcount=0
      then p_status:='product id '||p_id||' does not exist';
      end if;
      commit;
         EXCEPTION 
         when others then
         p_status:='no data found';
         p_error:=sqlcode||sqlerrm;
         
   END remove_product;

   PROCEDURE add_employees(
   e_fname employees.first_name%type,
   e_lname employees.last_name%type,
   e_mail employees.email%type,
   p_num employees.phone%type,
   e_hire employees.hire_date%type,
   m_id employees.manager_id%type,
   j_title employees.job_title%type,e_status out varchar2,e_error out varchar2)
   IS 
   BEGIN
     INSERT INTO employees(first_name,last_name,email,phone,hire_date,manager_id,job_title)
     VALUES(e_fname,e_lname,e_mail,p_num,e_hire,m_id,j_title);
     if sql%rowcount>0
         then e_status:='employee inserted';
         end if;
         commit;
         EXCEPTION 
         when others then
         e_status:='employee not inserted';
         e_error:=sqlcode||sqlerrm;
  END add_employees;
  
  PROCEDURE remove_employees(e_id employees.employee_id%type,e_status out varchar2,e_error out varchar2)IS 
  BEGIN
      DELETE FROM employees WHERE employee_id=e_id;
      if sql%rowcount>0
         then e_status:='employee deleted';
         end if;
        if sql%rowcount=0
        then e_status:='employee id '||e_id||' does not exist';
        end if;
         commit;
         EXCEPTION 
         when no_data_found then 
         DBMS_OUTPUT.PUT_LINE('product id does not found');
         when others then
         e_status:='not deleted';
         e_error:=sqlcode||sqlerrm;
  END remove_employees;
  
  
  PROCEDURE add_customer(
   c_name customers.customer_name%type,
   c_ad customers.address%type,
   c_website customers.website%type,
   c_limit customers.credit_limit%type,c_status out varchar2,c_error out varchar2)IS
   BEGIN
   INSERT INTO customers(customer_name,address,website,credit_limit )
   VALUES(c_name,c_ad,c_website,c_limit);
   if sql%rowcount>0
         then c_status:='customer inserted';
         end if;
         commit;
         EXCEPTION 
         when others then
         c_status:='customer not inserted';
         c_error:=sqlcode||sqlerrm;
   END add_customer;
   
   PROCEDURE remove_customer(c_id customers.customer_id%type,c_status out varchar2,c_error out varchar2)IS
   BEGIN
   DELETE FROM customers WHERE customer_id=c_id;
   if sql%rowcount>0
         then c_status:='customer deleted';
         end if;
          if sql%rowcount=0
        then c_status:='customer id '||c_id||'not deleted';
        end if;
         commit;
         EXCEPTION 
         when others then
         c_status:='not found';
         c_error:=sqlcode||sqlerrm;
   END remove_customer;
  
  
  PROCEDURE add_orders(
  c_id in number,o_status in varchar2,s_id in number,
 o_date in date,status out varchar2,or_error out varchar2)
 IS 
 BEGIN
 INSERT INTO orders(customer_id ,status ,salesman_id ,order_date)
 VALUES(c_id,o_status,s_id,o_date);
 if sql%rowcount>0
         then status:='order inserted';
         end if;
         commit;
         EXCEPTION 
         when others then
         status:='order not inserted';
         or_error:=sqlcode||sqlerrm;
 END add_orders;
 
 PROCEDURE cancel_order(o_id in number,status out varchar2,or_error out varchar2) IS 
 BEGIN
 UPDATE orders SET status='cancelled' where order_id=o_id;
 if sql%rowcount>0
         then status:='order cancelled';
         end if;
         if sql%rowcount=0
        then status:='order id '||o_id||' does not exist';
        end if;
        commit;
         EXCEPTION 
         when others then
         status:='not cancelled';
         or_error:=sqlcode||sqlerrm;
 END cancel_order;
 
PROCEDURE add_order_items(o_id in number,
i_id in number ,p_id in number,quan in number,u_price in number,status out varchar2,o_error out varchar2)
IS 
BEGIN
 INSERT INTO order_items(order_id ,item_id ,product_id ,quantity ,unit_price)
 values(o_id,i_id,p_id,quan,u_price);
 if sql%rowcount>0
         then status:='inserted';
         end if;
         commit;
         EXCEPTION 
         when others then
         status:='not inserted';
         o_error:=sqlcode||sqlerrm;
 END add_order_items;
 
  PROCEDURE remove_order_items(o_id in number,status out varchar2,o_error out varchar2)IS 
  BEGIN
   DELETE FROM order_items WHERE order_id=o_id;
   if sql%rowcount>0
         then status:='deleted';
         end if;
          if sql%rowcount=0
        then status:='order id '||o_id||'does not exist';
        end if;
         commit;
         EXCEPTION 
         when others then
         status:='not deleted';
         o_error:=sqlcode||sqlerrm;
   END remove_order_items;
   --add category
   PROCEDURE add_category(ca_id in number,ca_name in varchar2,ca_status out varchar2,ca_error out varchar2) is 
   begin
   insert into product_categories (category_id,category_name)values(ca_id,ca_name);
   if sql%rowcount>0
         then ca_status:='inserted';
         end if;
         commit;
         EXCEPTION 
         when others then
         ca_status:='not inserted';
         ca_error:=sqlcode||sqlerrm;
 END add_category;
 --remove category
 PROCEDURE remove_category(ca_id in number,ca_status out varchar2,ca_error out varchar2) is
 begin
 delete from product_categories where category_id=ca_id;
 if sql%rowcount>0
         then ca_status:='deleted';
         end if;
          if sql%rowcount=0
        then ca_status:='not deleted';
        end if;
         commit;
         EXCEPTION 
         when others then
         ca_status:='not deleted';
         ca_error:=sqlcode||sqlerrm;
   END remove_category;

END sales;

/
set serveroutput on
--ADD PRODUCT
DECLARE 
   p_status varchar2(20);
   p_error varchar2(300);
BEGIN
  sales.add_products('shower gel', 'Skin Care Product', 70, 75, 101,p_status,p_error);
  DBMS_OUTPUT.PUT_LINE(p_status||' '||p_error);
  end; 
--DELETE PRODUCT
SET SERVEROUTPUT ON
DECLARE 
     pro_id products.product_id%type:=&enter_id;
     p_status varchar2(200);
     p_error varchar2(500);
      
BEGIN
   sales.remove_product(pro_id,p_status,p_error);
   dbms_output.put_line(p_status||' '||p_error);
end remove_product;
--ADD EMPLOYEE
DECLARE
   e_status varchar2(20);
   e_error varchar2(200);
BEGIN
   sales.add_employees('Hamsavardhini', 'Sedhu', 'anu@gmail.com', '9876863748', '21-09-2016', 4, 'Accountant',e_status,e_error);
      dbms_output.put_line(e_status||' '||e_error);
end add_employees;
--DELETE employee
DECLARE 
     emp_id employees.employee_id%type:=&enter_id;
     e_status varchar2(200);
     e_error varchar2(500);
BEGIN
   sales.remove_employees(emp_id,e_status,e_error);
   dbms_output.put_line(e_status||' '||e_error);
end remove_empolyees;
--ADD customer
DECLARE
   c_status varchar2(20);
   c_error varchar2(200);
BEGIN
   sales.add_customer( 'Swathi','Ramnad', 'https://www.flipkart.com/', 5000,c_status,c_error);
      dbms_output.put_line(c_status||' '||c_error);
end add_customer;
--DELETE customer
DECLARE 
     cus_id customers.customer_id%type:=&enter_id;
     c_status varchar2(200);
     c_error varchar2(500);
BEGIN
   sales.remove_customer(cus_id,c_status,c_error);
   dbms_output.put_line(c_status||' '||c_error);
end remove_customer;
set serveroutput on
--ADD orders
DECLARE
    status varchar2(30);
    or_error varchar2(300);
BEGIN
    sales.add_orders(4, 'orderd', 21, '03-05-2021',status,or_error);
    dbms_output.put_line(status||' '||or_error);
end add_orders;
--cancel orders
DECLARE
    o_id integer:=&Enter_o_id;
    status varchar2(200);
    or_error varchar2(500);
BEGIN
    sales.cancel_order(o_id,status,or_error);
    dbms_output.put_line(status||' '||or_error);
end cancel_order;
--add order_items
DECLARE
    status varchar2(200);
    o_error varchar2(300);
BEGIN
    sales.add_order_items(4, 2, 24, 1, 32,status,o_error);
     dbms_output.put_line(status||' '||o_error);
end add_order_items;
DECLARE
    o_id integer:=&Enter_o_id;
    status varchar2(200);
    o_error varchar2(300);
BEGIN
    sales.remove_order_items(o_id,status,o_error);
          dbms_output.put_line(status||' '||o_error);

end remove_order_items;
set serveroutput on
--add category
DECLARE
   ca_status varchar2(200);
   ca_error varchar2(400);
BEGIN
  sales.add_category(103,'Dairy',ca_status,ca_error);
      dbms_output.put_line(ca_status||' '||ca_error);
end add_category;
--delete category
declare
 ca_id integer :=&enter_id; 
 ca_status varchar2(200);
   ca_error varchar2(400);
begin
  sales.remove_category(ca_id,ca_status,ca_error);
  dbms_output.put_line(ca_status||' '||ca_error);
end remove_category;


     
    
  
    


