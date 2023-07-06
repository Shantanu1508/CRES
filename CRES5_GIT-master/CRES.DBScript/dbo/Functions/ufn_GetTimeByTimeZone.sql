--[dbo].[ufn_GetTimeByTimeZone]'2020-05-05 05:55:04.547',null
-- [dbo].[ufn_GetTimeByTimeZone]'2020-05-05 05:55:04.547','00000000-0000-0000-0000-000000000000'
CREATE FUNCTION [dbo].[ufn_GetTimeByTimeZone] --'2020-05-05 05:55:04.547','80BF77B4-3A8D-4E4D-98B9-0146DEF6F0FE'
(
	@utcdate  datetime,
	@UserID UNIQUEIDENTIFIER = null 
)
RETURNS datetime
AS
BEGIN
DECLARE  @Result datetime, @sign int =1, @hh int, @mm int
Declare @utcoffset as nvarchar(256), @UserSystemDate Datetime
	
	IF(@UserID='00000000-0000-0000-0000-000000000000' OR @UserID IS NULL)
	BEGIN
		IF EXISTS(SELECT cast(getdate() as date) FROM App.TimeZoneDayLightSaving tds
							left join app.TimeZone t on t.TimeZoneID = tds.TimeZoneID
							WHERE cast(getdate() as date) BETWEEN tds.Startdate and tds.EndDate)
		BEGIN
			SELECT @utcoffset = t1.current_utc_offset
			from [App].[TimeZone] t
			left join [App].[TimeZoneDayLightSaving] t1 on t1.TimeZoneID = t.TimeZoneID
			where  t.Name = 'Central Standard Time' --and t1.TimeZoneID = t.timeZoneID
		END
		ELSE
		BEGIN
			SELECT @utcoffset = t.current_utc_offset
			from [App].[TimeZone] t
			where t.Name = 'Central Standard Time'
		END
	END
	ELSE
	BEGIN
		IF EXISTS(SELECT cast(getdate() as date) FROM App.TimeZoneDayLightSaving tds
							left join app.TimeZone t on t.TimeZoneID = tds.TimeZoneID
							WHERE cast(getdate() as date) BETWEEN tds.Startdate and tds.EndDate)
		BEGIN
			SELECT @utcoffset = ISNULL(t1.current_utc_offset,t.current_utc_offset)
			from [App].[TimeZone] t
			left join [App].[TimeZoneDayLightSaving] t1 on t1.TimeZoneID = t.TimeZoneID
			left join [APP].[UserEx] ux on t.Name = ux.TimeZone 
			Where ux.UserID = @UserID 
		END
		ELSE
		BEGIN
			SELECT @utcoffset = t.current_utc_offset
			from [App].[TimeZone] t
			left join [APP].[UserEx] ux on t.Name = ux.TimeZone 
			Where ux.UserID = @UserID
		END
	END
	-----------======================------------
			IF(SUBSTRING(@utcoffset,1,1)='-')
				SET @sign =-1;

			SET @hh = CAST(SUBSTRING(@utcoffset,2,2) as int);
			SET @mm = CAST(SUBSTRING(@utcoffset,5,2) as int);
			SET @mm = (@sign*(@hh*60+@mm));
			SET @Result = (SELECT DATEADD(minute,@mm,@utcdate)); 
    
		    RETURN @Result
	
END


