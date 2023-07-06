

CREATE Procedure [dbo].[usp_InsertTagMaster]
@TagName NVarchar(255),
@TagDesc NVarchar(255),
@UserID NVarchar(255),
@AnalysisID UNIQUEIDENTIFIER,
@NewTagID nvarchar(256) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

DECLARE @newTagMaster  UNIQUEIDENTIFIER;
DECLARE @tTagMaster TABLE (tTagMasterId UNIQUEIDENTIFIER)

	INSERT INTO [CRE].[TagMaster]([TagName],[TagDesc],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],AnalysisID)	
	OUTPUT inserted.TagMasterID INTO @tTagMaster(tTagMasterId)
	Values(@TagName,@TagDesc,@UserID,GETDATE(),@UserID,GETDATE(),@AnalysisID)
	
SET @NewTagID = (Select tTagMasterId from @tTagMaster)

END
