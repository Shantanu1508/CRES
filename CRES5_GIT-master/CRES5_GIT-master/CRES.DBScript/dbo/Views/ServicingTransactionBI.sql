


CREATE view [dbo].[ServicingTransactionBI]
as 
Select 
[TransactionDate],
[CurrentPaymentDate],
[CurrentInterestPaidToDate],
[CurrentAllInInterestRate],
[CurrentInterestRateAdjDate],
[BeginningBalance],
[TotalScheduledP&IDue],
[SchedulePrincipalPaid],
[BegBalLessPRNPayment],
[NoteID],
[ServicerID],
[EntryNo],
[TransactionType],
[CurrentIndexRate],
[DateDue],
[IntRatefromReceivable],
[Principal],
[InterestPayment],
[LateChargePayment],
[NewIndexRate],
[NewInterestRate],
[NextPaymentAdjDate],
[EffectiveDate],
[TransactionAmount],
[TaxEscrowAmount],
[InsuranceEscrowAmount],
[ReserveEscrowAmount],
[Suspense],
[BalanceafterFundingTransacton],
[PrincipalWriteOff],
[PaymentStatus]	
From dw.ServicingTransactionBI


