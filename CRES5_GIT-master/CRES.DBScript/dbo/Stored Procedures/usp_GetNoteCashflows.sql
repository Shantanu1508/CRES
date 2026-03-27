
CREATE PROCEDURE [dbo].[usp_GetNoteCashflows] 

@NoteId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
@DealId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000'

AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED



SELECT --n.NoteID
	--,n.Account_AccountID
	n.CRENoteID NoteID
	,acc.name NoteName
	,fs.[Date]
	,LEFT(CONVERT(VARCHAR, fs.[Date], 101), 10) AS DisplayDate
	,fs.Value
	,'FundingOrRepayment' as ValueType
	from [CORE].[FundingSchedule] fs INNER JOIN [CORE].[Event] eve ON eve.EventID = fs.EventId
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and eve.EffectiveStartDate=(select max(EffectiveStartDate) from [CORE].[Event] where  AccountID = eve.AccountID 
	and StatusID = (Select lookupid from Core.Lookup where parentid = 1 and name='Active'))
	--and fs.[Date] between  (CASE WHEN @StartDate IS NULL or @StartDate=''THEN (select min([Date])FROM [CORE].[FundingSchedule]) ELSE @StartDate END )
	--and   (CASE WHEN @EndDate IS NULL or @EndDate='' THEN (select max([Date])FROM [CORE].[FundingSchedule]) ELSE @EndDate END )
	and isnull(fs.Value,0)<>0 and acc.isdeleted=0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	
 UNION
 
	select n.crenoteid NoteID
	,acc.name NoteName
	,n.closingdate
	,LEFT(CONVERT(VARCHAR, n.closingdate, 101), 10)  AS DisplayDate
	,n.initialfundingamount
	,'InitialFunding' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(n.initialfundingamount,0)<>0 and acc.isdeleted=0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1

 UNION
 
	select n.crenoteid NoteID
	,acc.name NoteName
	,n.closingdate
	,LEFT(CONVERT(VARCHAR, n.closingdate, 101), 10)  AS DisplayDate
	,n.discount
	,'Discount/Premium' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(n.discount,0)<>0 and acc.isdeleted=0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1

 UNION
 
	select n.crenoteid NoteID
	,acc.name NoteName
	,n.closingdate
	,LEFT(CONVERT(VARCHAR, n.closingdate, 101), 10)  AS DisplayDate
	,n.StubIntOverride
	,'StubInterest' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(n.StubIntOverride,0)<>0 and acc.isdeleted=0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1

 UNION
 
	select n.crenoteid NoteID
	,acc.name NoteName
	,n.closingdate
	,LEFT(CONVERT(VARCHAR, n.closingdate, 101), 10) AS DisplayDate
	,n.OriginationFee
	,'OriginationFee' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(n.initialfundingamount,0)<>0 and acc.isdeleted=0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1

 UNION
 
	select n.crenoteid NoteID
	,acc.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) 
	,LEFT(CONVERT(VARCHAR, dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)), 101), 10) AS DisplayDate
	,-np.balloonpayment
	,'Balloon' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join CRE.noteperiodiccalc np on np.AccountID = n.Account_AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.balloonpayment,0)<>0 and acc.isdeleted=0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1

 UNION
 
	select n.crenoteid NoteID
	,acc.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) 
	,LEFT(CONVERT(VARCHAR, dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) , 101), 10) AS DisplayDate
	,-np.principalpaid
	,'ScheduledPrincipalPaid' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join CRE.noteperiodiccalc np on np.AccountID = n.Account_AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.principalpaid,0)<>0 and acc.isdeleted=0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1

 UNION
 
	select n.crenoteid NoteID
	,acc.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) 
	,LEFT(CONVERT(VARCHAR, dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)), 101), 10) AS DisplayDate
	,np.interestpaidonpaymentdate
	,'InterestPaid' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join CRE.noteperiodiccalc np on np.AccountID = n.Account_AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.interestpaidonpaymentdate,0)<>0 and acc.isdeleted=0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1

 UNION
 
	select n.crenoteid NoteID
	,acc.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) 
	,LEFT(CONVERT(VARCHAR, dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)), 101), 10) AS DisplayDate
	,np.ExitFeeIncludedInLevelYield
	,'ExitFeeIncludedInLevelYield' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join CRE.noteperiodiccalc np on np.AccountID = n.Account_AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.ExitFeeIncludedInLevelYield,0)<>0 and acc.isdeleted=0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1

 UNION
 
	select n.crenoteid NoteID
	,acc.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) 
	,LEFT(CONVERT(VARCHAR, dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)), 101), 10) AS DisplayDate
	,np.ExitFeeExcludedFromLevelYield
	,'ExitFeeExcludedFromLevelYield' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join CRE.noteperiodiccalc np on np.AccountID = n.Account_AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.ExitFeeExcludedFromLevelYield,0)<>0 and acc.isdeleted=0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1

 UNION
 
	select n.crenoteid NoteID
	,acc.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) 
	,LEFT(CONVERT(VARCHAR, dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) , 101), 10) AS DisplayDate  
	,np.AdditionalFeesIncludedInLevelYield
	,'AdditionalFeesIncludedInLevelYield' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join CRE.noteperiodiccalc np on np.AccountID = n.Account_AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.AdditionalFeesIncludedInLevelYield,0)<>0 and acc.isdeleted=0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1

 UNION
 
	select n.crenoteid NoteID
	,acc.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) 
	 ,LEFT(CONVERT(VARCHAR, dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) , 101), 10) AS DisplayDate
	,np.AdditionalFeesExcludedFromLevelYield
	,'AdditionalFeesExcludedFromLevelYield' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join CRE.noteperiodiccalc np on np.AccountID = n.Account_AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.AdditionalFeesExcludedFromLevelYield,0)<>0 and acc.isdeleted=0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1

 UNION
 
	select n.crenoteid NoteID
	,acc.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1))
	,LEFT(CONVERT(VARCHAR, dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)), 101), 10) AS DisplayDate
	,np.OriginationFeeStripping
	,'OriginationFeeStripping' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join CRE.noteperiodiccalc np on np.AccountID = n.Account_AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.OriginationFeeStripping,0)<>0 and acc.isdeleted=0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1

 UNION
 
	select n.crenoteid NoteID
	,acc.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) 
	,LEFT(CONVERT(VARCHAR, dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)), 101), 10)  AS DisplayDate
	,np.ExitFeeStrippingIncldinLevelYield
	,'ExitFeeStrippingIncldinLevelYield' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join CRE.noteperiodiccalc np on np.AccountID = n.Account_AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.ExitFeeStrippingIncldinLevelYield,0)<>0 and acc.isdeleted=0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1

 UNION
 
	select n.crenoteid NoteID
	,acc.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) 
	,LEFT(CONVERT(VARCHAR, dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)), 101), 10)  AS DisplayDate
	,np.ExitFeeStrippingExcldfromLevelYield
	,'ExitFeeStrippingExcldfromLevelYield' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join CRE.noteperiodiccalc np on np.AccountID = n.Account_AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.ExitFeeStrippingExcldfromLevelYield,0)<>0 and acc.isdeleted=0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1

 UNION
 
	select n.crenoteid NoteID
	,acc.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) 
	,LEFT(CONVERT(VARCHAR, dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) , 101), 10) AS DisplayDate 
	,np.AddlFeesStrippingIncldinLevelYield
	,'AddlFeesStrippingIncldinLevelYield' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join CRE.noteperiodiccalc np on np.AccountID = n.Account_AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.AddlFeesStrippingIncldinLevelYield,0)<>0 and acc.isdeleted=0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1

 UNION
 
	select n.crenoteid NoteID
	,acc.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) 
	,LEFT(CONVERT(VARCHAR, dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)), 101), 10)  AS DisplayDate
	,np.AddlFeesStrippingExcldfromLevelYield
	,'AddlFeesStrippingExcldfromLevelYield' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join CRE.noteperiodiccalc np on np.AccountID = n.Account_AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.AddlFeesStrippingExcldfromLevelYield,0)<>0 and acc.isdeleted=0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1

UNION

	select n.crenoteid NoteID
	,acc.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) 
	,LEFT(CONVERT(VARCHAR,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)), 101), 10) AS DisplayDate
	,np.EndingGAAPBookValue
	,'EndingGAAPBookValue' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join CRE.noteperiodiccalc np on np.AccountID = n.Account_AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.EndingGAAPBookValue,0)<>0 and acc.isdeleted=0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1

UNION

	select n.crenoteid NoteID
	,acc.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) 
	,LEFT(CONVERT(VARCHAR, dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)), 101), 10) AS DisplayDate
	,null TotalGAAPIncomeforthePeriod
	,'TotalGAAPIncomeforthePeriod' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join CRE.noteperiodiccalc np on np.AccountID = n.Account_AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	--and isnull(np.TotalGAAPIncomeforthePeriod,0)<>0 
	and acc.isdeleted=0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1

Union

	select n.crenoteid NoteID
	,a.name NoteName
	,transactiondate
	,LEFT(CONVERT(VARCHAR, transactiondate, 101), 10)  AS DisplayDate
	,amount
	,replace(l.name,' ','') + 'Receivable' as ValueType
	from cre.note n inner join core.account a on n.account_accountid=a.accountid inner join 
	cre.payruledistributions p on p.receivernoteid=n.noteid inner join core.lookup l on p.ruleid=l.lookupid
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(amount,0)<>0 and a.IsDeleted=0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1

	order by Noteid,Date
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
