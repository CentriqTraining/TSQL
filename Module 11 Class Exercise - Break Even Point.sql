-- order totals of $1,500 give our company enough profit to offer free shipping 
-- and still make a decent profit
-- We are trying to decide if there are enough orders at that level to justify
-- offering free shipping to all orders
-- Give a report consisting of the COUNT, AVERAGE ORDER TOTAL, TOTAL revenue
--  for all orders at that level...and the same information for less 

/*  Here we have to think outside the box.  We want to sum avg and count only WHEN the order total
is at a certain level...here's how we do it  */
select 
Sum(case when ordertotal >= 1500 then ordertotal else 0 end) as totalbreakeven, 
avg(case when ordertotal >= 1500 then ordertotal else null end) as AveragebreakEven,
Sum(case when ordertotal >= 1500 then 1 else 0 end) as countbreakeven,
Sum(case when ordertotal < 1500 then ordertotal else 0 end) as totalloss, 
Avg(case when ordertotal < 1500 then ordertotal else null end) as Averageloss,
count(case when ordertotal < 1500 then 1 else 0 end) as countloss
from 
(
/*  Start with an inner query to get order totals since that is the 
one thing that we do not have */
select ord.orderid, sum((unitprice * (1-discount)) * Qty) ordertotal
from sales.orders ord
join sales.orderdetails det
on ord.orderid = det.orderid
group by ord.orderid) totals
