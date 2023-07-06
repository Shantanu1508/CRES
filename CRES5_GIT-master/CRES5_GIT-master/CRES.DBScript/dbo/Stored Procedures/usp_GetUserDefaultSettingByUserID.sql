

 
CREATE PROCEDURE [dbo].[usp_GetUserDefaultSettingByUserID] --'B55D8909-25EF-4778-8756-6997E33AD9F5'
@UserID uniqueidentifier 
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT uds.[UserDefaultSettingID]
      ,uds.[UserID]
      ,uds.[Type]
	  ,l.Name as TypeText
      ,uds.[Value]
      ,uds.[CreatedBy]
      ,uds.[CreatedDate]
      ,uds.[UpdatedBy]
      ,uds.[UpdatedDate]
  FROM [App].[UserDefaultSetting] uds
  LEFT JOIN [Core].[Lookup] l ON l.LookupID = uds.[Type] and l.ParentID = 55
  Where UserID = @UserID

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
