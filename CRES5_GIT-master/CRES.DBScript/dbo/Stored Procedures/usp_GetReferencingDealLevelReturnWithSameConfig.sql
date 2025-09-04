
CREATE PROCEDURE [dbo].[usp_GetReferencingDealLevelReturnWithSameConfig]
(
	@XIRRConfigID int,
	@RefrencingDealLevel_XIRRConfigID int OUTPUT
)
AS
BEGIN

	IF OBJECT_ID('tempdb..#TempConfig') IS NOT NULL 
		DROP TABLE #TempConfig;

	CREATE TABLE #TempConfig (
		[XIRRConfigID] int NULL,
		[ReturnName] nvarchar(256) NULL, 
		[Filter] nvarchar(MAX) NULL
	);

	INSERT INTO #TempConfig([XIRRConfigID],[ReturnName],[Filter])
	SELECT XIRRConfigID,ReturnName,Result
	FROM (
		SELECT XC.XIRRConfigID,XC.ReturnName, XFS.[Name],XCF.FilterDropDownValue, CONCAT(XFS.[Name],' - ',XCF.FilterDropDownValue) as Result
		FROM [CRE].[XIRRConfigFilter] XCF
		INNER JOIN [CRE].[XIRRFilterSetup] XFS ON XCF.XIRRFilterSetupID=XFS.XIRRFilterSetupID
		INNER JOIN [CRE].[XIRRConfig] XC ON XC.XIRRConfigID=XCF.XIRRConfigID
	 
		UNION
 
		SELECT XC.XIRRConfigID,XC.ReturnName, XCD.ObjectType,CAST(XCD.ObjectID as NVARCHAR(256)), CONCAT(XCD.ObjectType,' - ',CAST(XCD.ObjectID as NVARCHAR(256))) as Result
		FROM [CRE].[XIRRConfig] XC 
		INNER JOIN [CRE].[XIRRConfigDetail] XCD ON XCD.XIRRConfigID=XC.XIRRConfigID AND XCD.ObjectType IS NOT NULL
		
		UNION

		SELECT XC.XIRRConfigID,XC.ReturnName, 'Scenario' as [Name],a.Name as ScenarioName, CONCAT('Scenario - ',a.Name ) as Result
		FROM [CRE].[XIRRConfig] XC 
		Inner JOin core.Analysis a on a.AnalysisID = xc.AnalysisID
	) Res Order By Result;

	DEclare @tbltemp as table(
		[XIRRConfigID] int NULL,
		[ReturnName] nvarchar(256) NULL, 
		FinalResult nvarchar(MAX) NULL,		
		[Type] nvarchar(100) NULL
	)

	INSERT INTO @tbltemp(XIRRConfigID,ReturnName,FinalResult,[Type])
	Select XXC.XIRRConfigID,XXC.ReturnName, STRING_AGG (TC.[Filter], ', ') as FinalResult ,XXC.[Type]
	from [CRE].[XIRRConfig] XXC
	INNER JOIN #TempConfig TC ON
	TC.XIRRConfigID=XXC.XIRRConfigID
	Group BY XXC.XIRRConfigID,XXC.ReturnName,XXC.[Type]
	


	SET @RefrencingDealLevel_XIRRConfigID  = (Select TOP 1 R2.XIRRConfigID as RefrencingDealLevel_XIRRConfigID	
		from @tbltemp as R1 
		INNER JOIN @tbltemp as R2 ON R1.XIRRConfigID<>R2.XIRRConfigID AND R1.FinalResult=R2.FinalResult and R1.Type = 'Portfolio' and R2.Type = 'Deal'	
		Where R1.XIRRConfigID = @XIRRConfigID
		Order by R2.XIRRConfigID desc
	)


	Select @RefrencingDealLevel_XIRRConfigID as RefrencingDealLevel_XIRRConfigID
 
	--Select R1.XIRRConfigID as Main_XIRRConfigID
	--,R1.ReturnName as Main_ReturnName
	--,R2.XIRRConfigID as RefrencingDealLevel_XIRRConfigID
	--,R2.ReturnName as RefrencingDealLevel_ReturnName
	--,R1.FinalResult as [Common_Filter]
	--from @tbltemp as R1 
	--INNER JOIN @tbltemp as R2 ON R1.XIRRConfigID<>R2.XIRRConfigID AND R1.FinalResult=R2.FinalResult and R1.Type = 'Portfolio' and R2.Type = 'Deal'	
	--Where R1.XIRRConfigID = @XIRRConfigID
	--Order by R2.XIRRConfigID desc



END