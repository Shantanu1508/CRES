CREATE PROCEDURE [App].[CheckUserIsACtive]   
@UserId nvarchar(256)  
AS  
BEGIN  

Select StatusID from App.[User] where UserId= @UserId

END