-- Procedure
-- Procedure
CREATE PROCEDURE [dbo].[usp_GetUserPreferenceByUserID]  
@UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

	Select [UserID]
	,ParentModuleName 
	,ModuleType
	,ModuleName	
	,HTMLTagID
	,IsActive
	,[CreatedBy]
	,[CreatedDate]
	,[UpdatedBy]
	,[UpdatedDate]
	From [App].[UserPreference]
	Where UserId = @UserId



END