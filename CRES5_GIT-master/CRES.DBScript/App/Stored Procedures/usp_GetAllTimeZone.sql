

-- [App].[usp_GetAllTimeZone] 'B0E6697B-3534-4C09-BE0A-04473401AB93'

CREATE PROCEDURE [App].[usp_GetAllTimeZone] 
@UserID UNIQUEIDENTIFIER
   
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	
    SELECT TimeZoneID, Name, current_utc_offset, is_currently_dst, [dbo].[ufn_GetAbbreviationByTimeZone](getdate(),@UserID) as Abbreviation
	FROM [App].[TimeZone] ORDER BY Name ASC


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
  
  




