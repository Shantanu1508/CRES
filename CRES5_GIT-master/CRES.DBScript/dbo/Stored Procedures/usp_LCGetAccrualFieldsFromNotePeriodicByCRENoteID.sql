CREATE Procedure [dbo].[usp_LCGetAccrualFieldsFromNotePeriodicByCRENoteID]  --'2307' ,''
(
@CRENoteID nvarchar(256),
@AnalysisName nvarchar(256)
)
AS

BEGIN
	SET NOCOUNT ON;
    
	Declare @NoteID UNIQUEIDENTIFIER = (select noteid from cre.note where crenoteid =@CRENoteID);
	Declare @AnalysisID UNIQUEIDENTIFIER = (select AnalysisID from  Core.Analysis where [name] = @AnalysisName);
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
		AllInBasisValuation as AllInBasisValuation		
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
		AllInBasisValuation as AllInBasisValuation		 
		FROM Core.PeriodCloseArchive
		where NoteID = @NoteID 
		and AnalysisID = @AnalysisID 	
		and PeriodID = @PeriodID
		and 1 = 0
		order by  PeriodEndDate 
	END
	
END

 
