

CREATE PROCEDURE [DW].[usp_MergeBackshopCurrentBalance]
@BatchLogId int
AS
BEGIN

SET NOCOUNT ON


UPDATE [DW].BatchDetail
SET
BITableName = 'BackshopCurrentBalanceBI',
BIStartTime = GETDATE()
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_BackshopCurrentBalanceBI'



Declare @TodayPacific date = getdate();
--=======================================================================
Declare @tblAmortizationScheduleByDate table
(
	ControlId_F	nvarchar(256) null,
	FinancingSource	nvarchar(256) null,
	NoteId_F int null,
	PaymentNumber int null,
	AmortSchedDate	Date null,
	DaysInPeriod	int null,
	BalanceAmt	decimal(28,15) null,
	PrincipleAmt decimal(28,15) null,
	InterestAmt	decimal(28,15) null,
	LiborInterestRate decimal(28,15) null,
	IsExtension	bit null,
	NoteExtensionId_F int null,
	ShardName nvarchar(max) null
)

--Insert data from function "[acore].[udf_AmortizationScheduleByDate]" to temp table "@tblAmortizationScheduleByDate"
DECLARE @query nvarchar(256) = N'Select ControlId_F,FinancingSource,NoteId_F,PaymentNumber,AmortSchedDate,DaysInPeriod,BalanceAmt,PrincipleAmt,InterestAmt,LiborInterestRate,IsExtension,NoteExtensionId_F
from [acore].[udf_AmortizationScheduleByDate]('''+Convert(Nvarchar(max),Convert(date,@TodayPacific))+''' , ''Next'')'
INSERT INTO @tblAmortizationScheduleByDate(ControlId_F,FinancingSource,NoteId_F,PaymentNumber,AmortSchedDate,DaysInPeriod,BalanceAmt,PrincipleAmt,InterestAmt,LiborInterestRate,IsExtension,NoteExtensionId_F,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', @stmt = @query
--=======================================================================

truncate table [DW].[BackshopCurrentBalanceBI]

--Main query
INSERT INTO [DW].[BackshopCurrentBalanceBI](DealID,[NoteID],[CurrentBalance],[ImportDate])

Select N.ControlId_F as DealID, N.[NoteId],
CASE WHEN (DATEADD(month, -1, N.FirstPIPaymentDate )) > @TodayPacific THEN ROUND(N.[StubAmortBalanceAmt], 2) 
ELSE ROUND(isnull(AMNEXT.[BalanceAmt],N.OrigLoanAmount), 2) END AS [CurrentBalance],
@TodayPacific as ImportDate

from dbo.[Ex_BS_tblNote]  N
LEFT OUTER JOIN @tblAmortizationScheduleByDate AMNEXT
ON AMNEXT.[NoteId_F] = N.[NoteId]



DECLARE @RowCount int
SET @RowCount = @@ROWCOUNT

UPDATE [DW].BatchDetail
SET
BIEndTime = GETDATE(),
BIRecordCount = @RowCount
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_BackshopCurrentBalanceBI'

Print(char(9) +'usp_MergeBackshopCurrentBalance - ROWCOUNT = '+cast(@RowCount  as varchar(100)));


END

