-- Procedure  
  
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
 sub_trans_type nvarchar(256),  
 [value] nvarchar(256)  
 )  
 Insert into @transactionType values  
 ('AccruedInterestSuspense','',''),  
 ('AdditionalFeesExcludedFromLevelYield','',''),  
 ('AdditionalFeesIncludedInLevelYield','',''),  
 ('Balloon','',''),  
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
 ('FloatInterest','CLOSE_FEE','FLOAT INTEREST ON PAYDOWN'),  
 ('FundingOrRepayment','',''),  
 ('InitialFunding','',''),  
 ('InterestPaid','LIB_INT','INTEREST PAYMENT'),  
 ('LIBORPercentage','',''),  
 ('OriginationFee','CLOSE_FEE','ORIGINATION FEE FROM BORROWER'),  
 ('OriginationFeeIncludedInLevelYield','',''),  
 ('OriginationFeeStripping','',''),  
 ('OriginationFeeStripReceivable','',''),  
 ('OtherFeeExcludedFromLevelYield','',''),  
 ('PIKInterest','',''),  
 ('PIKInterestPercentage','',''),  
 ('PIKPrincipalFunding','',''),  
 ('PrepaymentFeeExcludedFromLevelYield','CLOSE_FEE','PREPAYMENT FEE'),  
 ('PurchasedInterest','',''),  
 ('ScheduledPrincipalPaid','',''),  
 ('SpreadPercentage','',''),  
 ('StubInterest','LIB_INT','STUB INTEREST'),  
 ('UnusedFeeExcludedFromLevelYield','',''),  
 ('AcoreOriginationFeeExcludedFromLevelYield','MGMT_FEE','ORIGINATION FEE TO ADVISOR') ,
  ('ManagementFee','MGMT_FEE','MANAGEMENT FEE TO ADVISOR')   
   
 
 
 Select PORTFOLIO,
CURRENCY,
CUSIP,
SETTLE_DATE,
SUB_TRAN_TYPE,
TRADE_DATE,
TRAN_TYPE,
COMMISSION,
INTEREST,
PRINCIPAL,
[Other Fees],
AUTHORIZED_BY,
COMMENTS,
CONFIRMED_BY
From( 
 Select   
 --(CASE WHEN fs.FinancingSourceName ='TRE ACR Portfolio' THEN 'JPDACRTRE' ELSE 'USDACRTRE' END) as PORTFOLIO,  
 (CASE WHEN fs.FinancingSourceName ='TRE ACR Portfolio' THEN 'JPDACRCSH' ELSE 'USDACRCSH' END) as PORTFOLIO,  
 lcurrency.name as CURRENCY,  
 'ACR' + FORMAT(CAST(n.crenoteid as int),'D6') as CUSIP,  
 --CAST(GetDate() as Date) as SETTLE_DATE,  
 CONVERT(varchar, @currentdatetime,101) as SETTLE_DATE,  
 ISNULL(temptr.sub_trans_type,'LIB_INT') as SUB_TRAN_TYPE,  
 --CAST(GetDate() as Date) as TRADE_DATE,  
 CONVERT(varchar, @currentdatetime,101) as TRADE_DATE,  
 'MISC' as TRAN_TYPE,  
 null as COMMISSION,  
 (CASE When nc.type in ('InterestPaid','StubInterest') then FORMAT(nc.amount,'#,0.00')  else null end) as INTEREST,   
 null as PRINCIPAL,  
 (CASE When nc.type not in ('InterestPaid','StubInterest') then FORMAT(nc.amount,'#,0.00') else null end) as [Other Fees],   
 'RK' as AUTHORIZED_BY, 
 (CASE WHEN temptr.[Type] in ('AcoreOriginationFeeExcludedFromLevelYield') THEN ISNULL(temptr.[value],'INTEREST PAYMENT') ELSE UPPER(d.dealname) + ' ' + UPPER(acc.name) +' '+ ISNULL(temptr.[value],'INTEREST PAYMENT') END) as COMMENTS,
  ---UPPER(d.dealname) + ' ' + UPPER(acc.name) +' '+ ISNULL(temptr.[value],'INTEREST PAYMENT') as COMMENTS, --GREENSPOINT PLACE NOTE A-1 INTEREST PAYMENT  
 'RK' as CONFIRMED_BY  
 From cre.Note n  
 inner join cre.Deal d on d.dealid = n.dealid  
 inner join core.account acc on acc.accountid = n.account_accountid  
 left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and ParentID = 29  
 left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID  
 left join (  
	  Select tr.noteid,tr.type,SUM(tr.amount) amount  
	  from cre.TransactionEntry tr   
	  where tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'   
	  and tr.type in ('InterestPaid','StubInterest','ExitFeeExcludedFromLevelYield','PrepaymentFeeExcludedFromLevelYield','FloatInterest')  
	  and tr.Remitdate = Cast(@currentdatetime as Date)      
	  and tr.noteid in (  
		   Select nn.noteid from cre.note nn  
		   inner join core.account acc1 on acc1.accountid = nn.account_accountid  
		   left join cre.FinancingSourcemaster fs1 on fs1.FinancingSourcemasterID = nn.FinancingSourceID  
		   where acc1.IsDeleted <> 1 and ISNUMERIC(nn.crenoteid) = 1 and fs1.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio')  
		   )  
	  group by tr.noteid,tr.type  
  
	  --UNION ALL  
  
	  --Select tr.noteid,tr.type,SUM(tr.amount) amount  
	  --from cre.TransactionEntry tr   
	  --where tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'   
	  --and tr.type in ('AcoreOriginationFeeExcludedFromLevelYield')  
	  --and tr.date = Cast(@currentdatetime as Date)      
	  --and tr.noteid in (  
	  -- Select nn.noteid from cre.note nn  
	  -- inner join core.account acc1 on acc1.accountid = nn.account_accountid  
	  -- left join cre.FinancingSourcemaster fs1 on fs1.FinancingSourcemasterID = nn.FinancingSourceID  
	  -- where acc1.IsDeleted <> 1 and ISNUMERIC(nn.crenoteid) = 1 and fs1.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio')  
	  --)  
	  --group by tr.noteid,tr.type   

 )nc on nc.noteid = n.noteid  
 join @transactionType temptr on nc.[type]=temptr.[type]  
   
   
 --Outer Apply(  
 -- Select tr.noteid,SUM(tr.amount) amount  
 -- from cre.TransactionEntry tr   
 -- where tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'  
 -- and tr.type = 'InterestPaid'  
 -- and tr.date >= CAST(DATEADD(month, DATEDIFF(month, 0, getdate()), 0) as Date) and tr.date <= EOMONTH(getdate())  
 -- and tr.noteid = n.noteid  
 -- group by tr.noteid  
 --)nc   
 where acc.IsDeleted <> 1  
 and ISNUMERIC(n.crenoteid) = 1   
 and fs.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio')  
 ---and n.ActualPayOffDate is null  


 UNION ALL

Select   
(CASE WHEN fs.FinancingSourceName ='TRE ACR Portfolio' THEN 'JPDACRCSH' ELSE 'USDACRCSH' END) as PORTFOLIO,  
lcurrency.name as CURRENCY,  
'ACR' + FORMAT(CAST(n.crenoteid as int),'D6') as CUSIP,  
CONVERT(varchar, @currentdatetime,101) as SETTLE_DATE, 
ISNULL(temptr.sub_trans_type,'LIB_INT') as SUB_TRAN_TYPE, 
CONVERT(varchar, tr.Date,101) as TRADE_DATE,  
'MISC' as TRAN_TYPE,  
null as COMMISSION,  
null as INTEREST,   
null as PRINCIPAL,  
FORMAT(tr.amount,'#,0.00') as [Other Fees],   
'RK' as AUTHORIZED_BY, 
temptr.[value] as COMMENTS,
'RK' as CONFIRMED_BY  
from cre.TransactionEntry tr   
Inner join cre.Note n  on n.noteid = tr.noteid
inner join cre.Deal d on d.dealid = n.dealid  
inner join core.account acc on acc.accountid = n.account_accountid  
left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and ParentID = 29 
left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID 
join @transactionType temptr on tr.[Type]=temptr.[type] 

where tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'   
and tr.type in ('AcoreOriginationFeeExcludedFromLevelYield' )  
and tr.date = Cast(@currentdatetime as Date)
and tr.noteid in (  
	Select nn.noteid from cre.note nn  
	inner join core.account acc1 on acc1.accountid = nn.account_accountid  
	left join cre.FinancingSourcemaster fs1 on fs1.FinancingSourcemasterID = nn.FinancingSourceID  
	where acc1.IsDeleted <> 1 and ISNUMERIC(nn.crenoteid) = 1 and fs1.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio')  
)  
and acc.IsDeleted <> 1  
and ISNUMERIC(n.crenoteid) = 1   
and fs.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio')  


 UNION ALL



Select   
(CASE WHEN fs.FinancingSourceName ='TRE ACR Portfolio' THEN 'JPDACRCSH' ELSE 'USDACRCSH' END) as PORTFOLIO,  
lcurrency.name as CURRENCY,  
'ACR' + FORMAT(CAST(n.crenoteid as int),'D6') as CUSIP,  
CONVERT(varchar, @currentdatetime,101) as SETTLE_DATE, 
ISNULL(temptr.sub_trans_type,'LIB_INT') as SUB_TRAN_TYPE, 
CONVERT(varchar, tr.Date,101) as TRADE_DATE,  
'MISC' as TRAN_TYPE,  
null as COMMISSION,  
null as INTEREST,   
null as PRINCIPAL,  
FORMAT(tr.amount,'#,0.00') as [Other Fees],   
'RK' as AUTHORIZED_BY, 
temptr.[value] as COMMENTS,
'RK' as CONFIRMED_BY  
from cre.TransactionEntry tr   
Inner join cre.Note n  on n.noteid = tr.noteid
inner join cre.Deal d on d.dealid = n.dealid  
inner join core.account acc on acc.accountid = n.account_accountid  
left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and ParentID = 29 
left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID 
join @transactionType temptr on tr.[Type]=temptr.[type] 

where tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'   
and tr.type in ('ManagementFee' )  
and tr.Remitdate = Cast(@currentdatetime as Date)
and tr.noteid in (  
	Select nn.noteid from cre.note nn  
	inner join core.account acc1 on acc1.accountid = nn.account_accountid  
	left join cre.FinancingSourcemaster fs1 on fs1.FinancingSourcemasterID = nn.FinancingSourceID  
	where acc1.IsDeleted <> 1 and ISNUMERIC(nn.crenoteid) = 1 and fs1.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio')  
)  
and acc.IsDeleted <> 1  
and ISNUMERIC(n.crenoteid) = 1   
and fs.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio')  

)z

 order by z.SUB_TRAN_TYPE  --,CAST(n.crenoteid as int)  
  
  
   
  
END  