


create PROCEDURE [dbo].[usp_ChangeTaskStatus]  
  
AS
BEGIN
  
  Declare @InProgressTask int = (Select LookupID from core.lookup where ParentID = 59 and name ='InProgress')
  Declare @OpenTask int = (Select LookupID from core.lookup where ParentID = 59 and name ='Open')
 
  UPDATE app.task set Status =@InProgressTask  where CAST(StartDate as date) = CAst(GETDATE() as date) and Status =@OpenTask

END

