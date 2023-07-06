-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>    
-- =============================================   
CREATE PROCEDURE [dbo].[usp_InsertTaskActivity] 
(   


		@TaskID  nvarchar(256), 		 
		@ActivityType int,
		@Displaymessage  nvarchar(max),
		@username   nvarchar(256)
		 
)    
     
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
 

 
    Insert into App.TaskActivity
    (    
	     
TaskID
,ActivityDate
,ActivityType
,Displaymessage
,CreatedBy
,CreatedDate
,UpdatedBy
,UpdatedDate
  
    )      
   
    values    
    (    
 
			@TaskID	 ,
			GETDATE() ,
			@ActivityType	 ,
			@Displaymessage	 ,			 
			@username ,    
			getdate(),    
			@username,    
			getdate()    
     )    

	 
  END
  

 
