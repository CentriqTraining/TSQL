--  Subquery
--  Select *
--  from {table}
--  where {column} (in | {operator}) ({another select})


-- Correlated Subquery
-- Select *
-- From {table} as Alais1
-- where {column} (in | {operator}) ({Select *
-- From {table} as Alias2
-- where Alais1.{column} = Alias2.{column})					


-- Exist Subquery
-- Select * 
-- from {table}
-- Where [not] exists ({Query})


-- View
-- Create view {schema}.{view}
-- as
-- {select statements}


-- Derived Tables
--  Select *
--  From ({another query}) as ALIAS


-- Inline TVF
-- create function {schema}.{funcName}
-- ({paramter list})
-- returns 
-- table
-- as
-- return 
--	{select statement}
-- can use apply/outer apply on these


-- CTE (Common Table Expressions)
--  With {CTEName}
--    as
--   ({select statement})
--  {Select statement that MUST use {CTEName}


-- Stored Prodedure
-- create procedure {schema}.{procedurename}
-- ({parameter list})
-- as
-- begin
--  ...
-- end

--exec proc
