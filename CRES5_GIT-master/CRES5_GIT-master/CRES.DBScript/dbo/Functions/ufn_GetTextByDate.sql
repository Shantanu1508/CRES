
---  [dbo].[ufn_GetTextByDate] '2020-05-05 05:55:04.547','80BF77B4-3A8D-4E4D-98B9-0146DEF6F0FE'

CREATE FUNCTION [dbo].[ufn_GetTextByDate] 
(
	@CreatedDate  datetime,
	@UserID nvarchar(256)
)
RETURNS nvarchar(256)
AS
BEGIN
	DECLARE @TodayDate datetime = (SELECT CAST(GetDate() as date));
	DECLARE @Result nvarchar(256);
	
	IF(CAST(@CreatedDate as date)=  @TodayDate)
	BEGIN 
		set @Result =  'Today'
		
	END

	ELSE IF(DATEDIFF(DAY, CAST(@CreatedDate as date), cast(@TodayDate as date))=1)
	BEGIN
		set @Result =  'Yesterday'
		
	END

	ELSE IF(DATEDIFF(DAY, CAST(@CreatedDate as date), cast(@TodayDate as date))>1)
	BEGIN
		set @Result =  'Past'
	END
	
	RETURN @Result
END

