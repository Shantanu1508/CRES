CREATE FUNCTION [dbo].[ufn_GetTimeByTimeZoneName] --'2020-05-05 05:55:04.547','80BF77B4-3A8D-4E4D-98B9-0146DEF6F0FE'
(
	@utcdate  datetime,
	@TimeZoneName nvarchar(250)
)
RETURNS datetime
AS
BEGIN
		DECLARE  @Result datetime, @sign int =1, @hh int, @mm int
		Declare @utcoffset as nvarchar(256), @UserSystemDate Datetime
		IF EXISTS(SELECT cast(getdate() as date) FROM App.TimeZoneDayLightSaving tds
							left join app.TimeZone t on t.TimeZoneID = tds.TimeZoneID
							WHERE cast(getdate() as date) BETWEEN tds.Startdate and tds.EndDate)
		BEGIN
			SELECT @utcoffset = ISNULL(t1.current_utc_offset,t.current_utc_offset)
			from [App].[TimeZone] t
			left join [App].[TimeZoneDayLightSaving] t1 on t1.TimeZoneID = t.TimeZoneID
		    where t.name=@TimeZoneName
		END
		ELSE
		BEGIN
			SELECT @utcoffset = t.current_utc_offset
			from [App].[TimeZone] t
			where t.name=@TimeZoneName
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

