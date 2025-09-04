--[dbo].[usp_GetNoteCashflowsExportData_All] 'c10f3372-0fc2-4861-a9f5-148f1f80804f'

CREATE Procedure [dbo].[usp_GetNoteCashflowsExportData_All]

@AnalysisID  UNIQUEIDENTIFIER

AS
BEGIN
	SET NOCOUNT ON;


DECLARE @cols_Per AS NVARCHAR(MAX);

select @cols_Per =  STUFF((SELECT ',' + (CAST(CRENoteID as nvarchar(100)))   
From(
	SELECT  distinct n.CRENoteID
	from  CRE.Note n  
	inner JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
	left join Core.CalculationRequests cr on cr.accountid = ac.AccountID and cr.AnalysisID=@AnalysisID  
	  
	inner join cre.Deal d on n.DealId = d.DealId  
	left join Core.Lookup l ON cr.[StatusID]=l.LookupID  
	left join Core.Lookup lPriority ON cr.[PriorityID]=lPriority.LookupID  
	left join Core.Lookup lApplication ON cr.[ApplicationID]=lApplication.LookupID  
	left join Core.Lookup lstaus on lstaus.LookupID = ac.StatusID and ac.IsDeleted=0   
	left join Core.Lookup lEnableM61Calculations on lEnableM61Calculations.LookupID = ISNULL(n.EnableM61Calculations,3)   
	left join Core.Lookup lCalcEngineType ON cr.CalcEngineType=lCalcEngineType.LookupID  
	where    
	n.noteID not in (select distinct ObjectID FROM CORE.Exceptions where ActionLevelID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=46 AND NAME='Critical') )  
	and ac.IsDeleted=0  
	and ISNULL(ac.StatusID,1) = (select LookupID from Core.Lookup where  ParentID=1 and Name='active') 
	---and n.crenoteid in ('17787','19679') 
)a  
FOR XML PATH(''), TYPE  
).value('.', 'NVARCHAR(MAX)')   
,1,1,'')


EXEC [dbo].[usp_GetNoteCashflowsExportData] '00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000',@AnalysisID,@cols_Per,null,0,0,null


END