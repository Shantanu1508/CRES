-- [dbo].[usp_GetwarehouseStatus] 'Refresh Data Warehouse' 
CREATE PROCEDURE [dbo].[usp_GetwarehouseStatus]  
(  
    @ButtonName nvarchar(256)  
   --@UserID UNIQUEIDENTIFIER  null  
)  
AS  
BEGIN   
  
Declare @BatchName nvarchar(256);  
  
IF(@ButtonName = 'Refresh Data Warehouse')  
BEGIN  
 SET @BatchName = 'Delta Refresh Process'  
END  
  
IF(@ButtonName = 'Refresh Backshop Data')  
BEGIN  
 SET @BatchName = 'Refresh From Backshop'  
END  
 IF(@ButtonName = 'Refresh Entity Data')  
BEGIN  
 SET @BatchName = 'Refresh Entity Data'  
END  
  
Select top 1 Status2, dbo.[ufn_GetTimeByTimeZone](BatchEndTime,'00000000-0000-0000-0000-000000000000')as BatchEndTime    
from dw.batchlog where   
BatchName =  @BatchName 
order by batchlogid desc  
  
END
GO

