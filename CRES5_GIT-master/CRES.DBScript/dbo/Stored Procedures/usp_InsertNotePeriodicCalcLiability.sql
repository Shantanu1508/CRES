
---[dbo].[usp_InsertNotePeriodicCalcLiability] '4596187B-92F7-4B22-B1B5-B5AECA729CD6','C10F3372-0FC2-4861-A9F5-148F1F80804F'

CREATE PROCEDURE [dbo].[usp_InsertNotePeriodicCalcLiability]
(
    @EquityID UNIQUEIDENTIFIER,
	@AnalysisID UNIQUEIDENTIFIER

)
AS
BEGIN



Declare @NumberofDaysinPast int  = (Select [Value] from app.appconfig where [key] = 'NumberofDaysinPast')
Declare @NumberofDaysinFuture int  = (Select [Value] from app.appconfig where [key] = 'NumberofDaysinFuture')


DECLARE @StartDateTime DATE
DECLARE @EndDateTime DATE
SET @StartDateTime = Dateadd(day,@NumberofDaysinPast *-1,getdate())
SET @EndDateTime = Dateadd(day,@NumberofDaysinFuture,getdate()) -1 


Declare @tblCalendar_Daily as table (DateData Date)
;WITH DateRange(DateData) AS (
	SELECT @StartDateTime as Date
	UNION ALL
	SELECT DATEADD(d,1,DateData)
	FROM DateRange 
	WHERE DateData < @EndDateTime)

INSERT INTO @tblCalendar_Daily(DateData)
SELECT DISTINCT (DateData) DateData  FROM DateRange
OPTION (MAXRECURSION 0)
---------------------------------------------------


Declare @tblLibAccount as TABLE(
	Accountid UNIQUEIDENTIFIER	,
	EndingBalance decimal(28,15)
)

INSERT INTO @tblLibAccount(Accountid)
Select Distinct tr.accountid
from cre.TransactionEntry tr
where tr.analysisid = @AnalysisID
and tr.ParentAccountID = @EquityID
and tr.EndingBalance is not null
---------------------------------------------------------

Declare @tblLib_AccountDates as TABLE(
	Accountid UNIQUEIDENTIFIER,
	[Date] date
)

INSERT INTO @tblLib_AccountDates(Accountid,[Date])
Select libacc.accountid,c.DateData
from @tblCalendar_Daily c,@tblLibAccount libacc
---------------------------------------------------------

Declare @tblLib_Tran as TABLE(
	Accountid UNIQUEIDENTIFIER,
	[Date] date,
	[type] nvarchar(256),
	Amount decimal(28,15),
	EndingBalance decimal(28,15)
)

INSERT INTO @tblLib_Tran(Accountid,[Date],[type],Amount,EndingBalance)
Select tr.accountid,tr.date,tr.[type],tr.amount,tr.EndingBalance
from cre.TransactionEntry tr
where tr.analysisid = @AnalysisID
and tr.ParentAccountID = @EquityID
and tr.EndingBalance is not null
--Order by tr.accountid,tr.date
---------------------------------------------------------

Delete from CRE.NotePeriodicCalc where ParentAccountID = @EquityID and AnalysisID = @AnalysisID

INSERT INTO CRE.NotePeriodicCalc(Accountid,PeriodEndDate,[Month],EndingBalance,AnalysisID)
Select dt.Accountid,dt.Date as PeriodEndDate,
(CASE WHEN dt.Date = EOMONTH(dt.Date) THEN MONTH(dt.Date) ELSE null END) as [Month]
,tr.EndingBalance 
,@AnalysisID as AnalysisID
from @tblLib_AccountDates dt
Outer apply(
	Select top 1 Accountid,[Date],[type],Amount,EndingBalance
	from @tblLib_Tran tr1
	Where tr1.Accountid = dt.Accountid and tr1.Date <= dt.Date
	Order by tr1.date desc
)tr
---Order by dt.accountid,dt.date


END


