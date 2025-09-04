CREATE PROCEDURE [dbo].[usp_QueueSingleDealForAutomation]   
 @DealID nvarchar(256),
 @AutomationType int,
 @CreatedBy nvarchar(256),  
 @BatchType nvarchar(256),
 @BatchID int
AS  
BEGIN        
      
 SET NOCOUNT ON;        
    
 
	 INSERT INTO [Core].[AutomationRequests] 
	(
		[DealID],
		[RequestTime],
		[StatusID],
		AutomationType,
		CreatedBy,
		CreatedDate,
		UpdatedBy,
		UpdatedDate,
		BatchType,
		BatchID
	) 
	values (
		@DealID
		,getdate()
		,292
		,@AutomationType
		,@CreatedBy
		,getdate(),
		@CreatedBy,
		getdate(),
		@BatchType,
		@BatchID
	) 
  
  
  
END  