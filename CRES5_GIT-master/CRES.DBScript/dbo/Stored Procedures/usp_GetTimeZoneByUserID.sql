

-- [App].[usp_GetTimeZoneByUserID] 'B0E6697B-3534-4C09-BE0A-04473401AB93'
CREATE PROCEDURE [dbo].[usp_GetTimeZoneByUserID] 
@UserID UNIQUEIDENTIFIER,
@DelegateUserID uniqueidentifier = null
   
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	
    SELECT TimeZoneID, Name, current_utc_offset, is_currently_dst, [dbo].[ufn_GetAbbreviationByTimeZone](getdate(),@UserID) as Abbreviation
	FROM [App].[TimeZone] t 
	left join app.[userex] uex on uex.TimeZone = t.Name
	left join app.[user] u on u.UserID = uex.UserID
	WHERE u.UserID = @UserID


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
  
  




