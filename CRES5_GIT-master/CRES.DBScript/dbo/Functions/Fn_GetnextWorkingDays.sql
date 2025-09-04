CREATE FUNCTION [dbo].[Fn_GetnextWorkingDays] 
(
   @Date date,
   @Days int,
   @DateType nvarchar(256)
)
RETURNS date
AS
BEGIN
   DECLARE @Result date 

    IF(@DateType = 'PMT Date') SET @DateType = 'US'
	IF(@DateType = 'Index Date') SET @DateType = 'UK'

	--Declare @HoliDayTypeID int = (Select LookupID from core.lookup where [Name] = @DateType and ParentID = 68) 
	Declare @HoliDayTypeID int = (Select HolidayMasterID from App.HolidaysMaster where CalendarName = @DateType ) 

	Declare @i int;

	IF(@Days = 0) 
	BEGIN
		SET @Result =  @Date; 
		RETURN @Result
	END

	IF(@Days > 0) 
	BEGIN
		IF((Select DateNAme(dw,@Date)) = 'Saturday')
		BEGIN
			SET @Date = DateAdd(day,1, @Date)
		END

		SET @i = 1;
		WHILE(@i <= @Days)
		BEGIN
			SET @Date = DateAdd(day,1, @Date)
			
			IF((Select DateNAme(dw,@Date)) = 'Saturday')
			BEGIN
				SET @Date = DateAdd(day,2, @Date)
			END
			IF((Select DateNAme(dw,@Date)) = 'Sunday')
			BEGIN
				SET @Date = DateAdd(day,1, @Date)
			END

			IF(@DateType is not null)
			BEGIN
				IF EXISTS(Select * from app.HoliDays where HoliDayDate = @Date and HoliDayTypeID = @HoliDayTypeID)
				BEGIN
					--commneted as it is returning 3 days forawrd date instead of 2 days if any holiday in between
					--SET @Date = DateAdd(day,1, @Date)
					SET @i = @i - 1;
				END
			END
			SET @i = @i + 1;

		END

		SET @Result =  @Date; 

	END
	IF(@Days < 0) 
	BEGIN
		IF((Select DateNAme(dw,@Date)) = 'Sunday')
		BEGIN
			SET @Date = DateAdd(day,-1, @Date)
		END
		
		SET @i = 1;
		WHILE(@i <= -@Days)
		BEGIN
			SET @Date = DateAdd(day,-1, @Date)
			
			IF((Select DateNAme(dw,@Date)) = 'Sunday')
			BEGIN
				SET @Date = DateAdd(day,-2, @Date)
			END
			IF((Select DateNAme(dw,@Date)) = 'Saturday')
			BEGIN
				SET @Date = DateAdd(day,-1, @Date)
			END

			IF(@DateType is not null)
			BEGIN
				IF EXISTS(Select * from app.HoliDays where HoliDayDate = @Date and HoliDayTypeID = @HoliDayTypeID)
				BEGIN
					--commneted as it is returning 3 days back date instead of 2 days if any holiday in between
					--ex 06/20/2025 should return 06/17/20025 but its retruns 06/16/2025
					--SET @Date = DateAdd(day,-1, @Date)
					SET @i = @i - 1;
				END
			END
			SET @i = @i + 1;

		END
		SET @Result =  @Date; 
	END



   RETURN @Result
END
