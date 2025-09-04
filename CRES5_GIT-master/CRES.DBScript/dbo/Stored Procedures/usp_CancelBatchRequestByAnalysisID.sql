
---[dbo].[usp_CancelBatchRequestByAnalysisID] 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

CREATE PROCEDURE [dbo].[usp_CancelBatchRequestByAnalysisID] --'C10F3372-0FC2-4861-A9F5-148F1F80804F'
(
	@AnalysisID UNIQUEIDENTIFIER
)
	
AS
BEGIN 
 

	--Declare @CalculationRequestsHistory as table (
	--[CalculationRequestID] UNIQUEIDENTIFIER NULL,
 --   [NoteId]               UNIQUEIDENTIFIER NOT NULL,
 --   [RequestTime]          DATETIME         NULL,
 --   [StatusID]             INT              NULL,
 --   [UserName]             NVARCHAR (MAX)   NULL,
 --   [ApplicationID]        INT              NULL,
 --   [StartTime]            DATETIME         NULL,
 --   [EndTime]              DATETIME         NULL,
 --   [ServerName]           NVARCHAR (256)   NULL,
 --   [PriorityID]           INT              NULL,
 --   [ErrorMessage]         NVARCHAR (MAX)   NULL,
 --   [ErrorDetails]         NVARCHAR (MAX)   NULL,
 --   [ServerIndex]          INT              NULL,
 --   [AnalysisID]           UNIQUEIDENTIFIER NULL,
 --   [CalculationModeID]    INT              NULL,
 --   [CalcBatch]            UNIQUEIDENTIFIER NULL,
 --   [NumberOfRetries]      INT              NULL,
 --   [DealID] UNIQUEIDENTIFIER  NULL,
 --   [RequestID] nvarchar(256)  NULL,
 --   CalcType int null
	--);

	--INSERT INTO @CalculationRequestsHistory(CalculationRequestID,	NoteId,	RequestTime,	StatusID,	UserName,	ApplicationID,	StartTime,	EndTime,	ServerName,	PriorityID,	ErrorMessage,	ErrorDetails,	ServerIndex,	AnalysisID,	CalculationModeID,	CalcBatch,	NumberOfRetries,	DealID,	RequestID,	CalcType	)
	--Select 	CalculationRequestID,	n.NoteId,	RequestTime,	StatusID,	UserName,	ApplicationID,	StartTime,	EndTime,	ServerName,	PriorityID,	ErrorMessage,	ErrorDetails,	ServerIndex,	AnalysisID,	CalculationModeID,	CalcBatch,	NumberOfRetries,	cr.DealID,	RequestID,	CalcType 	
	--from [Core].[CalculationRequests] cr
	--Inner Join cre.note n on n.Account_AccountID = cr.AccountId


    

	--------Main Cancel Script-------------
	select distinct requestid from Core.CalculationRequests WHERE CalcType <> 776 and  AnalysisID = @AnalysisID  and requestid is not null
	
	
	--Delete from [Core].[CalculationQueueRequest] where requestid in (Select requestid from Core.CalculationRequests  WHERE CalcType <> 776 and AnalysisID = @AnalysisID)	
	--Delete from Core.CalculationRequests  WHERE CalcType <> 776 and AnalysisID = @AnalysisID
	
	--select distinct requestid from Core.CalculationRequests where StatusID not in (266,265)  
	--update Core.CalculationRequests set  StatusID =736   --where AnalysisID=@AnalysisID  
	------------------------------------------
	--Declare @BatchID int = 0;
	--SET @BatchID = (Select ISNULL(MAX(BatchID),0) from [Core].[CalculationRequestsHistory] )

	--INSERT INTO [Core].[CalculationRequestsHistory](BatchID,BatchDate,CalculationRequestID,	NoteId,	RequestTime,	StatusID,	UserName,	ApplicationID,	StartTime,	EndTime,	ServerName,	PriorityID,	ErrorMessage,	ErrorDetails,	ServerIndex,	AnalysisID,	CalculationModeID,	CalcBatch,	NumberOfRetries,	DealID,	RequestID,	CalcType	)
	--Select 	(@BatchID + 1) as BatchID,getdate() as BatchDate,CalculationRequestID,	NoteId,	RequestTime,	StatusID,	UserName,	ApplicationID,	StartTime,	EndTime,	ServerName,	PriorityID,	ErrorMessage,	ErrorDetails,	ServerIndex,	AnalysisID,	CalculationModeID,	CalcBatch,	NumberOfRetries,	DealID,	RequestID,	CalcType 	
	--from @CalculationRequestsHistory

	

END

 