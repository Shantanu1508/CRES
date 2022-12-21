
CREATE PROCEDURE [DW].[usp_GetServicingTransactionBI]

AS
BEGIN
    SET NOCOUNT ON;


SELECT [TransactionDate]
      ,[CurrentPaymentDate]
      ,[CurrentInterestPaidToDate]
      ,[CurrentAllInInterestRate]
      ,[CurrentInterestRateAdjDate]
      ,[BeginningBalance]
      ,[TotalScheduledP&IDue] as [TotalScheduledPandIDue]
      ,[SchedulePrincipalPaid]
      ,[BegBalLessPRNPayment]
      ,[NoteID]
      ,[ServicerID]
      ,[EntryNo]
      ,[TransactionType]
      ,[CurrentIndexRate]
      ,[DateDue]
      ,[IntRatefromReceivable]
      ,[Principal]
      ,[InterestPayment]
      ,[LateChargePayment]
      ,[NewIndexRate]
      ,[NewInterestRate]
      ,[NextPaymentAdjDate]
      ,[EffectiveDate]
      ,[TransactionAmount]
      ,[TaxEscrowAmount]
      ,[InsuranceEscrowAmount]
      ,[ReserveEscrowAmount]
      ,[Suspense]
      ,[BalanceafterFundingTransacton]
      ,[PrincipalWriteOff]
      ,[PaymentStatus]
  FROM [DW].[ServicingTransactionBI]


    
END
