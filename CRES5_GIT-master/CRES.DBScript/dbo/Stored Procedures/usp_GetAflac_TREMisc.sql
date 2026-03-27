-- Procedure
---[dbo].[usp_GetAflac_TREMisc]  '{"Date":"11/30/2023"}' 
  
CREATE Procedure [dbo].[usp_GetAflac_TREMisc]  
(  
  @JsonReportParamters NVARCHAR(MAX)=null  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
 /*--read paramter from the json  
 DECLARE @SheetName NVARCHAR(256),  
   @SheetJsonParamters NVARCHAR(MAX),  
   @SheetJsonParamtersRoot NVARCHAR(MAX),  
   @Client_ID NVARCHAR(10),@SOURCE NVARCHAR(10)  
   
 Select @SheetName=SheetName From App.ReportFileSheet where ReportFileSheetID=2  
   
 SELECT @SheetJsonParamters=[value]  
    FROM OPENJSON (@JsonReportParamters,'$.Root') where [key]=@SheetName  
 print @SheetJsonParamters  
 IF (@SheetJsonParamters IS NOT NULL)  
 BEGIN  
     select @Client_ID=value from OPENJSON(@SheetJsonParamters) where [key]='CLIENT_ID'  
     select @SOURCE=value from OPENJSON(@SheetJsonParamters) where [key]='SOURCE'  
 END  
 --  
 */  
-- --US Eastern time zone  
-- declare @TimeZoneName nvarchar(256)='US Eastern Standard Time'  
-- declare @currentdatetime datetime = [dbo].[ufn_GetTimeByTimeZoneName](getdate(),@TimeZoneName)  
  
----- SET @currentdatetime = '05/05/2021'  



	--===============================================
	If(OBJECT_ID('tempdb..#tempReadJsonData') Is Not Null)
		Drop Table #tempReadJsonData
	
	CREATE TABLE #tempReadJsonData(Date date)
	INSERT INTO #tempReadJsonData (Date)
	SELECT * FROM OPENJSON(@JsonReportParamters)  WITH (Date Date '$.Date');

	declare @currentdatetime datetime	
	SET @currentdatetime = (Select date from #tempReadJsonData);
	--=============================================== 

  
	DECLARE @transactionType as table(  
	[type] nvarchar(256),  
	--sub_trans_type nvarchar(256),  
	[value] nvarchar(256)  
	)  
	Insert into @transactionType ([type],[value]) --sub_trans_type
	Select [TransactionName],RP_Mics_Comment from  [CRE].[TransactionTypes]   ---DecodeName
	--==============================

	If(OBJECT_ID('tempdb..#tbltransactionentry') Is Not Null)
		Drop Table #tbltransactionentry

	CREATE TABLE #tbltransactionentry
	(
		NoteID UNIQUEIDENTIFIER,
		[type] nvarchar(256),
		Date date,
		Amount  decimal(28,15),
		Analysisid UNIQUEIDENTIFIER,
		remitdate date,
		PurposeType nvarchar(256),
		DecodeName nvarchar(256)
	)
	INSERT INTO #tbltransactionentry (noteid,[type],date,Amount,Analysisid,remitdate,PurposeType,DecodeName)

	Select n.noteid,tr.[Type],tr.date,tr.amount,tr.Analysisid,remitdate,tr.PurposeType,tr.DecodeName
	from cre.transactionentry tr
	Inner Join core.account acc on acc.accountid = tr.accountid
	inner join cre.note n on n.account_accountid = acc.AccountID
	join cre.FinancingSourcemaster fn on fn.FinancingSourcemasterID = n.FinancingSourceID	
	where acc.IsDeleted = 0 and acc.AccountTypeID = 1
	and fn.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio','TRE ACR Series II Portfolio')
	and ISNUMERIC(n.crenoteid) = 1	
	and tr.[Type] in (
		'AcoreOriginationFeeExcludedFromLevelYield',
		'PIKInterest',
		'Purchased Interest',
		'StubInterest',

		'AdditionalFeesExcludedFromLevelYield',
		'ExitFeeExcludedFromLevelYield',
		'ExitFeeStrippingExcldfromLevelYield',
		'ExitFeeStripReceivable',
		'ExtensionFeeExcludedFromLevelYield',
		'ExtensionFeeStrippingExcldfromLevelYield',
		'ExtensionFeeStripReceivable',
		'FloatInterest',
		'InterestPaid',
		'ManagementFee',
		'OriginationFeeIncludedInLevelYield',
		'OriginationFeeStripping',
		'OriginationFeeStripReceivable',
		'OtherFeeExcludedFromLevelYield',
		'PIKInterestPaid',
		'PrepaymentFeeExcludedFromLevelYield',
		'UnusedFeeExcludedFromLevelYield'
	)
	and tr.analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	--===============================================


Select * from( 
	Select 
	PORTFOLIO as [Portfolio Name],
	CURRENCY as Currency,
	CUSIP as [Client ID],
	'' as [BBH ID],
	CONVERT(varchar, getdate(),12) + FORMAT(ROW_NUMBER() over(order by PORTFOLIO),'D3') as [External ID],
	SETTLE_DATE as [Settle Date],
	SUB_TRAN_TYPE as [Sub Transaction Type],
	ISNULL([Other Fees],0) as [Fees],
	TRADE_DATE as [Trade Date],
	ISNULL(INTEREST  ,'') as [Interest],
	ISNULL(PRINCIPAL ,'') as Principal,
	ISNULL(COMMISSION,'') as Commission,
	COMMENTS as Comment
	--TRAN_TYPE,
	--AUTHORIZED_BY,
	--CONFIRMED_BY
	From( 

		Select   
		(CASE WHEN fs.FinancingSourceName = 'TRE ACR Portfolio' THEN 'JPDACRCSH' WHEN fs.FinancingSourceName = 'TRE ACR Series II Portfolio' THEN 'JPDACRCSH2' ELSE 'USDACRCSH' END) as PORTFOLIO,      
		lcurrency.name as CURRENCY,  
		'ACR' + FORMAT(CAST(n.crenoteid as int),'D6') as CUSIP,  
		CONVERT(nvarchar(256), @currentdatetime,110) as SETTLE_DATE,  
		ISNULL(tr.DecodeName,'LIB_INT') as SUB_TRAN_TYPE,  
		CONVERT(nvarchar(256), @currentdatetime,110) as TRADE_DATE,  
		'MISC' as TRAN_TYPE,  
		null as COMMISSION,  
		(CASE When tr.type in ('InterestPaid','StubInterest') then FORMAT(tr.amount,'#,0.00')  else null end) as INTEREST,   
		null as PRINCIPAL,  
		(CASE When tr.type not in ('InterestPaid','StubInterest') then FORMAT(tr.amount,'#,0.00') else null end) as [Other Fees],   
		'RK' as AUTHORIZED_BY, 
		(CASE WHEN temptr.[Type] in ('AcoreOriginationFeeExcludedFromLevelYield') THEN ISNULL(temptr.[value],'INTEREST PAYMENT') ELSE ISNULL(temptr.[value],'INTEREST PAYMENT') END) as COMMENTS,   ----UPPER(d.dealname) + ' ' + UPPER(acc.name) +' '+ 
		'RK' as CONFIRMED_BY  

		from #tbltransactionentry tr   
		Inner join cre.Note n  on n.noteid = tr.noteid
		inner join cre.Deal d on d.dealid = n.dealid  
		inner join core.account acc on acc.accountid = n.account_accountid  
		left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and ParentID = 29 
		left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID 
		join @transactionType temptr on tr.[Type]=temptr.[type] 

		where tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'   
		and tr.type in ('InterestPaid','ExitFeeExcludedFromLevelYield','PrepaymentFeeExcludedFromLevelYield','FloatInterest',		
		'AdditionalFeesExcludedFromLevelYield',
		'ExitFeeExcludedFromLevelYield',
		'ExitFeeStrippingExcldfromLevelYield',
		'ExitFeeStripReceivable',
		'ExtensionFeeExcludedFromLevelYield',
		'ExtensionFeeStrippingExcldfromLevelYield',
		'ExtensionFeeStripReceivable',
		'FloatInterest',
		'InterestPaid',
		'OriginationFeeIncludedInLevelYield',
		'OriginationFeeStripping',
		'OriginationFeeStripReceivable',
		'OtherFeeExcludedFromLevelYield',
		'PIKInterestPaid',
		'PrepaymentFeeExcludedFromLevelYield',
		'UnusedFeeExcludedFromLevelYield')  
		and tr.Remitdate = Cast(@currentdatetime as Date)
		and n.noteid in (  
			Select nn.noteid from cre.note nn  
			inner join core.account acc1 on acc1.accountid = nn.account_accountid  
			left join cre.FinancingSourcemaster fs1 on fs1.FinancingSourcemasterID = nn.FinancingSourceID  
			where acc1.IsDeleted <> 1 and ISNUMERIC(nn.crenoteid) = 1 and fs1.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio','TRE ACR Series II Portfolio')  
		)  
		and acc.IsDeleted <> 1  
		and ISNUMERIC(n.crenoteid) = 1   
		and fs.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio','TRE ACR Series II Portfolio') 

		UNION ALL

		Select   
		(CASE WHEN fs.FinancingSourceName = 'TRE ACR Portfolio' THEN 'JPDACRCSH' WHEN fs.FinancingSourceName = 'TRE ACR Series II Portfolio' THEN 'JPDACRCSH2' ELSE 'USDACRCSH' END) as PORTFOLIO,  
		lcurrency.name as CURRENCY,  
		'ACR' + FORMAT(CAST(n.crenoteid as int),'D6') as CUSIP,  
		CONVERT(varchar, @currentdatetime,110) as SETTLE_DATE, 
		--ISNULL(temptr.sub_trans_type,'LIB_INT') as SUB_TRAN_TYPE,
		ISNULL(tr.DecodeName,'LIB_INT') as SUB_TRAN_TYPE,
		CONVERT(varchar, tr.Date,110) as TRADE_DATE,  
		'MISC' as TRAN_TYPE,  
		null as COMMISSION,  
		null as INTEREST,   
		null as PRINCIPAL,  
		FORMAT(tr.amount,'#,0.00') as [Other Fees],   
		'RK' as AUTHORIZED_BY, 
		temptr.[value] as COMMENTS,
		'RK' as CONFIRMED_BY  
		from #tbltransactionentry tr   
		Inner join cre.Note n  on n.noteid = tr.noteid
		inner join cre.Deal d on d.dealid = n.dealid  
		inner join core.account acc on acc.accountid = n.account_accountid  
		left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and ParentID = 29 
		left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID 
		join @transactionType temptr on tr.[Type]=temptr.[type] 

		where tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'   
		and tr.type in (
		'PIKInterest',
		'Purchased Interest',
		'StubInterest') 

		and tr.date = Cast(@currentdatetime as Date)
		and n.noteid in (  
			Select nn.noteid from cre.note nn  
			inner join core.account acc1 on acc1.accountid = nn.account_accountid  
			left join cre.FinancingSourcemaster fs1 on fs1.FinancingSourcemasterID = nn.FinancingSourceID  
			where acc1.IsDeleted <> 1 and ISNUMERIC(nn.crenoteid) = 1 and fs1.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio','TRE ACR Series II Portfolio')  
		)  
		and acc.IsDeleted <> 1  
		and ISNUMERIC(n.crenoteid) = 1   
		and fs.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio','TRE ACR Series II Portfolio')  

		UNION ALL

		Select   
		(CASE WHEN fs.FinancingSourceName = 'TRE ACR Portfolio' THEN 'JPDACRCSH' WHEN fs.FinancingSourceName = 'TRE ACR Series II Portfolio' THEN 'JPDACRCSH2' ELSE 'USDACRCSH' END) as PORTFOLIO,  
		lcurrency.name as CURRENCY,  
		'ACR' + FORMAT(CAST(n.crenoteid as int),'D6') as CUSIP,  
		CONVERT(varchar, @currentdatetime,110) as SETTLE_DATE, 
		--ISNULL(temptr.sub_trans_type,'LIB_INT') as SUB_TRAN_TYPE, 
		ISNULL(tr.DecodeName,'LIB_INT') as SUB_TRAN_TYPE,
		CONVERT(varchar, tr.Date,110) as TRADE_DATE,  
		'MISC' as TRAN_TYPE,  
		null as COMMISSION,  
		null as INTEREST,   
		null as PRINCIPAL,  
		FORMAT(tr.amount,'#,0.00') as [Other Fees],   
		'RK' as AUTHORIZED_BY, 
		temptr.[value] as COMMENTS,
		'RK' as CONFIRMED_BY  
		from #tbltransactionentry tr   
		Inner join cre.Note n  on n.noteid = tr.noteid
		inner join cre.Deal d on d.dealid = n.dealid  
		inner join core.account acc on acc.accountid = n.account_accountid  
		left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and ParentID = 29 
		left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID 
		join @transactionType temptr on tr.[Type]=temptr.[type] 

		where tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'   
		and tr.type in ('ManagementFee' )  
		and tr.Remitdate = Cast(@currentdatetime as Date)
		and n.noteid in (  
			Select nn.noteid from cre.note nn  
			inner join core.account acc1 on acc1.accountid = nn.account_accountid  
			left join cre.FinancingSourcemaster fs1 on fs1.FinancingSourcemasterID = nn.FinancingSourceID  
			where acc1.IsDeleted <> 1 and ISNUMERIC(nn.crenoteid) = 1 and fs1.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio','TRE ACR Series II Portfolio')  
		)  
		and acc.IsDeleted <> 1  
		and ISNUMERIC(n.crenoteid) = 1   
		and fs.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio','TRE ACR Series II Portfolio')  

		UNION ALL

		Select   
		(CASE WHEN fs.FinancingSourceName = 'TRE ACR Portfolio' THEN 'JPDACRCSH' WHEN fs.FinancingSourceName = 'TRE ACR Series II Portfolio' THEN 'JPDACRCSH2' ELSE 'USDACRCSH' END) as PORTFOLIO,  
		lcurrency.name as CURRENCY,  
		'ACR' + FORMAT(CAST(n.crenoteid as int),'D6') as CUSIP,  
		CONVERT(varchar, @currentdatetime,110) as SETTLE_DATE, 
		--ISNULL(temptr.sub_trans_type,'LIB_INT') as SUB_TRAN_TYPE, 
		ISNULL(tr.Decodename,'LIB_INT') as SUB_TRAN_TYPE, 
		CONVERT(varchar, tr.Date,110) as TRADE_DATE,  
		'MISC' as TRAN_TYPE,  
		null as COMMISSION,  
		null as INTEREST,   
		null as PRINCIPAL,  
		FORMAT(tr.amount,'#,0.00') as [Other Fees],   
		'RK' as AUTHORIZED_BY, 
		temptr.[value] as COMMENTS,
		'RK' as CONFIRMED_BY  
		from #tbltransactionentry tr   
		Inner join cre.Note n  on n.noteid = tr.noteid
		inner join cre.Deal d on d.dealid = n.dealid  
		inner join core.account acc on acc.accountid = n.account_accountid  
		left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and ParentID = 29 
		left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID 
		join @transactionType temptr on tr.[Type]=temptr.[type] 

		where tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'   
		and tr.type in ('AcoreOriginationFeeExcludedFromLevelYield' )  
		and tr.date = Cast(@currentdatetime as Date)
		and n.noteid in (  
			Select nn.noteid from cre.note nn  
			inner join core.account acc1 on acc1.accountid = nn.account_accountid  
			left join cre.FinancingSourcemaster fs1 on fs1.FinancingSourcemasterID = nn.FinancingSourceID  
			where acc1.IsDeleted <> 1 and ISNUMERIC(nn.crenoteid) = 1 and fs1.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio','TRE ACR Series II Portfolio')  
		)  
		and acc.IsDeleted <> 1  
		and ISNUMERIC(n.crenoteid) = 1   
		and fs.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio','TRE ACR Series II Portfolio')  
	)y
)z
 order by z.[External ID]   ---z.SUB_TRAN_TYPE  --,CAST(n.crenoteid as int)  
  
  
   
  
END  