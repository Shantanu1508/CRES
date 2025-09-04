CREATE PROCEDURE [dbo].[usp_GetRequestsFromXIRRCalculationRequest]  
AS  
BEGIN    
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	Declare @countMax int =   400;
	Declare @Running int = (select COUNT(*) from [CRE].[XIRRCalculationRequests] where [Status]=267);      

	Declare @count int = 0;
	set @count = @countMax-@Running;


	--Select Top (ISNULL(@count,0)) XIRRCalculationRequestsID,XIRRConfigID,XIRRReturnGroupID,[Type],DealAccountID,AnalysisID ,CreatedBy as UserID
	--from [CRE].[XIRRCalculationRequests]
	--Where [Status] = 292

	update [CRE].[XIRRCalculationRequests] set [Status] = 292,EndTime = null  where XIRRCalculationRequestsID in (
		Select XIRRCalculationRequestsID
		from [CRE].[XIRRCalculationRequests] Where [Status] = 267
		and DateDiff(minute,StartTime,getdate()) > 30
	)




	Select Top (ISNULL(@count,0)) XIRRCalculationRequestsID
	,cr.XIRRConfigID
	,cr.XIRRReturnGroupID
	,cr.[Type]
	,cr.DealAccountID
	,cr.AnalysisID 
	,cr.CreatedBy as UserID
	,xc.[Type]
	,(CASE WHEN xc.[Type] = 'Portfolio' and DealAccountID is null THEN 1
	WHEN xc.[Type] = 'Deal' THEN 1 ELSE 0 END) as IsCreateFile
	
	from [CRE].[XIRRCalculationRequests] cr
	Inner Join (
		Select XIRRConfigID,[Type] from cre.XIRRConfig
	)xc on cr.XIRRConfigID = xc.XIRRConfigID
	Where cr.[Status] = 292




	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END