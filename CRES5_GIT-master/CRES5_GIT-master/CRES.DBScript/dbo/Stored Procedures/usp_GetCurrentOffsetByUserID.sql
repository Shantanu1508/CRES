
-- [dbo].[usp_GetCurrentOffsetByUserID]'B0E6697B-3534-4C09-BE0A-04473401AB93'
CREATE PROCEDURE [dbo].[usp_GetCurrentOffsetByUserID]
@UserID UNIQUEIDENTIFIER
   
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	

    IF EXISTS(SELECT cast(getdate() as date) FROM App.TimeZoneDayLightSaving tds
							left join app.TimeZone t on t.TimeZoneID = tds.TimeZoneID
							WHERE cast(getdate() as date) BETWEEN tds.Startdate and tds.EndDate)
		BEGIN
			SELECT top 1 ISNULL(t1.current_utc_offset,t.current_utc_offset) as currentoffset
			from [App].[TimeZone] t
			left join [App].[TimeZoneDayLightSaving] t1 on t1.TimeZoneID = t.TimeZoneID
			left join [APP].[UserEx] ux on t.Name = ux.TimeZone 
			Where ux.UserID = @UserID 
		END
		ELSE
		BEGIN
			SELECT  t.current_utc_offset as currentoffset
			from [App].[TimeZone] t
			left join [APP].[UserEx] ux on t.Name = ux.TimeZone 
			Where ux.UserID = @UserID
		END


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
  

