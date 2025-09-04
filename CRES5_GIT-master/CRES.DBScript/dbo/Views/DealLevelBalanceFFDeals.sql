-- View



CREATE view [dbo].[DealLevelBalanceFFDeals]  
As  
Select CREDealID  
, DealName  
, creNoteId  

, p.date   
, (EndingBalance)EndingBalance,   
NegativeorPositiveBalance = Case when (EndingBalance)<0 Then'Negative Balance' else 'Positive Balanace' end  ,
null as HighorSmallNegativebalance
from cre.Note n  
  
inner join  [CRE].[DailyInterestAccruals]  p on n.NoteID=p.NoteID  
inner join core.Analysis A on A.analysisid = P.analysisid  
inner join cre.deal d on d.DealID = n.DealID  

where   
p.AnalysisID= 'c10f3372-0fc2-4861-a9f5-148f1f80804f'   
 and  
creDealid in (  
select   
d.CreDealid  
from cre.Note n  
inner join FundingSequences seq on n.CRENoteID=seq.CRENoteID  
--inner join cre.NotePeriodicCalc p on n.NoteID=p.NoteID   
inner join core.Analysis A on A.analysisid = P.analysisid  
Inner join cre.Deal d on D.Dealid = n.DealID  
where   
ActualPayoffDate is null  
and UseRuletoDetermineNoteFunding=3  
and seq.FundingSequenceType='Repayment sequence'  
and A.name = 'Default'  
and credealid in  
(  
Select CreDealid from [dbo].[DealFundingSchedule]  
Where Amount > 0 and Date > Convert(Date , Getdate())  

)  
and d.status = 323  

group by d.CreDealid, D.DealName  
)
GO