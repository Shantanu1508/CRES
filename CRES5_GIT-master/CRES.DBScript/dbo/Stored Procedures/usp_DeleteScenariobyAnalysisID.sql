CREATE PROCEDURE [dbo].[usp_DeleteScenariobyAnalysisID]  --'80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,20,''
    @AnalysisID UNIQUEIDENTIFIER,
	@Updatedby UNIQUEIDENTIFIER
   
AS
BEGIN
	
	Update Core.Analysis
	SET
	isDeleted=1,
	UpdatedBy=@Updatedby,
	UpdatedDate=getdate()
	 where AnalysisID=@AnalysisID
	END