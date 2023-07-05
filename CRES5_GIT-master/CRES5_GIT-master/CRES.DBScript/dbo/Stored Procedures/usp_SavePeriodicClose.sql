CREATE Procedure [dbo].[usp_SavePeriodicClose]
@StartDate Date,
@EndDate Date,
@AzureBlobLink NVarchar(max),
@UserID NVarchar(255),
@AnalysisID uniqueidentifier 

AS

BEGIN

	SET NOCOUNT ON;

	--get default analysisid
	select @AnalysisID = AnalysisID from core.Analysis where Name='Default'
	--DELETE FROM [Core].[Period] WHERE AnalysisID = @AnalysisID and  Cast(StartDate as date) >= Cast(@StartDate as date)

	DECLARE @tperiod TABLE (tperiodId UNIQUEIDENTIFIER)

	INSERT INTO [Core].[Period] (StartDate,EndDate,AzureBlobLink,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,AnalysisID)
	OUTPUT inserted.PeriodID INTO @tperiod(tperiodId)
	VALUES(@StartDate,@EndDate,@AzureBlobLink,@UserID,GETDATE(),@UserID,GETDATE(),@AnalysisID)

	Declare @PeriodID UNIQUEIDENTIFIER;
	SELECT @PeriodID = tperiodId FROM @tperiod;

	Select @PeriodID as PeriodID


END
