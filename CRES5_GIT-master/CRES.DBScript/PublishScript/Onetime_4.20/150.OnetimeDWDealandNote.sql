--Update dw.dealbi set dw.dealbi.[LinkedDealID] = a.[LinkedDealID],
--dw.dealbi.[EnableAutoSpread] = a.[EnableAutoSpread],
--dw.dealbi.[EnableAutoSpreadRepayments] = a.[EnableAutoSpreadRepayments],
--dw.dealbi.[ApplyNoteLevelPaydowns] = a.[ApplyNoteLevelPaydowns],
--dw.dealbi.[CalcEngineType] = a.[CalcEngineType],
--dw.dealbi.[CalcEngineTypeBI] = a.[CalcEngineTypeBI]
--From(
--	Select d.dealid,
--	d.[LinkedDealID]  ,             
--	d.[EnableAutoSpread]   ,        
--	d.[EnableAutoSpreadRepayments] ,
--	d.[ApplyNoteLevelPaydowns]    , 
--	d.[CalcEngineType]       ,      
--	lCalcEngineType.name as [CalcEngineTypeBI]  
--	FROM CRE.Deal d

--	LEFT Join Core.Lookup lCalcEngineType on d.CalcEngineType=lCalcEngineType.LookupID
--	WHERE d.isdeleted <> 1

--)a
--where dw.dealbi.dealid = a.DealID


--go



--Update dw.notebi set dw.notebi.NoteType = a.NoteType,
--dw.notebi.EnableM61Calculations = a.EnableM61Calculations,
--dw.notebi.NoteTypeBI = a.NoteTypeBI,
--dw.notebi.EnableM61CalculationsBI = a.EnableM61CalculationsBI,
--dw.notebi.RepaymentDayoftheMonth = a.RepaymentDayoftheMonth
--from(

--Select n.noteid,n.NoteType,
--n.EnableM61Calculations,
--LNoteType.name as NoteTypeBI,
--LEnableM61Calculations.name as EnableM61CalculationsBI,
--n.RepaymentDayoftheMonth

--From CRE.Note n
--Inner Join CORE.Account ac ON ac.AccountID = n.Account_AccountID
--left join Core.Lookup LNoteType ON n.NoteType=LNoteType.LookupID
--left join Core.Lookup LEnableM61Calculations ON n.EnableM61Calculations=LEnableM61Calculations.LookupID
--WHERE ac.isdeleted <> 1 

--)a
--where dw.notebi.noteid = a.noteid