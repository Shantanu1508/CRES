----[dbo].[usp_GetAflac_ACR_InterestAccrual]   '{"Date":"05/28/2021"}'

CREATE Procedure [dbo].[usp_GetAflac_ACR_InterestAccrual]    
(    
@JsonReportParamters NVARCHAR(MAX)=null    
)    
AS    
BEGIN    
SET NOCOUNT ON;    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
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
 --US Eastern time zone    
 --US Eastern time zone    
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


 declare @OneDayBackDate datetime = dateadd(d,-1,@currentdatetime)    
 declare @OneDayBackDayWeekName nvarchar(10) = DATENAME(dw, @OneDayBackDate)    
 declare @datefrom datetime =dateadd(d,1,dbo.[Fn_FFInnerGetnextWorkingDays](@OneDayBackDate,-1,'PMT Date'))    
 declare @holidaytypeid int,@CountOneDayBackDateHoliday int=0,@IsShowReport int =1    
 declare @currentDayWeekName nvarchar(10) = DATENAME(dw, @currentdatetime)  
   
 --select @holidaytypeid =LookupID from Core.Lookup where name='PMT Date'  
Select @holidaytypeid = HolidayMasterID from App.HolidaysMaster where CalendarName = 'US'


 select  @CountOneDayBackDateHoliday = count(1) from App.HoliDays where HolidayTypeID=@holidaytypeid and cast(HoliDayDate as date)=cast(@OneDayBackDate as date)    
     
 --if report date is saturday,sunday or holiday than dont show report    
 if (exists(select 1 from App.HoliDays where HolidayTypeID=@holidaytypeid and cast(HoliDayDate as date)=cast(@currentdatetime as date))    
 or @currentDayWeekName='sunday' or @currentDayWeekName='saturday')    
 begin    
  print @currentDayWeekName    
  set @IsShowReport=0    
 end    
--==================================================

---Store full accrual interest after paidoffdate
If(OBJECT_ID('tempdb..#tblDailyIn') Is Not Null)
	Drop Table #tblDailyIn
CREATE TABLE #tblDailyIn(
NoteID UNIQUEIDENTIFIER,
Date date,
DailyInterestAccrual decimal(28,15),
ActualPayoffDate date
)

INSERT INTO #tblDailyIn(NoteID,[date],DailyInterestAccrual,ActualPayoffDate)
Select di.Noteid,date,DailyInterestAccrual ,n.ActualPayoffDate
from CRE.DailyInterestAccruals di
inner join cre.note n on n.noteid = di.noteid
inner join core.account acc on acc.accountid = n.account_accountid   
left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID   
where analysisid='C10F3372-0FC2-4861-A9F5-148F1F80804F'
and Date >= n.ActualPayoffDate
and di.noteid in (
	Select n.noteid 
	from cre.note n 
	inner join core.account acc on acc.accountid = n.account_accountid   
	left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID  
	Where n.ActualPayoffDate is not null
	and fs.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio') 
	and acc.IsDeleted <> 1    
	and ISNUMERIC(n.crenoteid) = 1 
)
--==========================================================
    
	Select     
	'ACR'+REPLICATE('0',6-LEN(RTRIM(n.crenoteid))) + RTRIM(n.crenoteid) as [Asset_SecurityID],    
	ROUND((pir.AllInCouponRate*100),6,0) as [ContractIPF_AllInRate],    
	CONVERT(varchar, @currentdatetime, 101) as [ContractIP_ReceiveDate],    
	lcurrency.name as [Contract_CurrencyType_Identifier],    
	'ACR'+REPLICATE('0',6-LEN(RTRIM(n.crenoteid))) + RTRIM(n.crenoteid) +' '+    
	+ DATENAME(month, @currentdatetime)+' Interest'     
	as [Contract_Name], 
	(case 
	when (@OneDayBackDayWeekName='sunday' or @OneDayBackDayWeekName='saturday' or @CountOneDayBackDateHoliday>0) then (select FORMAT(sum(DailyinterestAccrual),'#,0.00') from CRE.DailyInterestAccruals where NoteID=n.NoteID and [Date] between @datefrom and nc.[Date] and analysisid='C10F3372-0FC2-4861-A9F5-148F1F80804F')    
	when Cast(@currentdatetime as date) = n.ActualPayoffDate Then FORMAT(tblFullAccrualInterest.sum_DailyInterestAccrual,'#,0.00')  
	else FORMAT(nc.DailyInterestAccrual,'#,0.00') 	   
	end
	) as EarnedCash, 
	'' as [MiscFees],    
	(CASE WHEN fs.FinancingSourceName ='TRE ACR Portfolio' THEN 'JPDACRTRE' ELSE 'USDACRTRE' END) as Portfolio_Name,    
	'ACR'+REPLICATE('0',6-LEN(RTRIM(n.crenoteid))) + RTRIM(n.crenoteid) as [Position_ID],    
	'LIBOR' as [Contract_FacilityOption_Name]    
	From cre.Note n    
	inner join core.account acc on acc.accountid = n.account_accountid    
	left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and ParentID = 29    
	left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID    
	join CRE.DailyInterestAccruals nc on nc.NoteID = n.NoteID and cast(nc.[Date]as date)=cast(@currentdatetime as date) and  nc.analysisid='C10F3372-0FC2-4861-A9F5-148F1F80804F'     
	join [CRE].[PeriodicInterestRateUsed] pir on pir.NoteID= n.NoteID  and cast(pir.[Date]as date)=cast(@currentdatetime as date)  and pir.analysisid='C10F3372-0FC2-4861-A9F5-148F1F80804F'    
	Left Join(	
		Select NoteID,ActualPayoffDate,SUM(DailyInterestAccrual) sum_DailyInterestAccrual
		from #tblDailyIn
		group by NoteID,ActualPayoffDate 
	)tblFullAccrualInterest on tblFullAccrualInterest.noteid = n.noteid and tblFullAccrualInterest.ActualPayoffDate = n.ActualPayoffDate
 
	where acc.IsDeleted <> 1    
	and ISNUMERIC(n.crenoteid) = 1     
	and fs.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio')   
	and (n.ActualPayOffDate is null OR n.ActualPayOffDate > Cast(@currentdatetime as date)  OR (n.ActualPayOffDate = Cast(@currentdatetime as date) and n.InterestCalculationRuleForPaydowns = 594) ) --Full Period Accrual
	and nc.DailyInterestAccrual is not null    
	and nc.DailyInterestAccrual > 0   
	and @IsShowReport=1    
	order by CAST(n.crenoteid as int)    
    





----	---====================================
--If(OBJECT_ID('tempdb..#tblDailyIn') Is Not Null)
--	Drop Table #tblDailyIn
--CREATE TABLE #tblDailyIn(
--NoteID UNIQUEIDENTIFIER,
--Date date,
--DailyInterestAccrual decimal(28,15)
--)

--INSERT INTO #tblDailyIn(NoteID,[date],DailyInterestAccrual)
--Select di.Noteid,date,DailyInterestAccrual 
--from CRE.DailyInterestAccruals di
--inner join cre.note n on n.noteid = di.noteid
--where analysisid='C10F3372-0FC2-4861-A9F5-148F1F80804F'
--and n.ActualPayoffDate is not null
----and di.noteid = 'B9B9C9B6-F5CC-4701-B646-00A9EA0F543B'
--and Date >= DATEADD(m, DATEDIFF(m, 0, n.ActualPayoffDate), 0) and date < n.ActualPayoffDate

----Select * from #tblDailyIn

--Select a.*,b.sum_DailyInterestAccrual from(
--Select  distinct tr.noteid,n.ActualPayoffDate,tr.Amount ,ISNULL(DAY(tr.PaymentDateNotAdjustedforWorkingDay),8)  dd

--,(CASE WHEN DAY(n.actualpayoffdate) <= ISNULL(DAY(tr.PaymentDateNotAdjustedforWorkingDay),8) THEN DATEADD(m, DATEDIFF(m, 0, DATEADD(m,-1,n.ActualPayoffDate)), (ISNULL(DAY(tr.PaymentDateNotAdjustedforWorkingDay),8) - 1 ))
--ELSE DATEADD(m, DATEDIFF(m, 0, n.ActualPayoffDate), (ISNULL(DAY(tr.PaymentDateNotAdjustedforWorkingDay),8) - 1 ))
--END
--)  as AccrualStartDate

--,DATEADD(d,-1, n.ActualPayoffDate) as AccrualEndDate
--from cre.TransactionEntry tr
--Inner Join cre.note n on n.noteid = tr.NoteID
--Inner join core.Account acc on acc.AccountID = n.account_accountid
--where tr.analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' 
--and [type] = 'InterestPaid'
--and tr.date = n.ActualPayoffDate
--and n.ActualPayoffDate is not null
--and Round(tr.Amount,0) <> 0

----and n.noteid = 'B9B9C9B6-F5CC-4701-B646-00A9EA0F543B'
--)a
--Outer Apply(
--	Select Noteid,SUM(DailyInterestAccrual ) sum_DailyInterestAccrual
--	from #tblDailyIn
--	where noteid = a.noteid
--	and Date >= a.AccrualStartDate and date <= AccrualEndDate
--	group by Noteid
--)b




















 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END
