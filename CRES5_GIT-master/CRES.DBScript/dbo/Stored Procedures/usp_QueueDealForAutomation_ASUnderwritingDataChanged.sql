CREATE PROCEDURE [dbo].[usp_QueueDealForAutomation_ASUnderwritingDataChanged] 
	@UpdatedBy nvarchar(256)
AS
BEGIN      
    
 SET NOCOUNT ON;      


Declare @tblDeals as table(CREDealid nvarchar(256))  

INSERT INTO @tblDeals(CREDealid)
exec [dbo].[usp_GetDiscrepancyForAutoSpreadUnderwritingData]
  
 
declare @TableTypeAutomationRequests [TableTypeAutomationRequests]
 
INSERT INTO @TableTypeAutomationRequests([DealID],[StatusText],AutomationType)
select d.dealid,'Processing' as [StatusText],789 as AutomationType
from @tblDeals t
Inner join cre.deal d on d.CREDealid =t.CREDealid


exec [dbo].[usp_QueueDealForAutomation] @TableTypeAutomationRequests,@UpdatedBy,@UpdatedBy 

 

 
END

