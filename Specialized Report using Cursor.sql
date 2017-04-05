-- Answers the scenario:  
-- Most Suppliers give us special discounts when we reach a
-- certain level of production so each year, we pick the top 3 
-- and push market them heavily.

-- I want a report that shows total sales by year, but I want those 
-- specific companies broken out into their own column 

create proc SpecializedSalesReport
(
@ID1 as int,
@ID2 as int, 
@ID3 as int
)

as

begin
--  Creates a report of sales totals by YEAR 
--  You can specify 3 companies that will have their own sums 
--  all others are summed to column OTHER

-- Creates a temporary table to hold all of my values
-- Just need ID and year because I don't know all of the columns yet
Create table #setup (
id int identity(1,1), 
[Year] int)

--  Create some variables to process our parameters
Declare @Comp varchar(200)
Declare @sql nvarchar(1000)

-- Find the supplier name for each ID passed in...keep them in the same order
-- Cursor is a special query that you can scan through one record at a time
Declare sups cursor for 
Select companyname from production.Suppliers
where supplierid in (@ID1, @ID2, @Id3)
Order by Case when supplierid=@ID1 then 1
				when supplierid=@ID2 then 2
				when supplierid=@ID3 then 3 end

--  Open the cursor and get ready to read
open sups

--  Get the first record
fetch next from sups into @Comp

-- go into loop as long as last Fetch was successful (returned 0)
while (@@FETCH_STATUS =0) begin

	--  This company needs its own column
	--  Company name CAN have spaces so BRACKETS are required when referencing this column
	Select @sql = 'alter table #setup add [' + @comp + '] numeric(19,2)'
	exec sp_executesql @sql

	-- Move to the next record in the cursor
	fetch next from sups into @Comp
end

-- cleanup
close sups
deallocate sups

-- We've added the custom columns, now add the OTHER column
alter table #setup add [Other] numeric(19,2)

--  now go get all my sales information for all SHIPPED items
--  Same thing - into a cursor
Declare salescursor cursor for 
select ord.orderdate, prod.unitprice*qty as SalesTotal, sup.supplierid, sup.companyname 
from sales.orders ord
join sales.orderdetails det on det.orderid = ord.orderid
join production.products prod on prod.productid = det.productid
join Production.suppliers sup on sup.supplierid = prod.supplierid
Where ord.shippeddate is not null 

--  Some variables to hold cursor values
Declare @date datetime
declare @val numeric(19,2)
declare @supID int
declare @col varchar(200)

--  open the cursor and get ready to read
open salescursor

--  Get the first record
fetch next from salescursor into @date, @val, @supId, @comp

-- go into loop as long as last Fetch was successful (returned 0)
while (@@FETCH_STATUS = 0) begin
	-- Add a new record for this YEAR if there isn't one already
	insert into #setup select year(@date), 0, 0, 0, 0
	where not exists (select * from #setup where [year] = year(@date))

	-- Set @col to update
	-- If this supplierID is in the list of custom ones use that companyName
	--  Otherwise use 'Other'
	Select @col = case when @supid in (@ID1, @ID2, @ID3) then @comp
						else 'Other' end

	--  Now update the total for that column 
	--  adding the @val to the current value of the column for the same year
	Select @sql = 'Update #setup set [' + @col + '] = [' + @col + '] + ' + convert(varchar(19), @val) + ' where [Year] = ' + convert(varchar(4), Year(@date))

	exec sp_executesql @sql

	-- Get next record
	fetch next from salescursor into @date, @val, @supId, @comp
end

-- clean up
close salescursor
deallocate salescursor

select * from #setup

-- final clean up
drop table #setup

end
select suser_name()
select USER_NAME()
-- Runs it
-- exec SpecializedSalesReport 5, 6, 7
