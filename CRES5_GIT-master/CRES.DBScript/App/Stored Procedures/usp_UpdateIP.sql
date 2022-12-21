--Select * from App.[User]

 --[App].[usp_UpdateIP]  'b0e6697b-3534-4c09-be0a-04473401ab93','admin_qa','157.34.253.245'
Create PROCEDURE [App].[usp_UpdateIP] 
(
	@UserID UNIQUEIDENTIFIER,
	@UserLogin VARCHAR(256),
	@IPAddress VARCHAR(256)
)	
AS
BEGIN
   --SET NOCOUNT ON;

--Delete Firewall
EXECUTE sp_delete_database_firewall_rule @name = N@UserLogin   

EXECUTE sp_set_database_firewall_rule
@name =N@UserLogin ,
@start_ip_address = @IPAddress,
@end_ip_address = @IPAddress


UPDATE App.[User] SET [IP] = @IPAddress WHERE UserID = @UserID 



END
