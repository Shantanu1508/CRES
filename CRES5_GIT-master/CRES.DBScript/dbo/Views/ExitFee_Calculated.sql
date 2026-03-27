CREATE View [dbo].[ExitFee_Calculated]  
  
  
AS  
  
  
Select   
  
 T.NoteID, StartDate, EndDate, T.Date  
,T. Balloon  
, T.Repayment  
  
, Value  
, Balloon_plus_Repayment  
, T.Repayment* Value RepaymentTimesPerc  
  
  
, BalloonTimesPer =Case WHen Balloon_plus_Repayment <> TotalCommitment   
THEN (T.Balloon + (TotalCommitment- Balloon_plus_Repayment)) * Value  
 Else ISNULL(T.Balloon,0) * Value ENd  
  
,ExitFeeCalc_IncludeRepayment =ISNULL(T.Repayment,0)* ISNULL(x.Value,0) + Case WHen(Balloon_plus_Repayment is not NULL and Balloon_plus_Repayment <> TotalCommitment )  
               THEN (isnull(T.Balloon,0) + (TotalCommitment- Balloon_plus_Repayment)) * Value  
               Else isnull(T.Balloon,0) * x.Value End  
  
  
  
  
, N.TotalCommitment  
, AnalysisName  
, BaseAmountOverride  
from [dbo].[TransactionEntryPivot] T  
  
Outer apply (Select * from [DW].[FeeScheduleBI] F  
    where F.crenoteid = T.NoteID  
    and T.Date between StartDate  and EndDate  
    and F.FeeType = 'Exit Fee'  
    )x  
  
Inner join Dw.NoteBI n  
oN N.NoteID = T.NoteKey  
Outer Apply  (Select Notekey, MAX(Date1) Date1, SUm(T1.Amount )Balloon_plus_Repayment, AnalysisID, A.Name from Dbo.TransactionEntry T1  
    Inner join Dw.AnalysisBI A on A.AnalysisKey = T1.AnalysisID  
    Outer apply (Select MAX(date) Date1 from dbo.Transactionentry T2  
       Where T1.noteid = T2.Noteid and T2.Type in ('Balloon',  'FundingOrRepayment')   
         and T2.AccountTypeID = 1
       Group by NoteID   
         
       )z3  
  
   where  T1.Type in ('Balloon',  'FundingOrRepayment') and T1.Amount > 0  
    and   T.NoteKey =  T1.NoteKey and T.AnalysisName =  A.Name  and T.date = Date1  
      
   Group By Notekey, AnalysisID, A.Name  
     
   )y  
    
  
  
WHere (T.Balloon is Not Null Or T.Repayment is not null)

	
		
