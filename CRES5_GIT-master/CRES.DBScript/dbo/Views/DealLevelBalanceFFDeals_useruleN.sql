CREATE view [dbo].[DealLevelBalanceFFDeals_useruleN]  
As  
Select CREDealID  
, d.DealName  
, n.noteId  
, n.noteId  as crenoteid
, p.date   
, (EndingBalance)EndingBalance,   
pd.Payoffdate  
,NegativeorPositiveBalance =   Case when Round(EndingBalance,2)<0 Then'Negative Balance' else 'Positive Balance' end  
,HighorSmallNegativebalance = Case when Round(EndingBalance,2) < 0 and Endingbalance >= -25 Then'Small Negative Balance'   
         when (EndingBalance) < -25  then 'High Negative Balance'   
   
 else 'Positive Balance' end  
,HasScheduledPrincipal HasSchPrin  
,PIk_NonPIk  
, Userule = 'Use Rule N'  
, FutureFundingDeals= 'Future Funding Deals'  
from Note n  
  
inner join  [CRE].[DailyInterestAccruals]  p on n.Notekey=p.NoteID   
inner join core.Analysis A on A.analysisid = P.analysisid  
inner join cre.deal d on d.DealID = n.Dealkey  
Left join Payoffdate pd on pd.NoteID = n.noteid  
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
and UseRuletoDetermineNoteFunding=4  
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