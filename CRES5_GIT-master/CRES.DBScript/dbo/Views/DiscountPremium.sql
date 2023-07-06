Create View [dbo].DiscountPremium
As

Select T.Notekey, ISNULL(SUM(Amount),0) amount from TransactionEntry T
--Inner join [dbo].[FeeSchedule] F on F.NoteKey = T.NoteKey 
--and F.StartDate = t.Date
Where Scenario = 'Default' and  Type like 'Discount/Premium' 
Group by T.NoteKey
