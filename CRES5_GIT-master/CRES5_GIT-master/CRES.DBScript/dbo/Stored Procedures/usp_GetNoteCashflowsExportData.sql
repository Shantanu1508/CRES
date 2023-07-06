-- Procedure
-- Procedure

 
--[dbo].[usp_GetNoteCashflowsExportData] '57addfcc-1fdb-4536-a452-268da9884447','00000000-0000-0000-0000-000000000000','c10f3372-0fc2-4861-a9f5-148f1f80804f','','00000000-0000-0000-0000-000000000000',0,0,null
--  [dbo].[usp_GetNoteCashflowsExportData] '00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000','c10f3372-0fc2-4861-a9f5-148f1f80804f',null,null,0,0,null
CREATE PROCEDURE [dbo].[usp_GetNoteCashflowsExportData] 
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

Declare @tblTranType as Table(
TransType nvarchar(256)
)

INSERT INTO @tblTranType(TransType)
Select TransType from(
	Select [Name] as TransType from core.Lookup where ParentID = 94
	UNION ALL
	Select 'InterestPaid' as TransType
	UNION ALL
	Select 'FloatInterest' as TransType
	UNION ALL
	Select 'PIKInterestPaid' as TransType
	UNION ALL
	Select 'ManagementFee' as TransType
)a

CREATE TABLE #tbltransactioncategory(              
   TransactionCategoryName VARCHAR(256)  ,      
   TransactionName nvarchar(256)            
 )   
 IF(@TransactionCategoryName IS NULL)  
	SET @TransactionCategoryName = 'All CashFlows'  
  
 IF(@TransactionCategoryName = 'All CashFlows' OR CHARINDEX('All CashFlows',@TransactionCategoryName) > 0)        
 BEGIN        
  SET @TransactionCategoryName = 'All CashFlows'
  INSERT INTO #tbltransactioncategory(TransactionCategoryName,TransactionName)              
  select 'All CashFlows','1';        
 END        
 ELSE        
 BEGIN        
  INSERT INTO #tbltransactioncategory(TransactionCategoryName,TransactionName)              
  Select TransactionCategory,TransactionName from cre.TransactionTypes where TransactionCategory in ( select Value from fn_Split_Pipe(@TransactionCategoryName))       
 END        

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

	CREATE TABLE #tmpTransactionEntry(
	  ID INT IDENTITY(1,1) PRIMARY KEY,
	  NoteID VARCHAR(500),
	  Name VARCHAR(500),
	  CRENoteID  VARCHAR(500),
	  AnalysisID VARCHAR(500),
	  --TagMasterID UNIQUEIDENTIFIER,
	  [Date] DATETIME NULL,
	  Amount DECIMAL(28,15) NULL,
	  [Type] VARCHAR(500),
	  TransactionDateByRule date null,
	  TransactionDateServicingLog date null,
	  IsFeeTransaction bit null,
	  RemitDate  date null,
	  TransactionCategory VARCHAR(500),
	  [FeeName] VARCHAR(500),
	  [Comment] nVARCHAR(max),
	  PurposeType nVARCHAR(256),
	  Mst_Cash_NonCash nVARCHAR(256),
	  manual_Cash_NonCash nVARCHAR(256),
	  tr_Cash_NonCash nVARCHAR(256)
	)
	

	INSERT INTO #tmpTransactionEntry(NoteID, Name,CRENoteID, AnalysisID, [Date], Amount, [Type],TransactionDateByRule,TransactionDateServicingLog,IsFeeTransaction,RemitDate,TransactionCategory,[FeeName],[Comment],PurposeType,Mst_Cash_NonCash,manual_Cash_NonCash,tr_Cash_NonCash ) --
	SELECT 
	te.NoteID,
	acc.Name,
	n.CRENoteID,
	@ScenarioId,
	te.[Date],
	te.Amount ,
	te.[Type] ,
	te.TransactionDateByRule,
	te.TransactionDateServicingLog,
	(CASE
		WHEN (Select Count(TransType) from @tblTranType where CHARINDEX(Replace(TransType,' ',''),Replace(te.[Type],' ','')) = 1) > 0 THEN 1
		ELSE 0 END
	) as IsFeeTransaction,
	te.RemitDate ,
	tym.TransactionCategory,
	te.FeeName,
	te.Comment,
	te.PurposeType,
	tym.Cash_NonCash as Mst_Cash_NonCash,
	te.Cash_NonCash as manual_Cash_NonCash,
	te.Cash_NonCash as tr_Cash_NonCash
	FROm CRE.TransactionEntry te
	inner join Cre.Note n on n.NoteID=te.NoteID
	inner join core.Account acc on acc.AccountID=n.Account_AccountID		
	left join cre.transactiontypes tym on LOWER(tym.TransactionName) = LOWER(te.[Type])
	WHERE AnalysisID = @ScenarioId
	AND acc.IsDeleted=0
	AND acc.StatusID <> 2
	AND n.CRENoteID in (select CRENoteID from #tblListNotes)
	--AND 1 = ISNULL((Select 0 from cre.FeeSchedulesConfig where ExcludeFromCashflowDownload = 1 and CHARINDEX(Replace(FeeTypeNameText,' ',''), Replace(te.Type,' ','')) = 1),1) 
	AND 1 = ISNULL((Select 0 from cre.FeeSchedulesConfig where ExcludeFromCashflowDownload = 1 and CHARINDEX(Replace(FeeTypeNameText,' ',''), Replace(te.FeeTypeName,' ','')) = 1),1) 
	and tym.IncludeCashflowDownload = 3
	
	--AND te.type in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage')

 

	Select Noteid,NoteName,
	cast((CASE WHEN IsFeeTransaction = 1 THEN LEFT(CONVERT(VARCHAR, ISNULL(TransactionDateByRule,TransDate), 101), 10) 
		ELSE LEFT(CONVERT(VARCHAR, TransDate, 101), 10)
	END)as date) AS [Date],
	cast(Round(Value,5)as decimal(28,5)) as Value,ValueType,
	cast(SpreadPercentage as decimal(28,11)) [Spread], ---[Cash Interest Spread], --[Rate Or Spread %] 
	--ISNULL(PIKInterestPercentage,'') [Additional PIK Spread], --[PIK Interest %],
	cast(LIBORPercentage as decimal(28,7)) as [Index Value], -- [Index %],
	cast(LEFT(CONVERT(VARCHAR,TransactionDateServicingLog, 101), 10)as date) as [Transaction Date],
	cast(LEFT(CONVERT(VARCHAR,TransDate, 101), 10)as date) as [Due Date],
	cast(LEFT(CONVERT(VARCHAR,RemitDate, 101), 10)as date) as [Remit Date],
	ISNULL(FeeName,'') as [Fee Name],
	ISNULL(Comment,'') as [Description],

	tr_Cash_NonCash as [Cash / Non Cash]
	--(CASE WHEN EnableM61Calculations = 3 THEN 
	--	(CASE WHEN ValueType = 'FundingOrRepayment' and ISNULL(PurposeType,'') in ('Capitalized Interest','Note Transfer') THEN 'Non-Cash'
	--	WHEN ValueType = 'FundingOrRepayment' and ISNULL(PurposeType,'') not in ('Capitalized Interest','Note Transfer') and Value < 0 THEN 'Funding'
	--	WHEN ValueType = 'FundingOrRepayment' and ISNULL(PurposeType,'') not in ('Capitalized Interest','Note Transfer') and Value > 0 THEN 'Repayment'
	--	ELSE Mst_Cash_NonCash END
	--	)
	--ELSE
	--	(CASE WHEN (ValueType = 'FundingOrRepayment' and manual_Cash_NonCash is not null) THEN manual_Cash_NonCash
	--	WHEN (ValueType = 'FundingOrRepayment' and manual_Cash_NonCash is null and Value < 0) THEN 'Funding'
	--	WHEN (ValueType = 'FundingOrRepayment' and manual_Cash_NonCash is null and Value > 0) THEN 'Repayment'
	--	ELSE Mst_Cash_NonCash END
	--	)
	--END
	--) as [Cash / Non Cash]


	 
	 
	from
	(
		select 
		te.CRENoteID Noteid,
		te.Name NoteName,
		te.[Date] AS [TransDate],
		te.Amount Value,
		te.[Type] ValueType,
		(case 
		when te.[Type] = 'InterestPaid' then Cast(tblTr.LIBORPercentage as varchar(256))
		when te.[Type] = 'StubInterest' then Cast(n.InitialIndexValueOverride as varchar(256))
		when te.[Type] in ('PIKInterest','PIKInterestPaid') then Cast(tblTr.PIKLiborPercentage as nvarchar(256))
		else null end) as LIBORPercentage,

		(case when te.[Type] = 'PIKInterest' then Cast(tblTr.PIKInterestPercentage as varchar(256)) else '' end) as PIKInterestPercentage,

		(case 
			when te.[Type] in ('InterestPaid','StubInterest') then Cast(tblTr.SpreadPercentage as nvarchar(256)) 
			when te.[Type] in ('PIKInterest','PIKInterestPaid') then Cast(tblTr.PIKInterestPercentage as nvarchar(256))   
			else null 
			end
			) as SpreadPercentage,

		TransactionDateByRule,
		TransactionDateServicingLog,
		IsFeeTransaction,
		RemitDate ,
		te.TransactionCategory,
		te.FeeName,
		te.Comment,
		te.PurposeType,
		n.EnableM61Calculations,
		te.Mst_Cash_NonCash,
		te.manual_Cash_NonCash,
		te.tr_Cash_NonCash
		from  #tmpTransactionEntry te 
		inner join Cre.Note n on n.NoteID=te.NoteID
		LEFT JOIN
		(
			Select Noteid,Date,LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage
			from(
				select 
				te.Noteid,
				te.[Date] ,
				te.Amount,
				te.[Type] ValueType
				from  #tmpTransactionEntry te 		
				where te.type in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage')
			)a
			PIVOT (
			SUM(Amount)
			FOR ValueType in (LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage)
			) pvt
		)tblTr on tblTr.noteid = te.noteid and tblTr.[Date] = te.[Date]
		where te.type not in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage')
		 and  IIF(@TransactionCategoryName='All CashFlows','1',te.Type)in(SELECT TransactionName FROM #tbltransactioncategory)                 
	)a
	order by a.NoteID,Transdate  asc

	DROP TABLE #tblListNotes;
	DROP TABLE #tmpTransactionEntry;
END
ELSE
BEGIN
	IF(@NoteId <> '00000000-0000-0000-0000-000000000000')
	BEGIN

		Select Noteid,NoteName,
		--LEFT(CONVERT(VARCHAR, TransDate, 101), 10) AS [Date],
		CAST((CASE WHEN IsFeeTransaction = 1 THEN LEFT(CONVERT(VARCHAR, ISNULL(TransactionDateByRule,TransDate), 101), 10) 
			ELSE LEFT(CONVERT(VARCHAR, TransDate, 101), 10)
		END)as date) AS [Date],
		cast(Round(Value,5)as decimal(28,5)) as Value,ValueType,
		cast(SpreadPercentage as decimal(28,11)) [Spread], --[Cash Interest Spread], --[Rate Or Spread %] 
		--ISNULL(PIKInterestPercentage,'') [Additional PIK Spread], --[PIK Interest %],
		cast(LIBORPercentage as decimal(28,7)) as [Index Value], -- [Index %],
		CAST(LEFT(CONVERT(VARCHAR,TransactionDateServicingLog, 101), 10)as date) as [Transaction Date],
		CAST(LEFT(CONVERT(VARCHAR,TransDate, 101), 10)as date) as [Due Date],
		CAST(LEFT(CONVERT(VARCHAR,RemitDate, 101), 10)as date) as [Remit Date],
		ISNULL(FeeName,'') as [Fee Name],
		ISNULL(Comment,'') as [Description],
		
		tr_Cash_NonCash as [Cash / Non Cash]
		--(CASE WHEN EnableM61Calculations = 3 THEN 
		--	(CASE WHEN ValueType = 'FundingOrRepayment' and ISNULL(PurposeType,'') in ('Capitalized Interest','Note Transfer') THEN 'Non-Cash'
		--	WHEN ValueType = 'FundingOrRepayment' and ISNULL(PurposeType,'') not in ('Capitalized Interest','Note Transfer') and Value < 0 THEN 'Funding'
		--	WHEN ValueType = 'FundingOrRepayment' and ISNULL(PurposeType,'') not in ('Capitalized Interest','Note Transfer') and Value > 0 THEN 'Repayment'
		--	ELSE Mst_Cash_NonCash END
		--	)
		--ELSE
		--	(CASE WHEN (ValueType = 'FundingOrRepayment' and manual_Cash_NonCash is not null) THEN manual_Cash_NonCash
		--	WHEN (ValueType = 'FundingOrRepayment' and manual_Cash_NonCash is null and Value < 0) THEN 'Funding'
		--	WHEN (ValueType = 'FundingOrRepayment' and manual_Cash_NonCash is null and Value > 0) THEN 'Repayment'
		--	ELSE Mst_Cash_NonCash END
		--	)
		--END
		--) as [Cash / Non Cash]
		
		--,(CASE WHEN ValueType in ('PIKInterestPaid','PIKPrincipalPaid') THEN 'Cash'
		-- WHEN ValueType in ('PIKInterest','PIKPrincipalFunding') THEN 'Non-Cash'
		-- WHEN ValueType = 'FundingOrRepayment' and ISNULL(PurposeType,'') in ('Capitalized Interest','Note Transfer') THEN 'Non-Cash'
		-- WHEN ValueType = 'FundingOrRepayment' and ISNULL(PurposeType,'') not in ('Capitalized Interest','Note Transfer') and Value < 0 THEN 'Funding'
		-- WHEN ValueType = 'FundingOrRepayment' and ISNULL(PurposeType,'') not in ('Capitalized Interest','Note Transfer') and Value > 0 THEN 'Repayment'
		-- ELSE ''
		-- END
		--) as [Cash / Non Cash]
		
		from
		(
			select 
			n.CRENoteID Noteid,
			acc.Name NoteName,
			te.[Date] AS [TransDate],
			te.Amount Value,
			te.[Type] ValueType,
			(case 
			when te.[Type] = 'InterestPaid' then Cast(tblTr.LIBORPercentage as nvarchar(256))
			when te.[Type] = 'StubInterest' then Cast(n.InitialIndexValueOverride as nvarchar(256))
			when te.[Type] in ('PIKInterest','PIKInterestPaid') then Cast(tblTr.PIKLiborPercentage as nvarchar(256))
			else null end) as LIBORPercentage,
			(case when te.[Type] = 'PIKInterest' then Cast(tblTr.PIKInterestPercentage as nvarchar(256)) else '' end) as PIKInterestPercentage,
			(case 
			when te.[Type] in ('InterestPaid','StubInterest') then Cast(tblTr.SpreadPercentage as nvarchar(256)) 
			when te.[Type] in ('PIKInterest','PIKInterestPaid') then Cast(tblTr.PIKInterestPercentage as nvarchar(256))   
			else null 
			end
			) as SpreadPercentage,
			TransactionDateByRule,
			TransactionDateServicingLog,
			(CASE
				WHEN (Select Count(TransType) from @tblTranType where CHARINDEX(Replace(TransType,' ',''),Replace(te.[Type],' ','')) = 1) > 0 THEN 1
				ELSE 0 END
			) as IsFeeTransaction,
			te.RemitDate,
			tym.TransactionCategory,
			te.FeeName,
			te.Comment,
			te.PurposeType,
			n.EnableM61Calculations,
			tym.Cash_NonCash as Mst_Cash_NonCash,
			te.Cash_NonCash as manual_Cash_NonCash,
			te.Cash_NonCash as tr_Cash_NonCash
			from  CRE.TransactionEntry te 
			inner join Cre.Note n on n.NoteID=te.NoteID
			inner join core.Account acc on acc.AccountID=n.Account_AccountID
			left join core.Analysis sc on sc.AnalysisID = te.AnalysisID			
			LEFT JOIN
			(
				Select Noteid,Date,LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage
				from(
					select 
					te.Noteid,
					te.[Date] ,
					te.Amount,
					te.[Type] ValueType
					from  CRE.TransactionEntry te 
					inner join Cre.Note n on n.NoteID=te.NoteID
					inner join core.Account acc on acc.AccountID=n.Account_AccountID
					left join core.Analysis sc on sc.AnalysisID = te.AnalysisID
					where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
					AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
					AND acc.IsDeleted=0
					AND te.AnalysisID = @ScenarioId
					--AND 1 = ISNULL((Select 0 from cre.FeeSchedulesConfig where ExcludeFromCashflowDownload = 1 and CHARINDEX(Replace(FeeTypeNameText,' ',''), Replace(te.Type,' ','')) = 1),1) 
					AND 1 = ISNULL((Select 0 from cre.FeeSchedulesConfig where ExcludeFromCashflowDownload = 1 and CHARINDEX(Replace(FeeTypeNameText,' ',''), Replace(te.FeeTypeName,' ','')) = 1),1) 
					AND te.type in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage')
				)a
				PIVOT (
				SUM(Amount)
				FOR ValueType in (LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage)
				) pvt

			)tblTr on tblTr.noteid = te.noteid and tblTr.[Date] = te.[Date]
			
			left join cre.transactiontypes tym on LOWER(tym.TransactionName) = LOWER(te.[Type])

			where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
			AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
			AND acc.IsDeleted=0
			AND te.AnalysisID = @ScenarioId			
			--AND 1 = ISNULL((Select 0 from cre.FeeSchedulesConfig where ExcludeFromCashflowDownload = 1 and CHARINDEX(Replace(FeeTypeNameText,' ',''), Replace(te.Type,' ','')) = 1),1) 
			AND 1 = ISNULL((Select 0 from cre.FeeSchedulesConfig where ExcludeFromCashflowDownload = 1 and CHARINDEX(Replace(FeeTypeNameText,' ',''), Replace(te.FeeTypeName,' ','')) = 1),1) 
			AND te.type not in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage')

			and tym.IncludeCashflowDownload = 3
			 and  IIF(@TransactionCategoryName='All CashFlows','1',te.Type)in(SELECT TransactionName FROM #tbltransactioncategory)                 
		)a
		order by a.NoteID,Transdate  asc
	END
	ELSE
	BEGIN

		Declare @tblPertable as table
		(
			Noteid	UNIQUEIDENTIFIER,
			Date	date,
			LIBORPercentage	decimal(28,15),
			PIKInterestPercentage	decimal(28,15),
			SpreadPercentage	decimal(28,15),
			PIKLiborPercentage decimal(28,15)
		)

		INSERT INTO @tblPertable (Noteid,Date,LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage)
		Select Noteid,Date,LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage
		from(
			select 
			te.Noteid,
			te.[Date] ,
			te.Amount,
			te.[Type] ValueType
			from  CRE.TransactionEntry te 
			inner join Cre.Note n on n.NoteID=te.NoteID
			inner join core.Account acc on acc.AccountID=n.Account_AccountID
			left join core.Analysis sc on sc.AnalysisID = te.AnalysisID
			where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
			AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
			AND acc.IsDeleted=0
			AND ISNULL(acc.StatusID,1) = 1
			AND te.AnalysisID = @ScenarioId
			--AND 1 = ISNULL((Select 0 from cre.FeeSchedulesConfig where ExcludeFromCashflowDownload = 1 and CHARINDEX(Replace(FeeTypeNameText,' ',''), Replace(te.Type,' ','')) = 1),1) 
			AND 1 = ISNULL((Select 0 from cre.FeeSchedulesConfig where ExcludeFromCashflowDownload = 1 and CHARINDEX(Replace(FeeTypeNameText,' ',''), Replace(te.FeeTypeName,' ','')) = 1),1) 
			AND te.type in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage')
		)a
		PIVOT (
			SUM(Amount)
			FOR ValueType in (LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage)
		) pvt

		--=================
		if object_id('tempdb..#tblcashflow') is not null drop table #tblcashflow 

		CREATE TABLE #tblcashflow( 
		cashflow_autoID int Identity(1,1)  ,   
		Noteid nvarchar(256),
		NoteName nvarchar(256),
		Date date,
		Value decimal(28,5),
		ValueType nvarchar(256),
		Spread decimal(28,11),
		[Index Value] decimal(28,7),
		[Transaction Date] date,
		[Due Date] date,
		[Remit Date] date,
		[Fee Name] nvarchar(256),
		[Description] nvarchar(256),
		[Cash / Non Cash] nvarchar(256)
 
		INDEX index_tblcashflow_cashflow_autoID CLUSTERED(cashflow_autoID)
		)  
		
		INSERT INTO #tblcashflow(
		Noteid,
		NoteName,
		Date,
		Value,
		ValueType,
		Spread,
		[Index Value],
		[Transaction Date],
		[Due Date],
		[Remit Date],
		[Fee Name],
		[Description],
		[Cash / Non Cash]
		)

		---========================================
		Select Noteid,NoteName,
		--LEFT(CONVERT(VARCHAR, TransDate, 101), 10) AS [Date],
		cast((CASE WHEN IsFeeTransaction = 1 THEN LEFT(CONVERT(VARCHAR, ISNULL(TransactionDateByRule,TransDate), 101), 10) 
			ELSE LEFT(CONVERT(VARCHAR, TransDate, 101), 10)
		END) as date) AS [Date],
		cast(Round(Value,5)as decimal(28,5)) as Value,
		ValueType,
		cast(SpreadPercentage as decimal(28,11)) [Spread], -- [Cash Interest Spread], --[Rate Or Spread %] 
		--ISNULL(PIKInterestPercentage,'') [Additional PIK Spread], --[PIK Interest %],
		cast(LIBORPercentage as decimal(28,7)) as [Index Value], -- [Index %],
		cast(LEFT(CONVERT(VARCHAR,TransactionDateServicingLog, 101), 10)as date) as [Transaction Date],
		cast(LEFT(CONVERT(VARCHAR,TransDate, 101), 10)as date) as [Due Date],
		cast(LEFT(CONVERT(VARCHAR,RemitDate, 101), 10) as date) as [Remit Date],
		ISNULL(FeeName,'') as [Fee Name],
		ISNULL(Comment,'') as [Description],
		iSNULL(tr_Cash_NonCash,'') as [Cash / Non Cash]
		--(CASE WHEN EnableM61Calculations = 3 THEN 
		--	(CASE WHEN ValueType = 'FundingOrRepayment' and ISNULL(PurposeType,'') in ('Capitalized Interest','Note Transfer') THEN 'Non-Cash'
		--	WHEN ValueType = 'FundingOrRepayment' and ISNULL(PurposeType,'') not in ('Capitalized Interest','Note Transfer') and Value < 0 THEN 'Funding'
		--	WHEN ValueType = 'FundingOrRepayment' and ISNULL(PurposeType,'') not in ('Capitalized Interest','Note Transfer') and Value > 0 THEN 'Repayment'
		--	ELSE Mst_Cash_NonCash END
		--	)
		--ELSE
		--	(CASE WHEN (ValueType = 'FundingOrRepayment' and manual_Cash_NonCash is not null) THEN manual_Cash_NonCash
		--	WHEN (ValueType = 'FundingOrRepayment' and manual_Cash_NonCash is null and Value < 0) THEN 'Funding'
		--	WHEN (ValueType = 'FundingOrRepayment' and manual_Cash_NonCash is null and Value > 0) THEN 'Repayment'
		--	ELSE Mst_Cash_NonCash END
		--	)
		--END
		--) as [Cash / Non Cash]
		 
		
		from
		(
			select 
			n.CRENoteID Noteid,
			acc.Name NoteName,
			te.[Date] AS [TransDate],
			te.Amount Value,
			te.[Type] ValueType,
			(case 
			when te.[Type] = 'InterestPaid' then Cast(tblTr.LIBORPercentage as nvarchar(256))
			when te.[Type] = 'StubInterest' then Cast(n.InitialIndexValueOverride as nvarchar(256))
			when te.[Type] in ('PIKInterest','PIKInterestPaid') then Cast(tblTr.PIKLiborPercentage as nvarchar(256))
			else null end) as LIBORPercentage,
			(case when te.[Type] = 'PIKInterest' then Cast(tblTr.PIKInterestPercentage as nvarchar(256)) else '' end) as PIKInterestPercentage,
			
			(case 
			when te.[Type] in ('InterestPaid','StubInterest') then Cast(tblTr.SpreadPercentage as nvarchar(256)) 
			when te.[Type] in ('PIKInterest','PIKInterestPaid') then Cast(tblTr.PIKInterestPercentage as nvarchar(256))   
			else null 
			end
			) as SpreadPercentage,
			
			TransactionDateByRule,
			TransactionDateServicingLog,
			(CASE
				WHEN (Select Count(TransType) from @tblTranType where CHARINDEX(Replace(TransType,' ',''),Replace(te.[Type],' ','')) = 1) > 0 THEN 1
				ELSE 0 END
			) as IsFeeTransaction,
			te.RemitDate,
			tym.TransactionCategory,
			te.FeeName,
			te.Comment,
			te.PurposeType,
			n.EnableM61Calculations,
			tym.Cash_NonCash as Mst_Cash_NonCash,
			te.Cash_NonCash as manual_Cash_NonCash,
			te.Cash_NonCash as tr_Cash_NonCash
			from  CRE.TransactionEntry te 
			inner join Cre.Note n on n.NoteID=te.NoteID
			inner join core.Account acc on acc.AccountID=n.Account_AccountID
			left join core.Analysis sc on sc.AnalysisID = te.AnalysisID
			LEFT JOIN
			(
				Select Noteid,Date,LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage from @tblPertable

			)tblTr on tblTr.noteid = te.noteid and tblTr.[Date] = te.[Date]
			left join cre.transactiontypes tym on LOWER(tym.TransactionName) = LOWER(te.[Type])

			where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
			AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
			AND acc.IsDeleted=0

			AND te.AnalysisID = @ScenarioId
			AND ISNULL(acc.StatusID,1) = 1
			--AND 1 = ISNULL((Select 0 from cre.FeeSchedulesConfig where ExcludeFromCashflowDownload = 1 and CHARINDEX(Replace(FeeTypeNameText,' ',''), Replace(te.Type,' ','')) = 1),1) 
			AND 1 = ISNULL((Select 0 from cre.FeeSchedulesConfig where ExcludeFromCashflowDownload = 1 and CHARINDEX(Replace(FeeTypeNameText,' ',''), Replace(te.FeeTypeName,' ','')) = 1),1) 
			AND te.type not in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage')
			and tym.IncludeCashflowDownload = 3
			and  IIF(@TransactionCategoryName='All CashFlows','1',te.Type)in(SELECT TransactionName FROM #tbltransactioncategory)                 
		)a
		--order by a.NoteID,Transdate  asc


		Select Noteid,NoteName,Date,Value,ValueType,Spread,[Index Value],[Transaction Date],[Due Date],[Remit Date],[Fee Name],[Description],[Cash / Non Cash] 
		from #tblcashflow
		order by NoteID,[Due Date] 


	END
	DROP TABLE #tbltransactioncategory;  
END

	 
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	
	
END
GO

