
 
--[dbo].[usp_GetNoteCashflowsExportData_GAAPBasisComponents] 'A8D91464-26F0-44CF-AF19-33DA2AB48405','00000000-0000-0000-0000-000000000000','c10f3372-0fc2-4861-a9f5-148f1f80804f','','00000000-0000-0000-0000-000000000000',0,0,null
--[dbo].[usp_GetNoteCashflowsExportData_GAAPBasisComponents] '00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000','c10f3372-0fc2-4861-a9f5-148f1f80804f','','00000000-0000-0000-0000-000000000000',0,0,null
--[dbo].[usp_GetNoteCashflowsExportData_GAAPBasisComponents] '00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000','c10f3372-0fc2-4861-a9f5-148f1f80804f','12190,12515',null,0,0,'Default'

CREATE PROCEDURE [dbo].[usp_GetNoteCashflowsExportData_GAAPBasisComponents] 
	@NoteId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
	@DealId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
	@ScenarioId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
	
	@MultipleNoteids nvarchar(max),
	@PortfolioMasterGuid nvarchar(256)='00000000-0000-0000-0000-000000000000',
	@CountOnDropDownFilter int=0,
	@CountOnGridFilter int=0,
	@TransactionCategoryName nvarchar(256) =null              
AS
BEGIN
    SET NOCOUNT ON;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


if(@MultipleNoteids<>'')
BEGIN
	CREATE TABLE #tblListNotes(
	  CRENoteID VARCHAR(256)
	)

	INSERT INTO #tblListNotes(CRENoteID)
	select Value from fn_Split(@MultipleNoteids);

	IF(@CountOnGridFilter=@CountOnDropDownFilter)
	BEGIN
	  INSERT INTO #tblListNotes(CRENoteID)
	  select CRENoteID from [dbo].[fn_GetCalculationRequestsInActiveNotes] (@PortfolioMasterGuid,@ScenarioId);
	END;



	Select n.CRENoteID as NoteID
	,acc.name as NoteName
	,CAST(CONVERT(VARCHAR, [Date], 101) as Date)as [Date]
		,AccumAmortofDeferredFees
		,AccumulatedAmortofDiscountPremium
		,AccumulatedAmortofCapitalizedCost
		,EndingBalance  
		,GrossDeferredFees   
		,CleanCost  
		,CurrentPeriodInterestAccrualPeriodEnddate  
		,CurrentPeriodPIKInterestAccrualPeriodEnddate  
		,InterestSuspenseAccountBalance 

	from [CRE].[DailyGAAPBasisComponents] g
	inner join cre.note n on n.noteid = g.noteid
	inner join core.account acc on acc.accountid =n.account_accountid
	left join core.Analysis sc on sc.AnalysisID = g.AnalysisID

	where acc.IsDeleted=0
	and n.CRENoteID in (select CRENoteID from #tblListNotes)
	AND g.AnalysisID = @ScenarioId

	order by n.CRENoteID,g.[Date]  asc
	 

END
ELSE
BEGIN


	Select n.CRENoteID as NoteID
	,acc.name as NoteName
	,CAST(CONVERT(VARCHAR, [Date], 101) as Date)as [Date]
	,AccumAmortofDeferredFees
	,AccumulatedAmortofDiscountPremium
	,AccumulatedAmortofCapitalizedCost
	,EndingBalance  
	,GrossDeferredFees   
	,CleanCost  
	,CurrentPeriodInterestAccrualPeriodEnddate  
	,CurrentPeriodPIKInterestAccrualPeriodEnddate  
	,InterestSuspenseAccountBalance 

	from [CRE].[DailyGAAPBasisComponents] g
	inner join cre.note n on n.noteid = g.noteid
	inner join core.account acc on acc.accountid =n.account_accountid
	left join core.Analysis sc on sc.AnalysisID = g.AnalysisID

	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	AND acc.IsDeleted=0
	AND g.AnalysisID = @ScenarioId
					 
	order by n.CRENoteID,g.[Date]  asc
END




SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	
	
END



