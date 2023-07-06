
CREATE view [dbo].[BackshopCurrentBalance]
as 

select DealID,[NoteID],[CurrentBalance],[ImportDate]
from [DW].[BackshopCurrentBalanceBI]



