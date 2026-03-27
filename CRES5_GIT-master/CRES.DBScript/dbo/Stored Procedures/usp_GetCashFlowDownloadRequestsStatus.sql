CREATE PROCEDURE [dbo].[usp_GetCashFlowDownloadRequestsStatus] 
@AnalysisID  nvarchar(256), 
@UserName  nvarchar(256)
 
AS
BEGIN

SET NOCOUNT ON;		
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

select * from [Core].[CashFlowDownloadRequests]
where CashFlowDownloadRequestsID =(
 select Max(CashFlowDownloadRequestsID) from [Core].[CashFlowDownloadRequests] 
 where AnalysisID =@AnalysisID and 
 CreatedBy=@UserName
)
 
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END
GO

