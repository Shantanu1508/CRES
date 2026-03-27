--[dbo].[usp_GetNoteCashflowsExportData] '7dfb18a5-65f9-43fb-8976-e11612bd34ea','00000000-0000-0000-0000-000000000000','c10f3372-0fc2-4861-a9f5-148f1f80804f','','00000000-0000-0000-0000-000000000000',0,0,null
--[dbo].[usp_GetNoteCashflowsExportData] '00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000','c10f3372-0fc2-4861-a9f5-148f1f80804f',null,null,0,0,null
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


IF OBJECT_ID('tempdb..#tbltransactioncategory') IS NOT NULL         
	DROP TABLE #tbltransactioncategory

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

	IF OBJECT_ID('tempdb..#tblListNotes') IS NOT NULL         
		DROP TABLE #tblListNotes

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


	IF OBJECT_ID('tempdb..#tmpTransactionEntry') IS NOT NULL         
	DROP TABLE #tmpTransactionEntry

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
	  tr_Cash_NonCash nVARCHAR(256),
	  AdjustmentType nvarchar(256),
	  AllInCouponRate decimal(28,15),
	  AccountingCloseDate Date,
	  IndexValue  DECIMAL(28,15) NULL,
		SpreadValue  DECIMAL(28,15) NULL,
		OriginalIndex  DECIMAL(28,15) NULL,
	   
	)
	

	INSERT INTO #tmpTransactionEntry(NoteID, Name,CRENoteID, AnalysisID, [Date], Amount, [Type],TransactionDateByRule,TransactionDateServicingLog,IsFeeTransaction,RemitDate,TransactionCategory,[FeeName],[Comment],PurposeType,Mst_Cash_NonCash,manual_Cash_NonCash,tr_Cash_NonCash,AdjustmentType ,AllInCouponRate,AccountingCloseDate,IndexValue,SpreadValue,OriginalIndex) --
	SELECT 
	n.NoteID,
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
	te.Cash_NonCash as tr_Cash_NonCash,
	te.AdjustmentType,
	te.AllInCouponRate,
	te.AccountingCloseDate,
	te.IndexValue,
	te.SpreadValue,
	te.OriginalIndex
	FROm CRE.TransactionEntry te
	inner join core.Account acc on acc.AccountID=te.AccountID		
	inner join Cre.Note n on n.Account_accountid=te.AccountID

	left join cre.transactiontypes tym on LOWER(tym.TransactionName) = LOWER(te.[Type])
	WHERE AnalysisID = @ScenarioId
	AND acc.IsDeleted=0
	AND acc.StatusID <> 2
	AND n.CRENoteID in (select CRENoteID from #tblListNotes)
	--AND 1 = ISNULL((Select 0 from cre.FeeSchedulesConfig where ExcludeFromCashflowDownload = 1 and CHARINDEX(Replace(FeeTypeNameText,' ',''), Replace(te.Type,' ','')) = 1),1) 
	AND 1 = ISNULL((Select 0 from cre.FeeSchedulesConfig where ExcludeFromCashflowDownload = 1 and CHARINDEX(Replace(FeeTypeNameText,' ',''), Replace(te.FeeTypeName,' ','')) = 1),1) 
	and tym.IncludeCashflowDownload = 3
	
	--AND te.type in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage')

 

	 
	Select 	DealName as [Deal Name]
	,DealID as [Deal ID]
	,Noteid as [Note Id]
	,NoteName as [Note Name]
	,cast((CASE WHEN IsFeeTransaction = 1 THEN LEFT(CONVERT(VARCHAR, ISNULL(TransactionDateByRule,TransDate), 101), 10) 
		ELSE LEFT(CONVERT(VARCHAR, TransDate, 101), 10)
	END)as date) AS [Date],
	cast(Round(Value,5)as decimal(28,5)) as [Value]
	,ValueType as [Value Type]
	,cast(SpreadPercentage as decimal(28,11)) [Spread], ---[Cash Interest Spread], --[Rate Or Spread %] 
	--ISNULL(PIKInterestPercentage,'') [Additional PIK Spread], --[PIK Interest %],
		cast(RawIndexPercentage as decimal(28,7)) as [Original Index],
	cast(LIBORPercentage as decimal(28,7)) as [Index Value], -- [Index %],

	cast(AllInCouponRate as decimal(28,11)) as [Effective Rate],
	cast(LEFT(CONVERT(VARCHAR,TransactionDateServicingLog, 101), 10)as date) as [Transaction Date],
	cast(LEFT(CONVERT(VARCHAR,TransDate, 101), 10)as date) as [Due Date],
	cast(LEFT(CONVERT(VARCHAR,RemitDate, 101), 10)as date) as [Remit Date],
	cast(LEFT(CONVERT(VARCHAR,AccountingCloseDate, 101), 10)as date) as [Accounting Close Date],
	ISNULL(FeeName,'') as [Fee Name],
	ISNULL(Comment,'') as [Description],
	tr_Cash_NonCash as [Cash / Non Cash],
	AdjustmentType as [Adjustment Type],
	PurposeType as [Purpose Type]
	
	
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
		d.dealname as DealName,
		d.CREDealId as DealID,
		te.CRENoteID Noteid,
		te.Name NoteName,
		te.[Date] AS [TransDate],
		te.Amount Value,
		te.[Type] ValueType,
		/*(case 
		when te.[Type] in ( 'InterestPaid','StubInterest' ) then Cast(tblTr.LIBORPercentage as varchar(256))
		--when (te.[Type] = 'StubInterest' and  n.RateType = 140)  then Cast(n.InitialIndexValueOverride as varchar(256))
		when te.[Type] in ('PIKInterest','PIKInterestPaid','PIKPrincipalFunding') then Cast(tblTr.PIKLiborPercentage as nvarchar(256))
		else null end) as LIBORPercentage,

		(case when te.[Type] = 'PIKInterest' then Cast(tblTr.PIKInterestPercentage as varchar(256)) else '' end) as PIKInterestPercentage,

		(case 
			when te.[Type] in ('InterestPaid','StubInterest') then Cast(tblTr.SpreadPercentage as nvarchar(256)) 
			when te.[Type] in ('PIKInterest','PIKInterestPaid','PIKPrincipalFunding') then Cast(tblTr.PIKInterestPercentage as nvarchar(256))   
			else null 
			end
			) as SpreadPercentage,
		*/
		 te.IndexValue as LIBORPercentage,
		 NULL as PIKInterestPercentage,
		 te.SpreadValue as SpreadPercentage,
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
		te.tr_Cash_NonCash,
		ROW_number() over(order by d.dealname,te.CRENoteID,te.Date) rno,
		te.AdjustmentType,
		te.AllInCouponRate,
		/*
		(case when te.[Type] in ( 'InterestPaid','StubInterest' ) then Cast(tblTr.RawIndexPercentage  as nvarchar(256)) 
		when te.[Type] in ('PIKInterest','PIKInterestPaid','PIKPrincipalFunding') then Cast(tblTr.RawPIKIndexPercentage as nvarchar(256))
		else null end) as RawIndexPercentage,
		*/
		
		te.OriginalIndex as RawIndexPercentage,
		te.AccountingCloseDate	

		from  #tmpTransactionEntry te 
		inner join Cre.Note n on n.NoteID=te.NoteID
		inner join cre.deal d on d.dealid = n.dealid
		/*
		LEFT JOIN
		(
			Select Noteid,Date,LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage,RawIndexPercentage,RawPIKIndexPercentage
			from(
				select 
				te.Noteid,
				te.[Date] ,
				te.Amount,
				te.[Type] ValueType
				from  #tmpTransactionEntry te 		
				where te.type in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage','RawIndexPercentage','RawPIKIndexPercentage')
			)a
			PIVOT (
			SUM(Amount)
			FOR ValueType in (LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage,RawIndexPercentage,RawPIKIndexPercentage)
			) pvt
		)tblTr on tblTr.noteid = te.noteid and tblTr.[Date] = te.[Date]
		*/
		where te.type not in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage','RawIndexPercentage','RawPIKIndexPercentage')
		 and  IIF(@TransactionCategoryName='All CashFlows','1',te.Type)in(SELECT TransactionName FROM #tbltransactioncategory)                 
	)a
	Order by rno
	--order by a.NoteID,Transdate  asc

	--DROP TABLE #tblListNotes;
	--DROP TABLE #tmpTransactionEntry;
END
ELSE
BEGIN
	IF(@NoteId <> '00000000-0000-0000-0000-000000000000')
	BEGIN

		Select 	DealName as [Deal Name]
		,DealID as [Deal ID]
		,Noteid as [Note Id]
		,NoteName as [Note Name]
		--LEFT(CONVERT(VARCHAR, TransDate, 101), 10) AS [Date],
		,CAST((CASE WHEN IsFeeTransaction = 1 THEN LEFT(CONVERT(VARCHAR, ISNULL(TransactionDateByRule,TransDate), 101), 10) 
			ELSE LEFT(CONVERT(VARCHAR, TransDate, 101), 10)
		END)as date) AS [Date],
		cast(Round(Value,5)as decimal(28,5)) as Value
		,ValueType as [Value Type]
		,cast(SpreadPercentage as decimal(28,11)) [Spread], --[Cash Interest Spread], --[Rate Or Spread %] 
		--ISNULL(PIKInterestPercentage,'') [Additional PIK Spread], --[PIK Interest %],		
		cast(RawIndexPercentage as decimal(28,7)) as [Original Index],
		cast(LIBORPercentage as decimal(28,7)) as [Index Value], -- [Index %],
		
		cast(AllInCouponRate as decimal(28,11)) as [Effective Rate],
		CAST(LEFT(CONVERT(VARCHAR,TransactionDateServicingLog, 101), 10)as date) as [Transaction Date],
		CAST(LEFT(CONVERT(VARCHAR,TransDate, 101), 10)as date) as [Due Date],
		CAST(LEFT(CONVERT(VARCHAR,RemitDate, 101), 10)as date) as [Remit Date],
		CAST(LEFT(CONVERT(VARCHAR,AccountingCloseDate, 101), 10)as date) as [Accounting Close Date],
		ISNULL(FeeName,'') as [Fee Name],
		ISNULL(Comment,'') as [Description],
		
		tr_Cash_NonCash as [Cash / Non Cash],
		AdjustmentType as [Adjustment Type],
		PurposeType as [Purpose Type]

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
			d.dealname as DealName,
			d.CREDealId as DealID,
			n.CRENoteID Noteid,
			acc.Name NoteName,
			te.[Date] AS [TransDate],
			te.Amount Value,
			te.[Type] ValueType,
			/*(case 
			when te.[Type] in ( 'InterestPaid','StubInterest' ) then Cast(tblTr.LIBORPercentage as nvarchar(256))
			--when (te.[Type] = 'StubInterest' and  n.RateType = 140)  then Cast(n.InitialIndexValueOverride as nvarchar(256))
			when te.[Type] in ('PIKInterest','PIKInterestPaid','PIKPrincipalFunding') then Cast(tblTr.PIKLiborPercentage as nvarchar(256))
			else null end) as LIBORPercentage,
			(case when te.[Type] = 'PIKInterest' then Cast(tblTr.PIKInterestPercentage as nvarchar(256)) else '' end) as PIKInterestPercentage,
			(case 
			when te.[Type] in ('InterestPaid','StubInterest') then Cast(tblTr.SpreadPercentage as nvarchar(256)) 
			when te.[Type] in ('PIKInterest','PIKInterestPaid','PIKPrincipalFunding') then Cast(tblTr.PIKInterestPercentage as nvarchar(256))   
			else null 
			end
			) as SpreadPercentage,
			*/
			te.IndexValue as LIBORPercentage,
			 NULL as PIKInterestPercentage,
			 te.SpreadValue as SpreadPercentage,
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
			te.Cash_NonCash as tr_Cash_NonCash,
			te.AdjustmentType,
			te.AllInCouponRate,
			/*
			(case when te.[Type] in ( 'InterestPaid','StubInterest' ) then Cast(tblTr.RawIndexPercentage  as nvarchar(256)) 
			when te.[Type] in ('PIKInterest','PIKInterestPaid','PIKPrincipalFunding') then Cast(tblTr.RawPIKIndexPercentage as nvarchar(256))
			else null end) as RawIndexPercentage,
			*/
			te.OriginalIndex as RawIndexPercentage,
			
			AccountingCloseDate	
			from  CRE.TransactionEntry te 
			inner join core.Account acc on acc.AccountID=te.AccountID		
			inner join Cre.Note n on n.Account_accountid=te.AccountID
			inner join cre.deal d on d.dealid = n.dealid
			left join core.Analysis sc on sc.AnalysisID = te.AnalysisID			
			/*LEFT JOIN
			(
				Select Noteid,Date,LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage,RawIndexPercentage,RawPIKIndexPercentage
				from(
					select 
					n.Noteid,
					te.[Date] ,
					te.Amount,
					te.[Type] ValueType
					from  CRE.TransactionEntry te 
					inner join core.Account acc on acc.AccountID=te.AccountID		
					inner join Cre.Note n on n.Account_accountid=te.AccountID
					left join core.Analysis sc on sc.AnalysisID = te.AnalysisID
					where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
					AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
					AND acc.IsDeleted=0
					AND te.AnalysisID = @ScenarioId
					--AND 1 = ISNULL((Select 0 from cre.FeeSchedulesConfig where ExcludeFromCashflowDownload = 1 and CHARINDEX(Replace(FeeTypeNameText,' ',''), Replace(te.Type,' ','')) = 1),1) 
					AND 1 = ISNULL((Select 0 from cre.FeeSchedulesConfig where ExcludeFromCashflowDownload = 1 and CHARINDEX(Replace(FeeTypeNameText,' ',''), Replace(te.FeeTypeName,' ','')) = 1),1) 
					AND te.type in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage','RawIndexPercentage','RawPIKIndexPercentage')
				)a
				PIVOT (
				SUM(Amount)
				FOR ValueType in (LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage,RawIndexPercentage,RawPIKIndexPercentage)
				) pvt

			)tblTr on tblTr.noteid = n.noteid and tblTr.[Date] = te.[Date]
			*/

			left join cre.transactiontypes tym on LOWER(tym.TransactionName) = LOWER(te.[Type])

			where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
			AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
			AND acc.IsDeleted=0
			AND te.AnalysisID = @ScenarioId			
			--AND 1 = ISNULL((Select 0 from cre.FeeSchedulesConfig where ExcludeFromCashflowDownload = 1 and CHARINDEX(Replace(FeeTypeNameText,' ',''), Replace(te.Type,' ','')) = 1),1) 
			AND 1 = ISNULL((Select 0 from cre.FeeSchedulesConfig where ExcludeFromCashflowDownload = 1 and CHARINDEX(Replace(FeeTypeNameText,' ',''), Replace(te.FeeTypeName,' ','')) = 1),1) 
			AND te.type not in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage','RawIndexPercentage','RawPIKIndexPercentage')

			and tym.IncludeCashflowDownload = 3
			 and  IIF(@TransactionCategoryName='All CashFlows','1',te.Type)in(SELECT TransactionName FROM #tbltransactioncategory)                 
		)a
		order by a.DealName,a.NoteID,Transdate  asc
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
			PIKLiborPercentage decimal(28,15),
			RawIndexPercentage decimal(28,15),
			RawPIKIndexPercentage decimal(28,15)
		)

		INSERT INTO @tblPertable (Noteid,Date,LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage,RawIndexPercentage,RawPIKIndexPercentage)
		Select Noteid,Date,LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage,RawIndexPercentage,RawPIKIndexPercentage
		from(
			select 
			n.Noteid,
			te.[Date] ,
			te.Amount,
			te.[Type] ValueType
			from  CRE.TransactionEntry te 
			inner join core.Account acc on acc.AccountID=te.AccountID		
			inner join Cre.Note n on n.Account_accountid=te.AccountID

			left join core.Analysis sc on sc.AnalysisID = te.AnalysisID
			where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
			AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
			AND acc.IsDeleted=0
			AND ISNULL(acc.StatusID,1) = 1
			AND te.AnalysisID = @ScenarioId
			--AND 1 = ISNULL((Select 0 from cre.FeeSchedulesConfig where ExcludeFromCashflowDownload = 1 and CHARINDEX(Replace(FeeTypeNameText,' ',''), Replace(te.Type,' ','')) = 1),1) 
			AND 1 = ISNULL((Select 0 from cre.FeeSchedulesConfig where ExcludeFromCashflowDownload = 1 and CHARINDEX(Replace(FeeTypeNameText,' ',''), Replace(te.FeeTypeName,' ','')) = 1),1) 
			AND te.type in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage','RawIndexPercentage','RawPIKIndexPercentage')
		)a
		PIVOT (
			SUM(Amount)
			FOR ValueType in (LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage,RawIndexPercentage,RawPIKIndexPercentage)
		) pvt

		--=================
		if object_id('tempdb..#tblcashflow') is not null 
		Begin	
			drop table #tblcashflow 
		END

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
		[Cash / Non Cash] nvarchar(256),
		AdjustmentType nvarchar(256),
		AllInCouponRate decimal(28,7),
		RawIndexPercentage decimal(28,7),
		AccountingCloseDate Date,
		PurposeType nvarchar(256),
		DealName nvarchar(256),
		DealID nvarchar(256)
 
		CONSTRAINT [PK_cashflow_autoID123] PRIMARY KEY CLUSTERED (cashflow_autoID)
		---INDEX index_tblcashflow_cashflow_autoID CLUSTERED(cashflow_autoID)
		)  
		
		INSERT INTO #tblcashflow(
		DealName ,
		DealID, 
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
		[Cash / Non Cash],
		AdjustmentType,
		AllInCouponRate,
		RawIndexPercentage,
		AccountingCloseDate,
		PurposeType		
		)

		---========================================
		Select 	DealName,
		DealID,
		Noteid,NoteName,
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
		iSNULL(tr_Cash_NonCash,'') as [Cash / Non Cash],
		AdjustmentType as [Adjustment Type],
		cast(AllInCouponRate as decimal(28,7))  as [All In Coupon Rate],
		cast(RawIndexPercentage as decimal(28,7)) as RawIndexPercentage,
		cast(LEFT(CONVERT(VARCHAR,AccountingCloseDate, 101), 10) as date) as [Accounting Close Date],
		iSNULL(PurposeType,'') as PurposeType
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
			d.dealname as DealName,
			d.CREDealId as DealID,
			n.CRENoteID Noteid,
			acc.Name NoteName,
			te.[Date] AS [TransDate],
			te.Amount Value,
			te.[Type] ValueType,
			/*
			(case 
			when te.[Type] in ( 'InterestPaid','StubInterest' ) then Cast(tblTr.LIBORPercentage as nvarchar(256))
			--when (te.[Type] = 'StubInterest' and  n.RateType = 140)  then Cast(n.InitialIndexValueOverride as nvarchar(256))
			when te.[Type] in ('PIKInterest','PIKInterestPaid','PIKPrincipalFunding') then Cast(tblTr.PIKLiborPercentage as nvarchar(256))
			else null end) as LIBORPercentage,
			(case when te.[Type] = 'PIKInterest' then Cast(tblTr.PIKInterestPercentage as nvarchar(256)) else '' end) as PIKInterestPercentage,
			
			(case 
			when te.[Type] in ('InterestPaid','StubInterest') then Cast(tblTr.SpreadPercentage as nvarchar(256)) 
			when te.[Type] in ('PIKInterest','PIKInterestPaid','PIKPrincipalFunding') then Cast(tblTr.PIKInterestPercentage as nvarchar(256))   
			else null 
			end
			) as SpreadPercentage,
			*/
			te.IndexValue as LIBORPercentage,
			 NULL as PIKInterestPercentage,
			 te.SpreadValue as SpreadPercentage,

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
			te.Cash_NonCash as tr_Cash_NonCash,
			te.AdjustmentType,
			te.AllInCouponRate,
			/*
			(case when te.[Type] in ( 'InterestPaid','StubInterest' ) then Cast(tblTr.RawIndexPercentage  as nvarchar(256)) 
			when te.[Type] in ('PIKInterest','PIKInterestPaid','PIKPrincipalFunding') then Cast(tblTr.RawPIKIndexPercentage as nvarchar(256))
			else null end) as RawIndexPercentage,
			*/
		
			te.OriginalIndex as RawIndexPercentage,
			te.AccountingCloseDate	

			from  CRE.TransactionEntry te 
			inner join core.Account acc on acc.AccountID=te.AccountID		
			inner join Cre.Note n on n.Account_accountid=te.AccountID
			inner join cre.deal d on d.dealid = n.dealid
			left join core.Analysis sc on sc.AnalysisID = te.AnalysisID
			/*
			LEFT JOIN
			(
				Select Noteid,Date,LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage,RawIndexPercentage,RawPIKIndexPercentage from @tblPertable

			)tblTr on tblTr.noteid = n.noteid and tblTr.[Date] = te.[Date]
			*/

			left join cre.transactiontypes tym on LOWER(tym.TransactionName) = LOWER(te.[Type])

			where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
			AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
			AND acc.IsDeleted=0

			AND te.AnalysisID = @ScenarioId
			AND ISNULL(acc.StatusID,1) = 1
			--AND 1 = ISNULL((Select 0 from cre.FeeSchedulesConfig where ExcludeFromCashflowDownload = 1 and CHARINDEX(Replace(FeeTypeNameText,' ',''), Replace(te.Type,' ','')) = 1),1) 
			AND 1 = ISNULL((Select 0 from cre.FeeSchedulesConfig where ExcludeFromCashflowDownload = 1 and CHARINDEX(Replace(FeeTypeNameText,' ',''), Replace(te.FeeTypeName,' ','')) = 1),1) 
			AND te.type not in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage','RawIndexPercentage','RawPIKIndexPercentage')
			and tym.IncludeCashflowDownload = 3
			and  IIF(@TransactionCategoryName='All CashFlows','1',te.Type)in(SELECT TransactionName FROM #tbltransactioncategory)                 
		)a
		


		Select 	DealName as [Deal Name]
		,DealID as [Deal ID]
		,Noteid as [Note Id]
		,NoteName as [Note Name]
		,Date
		,Value
		,ValueType as [Value Type]
		,Spread
		,RawIndexPercentage as [Original Index]
		,[Index Value]
		
		,AllInCouponRate as [Effective Rate]
		,[Transaction Date]
		,[Due Date]
		,[Remit Date]
		,AccountingCloseDate as [Accounting Close Date]
		,[Fee Name]
		,[Description]
		,[Cash / Non Cash] 
		,AdjustmentType as [Adjustment Type]
		,PurposeType as [Purpose Type]
		From(
			Select DealName,DealID,Noteid,NoteName,Date,Value,ValueType,Spread,[Index Value],[Transaction Date],[Due Date],[Remit Date],[Fee Name],[Description],[Cash / Non Cash] ,AdjustmentType,AllInCouponRate,RawIndexPercentage,AccountingCloseDate,PurposeType,
			ROW_number() over(order by DealID,Noteid,Date) rno
			from #tblcashflow			
		)a
		order by rno
		--order by NoteID,[Due Date] 


	END
	--DROP TABLE #tbltransactioncategory;  
END

	 
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	
	
END
GO

