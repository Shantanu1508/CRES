CREATE Procedure [dbo].[usp_GetDelphiTransactionsReport]  
(  
  @JsonReportParamters NVARCHAR(MAX)=null  
)  
AS  
BEGIN  
 SET NOCOUNT ON; 


/*
Chages done on 01/29/2021
Price = 100*(1- Origination Fee %) = 99
Fees = Unit * Origination Fee% = 10,000
Proceeds = Unit – Fees = 990,000 (sign of Proceeds, is depending on if this is a funding (negative) or repayment (positive))

When we have a future or initial funding where the price column is less than 100, that means there is an origination fee associated with that funding that reduces the proceeds for accounting purposes. For example, if there is a funding for 1,000,000 (units column) and the price is 99 (1% origination fee), in the fee column we would like to see 10,000 and the proceeds are -990,000.
*/


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


 ---set @currentdatetime = '4/8/2021'
	--set @currentdatetime = '1/26/2021'
	---set @currentdatetime = '1/08/2021'
	--set @currentdatetime = '1/11/2021'

 DECLARE @transactionType as table(
	[type] nvarchar(256),
	sub_trans_type nvarchar(256),
	[value] nvarchar(256)
	)
	Insert into @transactionType values
	('AccruedInterestSuspense','',''),
	('AdditionalFeesExcludedFromLevelYield','',''),
	('AdditionalFeesIncludedInLevelYield','',''),
	('Balloon','','Loan Repayment - Balloon'),
	('CapitalizedClosingCost','',''),
	('Discount/Premium','',''),
	('EndingGAAPBookValue','',''),
	('EndingPVGAAPBookValue','',''),
	('ExitFeeExcludedFromLevelYield','CLOSE_FEE','EXIT FEE'),
	('ExitFeeIncludedInLevelYield','',''),
	('ExitFeeStrippingExcldfromLevelYield','',''),
	('ExitFeeStripReceivable','',''),
	('ExtensionFeeExcludedFromLevelYield','',''),
	('ExtensionFeeIncludedInLevelYield','',''),
	('ExtensionFeeStrippingExcldfromLevelYield','',''),
	('ExtensionFeeStripReceivable','',''),
	('FloatInterest','CLOSE_FEE','Float Interest'),
	('FundingOrRepayment','',''),
	('InitialFunding','','Initial Funding'),
	('InterestPaid','LIB_INT','Cash Interest'),
	('LIBORPercentage','',''),
	('OriginationFee','CLOSE_FEE','ORIGINATION FEE FROM BORROWER'),
	('OriginationFeeIncludedInLevelYield','',''),
	('OriginationFeeStripping','',''),
	('OriginationFeeStripReceivable','',''),
	('OtherFeeExcludedFromLevelYield','',''),

	('PIKInterest','','COVID PIK - Interest'),

	('PIKInterestPercentage','',''),

	('PIKPrincipalFunding','','COVID PIK - Principal'),

	('PrepaymentFeeExcludedFromLevelYield','CLOSE_FEE','PREPAYMENT FEE'),
	('PurchasedInterest','','Purchased Interest'),
	('ScheduledPrincipalPaid','','Loan Repayment - Amortization'),
	('SpreadPercentage','',''),
	('StubInterest','LIB_INT','Stub Interest'),
	('UnusedFeeExcludedFromLevelYield','',''),
	('DefaultInterest','','Default Interest')
  
Select 
TransactionType,
AccountNumber,
DealID,
DealName,
LoanID,
NoteName,
Units,
TradeDate,
PostDate,
(CASE WHEN Price is null THEN null when Price <> 100 THEN CAST(format((100-Price),'#,0.00') as nvarchar(256)) else cast(format(100,'#,0.00') as nvarchar(256)) end) as Price,
Currency,
format(Fees,'#,0.00') as Fees,
FeeType,
TradeAccrued,
(case when Proceeds < 0 then +'('+cast(FORMAT(ABS(Proceeds + isnull(Fees,0)),'#,0.00') as varchar(256))+')' when Proceeds>0 then cast(FORMAT(Proceeds - isnull(Fees,0),'#,0.00') as varchar(256)) else null end) as Proceeds,
Comments,
Reversal,
RSLIC,
SNCC,
PIIC,
TMR,
HCC,
USSIC,
[TMD-DL],
HAIH
From(

Select a.TransactionType,AccountNumber,DealID,DealName,LoanID,NoteName,
(case when isnull(Units,0)<0 then +'('+cast(FORMAT(ABS(isnull(Units,0)),'#,0.00') as varchar(256))+')' when isnull(Units,0)>0 then  cast(FORMAT(isnull(Units,0),'#,0.00') as varchar(256)) else null end) as Units ,
Cast(Format(TradeDate,'MM/dd/yyyy') as nvarchar(256)) as TradeDate,
Cast(Format(PostDate,'MM/dd/yyyy') as nvarchar(256)) as PostDate,
(CASE WHEN a.TransactionType in ('Loan Repayment - Unscheduled Paydown','Loan Repayment - Amortization','Non-cash Advance - Principal') THEN 100 
	  when a.TransactionType in ('Unused Fee','Cash Interest','Float Interest','Stub Interest','Default Interest','Purchased Interest') then null else tblPrc.OriginationFeePercentageRP end)as Price
--tblPrc.OriginationFeePercentageRP as Price
--null as Price
,Currency,

--(case when (a.TransactionType='Initial Funding' or a.TransactionType='Future Funding') and tblOrgFee.CRENoteID is not null then tblOrgFee.amount else null end) as Fees,
--(case when (a.TransactionType='Initial Funding' or a.TransactionType='Future Funding') and tblOrgFee.CRENoteID is not null then 'Origination Fee' else null end) as FeeType,

(case when (a.TransactionType='Initial Funding' or a.TransactionType='Future Funding') and (100-tblPrc.OriginationFeePercentageRP) < 100 then (Units * tblPrc.OriginationFeePercentageRP)/100 else null end) as Fees,
(case when (a.TransactionType='Initial Funding' or a.TransactionType='Future Funding') and (100-tblPrc.OriginationFeePercentageRP) < 100 then 'Origination Fee' else null end) as FeeType,


TradeAccrued,
--(case when Proceeds<0 then +'('+cast(FORMAT(ABS(Proceeds+isnull(tblOrgFee.amount,0)),'#,0.00') as varchar(256))+')' when Proceeds>0 then cast(FORMAT(Proceeds,'#,0.00') as varchar(256)) else null end) as Proceeds,
Proceeds,
Comments,Reversal,RSLIC,SNCC,PIIC,TMR,HCC,USSIC,[TMD-DL],HAIH
From(
	--transactions based on remit date
	Select temptr.value as TransactionType,'Delphi' as AccountNumber,d.Credealid as DealID,d.dealname as DealName,n.crenoteid as LoanID,acc.name as NoteName,null as Units,ISNULL(tr.PaymentDateNotAdjustedforWorkingDay,te.DateDue) as TradeDate  ---@currentdatetime as TradeDate --
	,@currentdatetime as PostDate,lcurrency.name as Currency,null as Fees,null as FeeType,null as TradeAccrued,te.TotalInterest as Proceeds,null as Comments,null as Reversal
	From cre.note n
	inner join core.account acc on acc.accountid = n.account_accountid  
	left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID 
	inner join cre.deal d on d.dealid = n.dealid
	inner join cre.TranscationReconciliation te on n.noteid = te.noteid
	
	left join cre.TransactionEntry tr on n.noteid = tr.noteid and tr.analysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and tr.[Type] = te.TransactionType --in ('InterestPaid','StubInterest','FloatInterest','DefaultInterest','PurchasedInterest')
	and te.RemittanceDate = tr.RemitDate and te.DateDue = tr.date

	left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and ParentID = 29
	left join @transactionType temptr on te.TransactionType = temptr.type
	where fs.FinancingSourceName like '%Delphi%'
	and te.RemittanceDate = Cast(@currentdatetime as date) --'04/30/2018'
	and ISNUMERIC(n.crenoteid) = 1
	--and n.ActualPayOffDate is null
	and te.Deleted<>1
	and te.PostedDate is not null
	and ABS(te.TotalInterest)>1
	and te.TransactionType in ('InterestPaid','StubInterest','FloatInterest','DefaultInterest','PurchasedInterest')
	UNION

	--transactions based on transaction date	
	Select temptr.[value] as TransactionType,'Delphi' as AccountNumber,d.Credealid as DealID,d.dealname as DealName,n.crenoteid as LoanID,acc.name as NoteName,
	(case when temptr.[type]='InitialFunding' then ABS(te.amount) 
	when temptr.[type]='ScheduledPrincipalPaid' then (te.amount*-1)
	else null end )as Units,
	te.date as TradeDate,te.date as PostDate,lcurrency.name as Currency,
	null as Fees,null as FeeType,null as TradeAccrued,
	te.amount as Proceeds,
	null as Comments,null as Reversal
	From cre.note n
	inner join core.account acc on acc.accountid = n.account_accountid  
	left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID 
	inner join cre.deal d on d.dealid = n.dealid
	inner join cre.TransactionEntry te on n.noteid = te.noteid and te.analysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and [Type] in ('InitialFunding','ScheduledPrincipalPaid') ---,'PIKInterest'
	left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and ParentID = 29
	left join @transactionType temptr on te.[type]=temptr.[type]
	where fs.FinancingSourceName like '%Delphi%'
	and te.date = Cast(@currentdatetime as date) --'02/07/2020'
	and ISNUMERIC(n.crenoteid) = 1
	and (n.ActualPayOffDate is null OR n.ActualPayOffDate >= Cast(@currentdatetime as date))
	and ABS(te.amount)>1
	
	UNION

	--Added by Vishal 01/29/2021
	--transactions based on transaction date	for "COVID PIK INterest"
	Select temptr.[value] as TransactionType,'Delphi' as AccountNumber,d.Credealid as DealID,d.dealname as DealName,n.crenoteid as LoanID,acc.name as NoteName,
	(case when temptr.[type]='InitialFunding' then ABS(te.amount)when temptr.[type]='ScheduledPrincipalPaid' then (te.amount*-1)
	else null end )as Units,
	ISNULL(te.PaymentDateNotAdjustedforWorkingDay,te.Date) as TradeDate,
	te.date as PostDate,lcurrency.name as Currency,
	null as Fees,null as FeeType,null as TradeAccrued,
	te.amount as Proceeds,
	null as Comments,null as Reversal
	From cre.note n
	inner join core.account acc on acc.accountid = n.account_accountid  
	left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID 
	inner join cre.deal d on d.dealid = n.dealid
	inner join cre.TransactionEntry te on n.noteid = te.noteid and te.analysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and [Type] in ('PIKInterest')
	left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and ParentID = 29
	left join @transactionType temptr on te.[type]=temptr.[type]
	where fs.FinancingSourceName like '%Delphi%'
	and te.date = Cast(@currentdatetime as date) --'02/07/2020'
	and ISNUMERIC(n.crenoteid) = 1
	and (n.ActualPayOffDate is null OR n.ActualPayOffDate >= Cast(@currentdatetime as date))
	and ABS(te.amount)>1
	and te.FeeName = 'COVID'


	union
	
	
	--future funding
	Select 'Future Funding' as TransactionType,'Delphi' as AccountNumber,d.Credealid as DealID,d.dealname as DealName,n.crenoteid as LoanID,acc.name as NoteName,fs.Value as Units,@currentdatetime as TradeDate,@currentdatetime as PostDate,lcurrency.name as Currency,null as Fees,null as FeeType,null as TradeAccrued,(fs.Value*-1) as Proceeds,null as Comments,null as Reversal
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
	inner join cre.deal d on d.dealid = n.dealid
	left join cre.FinancingSourcemaster fn on fn.FinancingSourcemasterID = n.FinancingSourceID
	left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and lcurrency.ParentID = 29
	--and n.crenoteid='6114'  
	where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
	and fn.FinancingSourceName like '%Delphi%'
	and ISNUMERIC(n.crenoteid) = 1
	and fs.[date]=CAST(@currentdatetime as date) --'02/07/2020'
	and (n.ActualPayOffDate is null OR n.ActualPayOffDate >= Cast(@currentdatetime as date))
	and fs.Value>0
	and fs.PurposeID not in (581,629)

	UNION
	
	--loan Repayment-Unscheduled paydown
	Select 'Loan Repayment - Unscheduled Paydown' as TransactionType,'Delphi' as AccountNumber,d.Credealid as DealID,d.dealname as DealName,n.crenoteid as LoanID,acc.name as NoteName,fs.Value as Units,@currentdatetime as TradeDate,@currentdatetime as PostDate,lcurrency.name as Currency,null as Fees,null as FeeType,null as TradeAccrued,(fs.Value*-1) as Proceeds,null as Comments,null as Reversal
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
	inner join cre.deal d on d.dealid = n.dealid
	left join cre.FinancingSourcemaster fn on fn.FinancingSourcemasterID = n.FinancingSourceID
	left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and lcurrency.ParentID = 29
	--and n.crenoteid='6114'  
	where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
	and fn.FinancingSourceName like '%Delphi%'
	and ISNUMERIC(n.crenoteid) = 1
	and fs.[date]=CAST(@currentdatetime as date)
	and (n.ActualPayOffDate is null OR n.ActualPayOffDate >= Cast(@currentdatetime as date))
	and fs.Value<0
	--and fs.PurposeID not in (629)
	--as per corey full pay off should only be count in 'Loan Repayment - Balloon' so excluding that PurposeID(630) from here
	and fs.PurposeID not in (629,630,351)  ---(Added 351 by vishal for ignore amortization)
		
	union

	--ballon payment- purpose type as 'Full Payoff'
	Select 'Loan Repayment - Balloon' as TransactionType,'Delphi' as AccountNumber,d.Credealid as DealID,d.dealname as DealName,n.crenoteid as LoanID,acc.name as NoteName,fs.Value as Units,@currentdatetime as TradeDate,@currentdatetime as PostDate,lcurrency.name as Currency,null as Fees,null as FeeType,null as TradeAccrued,(fs.Value*-1) as Proceeds,null as Comments,null as Reversal
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
	inner join cre.deal d on d.dealid = n.dealid
	left join cre.FinancingSourcemaster fn on fn.FinancingSourcemasterID = n.FinancingSourceID
	left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and lcurrency.ParentID = 29
	--and n.crenoteid='6114'  
	where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
	and fn.FinancingSourceName like '%Delphi%'
	and ISNUMERIC(n.crenoteid) = 1
	and fs.[date]=CAST(@currentdatetime as date)
	and fs.Value<0
	and fs.PurposeID = 630

	union

	--ballon payment- transaction type 'Ballon'
	Select temptr.[value] as TransactionType,'Delphi' as AccountNumber,d.Credealid as DealID,d.dealname as DealName,n.crenoteid as LoanID,acc.name as NoteName,
	(te.amount*-1) as Units,
	@currentdatetime as TradeDate,@currentdatetime as PostDate,lcurrency.name as Currency,null as Fees,null as FeeType,null as TradeAccrued,
	te.amount as Proceeds,
	null as Comments,null as Reversal
	From cre.note n
	inner join core.account acc on acc.accountid = n.account_accountid  
	left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID 
	inner join cre.deal d on d.dealid = n.dealid
	inner join cre.TransactionEntry te on n.noteid = te.noteid and te.analysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and [Type] in ('Balloon')
	left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and ParentID = 29
	left join @transactionType temptr on te.[type]=temptr.[type]
	where fs.FinancingSourceName like '%Delphi%'
	and te.date = Cast(@currentdatetime as date) --'10/11/2017'
	and ISNUMERIC(n.crenoteid) = 1
	and te.amount>1

	union

	--Non-cash Advance - Interest
	Select 'Non-cash Advance - Interest' as TransactionType,'Delphi' as AccountNumber,d.Credealid as DealID,d.dealname as DealName,n.crenoteid as LoanID,acc.name as NoteName,
	null as Units,
	@currentdatetime as TradeDate,@currentdatetime as PostDate,lcurrency.name as Currency,null as Fees,null as FeeType,null as TradeAccrued,
	tr.AddlInterest as Proceeds,
	null as Comments,null as Reversal
	From cre.note n
	inner join core.account acc on acc.accountid = n.account_accountid  
	left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID 
	inner join cre.deal d on d.dealid = n.dealid
	inner join cre.TranscationReconciliation tr on n.noteid = tr.noteid
	inner join [CRE].[ServicerMaster] sm on sm.ServicerMasterID=tr.ServcerMasterID	
	left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and ParentID = 29
	where fs.FinancingSourceName like '%Delphi%'
	--and tr.[DateDue]  = Cast(@currentdatetime as date) --'10/11/2017'
	and tr.[RemittanceDate]  = Cast(@currentdatetime as date) --'03/23/2016'
	and ISNUMERIC(n.crenoteid) = 1
	--and n.ActualPayOffDate is null
	and tr.AddlInterest>0
	and tr.Deleted<>1
	and tr.PostedDate is not null

	UNION

	--Added by Vishal "Non Covid PIK Interest as Non-Cash"
	Select 'Non-cash Advance - Interest' as TransactionType,'Delphi' as AccountNumber,d.Credealid as DealID,d.dealname as DealName,n.crenoteid as LoanID,acc.name as NoteName,
	null as Units,
	ISNULL(te.PaymentDateNotAdjustedforWorkingDay,te.Date) as TradeDate,
	te.date as PostDate,lcurrency.name as Currency,
	null as Fees,null as FeeType,null as TradeAccrued,
	te.amount as Proceeds,
	null as Comments,null as Reversal
	From cre.note n
	inner join core.account acc on acc.accountid = n.account_accountid  
	left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID 
	inner join cre.deal d on d.dealid = n.dealid
	inner join cre.TransactionEntry te on n.noteid = te.noteid and te.analysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and [Type] in ('PIKInterest')
	left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and ParentID = 29	
	where fs.FinancingSourceName like '%Delphi%'
	and te.date = Cast(@currentdatetime as date) --'02/07/2020'
	and ISNUMERIC(n.crenoteid) = 1
	and (n.ActualPayOffDate is null OR n.ActualPayOffDate >= Cast(@currentdatetime as date))
	and ABS(te.amount)>1
	
	
	
	union

	--Non-cash Advance - Principal
	Select 'Non-cash Advance - Principal' as TransactionType,'Delphi' as AccountNumber,d.Credealid as DealID,d.dealname as DealName,n.crenoteid as LoanID,acc.name as NoteName,fs.Value as Units,@currentdatetime as TradeDate,@currentdatetime as PostDate,lcurrency.name as Currency,null as Fees,null as FeeType,null as TradeAccrued,(fs.Value*-1) as Proceeds,null as Comments,null as Reversal
	from [CORE].FundingSchedule fs
	INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
	INNER JOIN (						
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
	inner join cre.deal d on d.dealid = n.dealid
	left join cre.FinancingSourcemaster fn on fn.FinancingSourcemasterID = n.FinancingSourceID
	left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and lcurrency.ParentID = 29
	--and n.crenoteid='6114'  
	where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
	and fn.FinancingSourceName like '%Delphi%'
	and ISNUMERIC(n.crenoteid) = 1
	and fs.[date]=CAST(@currentdatetime as date)--'02/07/2020'
	and (n.ActualPayOffDate is null OR n.ActualPayOffDate >= Cast(@currentdatetime as date))
	and fs.Value>0
	and fs.PurposeID = 581

	
	UNION

	--Added by Vishal "Non Covid PIKPrincipalFunding as Non-Cash Principal"
	Select 'Non-cash Advance - Principal' as TransactionType,'Delphi' as AccountNumber,d.Credealid as DealID,d.dealname as DealName,n.crenoteid as LoanID,acc.name as NoteName,
	(te.amount *-1) as Units,
	te.date as TradeDate,te.date as PostDate,lcurrency.name as Currency,null as Fees,null as FeeType,null as TradeAccrued,
	te.amount as Proceeds,
	null as Comments,null as Reversal
	From cre.note n
	inner join core.account acc on acc.accountid = n.account_accountid  
	left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID 
	inner join cre.deal d on d.dealid = n.dealid
	inner join cre.TransactionEntry te on n.noteid = te.noteid and te.analysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and [Type] in ('PIKPrincipalFunding')
	left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and ParentID = 29
	left join @transactionType temptr on te.[type]=temptr.[type]
	where fs.FinancingSourceName like '%Delphi%'
	and te.date =  Cast(@currentdatetime as date) --'05/08/2020'
	and ISNUMERIC(n.crenoteid) = 1
	and (n.ActualPayOffDate is null OR n.ActualPayOffDate >= Cast(@currentdatetime as date))
	

	union

	--COVID PIK - Principal
	Select temptr.[value] as TransactionType,'Delphi' as AccountNumber,d.Credealid as DealID,d.dealname as DealName,n.crenoteid as LoanID,acc.name as NoteName,
	te.amount as Units,
	te.date as TradeDate,te.date as PostDate,lcurrency.name as Currency,null as Fees,null as FeeType,null as TradeAccrued,
	(te.amount *-1) as Proceeds,
	null as Comments,null as Reversal
	From cre.note n
	inner join core.account acc on acc.accountid = n.account_accountid  
	left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID 
	inner join cre.deal d on d.dealid = n.dealid
	inner join cre.TransactionEntry te on n.noteid = te.noteid and te.analysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and [Type] in ('PIKPrincipalFunding')
	left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and ParentID = 29
	left join @transactionType temptr on te.[type]=temptr.[type]
	where fs.FinancingSourceName like '%Delphi%'
	and te.date =  Cast(@currentdatetime as date) --'05/08/2020'
	and ISNUMERIC(n.crenoteid) = 1
	and (n.ActualPayOffDate is null OR n.ActualPayOffDate >= Cast(@currentdatetime as date))
	and te.FeeName = 'COVID' -- added by vishal 01/29/2021

	union 
	
	--Exit Fee,Extension Fee,Origination Fee,Unused Fee,Prepayment Fee,Modification fee
	
	select TransactionType,AccountNumber,DealID,DealName,LoanID,NoteName,
	Units,TradeDate,PostDate,Currency,Fees,FeeType,TradeAccrued,Proceeds,Comments,Reversal
	from
	(
	Select TransactionType,'Delphi' as AccountNumber,DealID,DealName,LoanID,NoteName,
	null as Units,
	TradeDate,PostDate,tblFeeType.Currency,FORMAT(sum(amount),'#,0.00') as Fees,TransactionType as FeeType,null as TradeAccrued,
	sum(tblFeeType.amount) as Proceeds,
	null as Comments,null as Reversal 
	from
	(
	select 
	(CASE 
	WHEN Type like 'ExitFee%'  THEN 'ExitFee'
	WHEN Type like 'Extension%' or  FeeName like 'Extension%' then 'Extension Fee'
	WHEN Type like 'Origination%' or  FeeName like 'Origination%' then 'Origination Fee'
	WHEN Type like 'Additional%' or  FeeName like 'Additional%' or FeeName like 'Mod Fee%' then 'Modification Fee'
	WHEN Type like 'Unused%'  THEN 'Unused Fee'
	WHEN Type like 'Prepayment%'  THEN 'Yield/Spread Maintenance'
	ELSE Type
	END) as TransactionType,n.crenoteid,te.amount,
	d.Credealid as DealID,d.dealname as DealName,n.crenoteid as LoanID,acc.name as NoteName,te.date as TradeDate,te.date as PostDate,
	lcurrency.name as Currency

	From cre.note n
	inner join core.account acc on acc.accountid = n.account_accountid  
	left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID 
	inner join cre.deal d on d.dealid = n.dealid
	inner join cre.TransactionEntry te on n.noteid = te.noteid and te.analysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and ParentID = 29
	where fs.FinancingSourceName like '%Delphi%'
	--and te.date = Cast(@currentdatetime as date) --'09/10/2021'
	--as per corey it should be on remit date not on payoff date
	and te.RemitDate = Cast(@currentdatetime as date)
	and (
	[Type] like 'ExitFee%' or [Type] like 'Extension%' 
	or ([Type] like 'Origination%' and n.InitialFundingAmount<1) or  (FeeName like 'Origination%' and n.InitialFundingAmount<1)
	or [Type] like 'Additional%' 
	or [Type] like 'Unused%' 
	or [Type] like 'Prepayment%' or FeeName like 'Extension%' or FeeName like 'Additional%' or FeeName like 'Mod Fee%'
	)
	and ISNUMERIC(n.crenoteid) = 1
	and (n.ActualPayOffDate is null OR n.ActualPayOffDate >= Cast(@currentdatetime as date))
	and acc.IsDeleted=0
  ) tblFeeType
  group by LoanID,TransactionType,TradeDate,PostDate,DealID,DealName,LoanID,NoteName,tblFeeType.Currency
  ) tblfee where cast(replace(isnull(tblfee.fees,0), ',', '') as decimal(18,2))<>0
  union
  --Prepayment Fee as 'Minimum Interest Multiple'
	Select TransactionType,'Delphi' as AccountNumber,DealID,DealName,LoanID,NoteName,
	null as Units,
	TradeDate,PostDate,tblFeeType.Currency,FORMAT(sum(amount),'#,0.00') as Fees,TransactionType as FeeType,null as TradeAccrued,
	sum(tblFeeType.amount) as Proceeds,
	null as Comments,null as Reversal 
	from
	(
	select 
	(CASE 
	WHEN Type like 'Prepayment%'  THEN 'Minimum Interest Multiple'
	ELSE Type
	END) as TransactionType,n.crenoteid,te.amount,
	d.Credealid as DealID,d.dealname as DealName,n.crenoteid as LoanID,acc.name as NoteName,te.date as TradeDate,te.date as PostDate,
	lcurrency.name as Currency

	From cre.note n
	inner join core.account acc on acc.accountid = n.account_accountid  
	left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID 
	inner join cre.deal d on d.dealid = n.dealid
	inner join cre.TransactionEntry te on n.noteid = te.noteid and te.analysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and ParentID = 29
	where fs.FinancingSourceName like '%Delphi%'
	and te.date = Cast(@currentdatetime as date) --'09/10/2021'
	and (
	[Type] like 'Prepayment%'
	)
	and ISNUMERIC(n.crenoteid) = 1
	and (n.ActualPayOffDate is null OR n.ActualPayOffDate >= Cast(@currentdatetime as date))
	and acc.IsDeleted=0
  ) tblFeeType
  group by LoanID,TransactionType,TradeDate,PostDate,DealID,DealName,LoanID,NoteName,tblFeeType.Currency
	
)a
Left Join(
	SELECT crenoteid ,ISNULL(RSLIC,0) as RSLIC,ISNULL(SNCC,0) as SNCC,ISNULL(PIIC,0) as PIIC,ISNULL(TMR,0) as TMR,ISNULL(HCC,0) as HCC,ISNULL(USSIC,0) as USSIC,ISNULL([TMD-DL],0) as [TMD-DL],ISNULL(HAIH,0) as HAIH
	--,(ISNULL(RSLIC,0)+ISNULL(SNCC,0)+ISNULL(PIIC,0)+ISNULL(TMR,0)+ISNULL(HCC,0)+ISNULL(USSIC,0)+ISNULL(TMNF,0)+ISNULL(HAIH,0)) TotalParticipation
	FROM   
	(
		Select crenoteid,TrancheName,PercentofNote  from CRE.NoteTranchePercentage
	) t 
	PIVOT(
		SUM(PercentofNote) 
		FOR TrancheName IN (RSLIC,SNCC,PIIC,TMR,HCC,USSIC,[TMD-DL],HAIH)
	) AS pivot_table
)tblDelphiPer on tblDelphiPer.crenoteid = a.LoanID 

--left join (
----origination fee with initial funding of note >1
--	Select 'Origination Fee' as TransactionType , CRENoteID,sum(te.amount) as amount
--	From cre.note n
--	inner join core.account acc on acc.accountid = n.account_accountid  
--	left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID 
--	inner join cre.deal d on d.dealid = n.dealid
--	inner join cre.TransactionEntry te on n.noteid = te.noteid and te.analysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and ([Type] like '%Origination%' or  FeeName like 'Origination%') and n.InitialFundingAmount>1
--	left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and ParentID = 29
--	group by n.crenoteid,fs.FinancingSourceName,n.ActualPayOffDate,te.date,d.Credealid,d.dealname,n.crenoteid,acc.name,lcurrency.name
--	having fs.FinancingSourceName like '%Delphi%'
--	and te.date = CAST(@currentdatetime as date) --'02/07/2020'
--	and ISNUMERIC(n.crenoteid) = 1
--	and n.ActualPayOffDate is null
--) tblOrgFee on tblOrgFee.crenoteid = a.LoanID 


left join (
		Select crenoteid as Noteid,(OriginationFeePercentageRP * 100) OriginationFeePercentageRP from cre.note n
		inner join core.account acc on acc.accountid = n.account_accountid
		where acc.isdeleted <> 1
) tblPrc on tblPrc.Noteid=a.LoanID


)z
order by z.TransactionType







END