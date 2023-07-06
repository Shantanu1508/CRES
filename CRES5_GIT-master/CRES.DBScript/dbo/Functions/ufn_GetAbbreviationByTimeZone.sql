


-- [dbo].[ufn_GetAbbreviationByTimeZone] '2020-02-26 14:54:15.513','B0E6697B-3534-4C09-BE0A-04473401AB93'
CREATE FUNCTION [dbo].[ufn_GetAbbreviationByTimeZone] 
(
	@utcdate  datetime,
	@UserID UNIQUEIDENTIFIER = null
	
)
RETURNS nvarchar(20)
AS
BEGIN

Declare @Abbreviation as nvarchar(20), @UserSystemDate Datetime
	
	IF(@UserID='00000000-0000-0000-0000-000000000000' OR @UserID IS NULL)
	BEGIN
		IF EXISTS(SELECT cast(@utcdate as date) FROM App.TimeZoneDayLightSaving tds
							left join app.TimeZone t on t.TimeZoneID = tds.TimeZoneID
							WHERE cast(@utcdate as date) BETWEEN tds.Startdate and tds.EndDate)
		BEGIN
			SELECT @Abbreviation = t1.Abbreviation
			from [App].[TimeZone] t
			left join [App].[TimeZoneDayLightSaving] t1 on t1.TimeZoneID = t.TimeZoneID
			where  t.Name = 'Central Standard Time' 
		END
		ELSE
		BEGIN
			SELECT @Abbreviation = t.Abbreviation
			from [App].[TimeZone] t
			where t.Name = 'Central Standard Time'
		END
	END
	ELSE
	BEGIN
		IF EXISTS(SELECT cast(@utcdate as date) FROM App.TimeZoneDayLightSaving tds
							left join app.TimeZone t on t.TimeZoneID = tds.TimeZoneID
							WHERE cast(@utcdate as date) BETWEEN tds.Startdate and tds.EndDate)
		BEGIN
			SELECT @Abbreviation = ISNULL(t1.Abbreviation,t.Abbreviation)
			from [App].[TimeZone] t
			left join [App].[TimeZoneDayLightSaving] t1 on t1.TimeZoneID = t.TimeZoneID
			left join [APP].[UserEx] ux on t.Name = ux.TimeZone 
			Where ux.UserID = @UserID 
		END
		ELSE
		BEGIN
			SELECT @Abbreviation = t.Abbreviation
			from [App].[TimeZone] t
			left join [APP].[UserEx] ux on t.Name = ux.TimeZone 
			Where ux.UserID = @UserID
		END
	END
	-----------======================------------
			
    
		    Return @Abbreviation
	
END


