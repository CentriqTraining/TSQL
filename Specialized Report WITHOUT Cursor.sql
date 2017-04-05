Declare @Supplier1 int = 1
Declare @Supplier2 int = 2
Declare @Supplier3 int = 3

Declare @sup1 varchar(100);
Declare @sup2 varchar(100);
Declare @sup3 varchar(100);

Select @sup1 = CompanyName 
from Production.Suppliers 
Where SupplierId = @Supplier1

Select @sup2 = CompanyName 
from Production.Suppliers 
Where SupplierId = @Supplier2

Select @sup3 = CompanyName 
from Production.Suppliers 
Where SupplierId = @Supplier3

Create table #SalesTotals (
Id int Identity(1,1) primary key,
Company varchar(155),
[Year] int, 
SalesTotal numeric(19,2) default 0
)

insert into #SalesTotals
select 
	case 
		when sup.supplierid in (@Supplier1, @Supplier2, @Supplier3) 
			then sup.companyname
		else 'Other' end as Company,
	Year(ord.orderdate) as Year, 
	Sum(prod.unitprice*qty) as SalesTotal
from sales.orders ord
	join sales.OrderDetails det 
		on det.orderid = ord.orderid
	join production.products prod 
		on prod.productid = det.productid
	join production.suppliers sup 
		on sup.supplierid = prod.supplierid
where ord.shippeddate is not null
group by 
	case 
		when sup.supplierid in (@Supplier1, @Supplier2, @Supplier3) 
			then sup.companyname
		else 'Other' end,
	ord.orderdate

declare @sql nvarchar(1000)

select @Sql = 'Select [Year], ' +
'[' + @sup1 +'],[' + @sup2 + '],[' + @sup3 + '],[Other] ' +
'from ' +
'(Select Company,[Year],Sum(SalesTotal) as SalesTotal ' +
'from #SalesTotals ' +
'group by Company, [Year]  ) as Source ' +
'Pivot (' +
'	Sum(SalesTotal)' +
'	For Company ' +
'	in ([' + @sup1 +'],[' + @sup2 + '],[' + @sup3 + '],[Other])) ' +
'as Pivottable'

print @sql
exec sp_executeSql @sql ;

drop table #SalesTotals