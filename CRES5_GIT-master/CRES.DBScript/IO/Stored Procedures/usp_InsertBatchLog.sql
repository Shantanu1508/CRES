


CREATE PROCEDURE [IO].[usp_InsertBatchLog] 
(
	@BatchTypeID	[int] = NULL,
	@StartedByUserID	[uniqueidentifier] = NULL,
	@UserName	[nvarchar](256) = NULL,

	@outBatchLogID uniqueidentifier OUTPUT  
)
AS 
BEGIN

DECLARE @BatchLog_BatchLogID uniqueidentifier;

DECLARE @tBatchLog TABLE (tBatchLogID UNIQUEIDENTIFIER)
	INSERT INTO [IO].[BatchLog]
           ([BatchTypeID]
           ,[StartTime]
           ,[EndTime]
           ,[StartedByUserID]
           ,[ErrorMessage]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])

	OUTPUT inserted.BatchLogID INTO @tBatchLog(tBatchLogID)

     VALUES
		(@BatchTypeID,
		GETDATE(),
		NULL,
		@StartedByUserID,
		NULL,
		@UserName,
		GETDATE(),
		@UserName,
		GETDATE())
 

 SELECT @outBatchLogID = tBatchLogID FROM @tBatchLog;
 

END



