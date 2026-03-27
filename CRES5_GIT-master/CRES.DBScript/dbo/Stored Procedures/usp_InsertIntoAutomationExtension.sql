CREATE PROCEDURE [dbo].[usp_InsertIntoAutomationExtension] -- 1,'0C449307-37AC-4073-BAFB-BD78E5FD3801',1,'rtest','dd','msingh'
(  
		@AutomationRequestsID int ,
		@DealID varchar(256) ,
		@BatchID int,
		@ErrorMessage NVARCHAR (MAX)   ,
		@Message NVARCHAR (MAX)   , 
		@CreatedBy varchar(256) ,
		@PurposeType NVARCHAR(256) ,
		@Amount  decimal(28,15),
		@Date datetime,
		@DealFundingID varchar(256) =null

	 
 )
AS  
BEGIN  
    SET NOCOUNT ON; 

  INSERT INTO Core.AutomationExtension
           (
		[AutomationRequestsID]
      ,[DealID]
      ,[BatchID]
      ,[ErrorMessage]
      ,[Message]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
	  ,DealFundingID
	  ,PurposeType
	  ,Amount
	  ,Date
		   )
     VALUES
           (
			@AutomationRequestsID
			,@DealID
			,@BatchID
			,@ErrorMessage
			,@Message
			,@CreatedBy
			,GETDATE()
			,@CreatedBy
			,GETDATE()
		   ,@DealFundingID
		   ,@PurposeType
		   ,@Amount
		   ,@Date
		   )
END
