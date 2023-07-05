


CREATE PROCEDURE [IO].[usp_InsertBatchDetail] 
(

@BatchLogID uniqueidentifier,
@SourceTableName	[nvarchar](256) =NULL,
@SourceRecordCount	[int] =NULL,
@SourceCheckSumValue	[bigint] =NULL,
@SourceStartTime	[datetime] =NULL,
@SourceEndTime	[datetime] =NULL,
@SourceErrorMessage	[text] =NULL,
@DestinationTableName	[nvarchar](256) =NULL,
@DestinationTableRecordCount	[int] =NULL,
@DestinationTableCheckSumValue	[bigint] =NULL,
@DestinationTableStartTime	[datetime] =NULL,
@DestinationTableEndTime	[datetime] =NULL,
@DestinationTableErrorMessage	[text] =NULL,
@CreatedBy	[nvarchar](256) = NULL,
@CreatedDate	[datetime] = NULL,
@UpdatedBy	[nvarchar](256) = NULL,
@UpdatedDate	[datetime] = NULL

)
AS 
BEGIN

 

	INSERT INTO [IO].[BatchDetail]
           ([BatchLog_BatchLogID]
           ,[SourceTableName]
           ,[SourceRecordCount]
           ,[SourceCheckSumValue]
           ,[SourceStartTime]
           ,[SourceEndTime]
           ,[SourceErrorMessage]
           ,[DestinationTableName]
           ,[DestinationTableRecordCount]
           ,[DestinationTableCheckSumValue]
           ,[DestinationTableStartTime]
           ,[DestinationTableEndTime]
           ,[DestinationTableErrorMessage]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
		VALUES
			(@BatchLogID,
			@SourceTableName,
			@SourceRecordCount,
			@SourceCheckSumValue,
			@SourceStartTime,
			@SourceEndTime,
			@SourceErrorMessage,
			@DestinationTableName,
			@DestinationTableRecordCount,
			@DestinationTableCheckSumValue,
			@DestinationTableStartTime,
			@DestinationTableEndTime,
			@DestinationTableErrorMessage,
			@CreatedBy,
			@CreatedDate,
			@UpdatedBy,
			@UpdatedDate
			)


END



