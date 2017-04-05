--  Simulate an operation on some column in some table
--  In a galaxy far far away
declare @columnValue int = 5;
select 45/@columnValue;
go

--  If is all fun and games until the column value is ZERO
declare @columnValue int = 0;
select 45/@columnValue;
go

--  So looking here, we have an actual legimate use for NullIf()
declare @columnValue int = 0;
select 45/Nullif(@columnValue,0); -- <-- anything divided by null is NULL
go

--  So we can then wrap that null with a coalesce
declare @columnValue int = 0;
select Coalesce(45/Nullif(@columnValue,0),0); -- <-- anything divided by null is NULL
go



