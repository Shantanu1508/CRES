CREATE PROCEDURE [dbo].[usp_InsertIntoCashFlowDownloadRequests] -- 'c10f3372-0fc2-4861-a9f5-148f1f80804f','B0E6697B-3534-4C09-BE0A-04473401AB93'
 
	@AnalysisID nvarchar(256), 
	@UserName nvarchar(256)
 
AS
BEGIN
 

SET NOCOUNT ON;		
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

 INSERT INTO [Core].[CashFlowDownloadRequests]
(
	 AnalysisID	
	,RequestTime	
	,StartTime	
	,EndTime	
	,StatusText	
	,PriorityID	
	,ErrorMessage	
	,CreatedBy	
	,CreatedDate	
	,UpdatedBy	
	,UpdatedDate
 )values
 (
	 @AnalysisID
	 ,getdate()
	 ,getdate()
	  ,null
	 ,'Processing'
	 ,null
	 ,''
	 ,@UserName
	 ,getdate()
	  ,@UserName
	 ,getdate()
 )

 select SCOPE_IDENTITY() as CashFlowDownloadRequestsID

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END
GO

