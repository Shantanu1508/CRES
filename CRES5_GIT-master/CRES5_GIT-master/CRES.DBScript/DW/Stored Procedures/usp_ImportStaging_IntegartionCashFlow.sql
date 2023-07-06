
CREATE PROCEDURE [DW].[usp_ImportStaging_IntegartionCashFlow]
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
	DECLARE @RowCount int

--===================================================

--Truncate table DW.Staging_IntegartionCashFlowBI
Delete from [DW].[Staging_IntegartionCashFlowBI] where NoteID in (Select Distinct n.creNoteID from [DW].[L_NotePeriodicCalcBI] a inner join cre.note n on n.noteid = a.noteid)

INSERT INTO DW.Staging_IntegartionCashFlowBI (Scenario,AnalysisID,NoteKey,NoteID,PeriodEndDate,In_EndingGAAPBookValue,In_TotalAmortAccrualForPeriod,In_AccumulatedAmort,In_DiscountPremiumAccrual,In_AccumaltedDiscountPremium,In_CapitalizedCostAccrual,In_AccumalatedCapitalizedCost,In_CurrentPeriodInterestAccrualPeriodEnddate,St_EndingGAAPBookValue,St_TotalAmortAccrualForPeriod,St_AccumulatedAmort,St_DiscountPremiumAccrual,St_AccumaltedDiscountPremium,St_CapitalizedCostAccrual,St_AccumalatedCapitalizedCost,St_CurrentPeriodInterestAccrualPeriodEnddate)
Select 
In_np.Scenario
,In_np.AnalysisID
,In_np.NoteKey	
,In_np.NoteID	
,In_np.PeriodEndDate

,In_np.EndingGAAPBookValue as In_EndingGAAPBookValue
,In_np.TotalAmortAccrualForPeriod as In_TotalAmortAccrualForPeriod
,In_np.AccumulatedAmort as In_AccumulatedAmort
,In_np.DiscountPremiumAccrual as In_DiscountPremiumAccrual
,In_np.AccumaltedDiscountPremium as In_AccumaltedDiscountPremium
,In_np.CapitalizedCostAccrual as In_CapitalizedCostAccrual
,In_np.AccumalatedCapitalizedCost as In_AccumalatedCapitalizedCost
,In_np.CurrentPeriodInterestAccrualPeriodEnddate as In_CurrentPeriodInterestAccrualPeriodEnddate

,St_np.EndingGAAPBookValue as St_EndingGAAPBookValue
,St_np.TotalAmortAccrualForPeriod as St_TotalAmortAccrualForPeriod
,St_np.AccumulatedAmort as St_AccumulatedAmort
,St_np.DiscountPremiumAccrual as St_DiscountPremiumAccrual
,St_np.AccumaltedDiscountPremium as St_AccumaltedDiscountPremium
,St_np.CapitalizedCostAccrual as St_CapitalizedCostAccrual
,St_np.AccumalatedCapitalizedCost as St_AccumalatedCapitalizedCost
,St_np.CurrentPeriodInterestAccrualPeriodEnddate as St_CurrentPeriodInterestAccrualPeriodEnddate

from dbo.NotePeriodicCalc In_np
left join dbo.Staging_Cashflow St_np on In_np.NoteID = St_np.NoteID and In_np.AnalysisID = St_np.AnalysisID and In_np.PeriodEndDate = St_np.PeriodEndDate
where In_np.NoteID in (Select Distinct n.creNoteID from [DW].[L_NotePeriodicCalcBI] a inner join cre.note n on n.noteid = a.noteid)

--===================================================
	

SET @RowCount = @@ROWCOUNT
Print(char(9) +'usp_ImportStaging_IntegartionCashFlow - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END