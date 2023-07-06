
CREATE PROCEDURE [DW].[usp_MergeUwCashflow]
@BatchLogId int

AS
BEGIN

SET NOCOUNT ON

UPDATE [DW].BatchDetail
SET
BITableName = 'UwCashflowBI',
BIStartTime = GETDATE()
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_UwCashflowBI'

--===================================
Declare @BSCashflow as Table(
DealID nvarchar(256) NULL,
NoteId nvarchar(256) NULL,
CurrentBalance decimal(28, 15) NULL,
PeriodEndDate datetime NULL,
SharedName nvarchar(max) NULL
)

Insert Into @BSCashflow(
DealID,
NoteId,
CurrentBalance,
PeriodEndDate,
SharedName)

EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'
DECLARE @dt1 Datetime= getdate() - 59
DECLARE @dt2 Datetime= getdate() 
--=======================================================================
Declare @tblCalendarDate table([CalDate]	Date null)
;WITH ctedaterange 
     AS (SELECT [Dates]=@dt1 
         UNION ALL
         SELECT [dates] + 1 
         FROM   ctedaterange 
         WHERE  [dates] + 1<= @dt2) 

INSERT INTO @tblCalendarDate([CalDate])
SELECT Cast([dates] as Date)  as [Date]
FROM   ctedaterange 
OPTION (maxrecursion 0)
---------------------
Declare @tblAMT table
(
	[CalDate]	Date null,
	NoteID int null,
	[BalanceAmt] decimal(28,15)
)
----=======================================================================
INSERT INTO @tblAMT([CalDate],NoteID,[BalanceAmt])
select C.CalDate,x.NoteID_F,x.[BalanceAmt]
from @tblCalendarDate C
outer apply(
	Select NoteID_F,[BalanceAmt] from [acore].[udf_AmortizationScheduleByDate](Convert(Nvarchar(max),Convert(date,Cast( C.CalDate as Date))) , ''Next'') AMNXT
) X

SELECT N.ControlId_F as DealID, N.[NoteId],
CASE WHEN (DATEADD(month, -1, N.FirstPIPaymentDate )) > Cast(a.CalDate as Date) THEN ROUND(N.[StubAmortBalanceAmt], 2) 
ELSE ROUND(isnull(a.[BalanceAmt],N.OrigLoanAmount), 2) END AS [CurrentBalance],
Cast(a.CalDate as Date)as [Date]
FROM dbo.tblnote  N
Inner join @tblAMT a on a.Noteid = N.Noteid
'
--===================================

DECLARE @60DaysTrailingDate Datetime= getdate() - 59
DECLARE @TodayDate Datetime= getdate() 



--Delete from [DW].[UwCashflowBI] where Cast(PeriodEndDate as date)=Cast(GETDATE() as Date);
--Delete from [DW].[UwCashflowBI] where Cast(PeriodEndDate as date) between @dt1 and @dt2

Delete from [DW].[UwCashflowBI] where PeriodEndDate between (getdate() - 60) and getdate() 


INSERT INTO [DW].[UwCashflowBI](
DealID,
NoteId,
CurrentBalance,
PeriodEndDate
)
SELECT 
bscf.DealID,
bscf.NoteId,
bscf.CurrentBalance,
bscf.PeriodEndDate
FROM @BSCashflow bscf


--left join(
--	Select Noteid,MAX(PeriodEndDate) MAXDate from [DW].[UwCashflowBI] 
--	group by Noteid
--)b
--on b.noteid = bscf.noteid 
--where bscf.PeriodEndDate > ISNULL(b.MAXDate,getdate() - 60)





DECLARE @RowCount int
SET @RowCount = @@ROWCOUNT

UPDATE [DW].BatchDetail
SET
BIEndTime = GETDATE(),
BIRecordCount = @RowCount
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_UwCashflowBI'

Print(char(9) +'usp_MergeUwCashflow - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

END