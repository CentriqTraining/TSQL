-- Give me the details on the employee and the order
--  for EACH products largest grossing order
-- (unitprice * qty) * (1-discount)
select s.productid, s.productName, 
		ord.orderid, maxinfo.maxqty as Revenue, 
		Emp.firstname, emp.lastname
from production.Products s
cross apply dbo.fn_LargestGrossingOrderByProduct(s.productId) as maxinfo
join sales.Orders ord 
  on ord.orderid = maxinfo.orderid
join hr.employees emp 
on emp.empid = ord.empid
order by productid








go
create function fn_LargestGrossingOrderByProduct (@productid int)
returns table 
as
return 
select top 1 productid, orderid, 
	max((unitprice * qty) * (1-discount)) maxqty
from sales.orderdetails 
where productid = @productid
group by productid, orderid
go


