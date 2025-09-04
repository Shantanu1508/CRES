CREATE PROCEDURE [dbo].[usp_UpdateStatusCashFlowDownloadRequests] 
@AnalysisID  nvarchar(256),
@CashFlowDownloadRequestsID int, 
@StatusText nvarchar(256),
@ColumnName nvarchar(256),
@ErrorMessage nvarchar(MAX),
@UserName  nvarchar(256)
 
AS
BEGIN

SET NOCOUNT ON;		
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

IF(@ColumnName = 'EndTime')
BEGIN

	update [Core].[CashFlowDownloadRequests] set 
	StatusText = @StatusText,
	EndTime = getdate() ,
	ErrorMessage=@ErrorMessage,
	UpdatedBy = @UserName,
	UpdatedDate = getdate()
	where CashFlowDownloadRequestsID =@CashFlowDownloadRequestsID and AnalysisID=@AnalysisID
END


IF(@ColumnName = 'StartTime')
BEGIN
	update [Core].[CashFlowDownloadRequests] set 
	StatusText = @StatusText,
	StartTime = getdate() ,	
	UpdatedBy = @UserName,
	UpdatedDate = getdate()
	where CashFlowDownloadRequestsID =@CashFlowDownloadRequestsID and AnalysisID=@AnalysisID
END

 SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END
GO

