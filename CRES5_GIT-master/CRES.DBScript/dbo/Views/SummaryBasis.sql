  
  
  
CREATE View [dbo].[SummaryBasis]  
as  
With GAAPBasis as  
(  
Select * from  
  
(  
Select   
N.Noteid  
  
--,SUM(PVAmortForThePeriod) as GAAPAmort  
--,SUM(PVAmortTotalIncomeMethod) As PVAmort  
--,SUM(SLAmortForThePeriod)SLAmortForThePeriod  
,SUM(TotalAmortAccrualForPeriod) AmortofDeferredFees  
--,SUM(SLAmortOfTotalFeesInclInLY) SLAmortOfTotalFeesInclInLY  
--, SUM(SLAmortofCapCost)SLAmortofCapCost  
--, SUM(SLAmortofDiscountPremium) SLAmortofDiscountPremium  
--, Sum(EndingCleanCostLY ) EndingCleanCostLY   
--,SUM(EndingAccumAmort ) AccGAAPAmort  
--, SUM(EndingAccumSLAmort ) AccSLAmort  
--, SUM(EndingPreCapGAAPBasis) GAAPBasis  
,MAX( N.Pik_NonPIK)Pik_NonPIK  
--, SUM(EndingSLBasis) SLBasis  
, SUM(CurrentPeriodInterestAccrualPeriodEnddate) AccruedInterest  
,SUM(CurrentPeriodPIKInterestAccrualPeriodEnddate)AccruedPIKInterest  
--,Sum(EndingCleanCostLY )+ SUM(CurrentPeriodInterestAccrualPeriodEnddate)+SUM(CurrentPeriodPIKInterestAccrualPeriodEnddate) + SUM(EndingAccumAmort ) As GaapAmortCalc  
--,Sum(EndingCleanCostLY ) + SUM(CurrentPeriodInterestAccrualPeriodEnddate) + SUM (CurrentPeriodPIKInterestAccrualPeriodEnddate) +SUM(EndingAccumSLAmort ) As SLAmortCalc  
,MAX(Y.NAme) Name  
--,ABS( SUM(EndingPreCapGAAPBasis) -( Sum(EndingCleanCostLY )+ SUM(CurrentPeriodInterestAccrualPeriodEnddate)+SUM(CurrentPeriodPIKInterestAccrualPeriodEnddate) + SUM(EndingAccumAmort ) ) )DeltaGAAP_Calc_Vs_Gen  
--,ABS(SUM(EndingSLBasis) -( Sum(EndingCleanCostLY )+ SUM(CurrentPeriodInterestAccrualPeriodEnddate)+SUM(CurrentPeriodPIKInterestAccrualPeriodEnddate) + SUM(SLAmortForThePeriod ) )) DeltaSL_Calc_Vs_Gen  
  
  
from Note N  
Left Join NoteperiodicCalc NC on N.Noteid = NC.Noteid  
Outer apply (Select C.Noteid, Max(Name) Name from [dbo].[Calcuationstatus] C  
    where C.Noteid = N.Noteid  
     and analysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'  
    Group By Noteid  
    )Y  
    Where Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'  
    And NC.Periodenddate = EOMONTH(NC.Periodenddate,0)  
Group By N.Noteid  
  
)z  
)  
Select * from GAAPBasis    