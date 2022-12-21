
Create View [dbo].[DealMultiClosingDates]
as

Select x.DealKey,  DealID, DealName, Status, Count(*)Number from
(

select d.DealKey,  DealID,dealname, closingdate,Status from Note N
inner join deal D on D.DealKey = N.DealKey
--where DealID = '15-0059'
Group By  DealId,Dealname, Closingdate, Status, d.dealkey

)x

Group by Dealid,dealname, Status, x.Dealkey

having count(*)>1
