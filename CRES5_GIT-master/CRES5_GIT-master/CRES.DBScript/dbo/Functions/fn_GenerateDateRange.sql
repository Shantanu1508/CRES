
CREATE FUNCTION [dbo].[fn_GenerateDateRange]
(@StartDate AS DATE,
 @EndDate AS   DATE,
 @Interval AS  INT,
 @IntervalForDayOrMonth as nvarchar(256)
)
RETURNS @Dates TABLE(DateValue DATE)
AS
BEGIN
    DECLARE @CUR_DATE DATE
    SET @CUR_DATE = @StartDate
    WHILE @CUR_DATE <= @EndDate 
	BEGIN
        INSERT INTO @Dates VALUES(@CUR_DATE)
		IF(@IntervalForDayOrMonth = 'day')
		BEGIN
			SET @CUR_DATE = DATEADD(DAY, @Interval, @CUR_DATE)
		END
		IF(@IntervalForDayOrMonth = 'month')
		BEGIN
			SET @CUR_DATE = DATEADD(month, @Interval, @CUR_DATE)
		END
        
    END
    RETURN;
END;
