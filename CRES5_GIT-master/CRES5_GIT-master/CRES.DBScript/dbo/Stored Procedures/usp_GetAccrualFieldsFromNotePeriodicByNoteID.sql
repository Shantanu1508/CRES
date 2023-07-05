CREATE Procedure [dbo].[usp_GetAccrualFieldsFromNotePeriodicByNoteID]  --'620d9a47-1894-4396-b2ca-d07f68109ba3','e9d71ab5-d827-4453-a8a2-b5d44f617e2c','C10F3372-0FC2-4861-A9F5-148F1F80804F'

@NoteID UNIQUEIDENTIFIER,
@UserID NVarchar(255),
@AnalysisID UNIQUEIDENTIFIER

AS

BEGIN
	SET NOCOUNT ON;	

	Declare @PeriodID UNIQUEIDENTIFIER = (Select Top 1 PeriodID from core.[Period] where IsDeleted <> 1 order by EndDate desc)

	IF EXISTS(select al.AnalysisID from Core.Analysis al
				left join Core.AnalysisParameter ap on al.AnalysisID = ap.AnalysisID
				LEFT Join Core.Lookup lCalculationMode on lCalculationMode.LookupID=ap.CalculationMode and lCalculationMode.ParentID = 79
				Where lCalculationMode.Name like '%Prospective%'
				and al.AnalysisID = @AnalysisID	)
	BEGIN
		Select 
		NoteID,
		PeriodEndDate,
		PVBasis,
		DeferredFeeAccrual,
		DiscountPremiumAccrual as DiscountPremiumAccrual,
		CapitalizedCostAccrual as CapitalizedCostAccrual,
		AllInBasisValuation as AllInBasisValuation,
		[CreatedBy],
		[CreatedDate],
		[UpdatedBy],
		[UpdatedDate]	
		FROM Core.PeriodCloseArchive
		where NoteID = @NoteID 		
		and PeriodID = @PeriodID
		order by  PeriodEndDate 
	END
	ELSE
	BEGIN
		Select 
		NoteID,
		PeriodEndDate,
		PVBasis,
		DeferredFeeAccrual,
		DiscountPremiumAccrual as DiscountPremiumAccrual,
		CapitalizedCostAccrual as CapitalizedCostAccrual,
		AllInBasisValuation as AllInBasisValuation,
		[CreatedBy],
		[CreatedDate],
		[UpdatedBy],
		[UpdatedDate]	
		FROM Core.PeriodCloseArchive
		where NoteID = @NoteID 
		and AnalysisID = @AnalysisID 	
		and PeriodID = @PeriodID
		and 1 = 0
		order by  PeriodEndDate 
	END
	

--=============================================================================================
	--Declare @ClosingDate Date = (Select ClosingDate from cre.note where noteid = @NoteID);

	--Select 
	--NoteID,
	--CLosingDate as PeriodEndDate,
	--CAst(0 as decimal) as PVBasis,
	--CAst(0 as decimal) as DeferredFeeAccrual,
	--CAst(0 as decimal) as DiscountPremiumAccrual,
	--CAst(0 as decimal) as CapitalizedCostAccrual,
	--[CreatedBy],
	--[CreatedDate],
	--[UpdatedBy],
	--[UpdatedDate]	
	--FROM cre.Note
	--where NoteID = @NoteID 

	--Declare @periodEndDate Date = (Select MAX(EndDate) from core.[Period] where IsDeleted <> 1); --AnalysisID = @AnalysisID and 
--=============================================================================================
	
END
