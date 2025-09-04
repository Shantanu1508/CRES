-- Procedure
-- Procedure
CREATE PROCEDURE [dbo].[usp_ImportProductionDataIntoIntegration_New]  
AS  
BEGIN  
    SET NOCOUNT ON;  
   
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  


EXEC [dbo].[usp_SetElasticQuery_ImportFromProduction]


 
  
IF((Select [Value] from app.appconfig where [key] = 'ImportStagingDataIntoIntegration') = 0)  
BEGIN  
 Print('You can not import data because flag is OFF.')  
 return  
END   
ELSE  
BEGIN   
 UPDATE app.appconfig set [value] = 0 where [key] = 'ImportStagingDataIntoIntegration'   
   
  
 --Truncate table DW.ImportStagDataIntoInt_Status  
 --INSERT INTO DW.ImportStagDataIntoInt_Status(TableName,[Status],StartDate,EndDate )  
 --Values('Note','Completed',getdate(),getdate()),  
 --('NoteFunding','Completed',getdate(),getdate()),  
 --('DealFundingSchdule','Completed',getdate(),getdate()),  
 --('TransactionEntry','Completed',getdate(),getdate()),  
 --('NotePeriodicCalc','Completed',getdate(),getdate())  
  
 --return  
END  
  
--===============================  
Truncate table DW.ImportStagDataIntoInt_Status  
INSERT INTO DW.ImportStagDataIntoInt_Status(TableName,[Status])  
Values('Note','Pending'),  
('NoteFunding','Pending'),  
('DealFundingSchdule','Pending'),  
('TransactionEntry','Pending'),  
('NotePeriodicCalc','Pending')  
--===============================  
  
--Declare @tblAnalysisID as table(AnalysisID UNIQUEIDENTIFIER)  
  
--INSERT INTO @tblAnalysisID(AnalysisID)  
--Select analysisID from  [dbo].[Ex_Staging_Analysis] where [name] in ( 'Default','Expected Maturity Date')   
  
----Declare @analysiID UNIQUEIDENTIFIER = (Select analysisID from  [dbo].[Ex_Staging_Analysis] where [name] = 'Default')  
  
  
  
Update DW.ImportStagDataIntoInt_Status set [Status] = 'InProcess',StartDate = getdate() where TableName = 'Note'  
  
exec [dbo].[usp_Import_Staging_Note]  
  
Update DW.ImportStagDataIntoInt_Status set [Status] = 'Completed',EndDate = getdate() where TableName = 'Note'  
  
  
truncate table [DW].[Staging_Cashflow]  
truncate table [DW].[Staging_TransactionEntry]  
truncate table [DW].[Staging_NoteFunding]  
Truncate table [DW].[Staging_DealFundingSchdule]  
  
Update DW.ImportStagDataIntoInt_Status set [Status] = 'InProcess',StartDate = getdate() where TableName = 'NoteFunding'  
  
INSERT INTO [DW].[Staging_NoteFunding]  
([NoteID]  
,[CRENoteID]  
,[TransactionDate]  
,[WireConfirm]  
,[PurposeBI]  
,[Amount]  
,[DrawFundingID]  
,[Comments]  
,[CreatedBy]  
,[CreatedDate]  
,[UpdatedBy]   
,[UpdatedDate] )  
  
Select [NoteID]  
,[CRENoteID]  
,[TransactionDate]  
,[WireConfirm]  
,[PurposeBI]  
,[Amount]  
,[DrawFundingID]  
,[Comments]  
,[CreatedBy]  
,[CreatedDate]  
,[UpdatedBy]   
,[UpdatedDate]  
From [dbo].[Ex_Staging_LatestNoteFunding]  
  
PRINT('Staging_NoteFunding: '+CAST(@@ROWCOUNT as nvarchar(256)))  
  
Update DW.ImportStagDataIntoInt_Status set [Status] = 'Completed',EndDate = getdate() where TableName = 'NoteFunding'  
  
--INSERT INTO [DW].[Staging_NoteFunding]  
--           ([NoteID]  
--     ,[CRENoteID]  
--           ,[TransactionDate]  
--           ,[WireConfirm]  
--           ,[PurposeBI]  
--           ,[Amount]  
--           ,[DrawFundingID]  
--           ,[Comments]  
--           ,[CreatedBy]  
--   ,[CreatedDate]  
--   ,[UpdatedBy]   
--   ,[UpdatedDate] )  
  
--Select    
--n.NoteID  
--,n.crenoteid as crenoteid  
--,fs.[Date] as [TransactionDate]  
--,fs.Applied as [WireConfirm]  
--,LPurposeID.Name as [PurposeBI]  
--,fs.Value as [Amount]  
--,fs.DrawFundingId as [DrawFundingID]  
--,fs.Comments as [Comments]  
--,fs.[CreatedBy]  
--,fs.[CreatedDate]  
--,fs.[UpdatedBy]   
--,fs.[UpdatedDate]   
--from [dbo].Ex_Staging_FundingSchedule fs  
--INNER JOIN [dbo].Ex_Staging_Event e on e.EventID = fs.EventId  
--INNER JOIN   
--   (  
        
--    Select   
--     (Select AccountID from [dbo].Ex_Staging_Account ac where ac.AccountID = ns.Account_AccountID) AccountID ,  
--     MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID  
--     from [dbo].Ex_Staging_Event eve  
--     INNER JOIN [dbo].Ex_Staging_Note ns ON ns.Account_AccountID = eve.AccountID  
--     INNER JOIN [dbo].Ex_Staging_Account acc ON acc.AccountID = ns.Account_AccountID  
--     where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')  
--     --and ns.NoteID = @NoteId    
--     and acc.IsDeleted = 0  
--     and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)  
--     GROUP BY ns.Account_AccountID,EventTypeID,eve.StatusID  
  
--   ) sEvent  
  
--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
  
--left JOIN [Core].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID   
--INNER JOIN [dbo].Ex_Staging_Account acc ON acc.AccountID = e.AccountID  
--INNER JOIN [dbo].Ex_Staging_Note n ON n.Account_AccountID = acc.AccountID  
--where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0  
  
  
---------------------------------------  
  
Update DW.ImportStagDataIntoInt_Status set [Status] = 'InProcess',StartDate = getdate() where TableName = 'DealFundingSchdule'  
  
  
INSERT INTO [DW].[Staging_DealFundingSchdule]  
([DealFundingID]  
,[DealID]  
,[CREDealID]  
,[Date]  
,[Amount]   
,[PurposeBI]  
,[WireConfirm]  
,[Comment]  
,[DrawFundingId]     
,[CreatedBy]  
,[CreatedDate]  
,[UpdatedBy]  
,[UpdatedDate])  
Select  
d.[DealFundingID],  
d.[DealID],  
deal.[CREDealID],  
d.[Date],  
d.[Amount],  
lPurpose.Name,  
d.[Applied],  
d.[Comment],  
d.[DrawFundingId],  
d.[CreatedBy],  
d.[CreatedDate],  
d.[UpdatedBy],  
d.[UpdatedDate]  
FROM EX_Staging_DealFunding d  
inner join EX_Staging_Deal deal on d.DealID = deal.DealID  
LEFT Join Core.Lookup lPurpose on d.PurposeID=lPurpose.LookupID and  ParentID = 50  
  
PRINT('Staging_DealFundingSchdule: '+CAST(@@ROWCOUNT as nvarchar(256)))  
  
Update DW.ImportStagDataIntoInt_Status set [Status] = 'Completed',EndDate = getdate() where TableName = 'DealFundingSchdule'  
  
  
  
  
Update DW.ImportStagDataIntoInt_Status set [Status] = 'InProcess',StartDate = getdate() where TableName = 'TransactionEntry'  
  
  
  
  
--INSERT INTO [DW].[Staging_TransactionEntry]  
--([TransactionEntryID]  
--,[NoteID]  
--,[CRENoteID]  
--,[Date]  
--,[Amount]  
--,[Type]  
--,[CreatedBy]  
--,[CreatedDate]  
--,[UpdatedBy]  
--,[UpdatedDate]  
--,AnalysisID  
--,FeeName  
--,StrCreatedBy  
--,GeneratedBy  
--)  
  
--SELECT [TransactionEntryID]  
--,tr.[NoteID]  
--,n.[CRENoteID]  
--,tr.[Date]  
--,tr.[Amount]  
--,tr.[Type]  
--,tr.[CreatedBy]  
--,tr.[CreatedDate]  
--,tr.[UpdatedBy]  
--,tr.[UpdatedDate]  
--,tr.AnalysisID  
--,tr.FeeName  
--,tr.StrCreatedBy  
--,tr.GeneratedBy  
--FROM [dbo].[Ex_Staging_TransactionEntry] tr  
--Inner Join [dbo].[Ex_Staging_Note] n on n.noteid = tr.noteid    
--Where tr.AnalysisID in (Select analysisID from @tblAnalysisID)  
  
  
DECLARE @tblTransactionEntry nvarchar(MAX) = N'  
SELECT [TransactionEntryID]  
,n.[NoteID]  
,n.[CRENoteID]  
,tr.[Date]  
,tr.[Amount]  
,tr.[Type]  
,tr.[CreatedBy]  
,tr.[CreatedDate]  
,tr.[UpdatedBy]  
,tr.[UpdatedDate]  
,tr.AnalysisID  
,tr.FeeName  
,tr.StrCreatedBy  
,tr.GeneratedBy  
  
,tr.[TransactionDateByRule]  
,tr.[TransactionDateServicingLog]  
,tr.[RemitDate]  
,tr.[FeeTypeName]  
,tr.[Comment]  
,tr.[PaymentDateNotAdjustedforWorkingDay]  
,tr.IndexDeterminationDate  
FROM cre.TransactionEntry  tr  
Inner Join cre.note n on n.account_accountid = tr.accountid    
Inner Join cre.deal d on d.dealid = n.dealid  
Where tr.AnalysisID in (''38644c56-91bf-4bb3-8593-064b86605f9e'')'    -----''C10F3372-0FC2-4861-A9F5-148F1F80804F''
  
--,''02d20d3e-291a-42f8-afcd-bddfbb9da16b''    
---,''261CA4F1-A0AF-45C1-8CF6-053DAFAAA835''  
  
  
IF OBJECT_ID('tempdb..##tblTransactionEntry') IS NOT NULL               
DROP TABLE ##tblTransactionEntry  
              
create table ##tblTransactionEntry(  
    [TransactionEntryID] UNIQUEIDENTIFIER NOT NULL,  
    [NoteID]             UNIQUEIDENTIFIER NULL,  
    [CRENoteID]          NVARCHAR (256)   NULL,  
    [Date]               DATETIME         NULL,  
    [Amount]             DECIMAL (28, 15) NULL,  
    [Type]               NVARCHAR (128)   NULL,  
    [CreatedBy]          NVARCHAR (256)   NULL,  
    [CreatedDate]        DATETIME         NULL,  
    [UpdatedBy]          NVARCHAR (256)   NULL,  
    [UpdatedDate]        DATETIME         NULL,  
    [AnalysisID]         UNIQUEIDENTIFIER NULL,  
    [FeeName]            NVARCHAR (256)   NULL,  
    [StrCreatedBy]       NVARCHAR (256)   NULL,  
    [GeneratedBy]        NVARCHAR (256)   NULL,  
  
 [TransactionDateByRule]       DATE             NULL,  
    [TransactionDateServicingLog] DATE             NULL,  
    [RemitDate]                   DATE             NULL,  
    [FeeTypeName]                 NVARCHAR (256)   NULL,  
    [Comment]                     NVARCHAR (MAX)   NULL,  
 [PaymentDateNotAdjustedforWorkingDay]                        DATETIME         NULL,  
  IndexDeterminationDate    date,
    [ShardName] nvarchar(max)  NULL  
)  
  
INSERT INTO ##tblTransactionEntry  
([TransactionEntryID]  
,[NoteID]  
,[CRENoteID]  
,[Date]  
,[Amount]  
,[Type]  
,[CreatedBy]  
,[CreatedDate]  
,[UpdatedBy]  
,[UpdatedDate]  
,AnalysisID  
,FeeName  
,StrCreatedBy  
,GeneratedBy  
  
,[TransactionDateByRule]  
,[TransactionDateServicingLog]  
,[RemitDate]  
,[FeeTypeName]  
,[Comment]  
,[PaymentDateNotAdjustedforWorkingDay]  
,IndexDeterminationDate  
,[ShardName]  
)  
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceCRESStaging', @stmt = @tblTransactionEntry  
  
  
INSERT INTO [DW].[Staging_TransactionEntry]  
([TransactionEntryID]  
,[NoteID]  
,[CRENoteID]  
,[Date]  
,[Amount]  
,[Type]  
,[CreatedBy]  
,[CreatedDate]  
,[UpdatedBy]  
,[UpdatedDate]  
,AnalysisID  
,FeeName  
,StrCreatedBy  
,GeneratedBy  
  
,[TransactionDateByRule]  
,[TransactionDateServicingLog]  
,[RemitDate]  
,[FeeTypeName]  
,[Comment]  
,[PaymentDateNotAdjustedforWorkingDay]  
,IndexDeterminationDate
)  
  
SELECT [TransactionEntryID]  
,tr.[NoteID]  
,tr.[CRENoteID]  
,tr.[Date]  
,tr.[Amount]  
,tr.[Type]  
,tr.[CreatedBy]  
,tr.[CreatedDate]  
,tr.[UpdatedBy]  
,tr.[UpdatedDate]  
,tr.AnalysisID  
,tr.FeeName  
,tr.StrCreatedBy  
,tr.GeneratedBy  
  
,tr.[TransactionDateByRule]  
,tr.[TransactionDateServicingLog]  
,tr.[RemitDate]  
,tr.[FeeTypeName]  
,tr.[Comment]  
,tr.[PaymentDateNotAdjustedforWorkingDay]  
,tr.IndexDeterminationDate  
FROM ##tblTransactionEntry tr   
  
  
PRINT('Staging_TransactionEntry: '+CAST(@@ROWCOUNT as nvarchar(256)))  
  
Update DW.ImportStagDataIntoInt_Status set [Status] = 'Completed',EndDate = getdate() where TableName = 'TransactionEntry'  
  
  
  
  
Update DW.ImportStagDataIntoInt_Status set [Status] = 'InProcess',StartDate = getdate() where TableName = 'NotePeriodicCalc'  
  
  
--INSERT INTO [DW].[Staging_Cashflow]  
--([NotePeriodicCalcID]  
--,[NoteID]  
--,[CRENoteID]  
--,[PeriodEndDate]  
--,[Month]  
--,[ActualCashFlows]  
--,[GAAPCashFlows]  
--,[EndingGAAPBookValue]  
--,[TotalGAAPIncomeforthePeriod]  
--,[InterestAccrualforthePeriod]  
--,[PIKInterestAccrualforthePeriod]  
--,[TotalAmortAccrualForPeriod]  
--,[AccumulatedAmort]  
--,[BeginningBalance]  
--,[TotalFutureAdvancesForThePeriod]  
--,[TotalDiscretionaryCurtailmentsforthePeriod]  
--,[InterestPaidOnPaymentDate]  
--,[TotalCouponStrippedforthePeriod]  
--,[CouponStrippedonPaymentDate]  
--,[ScheduledPrincipal]  
--,[PrincipalPaid]  
--,[BalloonPayment]  
--,[EndingBalance]  
--,[ExitFeeIncludedInLevelYield]  
--,[ExitFeeExcludedFromLevelYield]  
--,[AdditionalFeesIncludedInLevelYield]  
--,[AdditionalFeesExcludedFromLevelYield]  
--,[OriginationFeeStripping]  
--,[ExitFeeStrippingIncldinLevelYield]  
--,[ExitFeeStrippingExcldfromLevelYield]  
--,[AddlFeesStrippingIncldinLevelYield]  
--,[AddlFeesStrippingExcldfromLevelYield]  
--,[EndOfPeriodWAL]  
--,[PIKInterestFromPIKSourceNote]  
--,[PIKInterestTransferredToRelatedNote]  
--,[PIKInterestForThePeriod]  
--,[BeginningPIKBalanceNotInsideLoanBalance]  
--,[PIKInterestForPeriodNotInsideLoanBalance]  
--,[PIKBalanceBalloonPayment]  
--,[EndingPIKBalanceNotInsideLoanBalance]  
--,[CostBasis]  
--,[PreCapBasis]  
--,[BasisCap]  
--,[AmortAccrualLevelYield]  
--,[ScheduledPrincipalShortfall]  
--,[PrincipalShortfall]  
--,[PrincipalLoss]  
--,[InterestForPeriodShortfall]  
--,[InterestPaidOnPMTDateShortfall]  
--,[CumulativeInterestPaidOnPMTDateShortfall]  
--,[InterestShortfallLoss]  
--,[InterestShortfallRecovery]  
--,[BeginningFinancingBalance]  
--,[TotalFinancingDrawsCurtailmentsForPeriod]  
--,[FinancingBalloon]  
--,[EndingFinancingBalance]  
--,[FinancingInterestPaid]  
--,[FinancingFeesPaid]  
--,[PeriodLeveredYield]  
--,[OrigFeeAccrual]  
--,[DiscountPremiumAccrual]  
--,[ExitFeeAccrual]  
--,[CreatedBy]  
--,[CreatedDate]  
--,[UpdatedBy]  
--,[UpdatedDate]  
--,[AllInCouponRate]  
--,[CleanCost]  
--,[GrossDeferredFees]  
--,[DeferredFeesReceivable]  
--,[CleanCostPrice]  
--,[AmortizedCostPrice]  
--,[AdditionalFeeAccrual]  
--,[CapitalizedCostAccrual]  
--,[DailySpreadInterestbeforeStrippingRule]  
--,[DailyLiborInterestbeforeStrippingRule]  
--,[ReversalofPriorInterestAccrual]  
--,[InterestReceivedinCurrentPeriod]  
--,[CurrentPeriodInterestAccrual]  
--,[TotalGAAPInterestFortheCurrentPeriod]       
--,InvestmentBasis  
--,CurrentPeriodInterestAccrualPeriodEnddate  
--,LIBORPercentage  
--,SpreadPercentage  
--,AnalysisID  
--,FeeStrippedforthePeriod  
--,PIKInterestPercentage  
--,AmortizedCost  
--,InterestSuspenseAccountActivityforthePeriod  
--,InterestSuspenseAccountBalance  
  
--,AccumaltedDiscountPremiumBI   
--,AccumalatedCapitalizedCostBI  
--,NoteID_EODPeriodEndDateBI   
--)  
--SELECT [NotePeriodicCalcID]  
--,cf.[NoteID]  
--,n.[CRENoteID]  
--,[PeriodEndDate]  
--,[Month]  
--,[ActualCashFlows]  
--,[GAAPCashFlows]  
--,[EndingGAAPBookValue]  
--,[TotalGAAPIncomeforthePeriod]  
--,[InterestAccrualforthePeriod]  
--,[PIKInterestAccrualforthePeriod]  
--,[TotalAmortAccrualForPeriod]  
--,[AccumulatedAmort]  
--,[BeginningBalance]  
--,[TotalFutureAdvancesForThePeriod]  
--,[TotalDiscretionaryCurtailmentsforthePeriod]  
--,[InterestPaidOnPaymentDate]  
--,[TotalCouponStrippedforthePeriod]  
--,[CouponStrippedonPaymentDate]  
--,[ScheduledPrincipal]  
--,[PrincipalPaid]  
--,[BalloonPayment]  
--,[EndingBalance]  
--,[ExitFeeIncludedInLevelYield]  
--,[ExitFeeExcludedFromLevelYield]  
--,[AdditionalFeesIncludedInLevelYield]  
--,[AdditionalFeesExcludedFromLevelYield]  
--,[OriginationFeeStripping]  
--,[ExitFeeStrippingIncldinLevelYield]  
--,[ExitFeeStrippingExcldfromLevelYield]  
--,[AddlFeesStrippingIncldinLevelYield]  
--,[AddlFeesStrippingExcldfromLevelYield]  
--,[EndOfPeriodWAL]  
--,[PIKInterestFromPIKSourceNote]  
--,[PIKInterestTransferredToRelatedNote]  
--,[PIKInterestForThePeriod]  
--,[BeginningPIKBalanceNotInsideLoanBalance]  
--,[PIKInterestForPeriodNotInsideLoanBalance]  
--,[PIKBalanceBalloonPayment]  
--,[EndingPIKBalanceNotInsideLoanBalance]  
--,[CostBasis]  
--,[PreCapBasis]  
--,[BasisCap]  
--,[AmortAccrualLevelYield]  
--,[ScheduledPrincipalShortfall]  
--,[PrincipalShortfall]  
--,[PrincipalLoss]  
--,[InterestForPeriodShortfall]  
--,[InterestPaidOnPMTDateShortfall]  
--,[CumulativeInterestPaidOnPMTDateShortfall]  
--,[InterestShortfallLoss]  
--,[InterestShortfallRecovery]  
--,[BeginningFinancingBalance]  
--,[TotalFinancingDrawsCurtailmentsForPeriod]  
--,[FinancingBalloon]  
--,[EndingFinancingBalance]  
--,[FinancingInterestPaid]  
--,[FinancingFeesPaid]  
--,[PeriodLeveredYield]  
--,[OrigFeeAccrual]  
--,[DiscountPremiumAccrual]  
--,[ExitFeeAccrual]  
--,cf.[CreatedBy]  
--,cf.[CreatedDate]  
--,cf.[UpdatedBy]  
--,cf.[UpdatedDate]  
--,[AllInCouponRate]  
--,[CleanCost]  
--,[GrossDeferredFees]  
--,[DeferredFeesReceivable]  
--,[CleanCostPrice]  
--,[AmortizedCostPrice]  
--,[AdditionalFeeAccrual]  
--,[CapitalizedCostAccrual]  
--,[DailySpreadInterestbeforeStrippingRule]  
--,[DailyLiborInterestbeforeStrippingRule]  
--,[ReversalofPriorInterestAccrual]  
--,[InterestReceivedinCurrentPeriod]  
--,[CurrentPeriodInterestAccrual]  
--,[TotalGAAPInterestFortheCurrentPeriod]  
--,InvestmentBasis  
--,CurrentPeriodInterestAccrualPeriodEnddate  
--,LIBORPercentage  
--,SpreadPercentage  
--,AnalysisID  
--,FeeStrippedforthePeriod  
--,PIKInterestPercentage  
--,AmortizedCost  
--,InterestSuspenseAccountActivityforthePeriod  
--,InterestSuspenseAccountBalance  
--,null as AccumaltedDiscountPremiumBI  
--,null as AccumalatedCapitalizedCostBI  
----,SUM(ISNULL(cf.DiscountPremiumAccrual,0)) OVER(PARTITION BY cf.AnalysisID,cf.NoteID ORDER BY cf.AnalysisID,cf.NoteID,cf.PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccumaltedDiscountPremiumBI  
----,SUM(ISNULL(cf.CapitalizedCostAccrual,0)) OVER(PARTITION BY cf.AnalysisID,cf.NoteID ORDER BY cf.AnalysisID,cf.NoteID,cf.PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccumalatedCapitalizedCostBI  
--,n.CRENoteID + '_'+ Convert(Varchar(10),EOMonth(cf.PeriodEndDate,0),110)  as NoteID_EODPeriodEndDateBI  
--FROM [dbo].[Ex_Staging_NotePeriodicCalc] cf  
--Inner Join [dbo].[Ex_Staging_Note] n on n.noteid = cf.noteid    
--Where cf.AnalysisID in (Select analysisID from @tblAnalysisID)  
  
  
DECLARE @tblNPC nvarchar(MAX) = N'  
SELECT [NotePeriodicCalcID]  
,n.[NoteID]  
,n.[CRENoteID]  
,[PeriodEndDate]  
,[Month]  
,[ActualCashFlows]  
,[GAAPCashFlows]  
,[EndingGAAPBookValue]  
--,[TotalGAAPIncomeforthePeriod]  
--,[InterestAccrualforthePeriod]  
--,[PIKInterestAccrualforthePeriod]  
,[TotalAmortAccrualForPeriod]  
,[AccumulatedAmort]  
,[BeginningBalance]  
,[TotalFutureAdvancesForThePeriod]  
,[TotalDiscretionaryCurtailmentsforthePeriod]  
,[InterestPaidOnPaymentDate]  
,[TotalCouponStrippedforthePeriod]  
,[CouponStrippedonPaymentDate]  
,[ScheduledPrincipal]  
,[PrincipalPaid]  
,[BalloonPayment]  
,[EndingBalance]  
,[ExitFeeIncludedInLevelYield]  
,[ExitFeeExcludedFromLevelYield]  
,[AdditionalFeesIncludedInLevelYield]  
,[AdditionalFeesExcludedFromLevelYield]  
,[OriginationFeeStripping]  
,[ExitFeeStrippingIncldinLevelYield]  
,[ExitFeeStrippingExcldfromLevelYield]  
,[AddlFeesStrippingIncldinLevelYield]  
,[AddlFeesStrippingExcldfromLevelYield]  
,[EndOfPeriodWAL]  
,[PIKInterestFromPIKSourceNote]  
,[PIKInterestTransferredToRelatedNote]  
,[PIKInterestForThePeriod]  
,[BeginningPIKBalanceNotInsideLoanBalance]  
,[PIKInterestForPeriodNotInsideLoanBalance]  
,[PIKBalanceBalloonPayment]  
,[EndingPIKBalanceNotInsideLoanBalance]  
,[CostBasis]  
,[PreCapBasis]  
,[BasisCap]  
,[AmortAccrualLevelYield]  
,[ScheduledPrincipalShortfall]  
,[PrincipalShortfall]  
,[PrincipalLoss]  
,[InterestForPeriodShortfall]  
,[InterestPaidOnPMTDateShortfall]  
,[CumulativeInterestPaidOnPMTDateShortfall]  
,[InterestShortfallLoss]  
,[InterestShortfallRecovery]  
,[BeginningFinancingBalance]  
,[TotalFinancingDrawsCurtailmentsForPeriod]  
,[FinancingBalloon]  
,[EndingFinancingBalance]  
,[FinancingInterestPaid]  
,[FinancingFeesPaid]  
,[PeriodLeveredYield]  
,[OrigFeeAccrual]  
,[DiscountPremiumAccrual]  
,[ExitFeeAccrual]  
,cf.[CreatedBy]  
,cf.[CreatedDate]  
,cf.[UpdatedBy]  
,cf.[UpdatedDate]  
,[AllInCouponRate]  
,[CleanCost]  
,[GrossDeferredFees]  
,[DeferredFeesReceivable]  
,[CleanCostPrice]  
,[AmortizedCostPrice]  
,[AdditionalFeeAccrual]  
,[CapitalizedCostAccrual]  
,[DailySpreadInterestbeforeStrippingRule]  
,[DailyLiborInterestbeforeStrippingRule]  
,[ReversalofPriorInterestAccrual]  
,[InterestReceivedinCurrentPeriod]  
,[CurrentPeriodInterestAccrual]  
,[TotalGAAPInterestFortheCurrentPeriod]  
,InvestmentBasis  
,CurrentPeriodInterestAccrualPeriodEnddate  
,LIBORPercentage  
,SpreadPercentage  
,AnalysisID  
,FeeStrippedforthePeriod  
,PIKInterestPercentage  
,AmortizedCost  
,InterestSuspenseAccountActivityforthePeriod  
,InterestSuspenseAccountBalance  
,null as AccumaltedDiscountPremiumBI  
,null as AccumalatedCapitalizedCostBI  
--,SUM(ISNULL(cf.DiscountPremiumAccrual,0)) OVER(PARTITION BY cf.AnalysisID,n.NoteID ORDER BY cf.AnalysisID,n.NoteID,cf.PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccumaltedDiscountPremiumBI  
--,SUM(ISNULL(cf.CapitalizedCostAccrual,0)) OVER(PARTITION BY cf.AnalysisID,n.NoteID ORDER BY cf.AnalysisID,n.NoteID,cf.PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccumalatedCapitalizedCostBI  
,n.CRENoteID + ''_''+ Convert(Varchar(10),EOMonth(cf.PeriodEndDate,0),110)  as NoteID_EODPeriodEndDateBI  
,[AllInBasisValuation]  
,[AllInPIKRate]  
,[CurrentPeriodPIKInterestAccrualPeriodEnddate]  
,[PIKInterestPaidForThePeriod]  
,[PIKInterestAppliedForThePeriod]   
,[EndingPreCapPVBasis]  
,[LevelYieldIncomeForThePeriod]  
,[PVAmortTotalIncomeMethod]  
,[EndingCleanCostLY]  
,[EndingAccumAmort]  
,[PVAmortForThePeriod]  
,[EndingSLBasis]  
,[SLAmortForThePeriod]  
,[SLAmortOfTotalFeesInclInLY]   
,[SLAmortOfDiscountPremium]  
,[SLAmortOfCapCost]  
,[EndingAccumSLAmort]   
,[EndingPreCapGAAPBasis]  
,[PIKPrincipalPaidForThePeriod]  

,RemainingUnfundedCommitment
,CalcEngineType
,levyld
,cum_dailypikint
,cum_baladdon_am
,cum_baladdon_nonam
,cum_dailyint
,cum_ddbaladdon
,cum_ddintdelta
,initbal
,cum_fee_levyld
,period_ddintdelta_shifted
,intdeltabal
,cum_exit_fee_excl_lv_yield
,accountingclosedate
,CurrentPeriodPIKInterestAccrual
,AccPeriodEnd
,AccPeriodStart
,pmtdtnotadj
,pmtdt
,periodpikint
,DropDateInterestDeltaBalance
,AverageDailyBalance
,DeferredFeeGAAPBasis
,CapitalizedCostLevelYield
,CapitalizedCostGAAPBasis
,CapitalizedCostAccumulatedAmort
,DiscountPremiumLevelYield
,DiscountPremiumGAAPBasis
,DiscountPremiumAccumulatedAmort
,InterestPastDue
,AccountId

FROM cre.NotePeriodicCalc cf  
Inner Join cre.note n on n.account_accountid = cf.accountid   
Where cf.AnalysisID in ( ''38644c56-91bf-4bb3-8593-064b86605f9e'') '  ----C10F3372-0FC2-4861-A9F5-148F1F80804F
  
--,''261CA4F1-A0AF-45C1-8CF6-053DAFAAA835''  
  
IF OBJECT_ID('tempdb..##tblNPC') IS NOT NULL               
DROP TABLE ##tblNPC  
              
create table ##tblNPC(  
	[NotePeriodicCalcID]                          UNIQUEIDENTIFIER NOT NULL,  
	[NoteID]                                      UNIQUEIDENTIFIER NULL,  
	[CRENoteID]                                   NVARCHAR (MAX)   NULL,  
	[PeriodEndDate]                               DATE             NULL,  
	[Month]                                       INT              NULL,  
	[ActualCashFlows]                             DECIMAL (28, 15) NULL,  
	[GAAPCashFlows]                               DECIMAL (28, 15) NULL,  
	[EndingGAAPBookValue]                         DECIMAL (28, 15) NULL,  
	--[TotalGAAPIncomeforthePeriod]                 DECIMAL (28, 15) NULL,  
	--[InterestAccrualforthePeriod]                 DECIMAL (28, 15) NULL,  
	--[PIKInterestAccrualforthePeriod]              DECIMAL (28, 15) NULL,  
	[TotalAmortAccrualForPeriod]                  DECIMAL (28, 15) NULL,  
	[AccumulatedAmort]                            DECIMAL (28, 15) NULL,  
	[BeginningBalance]                            DECIMAL (28, 15) NULL,  
	[TotalFutureAdvancesForThePeriod]             DECIMAL (28, 15) NULL,  
	[TotalDiscretionaryCurtailmentsforthePeriod]  DECIMAL (28, 15) NULL,  
	[InterestPaidOnPaymentDate]                   DECIMAL (28, 15) NULL,  
	[TotalCouponStrippedforthePeriod]             DECIMAL (28, 15) NULL,  
	[CouponStrippedonPaymentDate]                 DECIMAL (28, 15) NULL,  
	[ScheduledPrincipal]                          DECIMAL (28, 15) NULL,  
	[PrincipalPaid]                               DECIMAL (28, 15) NULL,  
	[BalloonPayment]                              DECIMAL (28, 15) NULL,  
	[EndingBalance]                               DECIMAL (28, 15) NULL,  
	[ExitFeeIncludedInLevelYield]                 DECIMAL (28, 15) NULL,  
	[ExitFeeExcludedFromLevelYield]               DECIMAL (28, 15) NULL,  
	[AdditionalFeesIncludedInLevelYield]          DECIMAL (28, 15) NULL,  
	[AdditionalFeesExcludedFromLevelYield]        DECIMAL (28, 15) NULL,  
	[OriginationFeeStripping]                     DECIMAL (28, 15) NULL,  
	[ExitFeeStrippingIncldinLevelYield]           DECIMAL (28, 15) NULL,  
	[ExitFeeStrippingExcldfromLevelYield]         DECIMAL (28, 15) NULL,  
	[AddlFeesStrippingIncldinLevelYield]          DECIMAL (28, 15) NULL,  
	[AddlFeesStrippingExcldfromLevelYield]        DECIMAL (28, 15) NULL,  
	[EndOfPeriodWAL]                              DECIMAL (28, 15) NULL,  
	[PIKInterestFromPIKSourceNote]                DECIMAL (28, 15) NULL,  
	[PIKInterestTransferredToRelatedNote]         DECIMAL (28, 15) NULL,  
	[PIKInterestForThePeriod]                     DECIMAL (28, 15) NULL,  
	[BeginningPIKBalanceNotInsideLoanBalance]     DECIMAL (28, 15) NULL,  
	[PIKInterestForPeriodNotInsideLoanBalance]    DECIMAL (28, 15) NULL,  
	[PIKBalanceBalloonPayment]                    DECIMAL (28, 15) NULL,  
	[EndingPIKBalanceNotInsideLoanBalance]        DECIMAL (28, 15) NULL,  
	[CostBasis]                                   DECIMAL (28, 15) NULL,  
	[PreCapBasis]                                 DECIMAL (28, 15) NULL,  
	[BasisCap]                                    DECIMAL (28, 15) NULL,  
	[AmortAccrualLevelYield]                      DECIMAL (28, 15) NULL,  
	[ScheduledPrincipalShortfall]                 DECIMAL (28, 15) NULL,  
	[PrincipalShortfall]                          DECIMAL (28, 15) NULL,  
	[PrincipalLoss]                               DECIMAL (28, 15) NULL,  
	[InterestForPeriodShortfall]                  DECIMAL (28, 15) NULL,  
	[InterestPaidOnPMTDateShortfall]              DECIMAL (28, 15) NULL,  
	[CumulativeInterestPaidOnPMTDateShortfall]    DECIMAL (28, 15) NULL,  
	[InterestShortfallLoss]                       DECIMAL (28, 15) NULL,  
	[InterestShortfallRecovery]                   DECIMAL (28, 15) NULL,  
	[BeginningFinancingBalance]                   DECIMAL (28, 15) NULL,  
	[TotalFinancingDrawsCurtailmentsForPeriod]    DECIMAL (28, 15) NULL,  
	[FinancingBalloon]                            DECIMAL (28, 15) NULL,  
	[EndingFinancingBalance]                      DECIMAL (28, 15) NULL,  
	[FinancingInterestPaid]                       DECIMAL (28, 15) NULL,  
	[FinancingFeesPaid]                           DECIMAL (28, 15) NULL,  
	[PeriodLeveredYield]                          DECIMAL (28, 15) NULL,  
	[OrigFeeAccrual]                              DECIMAL (28, 15) NULL,  
	[DiscountPremiumAccrual]                      DECIMAL (28, 15) NULL,  
	[ExitFeeAccrual]                              DECIMAL (28, 15) NULL,  
	[CreatedBy]                                   NVARCHAR (256)   NULL,  
	[CreatedDate]                                 DATETIME         NULL,  
	[UpdatedBy]                                   NVARCHAR (256)   NULL,  
	[UpdatedDate]                                 DATETIME         NULL,  
	[AllInCouponRate]                             DECIMAL (28, 15) NULL,  
	[CleanCost]                                   DECIMAL (28, 15) NULL,  
	[GrossDeferredFees]                           DECIMAL (28, 15) NULL,  
	[DeferredFeesReceivable]                      DECIMAL (28, 15) NULL,  
	[CleanCostPrice]                              DECIMAL (28, 15) NULL,  
	[AmortizedCostPrice]                          DECIMAL (28, 15) NULL,  
	[AdditionalFeeAccrual]                        DECIMAL (28, 15) NULL,  
	[CapitalizedCostAccrual]                      DECIMAL (28, 15) NULL,  
	[DailySpreadInterestbeforeStrippingRule]      DECIMAL (28, 15) NULL,  
	[DailyLiborInterestbeforeStrippingRule]       DECIMAL (28, 15) NULL,  
	[ReversalofPriorInterestAccrual]              DECIMAL (28, 15) NULL,  
	[InterestReceivedinCurrentPeriod]             DECIMAL (28, 15) NULL,  
	[CurrentPeriodInterestAccrual]                DECIMAL (28, 15) NULL,  
	[TotalGAAPInterestFortheCurrentPeriod]        DECIMAL (28, 15) NULL,  
	[InvestmentBasis]                             DECIMAL (28, 15) NULL,  
	[CurrentPeriodInterestAccrualPeriodEnddate]   DECIMAL (28, 15) NULL,  
	[LIBORPercentage]                             DECIMAL (28, 15) NULL,  
	[SpreadPercentage]                            DECIMAL (28, 15) NULL,  
	[AnalysisID]                                  UNIQUEIDENTIFIER NULL,  
	[FeeStrippedforthePeriod]                     DECIMAL (28, 15) NULL,  
	[PIKInterestPercentage]                       DECIMAL (28, 15) NULL,  
	[AmortizedCost]                               DECIMAL (28, 15) NULL,  
	[InterestSuspenseAccountActivityforthePeriod] DECIMAL (28, 15) NULL,  
	[InterestSuspenseAccountBalance]              DECIMAL (28, 15) NULL,  
	[AccumaltedDiscountPremiumBI]                 DECIMAL (28, 15) NULL,  
	[AccumalatedCapitalizedCostBI]                DECIMAL (28, 15) NULL,  
	[NoteID_EODPeriodEndDateBI]                   NVARCHAR (256)   NULL,    
	[AllInBasisValuation]                          DECIMAL (28, 15) NULL,  
	[AllInPIKRate]                                 DECIMAL (28, 15) NULL,  
	[CurrentPeriodPIKInterestAccrualPeriodEnddate] DECIMAL (28, 15) NULL,  
	[PIKInterestPaidForThePeriod]                  DECIMAL (28, 15) NULL,  
	[PIKInterestAppliedForThePeriod]               DECIMAL (28, 15) NULL,  
	[EndingPreCapPVBasis]                          DECIMAL (28, 15) NULL,  
	[LevelYieldIncomeForThePeriod]                 DECIMAL (28, 15) NULL,  
	[PVAmortTotalIncomeMethod]                     DECIMAL (28, 15) NULL,  
	[EndingCleanCostLY]                            DECIMAL (28, 15) NULL,  
	[EndingAccumAmort]                             DECIMAL (28, 15) NULL,  
	[PVAmortForThePeriod]                          DECIMAL (28, 15) NULL,  
	[EndingSLBasis]                                DECIMAL (28, 15) NULL,  
	[SLAmortForThePeriod]                          DECIMAL (28, 15) NULL,  
	[SLAmortOfTotalFeesInclInLY]                   DECIMAL (28, 15) NULL,  
	[SLAmortOfDiscountPremium]                     DECIMAL (28, 15) NULL,  
	[SLAmortOfCapCost]                             DECIMAL (28, 15) NULL,  
	[EndingAccumSLAmort]                           DECIMAL (28, 15) NULL,  
	[EndingPreCapGAAPBasis]                        DECIMAL (28, 15) NULL,  
	[PIKPrincipalPaidForThePeriod]                 DECIMAL (28, 15) NULL,  
	
	RemainingUnfundedCommitment	decimal(28,15)	 ,
CalcEngineType	int	 ,
levyld	decimal(28,15)	 ,
cum_dailypikint	decimal(28,15)	 ,
cum_baladdon_am	decimal(28,15)	 ,
cum_baladdon_nonam	decimal(28,15)	 ,
cum_dailyint	decimal(28,15)	 ,
cum_ddbaladdon	decimal(28,15)	 ,
cum_ddintdelta	decimal(28,15)	 ,
initbal	decimal(28,15)	 ,
cum_fee_levyld	decimal(28,15)	 ,
period_ddintdelta_shifted	decimal(28,15)	 ,
intdeltabal	decimal(28,15)	 ,
cum_exit_fee_excl_lv_yield	decimal(28,15)	 ,
accountingclosedate	date	 ,
CurrentPeriodPIKInterestAccrual	decimal(28,15)	 ,
AccPeriodEnd	date	 ,
AccPeriodStart	date	 ,
pmtdtnotadj	date,
pmtdt	date ,
periodpikint	decimal(28,15)	 ,
DropDateInterestDeltaBalance	decimal(28,15)	 ,
AverageDailyBalance	decimal(28,15)	 ,
DeferredFeeGAAPBasis	decimal(28,15)	 ,
CapitalizedCostLevelYield	decimal(28,15)	 ,
CapitalizedCostGAAPBasis	decimal(28,15)	 ,
CapitalizedCostAccumulatedAmort	decimal(28,15)	 ,
DiscountPremiumLevelYield	decimal(28,15)	 ,
DiscountPremiumGAAPBasis	decimal(28,15)	 ,
DiscountPremiumAccumulatedAmort	decimal(28,15)	 ,
InterestPastDue	decimal(28,15)	 ,
AccountId	UNIQUEIDENTIFIER	 ,

	[ShardName] nvarchar(max)  NULL  
)  
  
  
INSERT INTO ##tblNPC  
([NotePeriodicCalcID]  
,[NoteID]  
,[CRENoteID]  
,[PeriodEndDate]  
,[Month]  
,[ActualCashFlows]  
,[GAAPCashFlows]  
,[EndingGAAPBookValue]  
--,[TotalGAAPIncomeforthePeriod]  
--,[InterestAccrualforthePeriod]  
--,[PIKInterestAccrualforthePeriod]  
,[TotalAmortAccrualForPeriod]  
,[AccumulatedAmort]  
,[BeginningBalance]  
,[TotalFutureAdvancesForThePeriod]  
,[TotalDiscretionaryCurtailmentsforthePeriod]  
,[InterestPaidOnPaymentDate]  
,[TotalCouponStrippedforthePeriod]  
,[CouponStrippedonPaymentDate]  
,[ScheduledPrincipal]  
,[PrincipalPaid]  
,[BalloonPayment]  
,[EndingBalance]  
,[ExitFeeIncludedInLevelYield]  
,[ExitFeeExcludedFromLevelYield]  
,[AdditionalFeesIncludedInLevelYield]  
,[AdditionalFeesExcludedFromLevelYield]  
,[OriginationFeeStripping]  
,[ExitFeeStrippingIncldinLevelYield]  
,[ExitFeeStrippingExcldfromLevelYield]  
,[AddlFeesStrippingIncldinLevelYield]  
,[AddlFeesStrippingExcldfromLevelYield]  
,[EndOfPeriodWAL]  
,[PIKInterestFromPIKSourceNote]  
,[PIKInterestTransferredToRelatedNote]  
,[PIKInterestForThePeriod]  
,[BeginningPIKBalanceNotInsideLoanBalance]  
,[PIKInterestForPeriodNotInsideLoanBalance]  
,[PIKBalanceBalloonPayment]  
,[EndingPIKBalanceNotInsideLoanBalance]  
,[CostBasis]  
,[PreCapBasis]  
,[BasisCap]  
,[AmortAccrualLevelYield]  
,[ScheduledPrincipalShortfall]  
,[PrincipalShortfall]  
,[PrincipalLoss]  
,[InterestForPeriodShortfall]  
,[InterestPaidOnPMTDateShortfall]  
,[CumulativeInterestPaidOnPMTDateShortfall]  
,[InterestShortfallLoss]  
,[InterestShortfallRecovery]  
,[BeginningFinancingBalance]  
,[TotalFinancingDrawsCurtailmentsForPeriod]  
,[FinancingBalloon]  
,[EndingFinancingBalance]  
,[FinancingInterestPaid]  
,[FinancingFeesPaid]  
,[PeriodLeveredYield]  
,[OrigFeeAccrual]  
,[DiscountPremiumAccrual]  
,[ExitFeeAccrual]  
,[CreatedBy]  
,[CreatedDate]  
,[UpdatedBy]  
,[UpdatedDate]  
,[AllInCouponRate]  
,[CleanCost]  
,[GrossDeferredFees]  
,[DeferredFeesReceivable]  
,[CleanCostPrice]  
,[AmortizedCostPrice]  
,[AdditionalFeeAccrual]  
,[CapitalizedCostAccrual]  
,[DailySpreadInterestbeforeStrippingRule]  
,[DailyLiborInterestbeforeStrippingRule]  
,[ReversalofPriorInterestAccrual]  
,[InterestReceivedinCurrentPeriod]  
,[CurrentPeriodInterestAccrual]  
,[TotalGAAPInterestFortheCurrentPeriod]       
,InvestmentBasis  
,CurrentPeriodInterestAccrualPeriodEnddate  
,LIBORPercentage  
,SpreadPercentage  
,AnalysisID  
,FeeStrippedforthePeriod  
,PIKInterestPercentage  
,AmortizedCost  
,InterestSuspenseAccountActivityforthePeriod  
,InterestSuspenseAccountBalance  
  
,AccumaltedDiscountPremiumBI   
,AccumalatedCapitalizedCostBI  
,NoteID_EODPeriodEndDateBI   
  
,[AllInBasisValuation]  
,[AllInPIKRate]  
,[CurrentPeriodPIKInterestAccrualPeriodEnddate]  
,[PIKInterestPaidForThePeriod]  
,[PIKInterestAppliedForThePeriod]   
,[EndingPreCapPVBasis]  
,[LevelYieldIncomeForThePeriod]  
,[PVAmortTotalIncomeMethod]  
,[EndingCleanCostLY]  
,[EndingAccumAmort]  
,[PVAmortForThePeriod]  
,[EndingSLBasis]  
,[SLAmortForThePeriod]  
,[SLAmortOfTotalFeesInclInLY]   
,[SLAmortOfDiscountPremium]  
,[SLAmortOfCapCost]  
,[EndingAccumSLAmort]   
,[EndingPreCapGAAPBasis]  
,[PIKPrincipalPaidForThePeriod]  

,RemainingUnfundedCommitment
,CalcEngineType
,levyld
,cum_dailypikint
,cum_baladdon_am
,cum_baladdon_nonam
,cum_dailyint
,cum_ddbaladdon
,cum_ddintdelta
,initbal
,cum_fee_levyld
,period_ddintdelta_shifted
,intdeltabal
,cum_exit_fee_excl_lv_yield
,accountingclosedate
,CurrentPeriodPIKInterestAccrual
,AccPeriodEnd
,AccPeriodStart
,pmtdtnotadj
,pmtdt
,periodpikint
,DropDateInterestDeltaBalance
,AverageDailyBalance
,DeferredFeeGAAPBasis
,CapitalizedCostLevelYield
,CapitalizedCostGAAPBasis
,CapitalizedCostAccumulatedAmort
,DiscountPremiumLevelYield
,DiscountPremiumGAAPBasis
,DiscountPremiumAccumulatedAmort
,InterestPastDue
,AccountId
  
,[ShardName]  
)  
  
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceCRESStaging', @stmt = @tblNPC  
  
INSERT INTO [DW].[Staging_Cashflow]  
([NotePeriodicCalcID]  
,[NoteID]  
,[CRENoteID]  
,[PeriodEndDate]  
,[Month]  
,[ActualCashFlows]  
,[GAAPCashFlows]  
,[EndingGAAPBookValue]  
--,[TotalGAAPIncomeforthePeriod]  
--,[InterestAccrualforthePeriod]  
--,[PIKInterestAccrualforthePeriod]  
,[TotalAmortAccrualForPeriod]  
,[AccumulatedAmort]  
,[BeginningBalance]  
,[TotalFutureAdvancesForThePeriod]  
,[TotalDiscretionaryCurtailmentsforthePeriod]  
,[InterestPaidOnPaymentDate]  
,[TotalCouponStrippedforthePeriod]  
,[CouponStrippedonPaymentDate]  
,[ScheduledPrincipal]  
,[PrincipalPaid]  
,[BalloonPayment]  
,[EndingBalance]  
,[ExitFeeIncludedInLevelYield]  
,[ExitFeeExcludedFromLevelYield]  
,[AdditionalFeesIncludedInLevelYield]  
,[AdditionalFeesExcludedFromLevelYield]  
,[OriginationFeeStripping]  
,[ExitFeeStrippingIncldinLevelYield]  
,[ExitFeeStrippingExcldfromLevelYield]  
,[AddlFeesStrippingIncldinLevelYield]  
,[AddlFeesStrippingExcldfromLevelYield]  
,[EndOfPeriodWAL]  
,[PIKInterestFromPIKSourceNote]  
,[PIKInterestTransferredToRelatedNote]  
,[PIKInterestForThePeriod]  
,[BeginningPIKBalanceNotInsideLoanBalance]  
,[PIKInterestForPeriodNotInsideLoanBalance]  
,[PIKBalanceBalloonPayment]  
,[EndingPIKBalanceNotInsideLoanBalance]  
,[CostBasis]  
,[PreCapBasis]  
,[BasisCap]  
,[AmortAccrualLevelYield]  
,[ScheduledPrincipalShortfall]  
,[PrincipalShortfall]  
,[PrincipalLoss]  
,[InterestForPeriodShortfall]  
,[InterestPaidOnPMTDateShortfall]  
,[CumulativeInterestPaidOnPMTDateShortfall]  
,[InterestShortfallLoss]  
,[InterestShortfallRecovery]  
,[BeginningFinancingBalance]  
,[TotalFinancingDrawsCurtailmentsForPeriod]  
,[FinancingBalloon]  
,[EndingFinancingBalance]  
,[FinancingInterestPaid]  
,[FinancingFeesPaid]  
,[PeriodLeveredYield]  
,[OrigFeeAccrual]  
,[DiscountPremiumAccrual]  
,[ExitFeeAccrual]  
,[CreatedBy]  
,[CreatedDate]  
,[UpdatedBy]  
,[UpdatedDate]  
,[AllInCouponRate]  
,[CleanCost]  
,[GrossDeferredFees]  
,[DeferredFeesReceivable]  
,[CleanCostPrice]  
,[AmortizedCostPrice]  
,[AdditionalFeeAccrual]  
,[CapitalizedCostAccrual]  
,[DailySpreadInterestbeforeStrippingRule]  
,[DailyLiborInterestbeforeStrippingRule]  
,[ReversalofPriorInterestAccrual]  
,[InterestReceivedinCurrentPeriod]  
,[CurrentPeriodInterestAccrual]  
,[TotalGAAPInterestFortheCurrentPeriod]       
,InvestmentBasis  
,CurrentPeriodInterestAccrualPeriodEnddate  
,LIBORPercentage  
,SpreadPercentage  
,AnalysisID  
,FeeStrippedforthePeriod  
,PIKInterestPercentage  
,AmortizedCost  
,InterestSuspenseAccountActivityforthePeriod  
,InterestSuspenseAccountBalance  
  
,AccumaltedDiscountPremiumBI   
,AccumalatedCapitalizedCostBI  
,NoteID_EODPeriodEndDateBI   
  
,[AllInBasisValuation]  
,[AllInPIKRate]  
,[CurrentPeriodPIKInterestAccrualPeriodEnddate]  
,[PIKInterestPaidForThePeriod]  
,[PIKInterestAppliedForThePeriod]   
,[EndingPreCapPVBasis]  
,[LevelYieldIncomeForThePeriod]  
,[PVAmortTotalIncomeMethod]  
,[EndingCleanCostLY]  
,[EndingAccumAmort]  
,[PVAmortForThePeriod]  
,[EndingSLBasis]  
,[SLAmortForThePeriod]  
,[SLAmortOfTotalFeesInclInLY]   
,[SLAmortOfDiscountPremium]  
,[SLAmortOfCapCost]  
,[EndingAccumSLAmort]   
,[EndingPreCapGAAPBasis]  
,[PIKPrincipalPaidForThePeriod]  

,RemainingUnfundedCommitment
,CalcEngineType
,levyld
,cum_dailypikint
,cum_baladdon_am
,cum_baladdon_nonam
,cum_dailyint
,cum_ddbaladdon
,cum_ddintdelta
,initbal
,cum_fee_levyld
,period_ddintdelta_shifted
,intdeltabal
,cum_exit_fee_excl_lv_yield
,accountingclosedate
,CurrentPeriodPIKInterestAccrual
,AccPeriodEnd
,AccPeriodStart
,pmtdtnotadj
,pmtdt
,periodpikint
,DropDateInterestDeltaBalance
,AverageDailyBalance
,DeferredFeeGAAPBasis
,CapitalizedCostLevelYield
,CapitalizedCostGAAPBasis
,CapitalizedCostAccumulatedAmort
,DiscountPremiumLevelYield
,DiscountPremiumGAAPBasis
,DiscountPremiumAccumulatedAmort
,InterestPastDue
,AccountId
)  
SELECT [NotePeriodicCalcID]  
,cf.[NoteID]  
,cf.[CRENoteID]  
,[PeriodEndDate]  
,[Month]  
,[ActualCashFlows]  
,[GAAPCashFlows]  
,[EndingGAAPBookValue]  
--,[TotalGAAPIncomeforthePeriod]  
--,[InterestAccrualforthePeriod]  
--,[PIKInterestAccrualforthePeriod]  
,[TotalAmortAccrualForPeriod]  
,[AccumulatedAmort]  
,[BeginningBalance]  
,[TotalFutureAdvancesForThePeriod]  
,[TotalDiscretionaryCurtailmentsforthePeriod]  
,[InterestPaidOnPaymentDate]  
,[TotalCouponStrippedforthePeriod]  
,[CouponStrippedonPaymentDate]  
,[ScheduledPrincipal]  
,[PrincipalPaid]  
,[BalloonPayment]  
,[EndingBalance]  
,[ExitFeeIncludedInLevelYield]  
,[ExitFeeExcludedFromLevelYield]  
,[AdditionalFeesIncludedInLevelYield]  
,[AdditionalFeesExcludedFromLevelYield]  
,[OriginationFeeStripping]  
,[ExitFeeStrippingIncldinLevelYield]  
,[ExitFeeStrippingExcldfromLevelYield]  
,[AddlFeesStrippingIncldinLevelYield]  
,[AddlFeesStrippingExcldfromLevelYield]  
,[EndOfPeriodWAL]  
,[PIKInterestFromPIKSourceNote]  
,[PIKInterestTransferredToRelatedNote]  
,[PIKInterestForThePeriod]  
,[BeginningPIKBalanceNotInsideLoanBalance]  
,[PIKInterestForPeriodNotInsideLoanBalance]  
,[PIKBalanceBalloonPayment]  
,[EndingPIKBalanceNotInsideLoanBalance]  
,[CostBasis]  
,[PreCapBasis]  
,[BasisCap]  
,[AmortAccrualLevelYield]  
,[ScheduledPrincipalShortfall]  
,[PrincipalShortfall]  
,[PrincipalLoss]  
,[InterestForPeriodShortfall]  
,[InterestPaidOnPMTDateShortfall]  
,[CumulativeInterestPaidOnPMTDateShortfall]  
,[InterestShortfallLoss]  
,[InterestShortfallRecovery]  
,[BeginningFinancingBalance]  
,[TotalFinancingDrawsCurtailmentsForPeriod]  
,[FinancingBalloon]  
,[EndingFinancingBalance]  
,[FinancingInterestPaid]  
,[FinancingFeesPaid]  
,[PeriodLeveredYield]  
,[OrigFeeAccrual]  
,[DiscountPremiumAccrual]  
,[ExitFeeAccrual]  
,cf.[CreatedBy]  
,cf.[CreatedDate]  
,cf.[UpdatedBy]  
,cf.[UpdatedDate]  
,[AllInCouponRate]  
,[CleanCost]  
,[GrossDeferredFees]  
,[DeferredFeesReceivable]  
,[CleanCostPrice]  
,[AmortizedCostPrice]  
,[AdditionalFeeAccrual]  
,[CapitalizedCostAccrual]  
,[DailySpreadInterestbeforeStrippingRule]  
,[DailyLiborInterestbeforeStrippingRule]  
,[ReversalofPriorInterestAccrual]  
,[InterestReceivedinCurrentPeriod]  
,[CurrentPeriodInterestAccrual]  
,[TotalGAAPInterestFortheCurrentPeriod]  
,InvestmentBasis  
,CurrentPeriodInterestAccrualPeriodEnddate  
,LIBORPercentage  
,SpreadPercentage  
,AnalysisID  
,FeeStrippedforthePeriod  
,PIKInterestPercentage  
,AmortizedCost  
,InterestSuspenseAccountActivityforthePeriod  
,InterestSuspenseAccountBalance  
,null as AccumaltedDiscountPremiumBI  
,null as AccumalatedCapitalizedCostBI  
,cf.CRENoteID + '_'+ Convert(Varchar(10),EOMonth(cf.PeriodEndDate,0),110)  as NoteID_EODPeriodEndDateBI  
  
,[AllInBasisValuation]  
,[AllInPIKRate]  
,[CurrentPeriodPIKInterestAccrualPeriodEnddate]  
,[PIKInterestPaidForThePeriod]  
,[PIKInterestAppliedForThePeriod]   
,[EndingPreCapPVBasis]  
,[LevelYieldIncomeForThePeriod]  
,[PVAmortTotalIncomeMethod]  
,[EndingCleanCostLY]  
,[EndingAccumAmort]  
,[PVAmortForThePeriod]  
,[EndingSLBasis]  
,[SLAmortForThePeriod]  
,[SLAmortOfTotalFeesInclInLY]   
,[SLAmortOfDiscountPremium]  
,[SLAmortOfCapCost]  
,[EndingAccumSLAmort]   
,[EndingPreCapGAAPBasis]  
,[PIKPrincipalPaidForThePeriod]  

,RemainingUnfundedCommitment
,CalcEngineType
,levyld
,cum_dailypikint
,cum_baladdon_am
,cum_baladdon_nonam
,cum_dailyint
,cum_ddbaladdon
,cum_ddintdelta
,initbal
,cum_fee_levyld
,period_ddintdelta_shifted
,intdeltabal
,cum_exit_fee_excl_lv_yield
,accountingclosedate
,CurrentPeriodPIKInterestAccrual
,AccPeriodEnd
,AccPeriodStart
,pmtdtnotadj
,pmtdt
,periodpikint
,DropDateInterestDeltaBalance
,AverageDailyBalance
,DeferredFeeGAAPBasis
,CapitalizedCostLevelYield
,CapitalizedCostGAAPBasis
,CapitalizedCostAccumulatedAmort
,DiscountPremiumLevelYield
,DiscountPremiumGAAPBasis
,DiscountPremiumAccumulatedAmort
,InterestPastDue
,AccountId
FROM ##tblNPC cf  


  
PRINT('Staging_Cashflow: '+CAST(@@ROWCOUNT as nvarchar(256)))  
  
Update DW.ImportStagDataIntoInt_Status set [Status] = 'Completed',EndDate = getdate() where TableName = 'NotePeriodicCalc'  
  
  
  
Update [DW].[Staging_Cashflow]  set [DW].[Staging_Cashflow].AccumaltedDiscountPremiumBI = a.AccumaltedDiscountPremiumBI,[DW].[Staging_Cashflow].AccumalatedCapitalizedCostBI = a.AccumalatedCapitalizedCostBI  
From(  
 SELECT [NotePeriodicCalcID]          
 ,SUM(ISNULL(cf.DiscountPremiumAccrual,0)) OVER(PARTITION BY cf.AnalysisID,cf.NoteID ORDER BY cf.AnalysisID,cf.NoteID,cf.PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccumaltedDiscountPremiumBI  
 ,SUM(ISNULL(cf.CapitalizedCostAccrual,0)) OVER(PARTITION BY cf.AnalysisID,cf.NoteID ORDER BY cf.AnalysisID,cf.NoteID,cf.PeriodEndDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS AccumalatedCapitalizedCostBI  
 FROM [DW].[Staging_Cashflow] cf  
)a  
where [DW].[Staging_Cashflow].[NotePeriodicCalcID] = a.[NotePeriodicCalcID]  
---------------------------------------  
   
  
PRINT('Insert - Start - DW.Staging_IntegartionCashFlowBI')  
  
Truncate table DW.Staging_IntegartionCashFlowBI  
  
INSERT INTO DW.Staging_IntegartionCashFlowBI (Scenario,AnalysisID,NoteKey,NoteID,PeriodEndDate,In_EndingGAAPBookValue,In_TotalAmortAccrualForPeriod,In_AccumulatedAmort,In_DiscountPremiumAccrual,In_AccumaltedDiscountPremium,In_CapitalizedCostAccrual,In_AccumalatedCapitalizedCost,In_CurrentPeriodInterestAccrualPeriodEnddate,St_EndingGAAPBookValue,St_TotalAmortAccrualForPeriod,St_AccumulatedAmort,St_DiscountPremiumAccrual,St_AccumaltedDiscountPremium,St_CapitalizedCostAccrual,St_AccumalatedCapitalizedCost,St_CurrentPeriodInterestAccrualPeriodEnddate)  
Select   
In_np.Scenario  
,In_np.AnalysisID  
,In_np.NoteKey   
,In_np.NoteID   
,In_np.PeriodEndDate  
,In_np.EndingGAAPBookValue as In_EndingGAAPBookValue  
,In_np.TotalAmortAccrualForPeriod as In_TotalAmortAccrualForPeriod  
,In_np.AccumulatedAmort as In_AccumulatedAmort  
,In_np.DiscountPremiumAccrual as In_DiscountPremiumAccrual  
,In_np.AccumaltedDiscountPremium as In_AccumaltedDiscountPremium  
,In_np.CapitalizedCostAccrual as In_CapitalizedCostAccrual  
,In_np.AccumalatedCapitalizedCost as In_AccumalatedCapitalizedCost  
,In_np.CurrentPeriodInterestAccrualPeriodEnddate as In_CurrentPeriodInterestAccrualPeriodEnddate  
,St_np.EndingGAAPBookValue as St_EndingGAAPBookValue  
,St_np.TotalAmortAccrualForPeriod as St_TotalAmortAccrualForPeriod  
,St_np.AccumulatedAmort as St_AccumulatedAmort  
,St_np.DiscountPremiumAccrual as St_DiscountPremiumAccrual  
,St_np.AccumaltedDiscountPremium as St_AccumaltedDiscountPremium  
,St_np.CapitalizedCostAccrual as St_CapitalizedCostAccrual  
,St_np.AccumalatedCapitalizedCost as St_AccumalatedCapitalizedCost  
,St_np.CurrentPeriodInterestAccrualPeriodEnddate as St_CurrentPeriodInterestAccrualPeriodEnddate  
from dbo.NotePeriodicCalc In_np  
left join dbo.Staging_Cashflow St_np on In_np.NoteID = St_np.NoteID and In_np.AnalysisID = St_np.AnalysisID and In_np.PeriodEndDate = St_np.PeriodEndDate  
  
PRINT('Insert - End - DW.Staging_IntegartionCashFlowBI')  
  
  
  
  
Update [DW].[Staging_Note] SET   
[DW].[Staging_Note].HasScheduledPrincipal = a.HasScheduledPrincipal,  
[DW].[Staging_Note].HasPIkPrincipalpaid = a.HasPIkPrincipalpaid,  
[DW].[Staging_Note].HasPIkInterestpaid = a.HasPIkInterestpaid  
From(  
 Select n.noteid,  
 (CASE WHEN tblHasScheduledPrincipal.Noteid is null THEN 'No' ELSE 'Yes' END) as HasScheduledPrincipal,  
 (CASE WHEN tblHasPIkPrincipalpaid.Noteid is null THEN 'No' ELSE 'Yes' END) as HasPIkPrincipalpaid,  
 (CASE WHEN tblHasPIkInterestpaid.Noteid is null THEN 'No' ELSE 'Yes' END) as HasPIkInterestpaid  
  
 From [dbo].[Ex_Staging_Note] n  
 Left JOIN(  
  Select Noteid from Staging_TransactionEntry T  
  where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and Type ='ScheduledPrincipalPaid'  
 )tblHasScheduledPrincipal on tblHasScheduledPrincipal.noteid = n.crenoteid  
 Left JOIN(  
  Select Noteid from Staging_TransactionEntry T  
  where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and Type ='PIKPrincipalPaid'  
 )tblHasPIkPrincipalpaid on tblHasPIkPrincipalpaid.noteid = n.crenoteid  
 Left JOIN(  
  Select Noteid from Staging_TransactionEntry T  
  where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and Type ='PIKInterestPaid'  
 )tblHasPIkInterestpaid on tblHasPIkInterestpaid.noteid = n.crenoteid  
  
)a  
where [DW].[Staging_Note].noteid = a.noteid  
  
  
Update DW.ImportStagDataIntoInt_Status set [Status] = 'Completed',EndDate = getdate() where TableName = 'NotePeriodicCalc'  
  
  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
  
  
  
END
GO

