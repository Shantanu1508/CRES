

CREATE PROCEDURE [DW].[usp_MergeDailyCalc]

@BatchLogId int

AS
BEGIN

SET NOCOUNT ON


UPDATE [DW].BatchDetail
SET
BITableName = 'DailyCalcBI',
BIStartTime = GETDATE()
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_DailyCalcBI'


MERGE [DW].DailyCalcBI TB
USING [DW].L_DailyCalcBI LTB
ON TB.DailyCalcID = LTB.DailyCalcID
WHEN MATCHED THEN
UPDATE 
SET 
TB.[AccountID] = LTB.[AccountID],
TB.[CalcValueID] = LTB.[CalcValueID],
TB.[Date] = LTB.[Date],
TB.[Amount] = LTB.[Amount],
TB.[IsActual] = LTB.[IsActual],
TB.[CurrencyID] = LTB.[CurrencyID],
TB.[CalcValueBI] = LTB.[CalcValueBI],
TB.[CurrencyBI] = LTB.[CurrencyBI],
TB.[ImportBIDate] = GETDATE(),
TB.[CreatedBy] = LTB.[CreatedBy],
TB.[CreatedDate] = LTB.[CreatedDate],
TB.[UpdatedBy] = LTB.[UpdatedBy],
TB.[UpdatedDate] = LTB.[UpdatedDate]

WHEN NOT MATCHED THEN
	
	INSERT 
	([DailyCalcID]
           ,[AccountID]
           ,[CalcValueID]
           ,[Date]
           ,[Amount]
           ,[IsActual]
           ,[CurrencyID]
           ,[CalcValueBI]
           ,[CurrencyBI]
		   ,[ImportBIDate]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
	VALUES (
	LTB.[DailyCalcID],
LTB.[AccountID],
LTB.[CalcValueID],
LTB.[Date],
LTB.[Amount],
LTB.[IsActual],
LTB.[CurrencyID],
LTB.[CalcValueBI],
LTB.[CurrencyBI],
GETDATE(),
LTB.[CreatedBy],
LTB.[CreatedDate],
LTB.[UpdatedBy],
LTB.[UpdatedDate]
);


DECLARE @RowCount int
SET @RowCount = @@ROWCOUNT

UPDATE [DW].BatchDetail
SET
BIEndTime = GETDATE(),
BIRecordCount = @RowCount
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_DailyCalcBI'

Print(char(9) +'usp_MergeDailyCalc - ROWCOUNT = '+cast(@RowCount  as varchar(100)));


END

