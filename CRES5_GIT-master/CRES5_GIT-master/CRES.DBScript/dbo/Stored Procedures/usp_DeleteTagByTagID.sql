

CREATE Procedure [dbo].[usp_DeleteTagByTagID]
	@UserID NVarchar(255),
	@AnalysisID UNIQUEIDENTIFIER,
	@TagMasterID UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;


	Update cre.TagMaster set IsDeleted = 1 where TagMasterID =  @TagMasterID and AnalysisID= @AnalysisID	

	--Delete from cre.TagMaster where TagMasterID =  @TagMasterID	
	--Delete from cre.TransactionEntryClose where TagMasterID =  @TagMasterID

END

