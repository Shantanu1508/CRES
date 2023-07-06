
Create PROCEDURE [DW].[usp_InsertServicingTransactionBI]
@TransactionDate	 date,
 @CurrentPaymentDate	 date,
 @CurrentInterestPaidToDate	 date	 ,
 @CurrentAllInInterestRate	 decimal(28, 15) ,
 @CurrentInterestRateAdjDate	 date	 ,
 @BeginningBalance	 decimal(28, 15) ,
 @TotalScheduledPandIDue	 decimal(28, 15) ,
 @SchedulePrincipalPaid	 decimal(28, 15) ,
 @BegBalLessPRNPayment	 decimal(28, 15) ,
 @NoteID	 nvarchar(256) ,
 @ServicerID	 int	 ,
 @EntryNo	 int	 ,
 @TransactionType	 nvarchar(256) ,
 @CurrentIndexRate	 decimal(28, 15) ,
 @DateDue	 date	 ,
 @IntRatefromReceivable	 decimal(28, 15) ,
 @Principal	 decimal(28, 15) ,
 @InterestPayment	 decimal(28, 15) ,
 @LateChargePayment	 decimal(28, 15) ,
 @NewIndexRate	 decimal(28, 15) ,
 @NewInterestRate	 decimal(28, 15) ,
 @NextPaymentAdjDate	 date	 ,
 @EffectiveDate	 date	 ,
 @TransactionAmount	 decimal(28, 15) ,
 @TaxEscrowAmount	 decimal(28, 15) ,
 @InsuranceEscrowAmount	 decimal(28, 15) ,
 @ReserveEscrowAmount	 decimal(28, 15) ,
 @Suspense	 decimal(28, 15) ,
 @BalanceafterFundingTransacton	 decimal(28, 15) ,
 @PrincipalWriteOff	 decimal(28, 15) ,
 @PaymentStatus	 nvarchar(256) 
 
AS
BEGIN
    SET NOCOUNT ON;

INSERT INTO [DW].[ServicingTransactionBI]
           ([TransactionDate]
           ,[CurrentPaymentDate]
           ,[CurrentInterestPaidToDate]
           ,[CurrentAllInInterestRate]
           ,[CurrentInterestRateAdjDate]
           ,[BeginningBalance]
           ,[TotalScheduledP&IDue]
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
           ,[PaymentStatus])
     VALUES
           ( @TransactionDate,
 @CurrentPaymentDate,
 @CurrentInterestPaidToDate,
 @CurrentAllInInterestRate,
 @CurrentInterestRateAdjDate,
 @BeginningBalance,
 @TotalScheduledPandIDue,
 @SchedulePrincipalPaid,
 @BegBalLessPRNPayment,
 @NoteID,
 @ServicerID,
 @EntryNo,
 @TransactionType,
 @CurrentIndexRate,
 @DateDue,
 @IntRatefromReceivable,
 @Principal,
 @InterestPayment,
 @LateChargePayment,
 @NewIndexRate,
 @NewInterestRate,
 @NextPaymentAdjDate,
 @EffectiveDate,
 @TransactionAmount,
 @TaxEscrowAmount,
 @InsuranceEscrowAmount,
 @ReserveEscrowAmount,
 @Suspense,
 @BalanceafterFundingTransacton,
 @PrincipalWriteOff,
 @PaymentStatus)


    
END
