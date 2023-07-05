
CREATE PROCEDURE [DW].[usp_ImportDailyCalc]
	@BatchLogId int,@LastBatchStart datetime, @CurrentBatchStart datetime
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime)
	VALUES (@BatchLogId,'L_DailyCalcBI',GETDATE())

	DECLARE @id int,@RowCount int
	SET @id = (SELECT @@IDENTITY)


IF EXISTS(Select DailyCalcID from [DW].DailyCalcBI)
BEGIN

Truncate table [DW].[L_DailyCalcBI]
INSERT INTO [DW].[L_DailyCalcBI]
           ([DailyCalcID]
           ,[AccountID]
           ,[CalcValueID]
           ,[Date]
           ,[Amount]
           ,[IsActual]
           ,[CurrencyID]
           ,[CalcValueBI]
           ,[CurrencyBI]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
SELECT
dc.[DailyCalcID],
dc.[AccountID],
dc.[CalcValueID],
dc.[Date],
dc.[Amount],
dc.[IsActual],
dc.[CurrencyID],
lCalcValue.Name  as [CalcValueBI],
lCurrency.Name  as [CurrencyBI],
dc.[CreatedBy],
dc.[CreatedDate],
dc.[UpdatedBy],
dc.[UpdatedDate]
FROM CORE.DailyCalc dc
LEFT Join Core.Lookup lCurrency on dc.CurrencyID=lCurrency.LookupID
LEFT Join Core.Lookup lCalcValue on dc.CalcValueID=lCalcValue.LookupID
	WHERE (dc.CreatedDate > @LastBatchStart 
	and dc.CreatedDate < @CurrentBatchStart) 
	OR 
	(dc.UpdatedDate > @LastBatchStart 
	and dc.UpdatedDate < @CurrentBatchStart)


SET @RowCount = @@ROWCOUNT
Print(char(9) +'usp_ImportDailyCalc - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

END
ELSE
BEGIN


Truncate table [DW].[L_DailyCalcBI]
INSERT INTO [DW].[L_DailyCalcBI]
           ([DailyCalcID]
           ,[AccountID]
           ,[CalcValueID]
           ,[Date]
           ,[Amount]
           ,[IsActual]
           ,[CurrencyID]
           ,[CalcValueBI]
           ,[CurrencyBI]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
SELECT
dc.[DailyCalcID],
dc.[AccountID],
dc.[CalcValueID],
dc.[Date],
dc.[Amount],
dc.[IsActual],
dc.[CurrencyID],
lCalcValue.Name  as [CalcValueBI],
lCurrency.Name  as [CurrencyBI],
dc.[CreatedBy],
dc.[CreatedDate],
dc.[UpdatedBy],
dc.[UpdatedDate]
FROM CORE.DailyCalc dc
LEFT Join Core.Lookup lCurrency on dc.CurrencyID=lCurrency.LookupID
LEFT Join Core.Lookup lCalcValue on dc.CalcValueID=lCalcValue.LookupID


SET @RowCount = @@ROWCOUNT
Print(char(9) +char(9)+'usp_ImportDailyCalc - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

END




UPDATE [DW].BatchDetail
SET
LandingEndTime = GETDATE(),
LandingRecordCount = @RowCount
WHERE BatchDetailId = @id





END


