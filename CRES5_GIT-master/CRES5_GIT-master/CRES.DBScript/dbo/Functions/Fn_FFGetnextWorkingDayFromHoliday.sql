CREATE FUNCTION [dbo].[Fn_FFGetnextWorkingDayFromHoliday] 
(
   @Date date,
   @HoliDayTypeID int
)
RETURNS date
AS
BEGIN
   DECLARE @Result date 

    IF EXISTS(Select * from app.HoliDays where HoliDayDate = @Date and HoliDayTypeID = @HoliDayTypeID)
				BEGIN
					IF((Select DateNAme(dw,@Date)) = 'Friday')
					   SET @Date = [dbo].[Fn_FFGetnextWorkingDayFromHoliday](DateAdd(day,-1, @Date),@HoliDayTypeID)
					ELSE
					  SET @Date = [dbo].[Fn_FFGetnextWorkingDayFromHoliday](DateAdd(day,1, @Date),@HoliDayTypeID)
				END
	
	SET @Result =  @Date;
    RETURN @Result
END
