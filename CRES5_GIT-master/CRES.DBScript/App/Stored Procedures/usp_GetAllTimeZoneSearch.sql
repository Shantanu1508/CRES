
CREATE PROCEDURE [App].[usp_GetAllTimeZoneSearch]
@UserID UNIQUEIDENTIFIER,
@Search nvarchar(256)   
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	
		SELECT TimeZoneID, Name, current_utc_offset, is_currently_dst FROM [App].[TimeZone] WHERE Name LIKE '%' + @Search + '%' ORDER BY Name ASC
	


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
  
  




