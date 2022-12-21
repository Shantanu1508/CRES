-- Procedure
  
  --[usp_CheckDuplicateIPAddress] '157.34.76.204'
CREATE PROCEDURE [DBO].[usp_CheckDuplicateIPAddress]  
(
@UserID uniqueidentifier,
 @IPAddress nvarchar(256)  
    
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
Declare @IsExist bit = 0;  
  
IF EXISTS(Select * from App.[User]  where IP = @IPAddress and UserID!=@UserID)  
BEGIN  
  SET @IsExist = 1;  
END  
   
select @IsExist  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END