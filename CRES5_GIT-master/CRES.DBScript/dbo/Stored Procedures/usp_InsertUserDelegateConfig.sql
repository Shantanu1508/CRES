CREATE Procedure [dbo].[usp_InsertUserDelegateConfig]  
	@userID UNIQUEIDENTIFIER,  
	@delegatedUserID UNIQUEIDENTIFIER,  
	@startdate [date],  
	@enddate [date]  
AS  
BEGIN  
 SET NOCOUNT ON;   
  
 INSERT INTO  [App].[UserDelegateConfig]  
 (  
  UserID ,  
  DelegatedUserID,   
  Startdate ,  
  Enddate ,  
  IsActive,  
  CreatedBy  , 
  CreatedDate  ,  
  UpdatedBy,
  UpdatedDate  
 )   
   
 Values(  
   @userID ,  
   @delegatedUserID,   
   @startdate ,  
   @enddate ,  
   1,  
   @userID,
   GETDATE(), 
   @userID,
   GETDATE()
 )   
  
END
