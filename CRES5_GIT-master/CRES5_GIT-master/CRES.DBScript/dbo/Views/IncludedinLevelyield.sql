
-- View
CREATE View [dbo].[IncludedinLevelyield]
As

Select T.Notekey
,amount = case when Notekey =  'f1c1338e-e2e2-4028-a1fc-97c390127e44' Then 25191.43 else

ISNULL(SUM(Amount),0)   end from TransactionEntry T
--Inner join [dbo].[FeeSchedule] F on F.NoteKey = T.NoteKey 
--and F.StartDate = t.Date
Where Scenario = 'Default' and  (Type like '%IncludedInLevelYield%'  or Type = 'OriginationFeeStripping' or Type = 'OriginationFeeStripReceivable')
 --and Notekey = 'b98aa865-3980-4c0c-8edc-04127a423e14'
 --and notekey = 'e5af0f0f-0896-4126-a62e-11936b329938'
--and [IncludedLevelYield] = 1
--and [FeeType] in ('Origination Fee', 'Unused Fee', 'Extension Fee_COMM', 'Extension Fee_UPB', 'Exit Fee', 'Additional Fee') 
--and t.NoteKey = '3c20f466-188b-4e5d-8c66-369e841e098b'

Group by  T.Notekey

