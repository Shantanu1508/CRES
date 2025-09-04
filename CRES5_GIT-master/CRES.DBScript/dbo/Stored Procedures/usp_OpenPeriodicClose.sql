
CREATE Procedure [dbo].[usp_OpenPeriodicClose]
@UserID NVarchar(255),
@PeriodIDs NVarchar(max),
@AnalysisID uniqueidentifier

AS

BEGIN
	SET NOCOUNT ON;
	Set @AnalysisID = (Select AnalysisID from core.Analysis where Name = 'Default')
	BEGIN TRY
	BEGIN TRAN
		UPDATE core.[AccountingCloseTransationArchive] SET IsDeleted=1 WHERE PeriodID in 
		(
		  select value from dbo.fn_Split(@PeriodIDs)
		)
		and AnalysisID=@AnalysisID


		UPDATE core.AccountingClosePeriodicArchive SET IsDeleted=1 WHERE PeriodID in 
		(
		  select value from dbo.fn_Split(@PeriodIDs)
		)
		and AnalysisID=@AnalysisID


	
		UPDATE core.Period SET IsDeleted=1 WHERE periodID in 
		(
		  select value from dbo.fn_Split(@PeriodIDs)
		)
		and AnalysisID=@AnalysisID

		--Hard delete auto-generated tag
		Update cre.TagMaster set StatusID = 2 where PeriodID is not null and PeriodID in (select value from dbo.fn_Split(@PeriodIDs))

	COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK
	END CATCH
	
END
