CREATE PROCEDURE [dbo].[usp_InsertXIRRCalculationRequests]  
	@XIRRConfigIDs nvarchar(256),
	@UserID UNIQUEIDENTIFIER
AS  
BEGIN    
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 



IF OBJECT_ID('tempdb..#tblXIRRConfigID') IS NOT NULL         
	DROP TABLE #tblXIRRConfigID

CREATE TABLE #tblXIRRConfigID(
	XIRRConfigID int
)

INSERT INTO #tblXIRRConfigID(XIRRConfigID)
select Value from fn_Split(@XIRRConfigIDs);
-------------------------------------------------

Delete From [CRE].[XIRRCalculationRequests] where XIRRConfigID in (Select XIRRConfigID from #tblXIRRConfigID)


--Deal
INSERT INTO [CRE].[XIRRCalculationRequests]
([XIRRConfigID]
,XIRRReturnGroupID
,AnalysisID
,[Type]
,DealAccountID
,[Status]
,RequestTime
,[StartTime]
,[EndTime]
,[ErrorMessage]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate])


select Distinct
xm.XIRRConfigID
,inp.XIRRReturnGroupID as XIRRReturnGroupID
,xm.AnalysisID 
,inp.[Type] 
,null as DealAccountID 
,292 as [Status]
,getdate() as RequestTime
,null as StartTime
,null as EndTime
,null as ErrorMessage
,@UserID as [CreatedBy]
,getdate() as [CreatedDate]
,@UserID as [UpdatedBy]
,getdate() as [UpdatedDate]
From [CRE].[XIRRReturnGroup] inp ---[CRE].[XIRRCalculationInput] inp
Inner Join [CRE].[XIRRConfig] xm on inp.XIRRConfigID = xm.XIRRConfigID
--Where xm.[type] in ('Portfolio') 
Where xm.[type] in ('Portfolio','Portfolio_ColumnTotal','Portfolio_RowTotal','Portfolio_OverallTotal','Portfolio_OverallColumnTotal','Portfolio_GroupTotal')
and xm.XIRRConfigID in (Select XIRRConfigID from #tblXIRRConfigID)

UNION ALL

select Distinct
xm.XIRRConfigID
,inp.XIRRReturnGroupID as XIRRReturnGroupID
,xm.AnalysisID 
,'Deal' as [Type] 
,inp.DealAccountID as DealAccountID 
,292 as [Status]
,getdate() as RequestTime
,null as StartTime
,null as EndTime
,null as ErrorMessage
,@UserID as [CreatedBy]
,getdate() as [CreatedDate]
,@UserID as [UpdatedBy]
,getdate() as [UpdatedDate]
From [CRE].[XIRRCalculationInput] inp
Inner Join [CRE].[XIRRConfig] xm on inp.XIRRConfigID = xm.XIRRConfigID
Where xm.[type] = 'Portfolio'
and xm.XIRRConfigID in (Select XIRRConfigID from #tblXIRRConfigID)
and NULLIF(xm.ReferencingDealLevelReturn,0) is null


UNION ALL


select Distinct
xm.XIRRConfigID
,inp.XIRRReturnGroupID as XIRRReturnGroupID
,xm.AnalysisID 
,xr.[Type] as [Type] 
,inp.DealAccountID as DealAccountID 
,292 as [Status]
,getdate() as RequestTime
,null as StartTime
,null as EndTime
,null as ErrorMessage
,@UserID as [CreatedBy]
,getdate() as [CreatedDate]
,@UserID as [UpdatedBy]
,getdate() as [UpdatedDate]
From [CRE].[XIRRReturnGroup] xr
Inner JOin [CRE].[XIRRCalculationInput] inp on inp.XIRRReturnGroupID = xr.XIRRReturnGroupID
Inner Join [CRE].[XIRRConfig] xm on inp.XIRRConfigID = xm.XIRRConfigID
Where xm.[type] = 'Deal'
and xm.XIRRConfigID in (Select XIRRConfigID from #tblXIRRConfigID)






	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END