-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>    

--usp_InsertTaskSubscribedUser 'aafce9c2-b3ae-4d6d-b194-4eca7d9c6942','82c09c31-fa74-48df-a7d9-4730e9dffe90','45696c0f-a73d-4f2d-afbf-ccaa7718a707'
-- =============================================   
Create PROCEDURE [dbo].[usp_InsertTaskSubscribedUser] 
(   
        
		@TaskID  uniqueidentifier, 		 
	    @UserID   uniqueidentifier, 	
		@username   nvarchar(256)
		 
)    
     
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
 

 
    Insert into App.TaskSubscribedUser
    (    
	     
[TaskID]
 ,[UserId]
,CreatedBy
,CreatedDate
,UpdatedBy
,UpdatedDate
  
    )      
   
    values    
    (    
 
			@TaskID	 ,
			@UserID,			 		 
			@username ,    
			getdate(),    
			@username,    
			getdate()    
     )    

	 
  END
  

 
--select * from App.TaskSubscribedUser
