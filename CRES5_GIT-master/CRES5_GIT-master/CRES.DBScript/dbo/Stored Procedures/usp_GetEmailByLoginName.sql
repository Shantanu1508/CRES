-- Procedure

 CREATE PROCEDURE [dbo].[usp_GetEmailByLoginName]  -- 'admin_qa'
   @LoginName nvarchar(50)  
as
BEGIN
	 
	 select Email from app.[User] where login =@LoginName
end




 
 
