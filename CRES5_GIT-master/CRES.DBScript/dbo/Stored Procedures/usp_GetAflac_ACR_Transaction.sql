-- Procedure
---[dbo].[usp_GetAflac_ACR_Transaction]  '{"Date":"12/10/2021"}' 
---[dbo].[usp_GetAflac_ACR_Transaction]  '{"Date":"12/13/2021"}' 
---[dbo].[usp_GetAflac_ACR_Transaction]  '{"Date":"12/11/2020"}'
---[dbo].[usp_GetAflac_ACR_Transaction]  '{"Date":"7/8/2021"}' 
---[dbo].[usp_GetAflac_ACR_Transaction]  '{"Date":"2/11/2022"}' 
---[dbo].[usp_GetAflac_ACR_Transaction]  '{"Date":"6/30/2023"}' 


CREATE Procedure [dbo].[usp_GetAflac_ACR_Transaction]
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
	----US Eastern time zone
	--declare @TimeZoneName nvarchar(256)='US Eastern Standard Time'
	--declare @currentdatetime datetime = [dbo].[ufn_GetTimeByTimeZoneName](getdate(),@TimeZoneName)

--===============================================
If(OBJECT_ID('tempdb..#tempReadJsonData') Is Not Null)
	Drop Table #tempReadJsonData
	
CREATE TABLE #tempReadJsonData(Date date)
INSERT INTO #tempReadJsonData (Date)
SELECT * FROM OPENJSON(@JsonReportParamters)  WITH (Date Date '$.Date');

declare @currentdatetime datetime	
SET @currentdatetime = (Select date from #tempReadJsonData);
--=============================================== 

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
PurposeType nvarchar(256)

)
INSERT INTO #tbltransactionentry (noteid,[type],date,Amount,Analysisid,remitdate,PurposeType)

Select n.noteid,tr.[Type],tr.date,tr.amount,tr.Analysisid,remitdate,tr.PurposeType
from cre.transactionentry tr
Inner Join core.account acc on acc.accountid = tr.accountid
inner join cre.note n on n.account_accountid = acc.AccountID	
--INNER JOIN [CRE].[Note] n ON n.noteid = tr.noteid
--INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
join cre.FinancingSourcemaster fn on fn.FinancingSourcemasterID = n.FinancingSourceID	
where acc.IsDeleted = 0 and acc.AccountTypeID = 1
and fn.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio','TRE ACR Series II Portfolio')
and ISNUMERIC(n.crenoteid) = 1	
and tr.[Type] in ('FundingOrRepayment','Balloon','ScheduledPrincipalPaid','InitialFunding','PIKPrincipalFunding','AcoreOriginationFeeExcludedFromLevelYield','PIKPrincipalPaid')
and tr.analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
--===============================================

If(OBJECT_ID('tempdb..#tblOrigination') Is Not Null)
	Drop Table #tblOrigination

CREATE TABLE #tblOrigination(NoteID UNIQUEIDENTIFIER,Date date,OriginationFee  decimal(28,15))
INSERT INTO #tblOrigination(NoteID,Date,OriginationFee)
select tr.noteid,tr.date,tr.amount as OriginationFee
from #tbltransactionentry tr  
where tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'   
and tr.type in ('AcoreOriginationFeeExcludedFromLevelYield' )  
and tr.date = Cast(@currentdatetime as Date)

--===============================================

If(OBJECT_ID('tempdb..#tblDailyEndingBls') Is Not Null)
	Drop Table #tblDailyEndingBls

CREATE TABLE #tblDailyEndingBls
(
	NoteID UNIQUEIDENTIFIER,
	actualDate date,
	Date date,
	BeginingBalance  decimal(28,15)
)
INSERT INTO #tblDailyEndingBls (noteid,actualDate,date,BeginingBalance)

select di.noteid,di.date as actualDate,@currentdatetime as Date,(CASE WHEN n.initialFundingAmount = 0.01 THEN (isnull(di.EndingBalance,0) - 0.01) ELSE isnull(di.EndingBalance,0) END) as BeginingBalance
from [CRE].[DailyInterestAccruals] di	
inner join (
	select n.noteid,n.initialFundingAmount from [CRE].[Note] n 
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID	
	join cre.FinancingSourcemaster fn on fn.FinancingSourcemasterID = n.FinancingSourceID
	where acc.IsDeleted = 0
	and fn.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio','TRE ACR Series II Portfolio')
	and ISNUMERIC(n.crenoteid) = 1	
)n on n.noteid = di.noteid
where di.analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
--and di.date = dateadd(day,-1,@currentdatetime)

--===============================================

If(OBJECT_ID('tempdb..#tbltransaction_FF') Is Not Null)
	Drop Table #tbltransaction_FF

CREATE TABLE #tbltransaction_FF
(NoteID UNIQUEIDENTIFIER,
Date date,
Amount  decimal(28,15),
Maturity date,	
[Type]	nvarchar(256),
Amt_NotOnMaturity	int,
Amt_OnMaturity	int,
FF_Decode int,
PurposeType nvarchar(256)
)
INSERT INTO #tbltransaction_FF (noteid,date,amount,Maturity,type,Amt_NotOnMaturity,Amt_OnMaturity,FF_Decode,PurposeType)

Select noteid,date,amount,Maturity,type,Amt_NotOnMaturity,Amt_OnMaturity
,(CASE WHEN (a.amount < 0 and PurposeType = 'Capitalized Interest') THEN 6
WHEN a.amount < 0 THEN 2
WHEN a.amount > 0 and Amt_NotOnMaturity = 1 and Zero_Out_Bls = 0  THEN 3
WHEN a.amount > 0 and Amt_OnMaturity = 1 and Zero_Out_Bls = 0  THEN 5
ELSE 7 END) as FF_Decode,
PurposeType
From(

	Select tr.noteid
	,tr.date
	,tr.amount
	,tr.type
	,iSNULL(n.ActualPayoffdate,n.fullyextendedmaturitydate) as Maturity
	,isnull(dbls.BeginingBalance,0) as BeginingBalance
	,(CASE WHEN tr.date <> iSNULL(n.ActualPayoffdate,n.fullyextendedmaturitydate) THEN 1 Else 0 END	)as Amt_NotOnMaturity
	,(CASE when tr.date = iSNULL(n.ActualPayoffdate,n.fullyextendedmaturitydate) THEN 1 ELSE 0 END)as Amt_OnMaturity
	,(iSNULL(tr.amount,0) - isnull(dbls.BeginingBalance,0)) as Zero_Out_Bls
	
	,tr.PurposeType
	--,(CASE WHEN tr.amount > 0 and tr.date <> iSNULL(n.ActualPayoffdate,n.fullyextendedmaturitydate) THEN (row_number() over (partition by tr.noteid order by tr.noteid,tr.date desc) -1)
	--Else 0 END
	--)as lastPositiveAmt_NotOnMaturity	
	--,(CASE WHEN tr.amount > 0 and tr.date = iSNULL(n.ActualPayoffdate,n.fullyextendedmaturitydate) THEN 1 ELSE 0 END)as lastPositiveAmt_OnMaturity

	from #tbltransactionentry tr	
	INNER JOIN [CRE].[Note] n ON n.noteid = tr.noteid
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
	Inner join cre.deal d on d.dealid = n.dealid
	join cre.FinancingSourcemaster fn on fn.FinancingSourcemasterID = n.FinancingSourceID	
	left join (
		Select noteid,actualDate,date,BeginingBalance from #tblDailyEndingBls where [date] = dateadd(day,-1,@currentdatetime) 
	)dbls on dbls.noteid = n.noteid and dbls.date = tr.date
	
	where acc.IsDeleted = 0
	and fn.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio','TRE ACR Series II Portfolio')
	and ISNUMERIC(n.crenoteid) = 1	
	and tr.[Type] in ('FundingOrRepayment','Balloon')
	and tr.analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	and tr.date = @currentdatetime
	
)a
--===============================================


Select * from(

Select 
PORTFOLIO as [Portfolio Name]
,[SECURITY.CUSIP] as [Client ID]
--,0 as CUSIP
,'' as CUSIP
,CONVERT(varchar, getdate(),12) + FORMAT(ROW_NUMBER() over(order by PORTFOLIO),'D3') as [External ID]
,[TRANSACTION] as [Transaction]
,[AflacTransactionTypes] as [Aflac Transaction Types]
,TRADE_DATE as [Trade Date]
,SETTLE_DATE as [Settle Date]
,QUANTITY as Quantity
,[SECURITY.SMARTCUT.TD_CURRENCY] as Currency
,100 as [Purchase Price]
,'' as [Transaction Status]
,ISNULL((CASE WHEN PurposeType = 'Capitalized Interest' THEN '' ELSE CAST(OriginationFee as nvarchar(256)) END) ,'') as [Origination Fees]
,dealname as [Loan Name]


--[TRANSACTION]
--,PORTFOLIO
--,[SECURITY.CUSIP]
--,QUANTITY
--,TRADE_DATE
--,SETTLE_DATE
--,PRICE
--,EX_BROKER
--,EX_DESK_TYPE
--,DELIVERY
--,SETTLEMENT_INSTRUCTION
--,TRADER
--,CONFIRMED_BY
--,CONFIRMED_WITH
--,STRATEGY
--,TRD_PURPOSE
--,COMMENT_GENERAL
--,SUPPRESS_NOTIFICATION
--,DELIVER_FREE
--,EXT_ID1
--,[SECURITY.CLIENT_ID]
--,[SECURITY.SMARTCUT.SW_COUNTERPARTY]
--,[SECURITY.SMARTCUT.TD_CURRENCY]
--,INTEREST
--,SETTLE_FX_RATE
--,[CHARGE.AMT.LOCO]
--,[CHARGE.AMT.CLRF]
From(
	 Select 
	 --[TRANSACTION] = (case when fs.Value<0  then 'SELL' else 'BUY' end),
	 [TRANSACTION] = (case when tr.amount > 0  then 'SELL' else 'BUY' end),

	 (CASE WHEN fn.FinancingSourceName = 'TRE ACR Portfolio' THEN 'JPDACRTRE' WHEN fn.FinancingSourceName = 'TRE ACR Series II Portfolio' THEN 'JPDACRTRE2' ELSE 'USDACRTRE' END) as PORTFOLIO,
	 'ACR' + FORMAT(CAST(n.crenoteid as int),'D6') as [SECURITY.CUSIP],

	 --FORMAT((case when fs.Value<0 then fs.Value*-1 else fs.Value end),'#,0.00') as [QUANTITY],
	 FORMAT((case when tr.amount > 0 then tr.amount  else tr.amount *-1 end),'#,0.00') as [QUANTITY],

	 CONVERT(varchar, @currentdatetime,110) as [TRADE_DATE],
	 CONVERT(varchar, @currentdatetime,110) as [SETTLE_DATE],
	 --b.[Value] as [PRICE],
	 '100' as [PRICE],
	 'ACR' as [EX_BROKER],
	 '' as [EX_DESK_TYPE],
	 'No Settlement' as [DELIVERY],
	 'N/A' as [SETTLEMENT_INSTRUCTION],
	 'EP' as [TRADER],
	 'CONV' as [CONFIRMED_BY],
	 'CONV' as [CONFIRMED_WITH],
	 --'Unassigned' as [STRATEGY],
	 --'FHLA' as [STRATEGY],
	 ISNULL(nullIF(lStrategyCode.name,'None'),'Unassigned')  as [STRATEGY],
	 '' as [TRD_PURPOSE],
	 '' as [COMMENT_GENERAL],
	 'Y' as [SUPPRESS_NOTIFICATION],
	 '' as [DELIVER_FREE],
	 ROW_NUMBER() OVER (ORDER BY CAST(n.crenoteid as int)) [EXT_ID1],
	 'ACR' + FORMAT(CAST(n.crenoteid as int),'D6') as [SECURITY.CLIENT_ID],
	 '' as [SECURITY.SMARTCUT.SW_COUNTERPARTY],
	 lcurrency.name as [SECURITY.SMARTCUT.TD_CURRENCY],
	 '' as [INTEREST],
	 '' as [SETTLE_FX_RATE],
	 '' as [CHARGE.AMT.LOCO],
	 '' as [CHARGE.AMT.CLRF],
	 CAST(n.crenoteid as int) as noteid,
	 d.dealname,
	 tr.FF_Decode as [AflacTransactionTypes],
	 ---CAST(tblorigi.OriginationFee as nvarchar(256)) as OriginationFee,
	 null as OriginationFee,
	 PurposeType 

	from #tbltransaction_FF tr	
	INNER JOIN [CRE].[Note] n ON n.noteid = tr.noteid
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
	Inner join cre.deal d on d.dealid = n.dealid
	Left Join core.lookup lStrategyCode on lStrategyCode.lookupid = n.StrategyCode and lStrategyCode.ParentID = 110
	join cre.FinancingSourcemaster fn on fn.FinancingSourcemasterID = n.FinancingSourceID
	left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and lcurrency.ParentID = 29
	left join (
		Select Noteid,Date,Value
		From(
			Select na.Noteid,na.Date,na.Value ,Row_number() over(Partition by na.Noteid order by na.date desc) as rno
			from [CRE].[NoteAttributesbyDate] na
			inner join cre.TransactionTypes ty on ty.TransactionTypesID = na.ValueTypeID
			where ty.TransactionName = 'MarketPrice'
			and cast(na.Date as date) <=cast(@currentdatetime as date)
		)a where rno =  1
	) b	on b.Noteid=n.crenoteid	
	left join #tblOrigination tblorigi on tblorigi.noteid = n.noteid and tblorigi.date = tr.date

	where acc.IsDeleted = 0
	and fn.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio','TRE ACR Series II Portfolio')
	and ISNUMERIC(n.crenoteid) = 1
	and tr.[date]=CAST(@currentdatetime as date)
	and tr.[Type] in ('FundingOrRepayment','Balloon')
	--and tr.analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	and (n.ActualPayOffDate is null OR n.ActualPayOffDate > Cast(@currentdatetime as date)  OR (n.ActualPayOffDate = Cast(@currentdatetime as date) and n.InterestCalculationRuleForPaydowns = 594) ) --Full Period Accrual
	


	UNION ALL


	Select 
	[TRANSACTION] = (case when (tr.Amount*-1) < 0  then 'SELL' else 'BUY' end),
	(CASE WHEN fn.FinancingSourceName = 'TRE ACR Portfolio' THEN 'JPDACRTRE' WHEN fn.FinancingSourceName = 'TRE ACR Series II Portfolio' THEN 'JPDACRTRE2' ELSE 'USDACRTRE' END) as PORTFOLIO,
	'ACR' + FORMAT(CAST(n.crenoteid as int),'D6') as [SECURITY.CUSIP],
	FORMAT((case when (tr.Amount*-1) < 0 then (tr.Amount*-1) * -1 else (tr.Amount*-1) end),'#,0.00') as [QUANTITY],
	CONVERT(varchar, tr.[Date],101) as [TRADE_DATE],
	CONVERT(varchar,  tr.remitdate,101) as [SETTLE_DATE],
	--b.[Value] as [PRICE],
	'100' as [PRICE],
	'ACR' as [EX_BROKER],
	'' as [EX_DESK_TYPE],
	'No Settlement' as [DELIVERY],
	'N/A' as [SETTLEMENT_INSTRUCTION],
	'EP' as [TRADER],
	'CONV' as [CONFIRMED_BY],
	'CONV' as [CONFIRMED_WITH],
	--'Unassigned' as [STRATEGY],
	--'FHLA' as [STRATEGY],
	ISNULL(nullIF(lStrategyCode.name,'None'),'Unassigned')  as [STRATEGY],
	'' as [TRD_PURPOSE],
	'' as [COMMENT_GENERAL],
	'Y' as [SUPPRESS_NOTIFICATION],
	'' as [DELIVER_FREE],
	ROW_NUMBER() OVER (ORDER BY CAST(n.crenoteid as int)) [EXT_ID1],
	'ACR' + FORMAT(CAST(n.crenoteid as int),'D6') as [SECURITY.CLIENT_ID],
	'' as [SECURITY.SMARTCUT.SW_COUNTERPARTY],
	lcurrency.name as [SECURITY.SMARTCUT.TD_CURRENCY],
	'' as [INTEREST],
	'' as [SETTLE_FX_RATE],
	'' as [CHARGE.AMT.LOCO],
	'' as [CHARGE.AMT.CLRF],
	CAST(n.crenoteid as int) as noteid,
	d.dealname,
	tty.decodeno as [AflacTransactionTypes],
	tblorigi.OriginationFee,
	PurposeType

	from #tbltransactionentry tr
	inner join cre.note n on n.noteid = tr.noteid
	Inner join cre.deal d on d.dealid = n.dealid
	inner join core.account acc on acc.accountid = n.account_accountid
	join cre.FinancingSourcemaster fn on fn.FinancingSourcemasterID = n.FinancingSourceID
	Left Join core.lookup lStrategyCode on lStrategyCode.lookupid = n.StrategyCode and lStrategyCode.ParentID = 110
	left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and lcurrency.ParentID = 29
	left join [CRE].[TransactionTypes]  tty on tr.[Type]=tty.transactionName 
	left join #tblOrigination tblorigi on tblorigi.noteid = n.noteid and tblorigi.date = tr.date

	where acc.isdeleted <> 1
	and fn.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio','TRE ACR Series II Portfolio')
	and ISNUMERIC(n.crenoteid) = 1	
	and analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and [type] = 'ScheduledPrincipalPaid'
	and tr.remitdate is not null
	and tr.remitdate = cast(@currentdatetime as date)
	and (n.ActualPayOffDate is null OR n.ActualPayOffDate > Cast(@currentdatetime as date)  OR (n.ActualPayOffDate = Cast(@currentdatetime as date) and n.InterestCalculationRuleForPaydowns = 594) ) --Full Period Accrual


	UNION ALL


	Select 
	[TRANSACTION] = (case when (tr.Amount*-1) < 0  then 'SELL' else 'BUY' end),
	(CASE WHEN fn.FinancingSourceName = 'TRE ACR Portfolio' THEN 'JPDACRTRE' WHEN fn.FinancingSourceName = 'TRE ACR Series II Portfolio' THEN 'JPDACRTRE2' ELSE 'USDACRTRE' END) as PORTFOLIO,
	'ACR' + FORMAT(CAST(n.crenoteid as int),'D6') as [SECURITY.CUSIP],
	FORMAT((case when (tr.Amount*-1) < 0 then (tr.Amount*-1) * -1 else (tr.Amount*-1) end),'#,0.00') as [QUANTITY],
	CONVERT(varchar, tr.[Date],101) as [TRADE_DATE],
	CONVERT(varchar,  tr.date,101) as [SETTLE_DATE],
	--b.[Value] as [PRICE],
	'100' as [PRICE],
	'ACR' as [EX_BROKER],
	'' as [EX_DESK_TYPE],
	'No Settlement' as [DELIVERY],
	'N/A' as [SETTLEMENT_INSTRUCTION],
	'EP' as [TRADER],
	'CONV' as [CONFIRMED_BY],
	'CONV' as [CONFIRMED_WITH],
	--'Unassigned' as [STRATEGY],
	--'FHLA' as [STRATEGY],
	ISNULL(nullIF(lStrategyCode.name,'None'),'Unassigned')  as [STRATEGY],
	'' as [TRD_PURPOSE],
	'' as [COMMENT_GENERAL],
	'Y' as [SUPPRESS_NOTIFICATION],
	'' as [DELIVER_FREE],
	ROW_NUMBER() OVER (ORDER BY CAST(n.crenoteid as int)) [EXT_ID1],
	'ACR' + FORMAT(CAST(n.crenoteid as int),'D6') as [SECURITY.CLIENT_ID],
	'' as [SECURITY.SMARTCUT.SW_COUNTERPARTY],
	lcurrency.name as [SECURITY.SMARTCUT.TD_CURRENCY],
	'' as [INTEREST],
	'' as [SETTLE_FX_RATE],
	'' as [CHARGE.AMT.LOCO],
	'' as [CHARGE.AMT.CLRF],
	CAST(n.crenoteid as int) as noteid,
	d.dealname,
	tty.decodeno as [AflacTransactionTypes],
	tblorigi.OriginationFee,
	PurposeType

	from #tbltransactionentry tr
	inner join cre.note n on n.noteid = tr.noteid
	Inner join cre.deal d on d.dealid = n.dealid
	inner join core.account acc on acc.accountid = n.account_accountid
	join cre.FinancingSourcemaster fn on fn.FinancingSourcemasterID = n.FinancingSourceID
	Left Join core.lookup lStrategyCode on lStrategyCode.lookupid = n.StrategyCode and lStrategyCode.ParentID = 110
	left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and lcurrency.ParentID = 29
	left join [CRE].[TransactionTypes]  tty on tr.[Type]=tty.transactionName 
	left join #tblOrigination tblorigi on tblorigi.noteid = n.noteid and tblorigi.date = tr.date

	where acc.isdeleted <> 1
	and fn.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio','TRE ACR Series II Portfolio')
	and ISNUMERIC(n.crenoteid) = 1	
	and analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and [type] in ('InitialFunding','PIKPrincipalFunding','PIKPrincipalPaid')
	and tr.date = cast(@currentdatetime as date)
	and (n.ActualPayOffDate is null OR n.ActualPayOffDate > Cast(@currentdatetime as date)  OR (n.ActualPayOffDate = Cast(@currentdatetime as date) and n.InterestCalculationRuleForPaydowns = 594) ) --Full Period Accrual

)a

)z
order by z.[External ID] ---CAST(a.noteid as int)


END