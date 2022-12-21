-- Procedure
CREATE PROCEDURE [App].[usp_UpdateIP]   
(  
 @UserID UNIQUEIDENTIFIER,  
 @UserLogin NVARCHAR(256),  
 @IPAddress VARCHAR(256)  
)   
AS  
BEGIN  
   --SET NOCOUNT ON;  
  
--Delete Firewall  
EXECUTE sp_delete_database_firewall_rule @name = N@UserLogin     

EXECUTE sp_set_database_firewall_rule 
  @UserLogin
,@IPAddress
,@IPAddress;

--EXECUTE sp_set_database_firewall_rule  
--@name = ''N'' + '''' @UserLogin ,--N'test',  
--@start_ip_address = @IPAddress,  
--@end_ip_address = @IPAddress  
  
  
UPDATE App.[User] SET [IP] = @IPAddress WHERE UserID = @UserID   
  
  
  
END