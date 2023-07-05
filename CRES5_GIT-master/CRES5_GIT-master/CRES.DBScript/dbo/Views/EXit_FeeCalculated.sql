  
  
  
CREATE View [dbo].EXit_FeeCalculated  
As  
Select T.NoteID, StartDate, EndDate, T.Date  
, Balloon  
, Repayment  
, Value  
, Balloon_plus_SchedulePrincipal_plus_Repayment  
, Repayment* Value RepaymentTimesPerc  
  
  
, BalloonTimesPer =Case WHen Balloon_plus_SchedulePrincipal_plus_Repayment <> TotalCommitment THEN (Balloon + (TotalCommitment- Balloon_plus_SchedulePrincipal_plus_Repayment)) * Value  
 Else Balloon * Value ENd  
  
,ExitFeeCalc =ISNULL(Repayment,0)* ISNULL(x.Value,0) + Case WHen Balloon_plus_SchedulePrincipal_plus_Repayment <> TotalCommitment   
               THEN (isnull(Balloon,0) + (TotalCommitment- Balloon_plus_SchedulePrincipal_plus_Repayment)) * Value  
               Else isnull(Balloon,0) * x.Value End  
  
, AnalysisName  
from [dbo].[TransactionEntryPivot] T  
  
Outer apply (Select * from [DW].[FeeScheduleBI] F  
    where F.crenoteid = T.NoteID  
    and T.Date Between StartDate  and EndDate  
    and F.FeeType = 'Exit Fee'  
    )x  
   
Inner join Dw.NoteBI n  
oN N.NoteID = T.NoteKey  
Outer Apply (Select SUm(T1.Amount ) Balloon_plus_SchedulePrincipal_plus_Repayment from Dbo.TransactionEntry T1  
   Where T.NoteKey =  T1.NoteKey  
   and Type in ('Balloon', 'ScheduledPrincipalPaid', 'FundingOrRepayment') and Amount > 0  
   Group By NoteID  
   )y  
  
  
WHere   
 (Balloon is Not Null Or Repayment is not null  
     
  )  
  
  
  
  
  
  
  
