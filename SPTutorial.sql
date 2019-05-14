--caling sp using parameter
exec sp_getsalary @id = 1
------------------------------------
--adding output parameter in sp
ALTER procedure [dbo].[sp_GetSalary]
@id int,
@count_value int output
as 
begin
select salary from customers where id = @id;

select @count_value = @@ROWCOUNT;
end;
------------------------------------
--calling sp using output parameter
declare @rowcount int 
exec sp_getsalary @id = 5,@count_value = @rowcount output;
select @rowcount as 'count value';
---------------------------------------
--ifelse part in sp
alter procedure sp_getAddress
@id int
as 
begin
declare @salary decimal(18,3)
declare @address char(30)
select @salary = salary, @address = address from customers where id = @id;
if @salary > 3000
begin
select @address;
end
else
begin
select 'Else part: ' +@address;
end
end
---------------------------------------
exec sp_getaddress @id = 4
---------------------------------------
--while loop, break, continue in sp
alter procedure sp_getCounter
as 
begin
declare @count_value int;
select @count_value = count(1) from customers;
while @count_value > 0
begin
if @count_value =3
	begin
	set @count_value = @count_value -1;
	continue;
	end
print @count_value
if @count_value = 2
	begin
	break;
	end
set @count_value = @count_value -1;
end
end
---------------------------------------
exec sp_getcounter
---------------------------------------
--cursors
declare @customer_Id int;
--declare
declare cursor_customers cursor
for select distinct customer_id from orders;
--open
open cursor_customers;
--fetch
fetch next from cursor_customers into @customer_id;

while @@FETCH_STATUS =0
begin
print @customer_id;
fetch next from cursor_customers into @customer_id;
end
--close
close cursor_customers
--deallocate
deallocate cursor_customers
---------------------------------------
--Try Catch
-- sp for report error
create procedure sp_reporterror
as 
begin
select ERROR_NUMBER() as ErrorNumber,
ERROR_SEVERITY() as ErrorSeverity,
ERROR_STATE() as ErrorState,
ERROR_LINE() as ErrorLine,
ERROR_PROCEDURE() as ErrorProcedure,
ERROR_MESSAGE() as ErrorMessage
end
--------------------------------------
--sp to delete customer which handle state of transactions
create procedure sp_deletecustomers
@id int
as 
Begin
	begin try
		begin transaction;
		delete from customers where id = @id;
		commit transaction;
	End Try
	Begin Catch
		exec sp_reporterror
		if XACT_STATE() = -1
		Begin
			PRINT  N'The transaction is in an uncommittable state.' +  
                    'Rolling back transaction.' 
			rollback transaction;
		end
		if XACT_STATE() = 1
		begin
			 PRINT N'The transaction is committable.' +  
                'Committing transaction.'  
			commit transaction;
		end
	End Catch
End
--------------------------------------
exec sp_deleteCustomers @id = 10
--------------------------------------
--raise error
exec sp_addmessage @msgnum = 50005, @severity = 1, @msgtext = 'custom error for tutorial'
select * from sys.messages where message_id = 50005
raiserror (50005,1,1)
----------------------------------------
--throw
throw 50005,'Error occured',1
----------------------------------------
sp_executesql N'select * from customers where id = @id'
,N'@id int'
,@id = 2
----------------------------------------
--scalar function
create function fn_getOrderAmount(@id int)
returns decimal
as
begin
declare @amount decimal;
select @amount = amount from orders where id = @id;
return @amount;
end
----------------------------------------
select dbo.fn_getOrderAmount(3)
----------------------------------------
--table variables (better than creating temp tables)
declare @tblAddress table(name varchar(30), address char(30));
insert into @tblAddress select name, address from customers
select * from @tblAddress
----------------------------------------
--table values function
create function fn_customerValues(@id int)
returns table
as 
return
select * from customers where id = @id;
----------------------------------------
select * from fn_customervalues(3)
----------------------------------------
select newid() as guid
----------------------------------------
with cte_order_amount(id,amount) as(select id, amount from orders)
select * from cte_order_amount
----------------------------------------

----------------------------------------

----------------------------------------














