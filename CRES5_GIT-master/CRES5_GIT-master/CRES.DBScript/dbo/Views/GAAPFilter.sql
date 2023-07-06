CREATE View [dbo].[GAAPFilter]
AS

Select 
CRENoteid
,CapitalizedCost = case when creNoteid in 

(Select CreNoteid 

from Dw.NoteBI
Where ISNULL([CapitalizedClosingCosts],0) <> 0)
THEN 'YES' ELSE 'NO' End
,IncorrectDiscountPremiun = CASE when CRenoteID in (Select  Distinct nn.Crenoteid
 
					from [DW].[Staging_Cashflow] np
					inner join cre.note nn on nn.noteid = np.noteid
					where ROUND(DiscountPremiumAccrual,2) <> 0
					and ISNULL(nn.Discount,0) = 0)
					
					THEN 'Yes' else 'No' End
,IsorginationFeeStripped = CAse when Crenoteid in (Select CReNOTEID from [DW].[FeeScheduleBI] fs
where FeeType = 'Origination Fee'  and ISNULL(FeetobeStripped,0) <> 0) 
THEN 'Yes' ELSE 'No' END
, ISpikLoan =  CASE WHEN CrenoteID in (Select CRENOTEID from(
Select n.crenoteid,
	(Select count(piks.StartDate) from Core.[PIKSchedule] piks
	inner join core.Event e on e.EventID = piks.EventId
	inner join core.Account acc on acc.AccountID = e.AccountID
	where e.EventTypeID = 12 
	and acc.AccountID = n.account_accountid) PIKScheduleCnt
 from cre.Note n
 )a  where PIKScheduleCnt > 0) THen 'Yes' else 'no' end

 from DW.noteBI N

