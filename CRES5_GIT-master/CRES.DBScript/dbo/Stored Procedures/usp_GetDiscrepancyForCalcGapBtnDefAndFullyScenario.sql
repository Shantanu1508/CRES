
CREATE PROCEDURE [dbo].[usp_GetDiscrepancyForCalcGapBtnDefAndFullyScenario]     
AS    
BEGIN   
  
Select def.AnalysisName	
,def.credealid	
,def.DealName	
,def.crenoteid	
,def.NoteName	
,def.EndTime_Default
,fully.EndTime_Fully,DATEDIFF(HOUR,fully.EndTime_Fully , def.EndTime_Default) as [Datediff_HOUR]
from(
	SELECT n.Account_AccountID
	,am.name as AnalysisName 
	,d.credealid
	,d.DealName
	,n.crenoteid
	,ac.name as NoteName
	--,cr.[StartTime]  as StartTime_Default  
	,cr.[EndTime] as EndTime_Default
	from  CRE.Note n  
	Inner join Core.CalculationRequests cr on n.Account_AccountID=cr.AccountId and cr.AnalysisID='C10F3372-0FC2-4861-A9F5-148F1F80804F'  
	inner JOIN core.Account ac ON ac.AccountID = n.Account_AccountID 
	Inner join core.Analysis am on am.AnalysisID = cr.AnalysisID
	Inner join cre.deal d on d.dealid = n.DealID
	where n.Account_AccountID not in (select distinct ObjectID FROM CORE.Exceptions where ActionLevelID=293 )
	and ac.IsDeleted=0  
	and ISNULL(ac.StatusID,1) = 1
	and cr.AnalysisID='C10F3372-0FC2-4861-A9F5-148F1F80804F'
)def
Left Join(
	SELECT n.Account_AccountID
	,am.name as AnalysisName 
	,d.credealid
	,d.DealName
	,n.crenoteid
	,ac.name as NoteName
	,cr.[StartTime]  as StartTime_Fully
	,cr.[EndTime] as EndTime_Fully
	from  CRE.Note n  
	left join Core.CalculationRequests cr on n.Account_AccountID=cr.AccountId and cr.AnalysisID='726671fa-16a9-44f6-af71-5d54492e7e82'  
	inner JOIN core.Account ac ON ac.AccountID = n.Account_AccountID 
	Inner join core.Analysis am on am.AnalysisID = cr.AnalysisID
	Inner join core.AnalysisParameter ap on ap.AnalysisID =am.AnalysisID
	Inner join cre.deal d on d.dealid = n.DealID
	where n.Account_AccountID not in (select distinct ObjectID FROM CORE.Exceptions where ActionLevelID=293 )
	and ac.IsDeleted=0  
	and ISNULL(ac.StatusID,1) = 1
	and ap.AllowCalcAlongWithDefault = 3
	and cr.AnalysisID='726671fa-16a9-44f6-af71-5d54492e7e82'
)fully on def.Account_AccountID = fully.Account_AccountID

where DATEDIFF(HOUR,fully.EndTime_Fully , def.EndTime_Default) > 6
Order by def.dealname,def.crenoteid


END