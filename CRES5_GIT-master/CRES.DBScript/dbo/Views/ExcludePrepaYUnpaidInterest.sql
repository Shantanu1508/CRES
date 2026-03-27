Create View [dbo].ExcludePrepaYUnpaidInterest  
As  
Select S.NoteID  
, S.PeriodEndDate  
, S.CurrentPeriodInterestAccrualPeriodEnddate StgaingUnpaidInterest_WithoutDropdate  
, T.CurrentPeriodInterestAccrual IntgartionActualUnpaidInterest_WithDropdate  
, ISNULL(s.CurrentPeriodInterestAccrualPeriodEnddate,0)+ ISNULL(Interest,0) expectedUnpaidInterest   
  
  
  
from Staging_Cashflow S  
  
Left Join ExcludePrepaYUnpaidInterest_Interim2 I on S.NoteID = CRENoteID and S.PeriodEndDate = I.Monthend  
Left Join NotePeriodicCalc T on S.NoteID = T.NoteID and S.PeriodEndDate = T.PeriodEndDate and T.AnalysisID = S.AnalysisID  
where S.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and S.PeriodEndDate = Eomonth(S.PeriodEndDate,0)  
 and T.PeriodEndDate = Eomonth(T.PeriodEndDate,0) and T.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'  