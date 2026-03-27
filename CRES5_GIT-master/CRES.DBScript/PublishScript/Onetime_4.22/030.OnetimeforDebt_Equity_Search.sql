Delete from [App].[SearchItem] where Object_ObjectAutoID in (Select ObjectAutoID from [App].[Object] where ObjectTypeID = 843)
Delete from [App].[Object] where ObjectTypeID = 843
Delete from [App].[SearchItem] where Object_ObjectAutoID in (Select ObjectAutoID from [App].[Object] where ObjectTypeID = 842)
Delete from [App].[Object] where ObjectTypeID = 842

go

Declare @ObjectIDEquity UNIQUEIDENTIFIER
 
IF CURSOR_STATUS('global','CursorEquity')>=-1
BEGIN
	DEALLOCATE CursorEquity
END

DECLARE CursorEquity CURSOR 
for
(
	Select EquityGUID from cre.Equity
)


OPEN CursorEquity  

FETCH NEXT FROM CursorEquity
INTO @ObjectIDEquity

WHILE @@FETCH_STATUS = 0
BEGIN

	EXEC [App].[usp_AddUpdateObject] @ObjectIDEquity,843,'Kbaderia','Kbaderia'
					 
FETCH NEXT FROM CursorEquity
INTO @ObjectIDEquity
END
CLOSE CursorEquity   
DEALLOCATE CursorEquity


go

Declare @ObjectIDDebt UNIQUEIDENTIFIER
 
IF CURSOR_STATUS('global','CursorDeal')>=-1
BEGIN
	DEALLOCATE CursorDeal
END

DECLARE CursorDeal CURSOR 
for
(
	Select DebtGUID from cre.debt
)


OPEN CursorDeal  

FETCH NEXT FROM CursorDeal
INTO @ObjectIDDebt

WHILE @@FETCH_STATUS = 0
BEGIN

	EXEC [App].[usp_AddUpdateObject] @ObjectIDDebt,842,'Kbaderia','Kbaderia'
					 
FETCH NEXT FROM CursorDeal
INTO @ObjectIDDebt
END
CLOSE CursorDeal   
DEALLOCATE CursorDeal
