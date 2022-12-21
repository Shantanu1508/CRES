---[dbo].[usp_GetAflac_ACR_Transaction]  '{"Date":"12/13/2021"}' 

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

Select 
[TRANSACTION]
,PORTFOLIO
,[SECURITY.CUSIP]
,QUANTITY
,TRADE_DATE
,SETTLE_DATE
,PRICE
,EX_BROKER
,EX_DESK_TYPE
,DELIVERY
,SETTLEMENT_INSTRUCTION
,TRADER
,CONFIRMED_BY
,CONFIRMED_WITH
,STRATEGY
,TRD_PURPOSE
,COMMENT_GENERAL
,SUPPRESS_NOTIFICATION
,DELIVER_FREE
,EXT_ID1
,[SECURITY.CLIENT_ID]
,[SECURITY.SMARTCUT.SW_COUNTERPARTY]
,[SECURITY.SMARTCUT.TD_CURRENCY]
,INTEREST
,SETTLE_FX_RATE
,[CHARGE.AMT.LOCO]
,[CHARGE.AMT.CLRF]
From(
	 Select 
	 [TRANSACTION] = (case when fs.Value<0  then 'SELL' else 'BUY' end),
	 (CASE WHEN fn.FinancingSourceName ='TRE ACR Portfolio' THEN 'JPDACRTRE' ELSE 'USDACRTRE' END) as PORTFOLIO,
	 'ACR' + FORMAT(CAST(n.crenoteid as int),'D6') as [SECURITY.CUSIP],
	 FORMAT((case when fs.Value<0 then fs.Value*-1 else fs.Value end),'#,0.00') as [QUANTITY],
	 CONVERT(varchar, @currentdatetime,101) as [TRADE_DATE],
	 CONVERT(varchar, @currentdatetime,101) as [SETTLE_DATE],
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
	 CAST(n.crenoteid as int) as noteid

	from [CORE].FundingSchedule fs
	INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
	INNER JOIN 
	(						
		Select 
		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
		from [CORE].[Event] eve
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
		--and n.crenoteid = '6114'  
		and acc.IsDeleted = 0
		and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
		GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
	) sEvent
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
	left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
	left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
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
	
	where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
	and fn.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio')
	and ISNUMERIC(n.crenoteid) = 1
	and fs.[date]=CAST(@currentdatetime as date)
	and (n.ActualPayOffDate is null OR n.ActualPayOffDate > Cast(@currentdatetime as date)  OR (n.ActualPayOffDate = Cast(@currentdatetime as date) and n.InterestCalculationRuleForPaydowns = 594) ) --Full Period Accrual
	and LPurposeID.name <> 'Amortization'


	UNION ALL


	Select 
	[TRANSACTION] = (case when (tr.Amount*-1) < 0  then 'SELL' else 'BUY' end),
	(CASE WHEN fn.FinancingSourceName ='TRE ACR Portfolio' THEN 'JPDACRTRE' ELSE 'USDACRTRE' END) as PORTFOLIO,
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
	CAST(n.crenoteid as int) as noteid
	from cre.TransactionEntry tr
	inner join cre.note n on n.noteid = tr.noteid
	inner join core.account acc on acc.accountid = n.account_accountid
	join cre.FinancingSourcemaster fn on fn.FinancingSourcemasterID = n.FinancingSourceID
	Left Join core.lookup lStrategyCode on lStrategyCode.lookupid = n.StrategyCode and lStrategyCode.ParentID = 110
	left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and lcurrency.ParentID = 29
	where acc.isdeleted <> 1
	and fn.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio')
	and ISNUMERIC(n.crenoteid) = 1	
	and analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and [type] = 'ScheduledPrincipalPaid'
	and tr.remitdate is not null
	and tr.remitdate = cast(@currentdatetime as date)
	and (n.ActualPayOffDate is null OR n.ActualPayOffDate > Cast(@currentdatetime as date)  OR (n.ActualPayOffDate = Cast(@currentdatetime as date) and n.InterestCalculationRuleForPaydowns = 594) ) --Full Period Accrual

)a
order by CAST(a.noteid as int)


END