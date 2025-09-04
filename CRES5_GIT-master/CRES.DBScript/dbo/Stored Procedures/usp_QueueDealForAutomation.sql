CREATE PROCEDURE [dbo].[usp_QueueDealForAutomation] 
	@AutomationRequest [TableTypeAutomationRequests] READONLY,
	@CreatedBy nvarchar(256),
	@UpdatedBy nvarchar(256)
AS
BEGIN      
    
 SET NOCOUNT ON;      
  
--IF OBJECT_ID('tempdb..[#TempautomationRequest]') IS NOT NULL                                         
-- DROP TABLE [#TempautomationRequest]  
 	
--CREATE TABLE  [dbo].[#TempautomationRequest](
--	[DealID]				UNIQUEIDENTIFIER  NULL,
--	[RequestTime]			DATETIME         NULL,    
--	[StartTime]				DATETIME         NULL,
--	[EndTime]				DATETIME         NULL,
--	[StatusID]				INT              NULL,
--	AutomationType			int		null	 
--)

Declare @BatchID int;
SET @BatchID = (Select ISNULL(MAX(BatchID),0) + 1 from [Core].[AutomationRequests])


INSERT INTO [Core].[AutomationRequests] ([DealID],[RequestTime],[StartTime],[EndTime],[StatusID],AutomationType,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,BatchType,BatchID)
select DealID,getdate(),null,null,lstatus.lookupid as statusid,AutomationType,@CreatedBy,getdate(),@UpdatedBy,getdate(),BatchType,@BatchID
from @AutomationRequest ar
left join core.lookup lstatus on lstatus.name = ar.[StatusText]



END