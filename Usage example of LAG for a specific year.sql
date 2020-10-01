select employee, orderyear, currentsales,
      previousyearsales, previouspreviousyearsales
from 
(SELECT employee, orderyear, totalsales AS currentsales,
      LAG(totalsales, 1,0) OVER (PARTITION BY employee ORDER BY orderyear) AS previousyearsales,
      LAG(totalsales, 2,0) OVER (PARTITION BY employee ORDER BY orderyear) AS previouspreviousyearsales
  FROM Sales.OrdersByEmployeeYear) data
where orderyear = 2008