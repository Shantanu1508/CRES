

-- Procedure
-- Procedure


Create PROCEDURE  GetAvgEndingBalanve
As

Begin

Insert Into AvgEndingBalanceTable
(creDealID
,DealName
,[creNoteId]
,[Avgendingbalance]

)

Select * from [AvgnNegativeBalance]
 end