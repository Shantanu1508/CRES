
CREATE PROCEDURE [DW].[usp_ImportAdditionalFee_Balance]
	
AS
BEGIN
	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
	DECLARE @RowCount int


Truncate table [DW].[AdditionalFee_BalanceBI]
	

INSERT INTO [DW].[AdditionalFee_BalanceBI]
           ([DealKey]
           ,[DealID]
           ,[NoteId]
           ,[EffectiveDate]
           ,[FeeName]
           ,[StartDate]
           ,[EndDate]
           ,[FeeType]
           ,[Value]
           ,[FeeAmountOverride]
           ,[BaseAmountOverride]
           ,[ApplyTrueUpFeature]
           ,[IncludedLevelYield]
           ,[FeetobeStripped]
           ,[EndingBalance]
           ,[Amount]
           ,[EstimatedEndingBalance])

SELECT 
Distinct 
F.[dealid] as DealKey
,NC.[CREDealID] as DealID
,F.[crenoteid] as NoteId
,[EffectiveDate]
,F.[FeeName]
,[StartDate]
,[EndDate]
,[FeeType]
,[Value]
,[FeeAmountOverride]
,[BaseAmountOverride]
,[ApplyTrueUpFeature]
,[IncludedLevelYield]
,[FeetobeStripped] 
, ISNUll(NC.EndingBalance,0) as EndingBalance
,ISNULL(SUM(T.Amount),0) as Amount
, ISNUll(NC.EndingBalance,0) + ISNULL(SUM(T.Amount),0) as EstimatedEndingBalance

FROM [DW].[FeeScheduleBI] F
LEFT JOIN TransactionEntry T on T.Noteid = F.Crenoteid 	and   eomonth(F.StartDate,-1) < DATE and DATE <= F.STartdate and [Type] in ('ScheduledPrincipalPaid' , 'FundingOrRepayment')
LEFT JOIN [dbo].[NotePeriodicCalc] NC on  NC.Noteid = F.Crenoteid	and NC.PeriodEnddate = Eomonth (F.Startdate,-1) and NC.Scenario = 'Default'
Where FeeType = 'Extension Fee_COMM' --'Extension Fee_UPB' --'Additional Fee'

Group by
F.[dealid]
,NC.[CREDealID]
,F.[crenoteid]
,[EffectiveDate]
,F.[FeeName]
,[StartDate]
,[EndDate]
,[FeeType]
,[Value]
,[FeeAmountOverride]
,[BaseAmountOverride]
,[ApplyTrueUpFeature]
,[IncludedLevelYield]
,[FeetobeStripped] 
,NC.EndingBalance




SET @RowCount = @@ROWCOUNT
Print(char(9) +'usp_ImportAdditionalFee_Balance - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

	

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END


