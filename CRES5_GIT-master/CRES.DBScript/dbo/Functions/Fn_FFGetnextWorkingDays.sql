CREATE FUNCTION [dbo].[Fn_FFGetnextWorkingDays] 
(
   @Date date,
   @DateType nvarchar(256)
)
RETURNS date
AS
BEGIN
   DECLARE @Result date 

   IF(@DateType = 'PMT Date') SET @DateType = 'US'
   IF(@DateType = 'Index Date') SET @DateType = 'UK'


	IF((Select DateNAme(dw,@Date)) = 'Saturday')
		BEGIN
			SET @Date = [dbo].[Fn_FFInnerGetnextWorkingDays](@Date,-1,@DateType)
		END
	ELSE IF((Select DateNAme(dw,@Date)) = 'Sunday')
		BEGIN
			SET @Date = [dbo].[Fn_FFInnerGetnextWorkingDays](@Date,+1,@DateType)
		END
    ELSE
	BEGIN
			SET @Date = [dbo].[Fn_FFGetnextWorkingDayFromHoliday](@Date,411)
			IF((Select DateNAme(dw,@Date)) = 'Saturday')
		BEGIN
			SET @Date = [dbo].[Fn_FFInnerGetnextWorkingDays](@Date,-1,@DateType)
		END
	ELSE IF((Select DateNAme(dw,@Date)) = 'Sunday')
		BEGIN
			SET @Date = [dbo].[Fn_FFInnerGetnextWorkingDays](@Date,+1,@DateType)
		END
	END
	
	SET @Result =  @Date;
    RETURN @Result
END
