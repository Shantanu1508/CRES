-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>    
-- =============================================   
CREATE PROCEDURE [dbo].[usp_DeleteTaskSubscribedUserByTaskID] 
(   
   @TaskID  nvarchar(256)  
	     
)    
     
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
 
   delete from App.TaskSubscribedUser where taskid = @TaskID
     
	 
  END
  

 
