
CREATE PROCEDURE [dbo].[usp_GetWLDealLegalStatusByDealID]
(
	@DealId UNIQUEIDENTIFIER
)
AS

 BEGIN

Select 
 ls.[WLDealLegalStatusID]
,ls.[DealID]          
,ls.[StartDate]  
,ls.[Type]
,ls.[Comment]         
,ls.[CreatedBy]       
,ls.[CreatedDate]     
,ls.[UpdatedBy]       
,ls.[UpdatedDate]   
,ls.ReasonCode
From [CRE].[WLDealLegalStatus] ls

Where dealid = @DealId
Order by ls.[StartDate] desc


END

