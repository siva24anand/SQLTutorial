

create table Customers(
Id int not null,
name varchar(20) not null,
age int not null,
address char(25),
salary decimal(18,2),
primary key(Id))
----------------------------------------------------------

select * from Customers
select * from orders

insert into Customers(name,age,address)
values('anand38',38,'mcity1');

update Customers set age = 35 where id = 2
----------------------------------------------------------
ALTER TABLE CUSTOMERS
alter column SALARY  DECIMAL (18, 2) null

alter table customers add constraint df_salary default 2500.00 for Salary
alter table customers add constraint nc_age unique(age)
----------------------------------------------------------
CREATE TABLE ORDERS (
   ID          INT        NOT NULL,
   DATE        DATETIME, 
   CUSTOMER_ID INT references CUSTOMERS(ID),
   AMOUNT    decimal(18,3),
   PRIMARY KEY (ID)
);
----------------------------------------------------------
alter table orders add constraint fk_cutomerid Foreign Key(customer_id) references customers(id)
alter table orders add constraint fk_customerid foreign key(customer_id) references customers(id)
alter table customers add constraint ck_age1 check(age<45)
create index idx_name on customers(name)
alter table customers drop column id
alter table customers drop PK__Customer__3214EC072A390D9C
alter table orders drop FK__ORDERS__CUSTOMER__145C0A3F
alter table customers add id int identity not null 
alter table customers add primary key (id)
---
alter table orders drop column id
alter table orders drop PK__ORDERS__3214EC279DED611F
alter table orders add id int identity
alter table orders add primary key(id)
----------------------------------------------------------
create view customersalary2k as 
select id,name,salary from customers where salary > 2000

alter view customersalary2k as 
select id,age,name,salary from customers where salary > 2000

select * from customersalary2k
exec sp_getsalary @id=3

select * from orders
----------------------------------------------------------
alter trigger trinsert 
on customers
after insert, delete
as
begin
set nocount on;
insert into ORDERS(date,CUSTOMER_ID,AMOUNT) 
select GETDATE(),id,salary from inserted
end
go
----------------------------------------------------------
create procedure sp_GetSalary
@id int
as 
select salary from customers where id = @id
go
----------------------------------------------------------
delete from customers where id = 9
delete from orders where CUSTOMER_ID = 9
----------------------------------------------------------
create table brands(
id int identity primary key,
name varchar(20) not null)
create table brands_approvals(
id int identity primary key,
name varchar(20) not null)
----------------------------------------------------------
create view vw_brands
as
select name, 'Approved' approval_status from brands
union
select name, 'Pending Approval' approval_status from brands_approvals
----------------------------------------------------------
create trigger trg_vw_brands
on vw_brands
instead of insert 
as begin
set nocount on
insert into brands_approvals(name) select i.name from inserted i where i.name not in (select name from brands);
end
----------------------------------------------------------
insert into vw_brands(name)values('samsung')

select * from vw_brands
select * from brands_approvals
----------------------------------------------------------
--drop trigger if exists trg_vw_brands
select * from sys.triggers

disable trigger all on customers
enable trigger all on customers
----------------------------------------------------------
