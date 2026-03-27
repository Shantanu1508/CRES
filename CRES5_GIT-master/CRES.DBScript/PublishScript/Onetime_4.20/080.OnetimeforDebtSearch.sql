

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
