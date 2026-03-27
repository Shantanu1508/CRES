--[usp_RefreshCalculationRequestsLiability] 'c10f3372-0fc2-4861-a9f5-148f1f80804f'  
  
CREATE PROCEDURE [dbo].[usp_RefreshCalculationRequestsLiability]
@AnalysisID uniqueidentifier = null
AS  
BEGIN  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

	IF @AnalysisID IS NULL
	BEGIN
		SET @AnalysisID = (Select AnalysisID from [Core].[Analysis] where [Name]='Default') 
	END
  
	SELECT DISTINCT 
	ac.AccountID
	,ac.[Name]  LiabilityName
	,(CASE WHEN l.[Name] IS NULL and CalculationRequestID is not null THEN 'Processing' WHEN l.[Name] = 'SaveDBPending' THEN 'Running'	ELSE l.[Name] END) as StatusText  	
	--,StatusName_New as StatusText
	,cr.[StartTime]  as StartTime  
	,cr.[EndTime] as EndTime   
	,cr.ErrorMessage   
	,eq.EquityGUID
	,cr.RequestTime
	from  CRE.Equity eq  
	left join Core.CalculationRequestsLiability cr on eq.AccountID=cr.AccountId and cr.AnalysisID=@AnalysisID  
	inner JOIN core.Account ac ON ac.AccountID = eq.AccountID  
	left join Core.Lookup l ON cr.[StatusID]=l.LookupID  
	left join Core.Lookup lPriority ON cr.[PriorityID]=lPriority.LookupID  
	left join Core.Lookup lApplication ON cr.[ApplicationID]=lApplication.LookupID  
	left join Core.Lookup lstaus on lstaus.LookupID = ac.StatusID and ac.IsDeleted=0   
	/*Left Join(
		Select  cr.AccountId,	
		STRING_AGG(l.Name,'_') AS StatusName,
		(CASE WHEN STRING_AGG(l.Name,'_') like '%Running%' THEN 'Running'
		 WHEN STRING_AGG(l.Name,'_') like '%Failed%' THEN 'Failed'
		 WHEN STRING_AGG(l.Name,'_') = 'Completed_Completed' THEN 'Completed'
		 ELSE 'Processing' END
		) as StatusName_New
		from core.CalculationRequestsLiability cr  
		LEFT JOIN   Core.Lookup l ON l.LookupID = cr.StatusID   
		where AnalysisID = @AnalysisID
		group by cr.AccountId
	)tblStatus on tblStatus.AccountId = cr.AccountId
	*/
	where  eq.AccountID not in (select distinct ObjectID FROM CORE.Exceptions where ActionLevelID=293 )
	and ac.IsDeleted=0  
	and ISNULL(ac.StatusID,1) = 1
	--AND CalcType = 910

 
          
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END
GO

