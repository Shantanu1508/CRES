


CREATE PROCEDURE [dbo].[usp_GetAllScenario]  --'80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,20,''
    @UserID UNIQUEIDENTIFIER,
    @PgeIndex INT,
    @PageSize INT,
	@TotalCount INT OUTPUT 
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	 
	SELECT @TotalCount = COUNT(AnalysisID) FROM  Core.Analysis;
     
	select 
	a.[AnalysisID]
	,a.[Name]
	,lMaturityScenarioOverride.name as MaturityScenarioOverrideText
	,im.IndexesName as IndexScenarioOverrideText
	,lExcludedForcastedPrePayment.Name as ExcludedForcastedPrePaymentText
	,lUseActuals.Name as UseActualsText
	,lCalcEngineType.Name as CalcEngineTypeText
	,lAllowCalcAlongWithDefault.Name as AllowCalcAlongWithDefaultText

	,a.[StatusID]
	,a.[Description]


	,a.[CreatedBy]
	,a.[CreatedDate]
	,a.[UpdatedBy]
	,a.[UpdatedDate]
	,l1.Name as StatusIDtext
	,ap.JsonTemplateMasterID
	,jt.TemplateName as TemplateName
	,a.ScenarioStatus
	,lScenario.[Name] as ScenarioStatusText
	,ap.AllowCalcOverride
	,lAllowCalcOverride.[Name] as AllowCalcOverrideText
	,ap.IncludeProjectedPrincipalWriteoff
	,lIncludeProjectedPrincipalWriteoff.[Name] as IncludeProjectedPrincipalWriteoffText
	,[dbo].[ufn_GetTimeByTimeZone](ap.LastCalculatedDate, @UserID) as LastCalculatedDate
	,lIncludeInDiscrepancy.[Name] as  IncludeInDiscrepancyText
	from Core.Analysis a
	left join Core.AnalysisParameter ap on a.AnalysisID = ap.AnalysisID
	LEFT Join Core.Lookup l1 on a.StatusID=l1.LookupID
	LEFT Join [CRE].[JsonTemplateMaster] jt on ap.JsonTemplateMasterID=jt.JsonTemplateMasterID
	
	LEFT Join Core.Lookup lMaturityScenarioOverride on lMaturityScenarioOverride.LookupID=ap.MaturityScenarioOverrideID and lMaturityScenarioOverride.ParentID = 52
	left join core.IndexesMaster im on im.IndexesMasterID = ap.IndexScenarioOverride
	LEFT Join Core.Lookup lExcludedForcastedPrePayment on lExcludedForcastedPrePayment.LookupID=ap.ExcludedForcastedPrePayment and lExcludedForcastedPrePayment.ParentID = 2
	LEFT Join Core.Lookup lUseActuals on lUseActuals.LookupID=ap.UseActuals and lUseActuals.ParentID = 2
	LEFT Join Core.Lookup lCalcEngineType on lCalcEngineType.LookupID=ap.CalcEngineType
	LEFT Join Core.Lookup lAllowCalcAlongWithDefault on lAllowCalcAlongWithDefault.LookupID=ap.AllowCalcAlongWithDefault
	left join core.Lookup lScenario on lScenario.LookupID = a.ScenarioStatus
	left join core.Lookup lAllowCalcOverride on lAllowCalcOverride.LookupID = ap.AllowCalcOverride
	left join core.Lookup lIncludeProjectedPrincipalWriteoff on lIncludeProjectedPrincipalWriteoff.LookupID = ap.IncludeProjectedPrincipalWriteoff
	left join core.Lookup lIncludeInDiscrepancy on lIncludeInDiscrepancy.LookupID = ap.IncludeInDiscrepancy

	where isnull(a.isDeleted,0)=0 
	--ORDER BY a.UpdatedDate DESC
	ORDER BY CASE WHEN a.[Name] = 'Default' THEN 'a'
	ELSE a.[Name] END ASC
	OFFSET (@PgeIndex - 1)*@PageSize ROWS
	FETCH NEXT @PageSize ROWS ONLY



    SET TRANSACTION ISOLATION LEVEL READ COMMITTED


END      


