---[dbo].[usp_CheckDuplicateTransactionCashflowDownload]  'C10F3372-0FC2-4861-A9F5-148F1F80804F','1d3af6f9-818d-4cb5-baf5-c41870a802df','1d3af6f9-818d-4cb5-baf5-c41870a802df'

CREATE PROCEDURE [dbo].[usp_CheckDuplicateTransactionCashflowDownload]  
	@AnalysisID uniqueidentifier   ,
	@DealID uniqueidentifier = null,
	@NoteID uniqueidentifier = null
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  


		--Declare @tbltran as TABLE(	
		--	AnalysisID				UNIQUEIDENTIFIER,
		--	AccountID	UNIQUEIDENTIFIER,
		--	Schenario	nvarchar(256),
		--	crenoteid	nvarchar(256),
		--	CalcEngineType	int,
		--	CalcEngineTypeName nvarchar(256),  
		--	[CreatedDate] DATETIME       NULL
		--)



		--IF(@DealID IS NOT NULL)
		--BEGIN
	
		--	print('@DealID IS NOT NULL')

		--	INSERT INTO @tbltran(AnalysisID,AccountID,Schenario,crenoteid,CalcEngineType,CalcEngineTypeName,CreatedDate)
		--	Select Distinct z.AnalysisID,z.AccountID,z.Schenario,z.crenoteid ,cl.CalcEngineType,lCalcEngineType.name as CalcEngineTypeName,getdate() as CreatedDate
		--	from (
 
		--		Select (Select a.name from core.analysis a where a.analysisid = tr.analysisid) as Schenario
		--		,d.dealid,d.DealName,n.crenoteid,tr.AnalysisID,tr.AccountID,tr.[Date],tr.amount,COUNT(tr.AccountID) cnt
		--		from cre.transactionentry tr
		--		Inner Join cre.note n on n.Account_accountid = tr.Accountid
		--		Inner join core.account acc on acc.accountid = n.Account_accountid
		--		Inner Join cre.deal d on d.dealid = n.dealid
		--		where  acc.isdeleted <> 1 and n.enableM61Calculations = 3
		--		and [type] = 'InterestPaid' and analysisid = @AnalysisID  ---'C10F3372-0FC2-4861-A9F5-148F1F80804F'
		--		and d.dealid = @DealID
		--		Group by d.dealid,d.DealName,n.crenoteid,tr.AnalysisID,tr.AccountID,tr.[Date],tr.amount
		--		Having COUNT(tr.AccountID) > 1
 
		--	)z
		--	Inner join core.CalculationRequests cl on cl.accountid = z.accountid and cl.AnalysisID = z.AnalysisID
		--	Left join core.lookup lCalcEngineType on lCalcEngineType.lookupid = cl.CalcEngineType
 
		--	WHERE lCalcEngineType.name <> 'V1 (New)'
		--END
		--ELSE IF(@NoteID IS NOT NULL)
		--BEGIN
	
		--	print('@NoteID IS NOT NULL')
		--	INSERT INTO @tbltran(AnalysisID,AccountID,Schenario,crenoteid,CalcEngineType,CalcEngineTypeName,CreatedDate)
		--	Select Distinct z.AnalysisID,z.AccountID,z.Schenario,z.crenoteid ,cl.CalcEngineType,lCalcEngineType.name as CalcEngineTypeName,getdate() as CreatedDate
		--	from (
 
		--		Select (Select a.name from core.analysis a where a.analysisid = tr.analysisid) as Schenario
		--		,d.dealid,d.DealName,n.crenoteid,tr.AnalysisID,tr.AccountID,tr.[Date],tr.amount,COUNT(tr.AccountID) cnt
		--		from cre.transactionentry tr
		--		Inner Join cre.note n on n.Account_accountid = tr.Accountid
		--		Inner join core.account acc on acc.accountid = n.Account_accountid
		--		Inner Join cre.deal d on d.dealid = n.dealid
		--		where  acc.isdeleted <> 1 and n.enableM61Calculations = 3
		--		and [type] = 'InterestPaid' and analysisid = @AnalysisID  ---'C10F3372-0FC2-4861-A9F5-148F1F80804F'
		--		and n.NoteID = @NoteID
		--		Group by d.dealid,d.DealName,n.crenoteid,tr.AnalysisID,tr.AccountID,tr.[Date],tr.amount
		--		Having COUNT(tr.AccountID) > 1
 
		--	)z
		--	Inner join core.CalculationRequests cl on cl.accountid = z.accountid and cl.AnalysisID = z.AnalysisID
		--	Left join core.lookup lCalcEngineType on lCalcEngineType.lookupid = cl.CalcEngineType
 
		--	WHERE lCalcEngineType.name <> 'V1 (New)'
		--END
		--ELSE 
		--BEGIN
		--	print('@AnalysisID IS NOT NULL')
	
		--	INSERT INTO @tbltran(AnalysisID,AccountID,Schenario,crenoteid,CalcEngineType,CalcEngineTypeName,CreatedDate)
		--	Select Distinct z.AnalysisID,z.AccountID,z.Schenario,z.crenoteid ,cl.CalcEngineType,lCalcEngineType.name as CalcEngineTypeName,getdate() as CreatedDate
		--	from (
 
		--		Select (Select a.name from core.analysis a where a.analysisid = tr.analysisid) as Schenario
		--		,d.dealid,d.DealName,n.crenoteid,tr.AnalysisID,tr.AccountID,tr.[Date],tr.amount,COUNT(tr.AccountID) cnt
		--		from cre.transactionentry tr
		--		Inner Join cre.note n on n.Account_accountid = tr.Accountid
		--		Inner join core.account acc on acc.accountid = n.Account_accountid
		--		Inner Join cre.deal d on d.dealid = n.dealid
		--		where  acc.isdeleted <> 1 and n.enableM61Calculations = 3
		--		and [type] = 'InterestPaid' and analysisid = @AnalysisID  ---'C10F3372-0FC2-4861-A9F5-148F1F80804F'
		--		Group by d.dealid,d.DealName,n.crenoteid,tr.AnalysisID,tr.AccountID,tr.[Date],tr.amount
		--		Having COUNT(tr.AccountID) > 1
 
		--	)z
		--	Inner join core.CalculationRequests cl on cl.accountid = z.accountid and cl.AnalysisID = z.AnalysisID
		--	Left join core.lookup lCalcEngineType on lCalcEngineType.lookupid = cl.CalcEngineType
 
		--	WHERE lCalcEngineType.name <> 'V1 (New)'

		--END
		-----========================================


		------Store in physical table
		--INSERT INTO [CRE].[DuplicateTransactionAnalysisData](AnalysisID,AccountID,Schenario,crenoteid,CalcEngineType,CalcEngineTypeName,CreatedDate)
		--Select AnalysisID,AccountID,Schenario,crenoteid,CalcEngineType,CalcEngineTypeName,CreatedDate from @tbltran
		-----========================================

		-----Queue note for calculation
		--declare @TableTypeCalculationRequests TableTypeCalculationRequests  
 
		--delete From @TableTypeCalculationRequests
		----Select Distinct z.AnalysisID,z.AccountID,z.Schenario,z.crenoteid ,cl.CalcEngineType,lCalcEngineType.name as CalcEngineTypeName
		--INSERT INTO @TableTypeCalculationRequests(NoteId,StatusText,UserName,PriorityText,AnalysisID,CalcType)  
		--Select Distinct n.NoteID,'Processing' as StatusText,'3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50' as UserName,'Real Time' as PriorityText,t.analysisID,775 as CalcType 
		--from @tbltran t
		--Inner join cre.note n on n.Account_Accountid = t.Accountid
		--where t.Analysisid = @Analysisid

		--exec [dbo].[usp_QueueNotesForCalculation] @TableTypeCalculationRequests,'3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50','3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50'   
		-----================================================


		--Select AnalysisID,AccountID,Schenario,crenoteid,CalcEngineType,CalcEngineTypeName,CreatedDate from @tbltran

  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
  
END  