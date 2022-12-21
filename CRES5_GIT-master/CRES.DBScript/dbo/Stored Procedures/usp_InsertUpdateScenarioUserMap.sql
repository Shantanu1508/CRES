



CREATE PROCEDURE [dbo].[usp_InsertUpdateScenarioUserMap]
(
	@AnalysisID   uniqueidentifier,
	@UserID  nvarchar(256) 
)
  
AS
BEGIN
  SET NOCOUNT ON;  



	Update CORE.ScenarioUserMap	
	set AnalysisID = @AnalysisID,
	UpdatedBy = @UserID,
	UpdatedDate = getdate()
	where UserID = @UserID


	IF @@ROWCOUNT = 0 
	BEGIN
		INSERT INTO [Core].[ScenarioUserMap]([AnalysisID],[UserID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])     
		VALUES (@AnalysisID,@UserID,@UserID,getdate(),@UserID,getdate())
	END 
		   

			
END


