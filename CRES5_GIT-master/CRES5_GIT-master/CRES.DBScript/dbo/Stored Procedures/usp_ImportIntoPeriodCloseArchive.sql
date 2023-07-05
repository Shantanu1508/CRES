CREATE Procedure [dbo].[usp_ImportIntoPeriodCloseArchive]
@StartDate Date,
@EndDate Date,
@PeriodID UNIQUEIDENTIFIER,
@UserID NVarchar(255),
@AnalysisID uniqueidentifier 

AS

BEGIN

	SET NOCOUNT ON;

	Set @AnalysisID = (Select AnalysisID from core.Analysis where Name = 'Default')
	Declare @LastCloseDate Date

	
	IF EXISTS (Select PeriodID from core.Period where AnalysisID = @AnalysisID and PeriodID <> @PeriodID and IsDeleted <> 1)
	BEGIN
		SET @LastCloseDate  = (Select ISNULL(MAX(EndDate),@StartDate) from core.[Period] where AnalysisID = @AnalysisID and PeriodID <> @PeriodID and IsDeleted <> 1);
	END
	ELSE
	BEGIN
		SET @LastCloseDate  = '01/01/2000' --(Select MIN(PeriodEndDate) from cre.noteperiodiccalc where Analysisid = @AnalysisID);
	END

	----===========Import data into PeriodCloseArchive =============================================================

	--DELETE FROM [CORE].[PeriodCloseArchive] WHERE AnalysisID = @AnalysisID and CAST(PeriodEndDate as date) >= CAST(@StartDate as date) 
	--DELETE FROM [CORE].[PeriodCloseArchive] WHERE PeriodID not in (Select Distinct PeriodID from core.[Period])
	

	INSERT INTO [Core].[PeriodCloseArchive]
           ([PeriodID]
           ,[NoteID]
           ,[PeriodEndDate]
           ,[PVBasis]
           ,[DeferredFeeAccrual]
           ,[DiscountPremiumAccrual]
           ,[CapitalizedCostAccrual]
           ,[AnalysisID]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
		   ,EndingGAAPBookValue
		   ,InterestReceivedinCurrentPeriod
		   ,CurrentPeriodInterestAccrual
		   ,AllInBasisValuation)
	Select 
	@PeriodID,
	nc.NoteId,
	PeriodEndDate,
	InvestmentBasis as PVBasis,
	TotalAmortAccrualForPeriod as DeferredFeeAccrual,	--OrigFeeAccrual as DeferredFeeAccrual,
	DiscountPremiumAccrual as DiscountPremiumAccrual,
	CapitalizedCostAccrual as CapitalizedCostAccrual,
	@AnalysisID,
	@UserID,
	GETDATE(),
	@UserID,
	GETDATE(),
	EndingGAAPBookValue,
	InterestReceivedinCurrentPeriod,
	CurrentPeriodInterestAccrual,
	AllInBasisValuation
	FROM cre.NotePeriodicCalc nc
	inner join cre.Note n on n.NoteID = nc.NoteID
	WHERE  AnalysisID =@AnalysisID
	and ( CAST(PeriodEndDate as date) > CAST(@LastCloseDate as date) and CAST(PeriodEndDate as date) <= CAST(@EndDate as date))
	and [Month] is NOT NULL
	--and n.crenoteid in ('1684','2190','2279','2742','11390','12445','1873','11736')

	--CAST(PeriodEndDate as date) between CAST(@LastCloseDate as date) and CAST(@EndDate as date)
	

END
