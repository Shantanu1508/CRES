CREATE PROCEDURE [dbo].[usp_GetXIRRCalculationStatusByObjectID]	--'43f1e31f-db37-4703-a1f3-78d977193b88','B0E6697B-3534-4C09-BE0A-04473401AB93'
	@XIRRCalculationRequestsID nvarchar(100),
	@UserID uniqueidentifier      
 
AS  
BEGIN    
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

select  
      
  [dbo].[ufn_GetTimeByTimeZone] (xr.updateddate,@USerID ) as UpdatedDate   
  ,l.Name
  ,xr.Status as StatusID
  ,u.Login as calculatedby
  ,xr.ErrorMessage
  ,xr.analysisid

from cre.XIRRCalculationRequests xr
inner join Core.Lookup l on l.LookupID = xr.Status 
inner join app.[user] u on u.userid = xr.createdby 
where XIRRCalculationRequestsID = @XIRRCalculationRequestsID 

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END