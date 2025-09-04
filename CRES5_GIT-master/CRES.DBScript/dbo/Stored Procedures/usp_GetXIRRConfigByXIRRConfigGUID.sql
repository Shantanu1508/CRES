CREATE PROCEDURE [dbo].[usp_GetXIRRConfigByXIRRConfigGUID]  
  @XIRRConfigGUID nvarchar(256)  
AS    
BEGIN    
    
SET NOCOUNT ON;    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
   
SELECT xc.XIRRConfigID, xc.ReturnName, TagID, TagName,   
TransactionID, TransactionName, a.AnalysisID, a.Name as AnalysisName,   
xc.Comments,  
--u.Login as LastCalculatedBy  
--,xc.UpdatedDate as LastCalculated  
--PortfolioDetails.PortfolioID as Deal_PortfolioID,  
--PortfolioDetails.PortfolioName as Deal_PortfolioText,  
tblConfigrequest.LastCalculatedDate as LastCalculated  
,tblConfigrequest.[Status]  
,ErrorDetail.ErrorDetails  
,xc.RowNumber  
,xc.Group1  
,xc.Group2  
,xc.ArchivalRequirement  
,xc.ReferencingDealLevelReturn  
,xc.UpdateXIRRLinkedDeal  
,xc.[Type]  
,xc.FileName_Input as [FileNameInput]  
,xc.FileName_Output as [FileNameOutput]  
,xc.XIRRConfigGUID
,xc.CutoffRelativeDateID
,xc.CutoffDateOverride
,xc.ShowReturnonDealScreen
,xc.isAllowDelete
FROM [CRE].[XIRRConfig] xc  
LEFT JOIN [CORE].[Analysis] a on a.AnalysisID = xc.AnalysisID  
LEFT JOIN [App].[USER] u on u.UserID = xc.UpdatedBy  
  
LEFT JOIN (  
    SELECT xd.XIRRConfigID, t.TagMasterXIRRID as TagID,  
        t.Name as TagName  
 From [CRE].TagMasterXIRR t   
 Inner Join [CRE].[XIRRConfigDetail] xd on xd.ObjectID = t.TagMasterXIRRID  
 where xd.ObjectType = 'Tag'  
) AS TagDetails on TagDetails.XIRRConfigID = xc.XIRRConfigID   
 
  
LEFT JOIN (  
    SELECT xd.XIRRConfigID, t.TransactionTypesID as TransactionID,  
        t.TransactionName as TransactionName  
 From [CRE].[TransactionTypes] t   
 Inner Join [CRE].[XIRRConfigDetail] xd on xd.ObjectID = t.TransactionTypesID  
 where xd.ObjectType = 'Transaction'  
) AS TransactionDetails on TransactionDetails.XIRRConfigID = xc.XIRRConfigID  
  
LEFT JOIN(  
  
 Select XIRRConfigID,LastCalculatedDate,  
 (CASE WHEN [TotalCount] = Completed Then 'Completed'  
 WHEN Failed > 0 Then 'Failed'  
 WHEN Running > 0 Then 'Running'  
 else 'Processing' end  
 ) as [Status]  
 From(  
  SELECT XIRRConfigID,[TotalCount]  
  ,ISNULL(Failed,0) as Failed  
  ,ISNULL(Completed,0) as Completed  
  ,ISNULL(Running,0) as Running  
  ,ISNULL(Processing,0) as Processing  
  ,LastCalculatedDate  
  FROM     
  (      
   Select a.XIRRConfigID,a.[Status],a.[count],tbllastcalcDate.LastCalculatedDate   
   from(  
    select xr.XIRRConfigID,'TotalCount' as [Status],count(xr.[Status]) [count]   
    from [CRE].[XIRRCalculationRequests] xr  
    group by xr.XIRRConfigID  
  
    UNION ALL  
  
    select xr.XIRRConfigID,l.name as [Status],count(xr.[Status]) [count]   
    from [CRE].[XIRRCalculationRequests] xr  
    Left Join core.lookup l on l.lookupid = xr.[Status]  
    group by xr.XIRRConfigID,l.name  
   )a  
   left Join(  
    select XIRRConfigID,MAX(updateddate) as LastCalculatedDate  
    from [CRE].[XIRRCalculationRequests]  
    Group by XIRRConfigID  
   )tbllastcalcDate on tbllastcalcDate.XIRRConfigID = a.XIRRConfigID  
   ---where a.XIRRConfigID = 18   
  ) t   
  PIVOT(  
   SUM([count])   
   FOR [Status] IN ([TotalCount],Failed,Completed,Running,Processing)  
  ) AS pivot_table  
 )z  
   
)tblConfigrequest on tblConfigrequest.XIRRConfigID = xc.XIRRConfigID  
   
LEFT JOIN (  
SELECT   
xr.XIRRConfigID,  
    STUFF((  
        SELECT ', ' + d.DealName  
        FROM [CRE].[Deal] d  
        INNER JOIN [CRE].[XIRRCalculationRequests] xc ON xc.DealAccountID = d.AccountID  
        WHERE xc.[Type] = 'Deal' AND xc.Status = 265  
        FOR XML PATH(''), TYPE  
    ).value('.', 'NVARCHAR(MAX)'), 1, 2, '') + ', ' + MAX(xr.ErrorMessage) AS ErrorDetails  
FROM [CRE].[Deal] d  
INNER JOIN [CRE].[XIRRCalculationRequests] xr ON xr.DealAccountID = d.AccountID  
WHERE xr.[Type] = 'Deal' AND xr.Status = 265  
GROUP BY xr.XIRRConfigID  
)AS ErrorDetail on ErrorDetail.XIRRConfigID = xc.XIRRConfigID  
  where XIRRConfigGUID= @XIRRConfigGUID

 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END 