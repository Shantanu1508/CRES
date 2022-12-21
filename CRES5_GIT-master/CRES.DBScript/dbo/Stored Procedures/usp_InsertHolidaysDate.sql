
CREATE PROCEDURE [dbo].[usp_InsertHolidaysDate]
	(
	 @TableHolidays [TableHolidays] READONLY,    
	 @CreatedBy uniqueidentifier
	)

AS
BEGIN
	SET NOCOUNT ON;

 DECLARE @HolidayID int = (SELECT top 1 HolidayMasterId from @TableHolidays);
 
 --------============Delete table HolidaysDate==============------    
 DELETE FROM  App.HoliDays where  HolidayTypeId = @HolidayID
 -----------=============================------------------------
 IF EXISTS(SELECT 1 from @TableHolidays WHERE HolidayDate is not null)
 BEGIN
	 INSERT INTO App.Holidays (HolidayDate,HolidayTypeId,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)
	 SELECT HolidayDate,@HolidayID,@CreatedBy,getdate(),@CreatedBy,getdate()
	 From @TableHolidays
 END

END
