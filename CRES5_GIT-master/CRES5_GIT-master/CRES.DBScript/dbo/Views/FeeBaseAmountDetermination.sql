CREATE View [dbo].[FeeBaseAmountDetermination]
as 
SELECT [FeeTypeName]
      ,[FeePaymentFrequency]
      ,[FeeCoveragePeriod]
      ,[FeeFunction]
      ,[TotalCommitment]
      ,[UnscheduledPaydowns]
      ,[BalloonPayment]
      ,[LoanFundings]
      ,[ScheduledPrincipalAmortizationPayment]
      ,[CurrentLoanBalance]
      ,[InterestPayment]
      ,[FeeNameTrans] as FeeGroupName
  FROM [DW].[FeeBaseAmountDeterminationBI]


  

