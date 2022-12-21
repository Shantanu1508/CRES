------------------------------------------------------------
-- Author:		<NewCon Infosystem>
-- Create date: <11/05/2012>
------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_CheckDataWareHouseStatus] 
 @currentTime nvarchar(50),
 @UserID UNIQUEIDENTIFIER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	 

select top 2 
 dbo.ufn_GetUserNotificationTime(@currentTime,BatchStartTime) as BatchStartTime,
 --dbo.ufn_GetUserNotificationTime(@currentTime,BatchEndTime) as BatchEndTime,
 convert(nvarchar,[dbo].[ufn_GetTimeByTimeZone](getutcdate() , @UserID),100) as BatchEndTime,
 Status2  
 from DW.BatchLog order by BatchLogId desc


 
END

