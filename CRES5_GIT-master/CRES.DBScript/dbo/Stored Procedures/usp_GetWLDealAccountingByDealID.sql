
CREATE PROCEDURE [dbo].[usp_GetWLDealAccountingByDealID]
(
	@DealId UNIQUEIDENTIFIER
)
AS

 BEGIN

Select 
 ls.[WLDealAccountingID]
,ls.[DealID]          
,ls.[StartDate] 
,ls.[EndDate]
,ls.[TypeID]
,l.name as [TypeText]
,ls.[Comment]         
,ls.[CreatedBy]       
,ls.[CreatedDate]     
,ls.[UpdatedBy]       
,ls.[UpdatedDate]     
From [CRE].[WLDealAccounting] ls
left Join core.lookup l on l.lookupid = ls.TypeID
Where dealid = @DealId


END