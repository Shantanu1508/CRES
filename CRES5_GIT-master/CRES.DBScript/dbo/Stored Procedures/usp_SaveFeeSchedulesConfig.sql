

-- Procedure
CREATE Procedure [dbo].[usp_SaveFeeSchedulesConfig]
(
@UserID NVarchar(255),
@FeeScheduleConfigXML XML
)
AS

BEGIN

	SET NOCOUNT ON;

	declare @tFeeSchedulsConfig table
  (
	 [FeeTypeGuID] nvarchar(256)
	,[FeeTypeNameText] [nvarchar](256)
	,[FeePaymentFrequencyID] int null
    ,[FeeCoveragePeriodID] int null
    ,[FeeFunctionID] int null
    ,[TotalCommitmentID] int null
    ,[UnscheduledPaydownsID] int null
    ,[BalloonPaymentID] int null
    ,[LoanFundingsID] int null
    ,[ScheduledPrincipalAmortizationPaymentID] int null
    ,[CurrentLoanBalanceID] int null
    ,[InterestPaymentID] int null
	,[FeeNameTransID] int null
	,ExcludeFromCashflowDownload bit null
	,InitialFundingID int null
	,M61AdjustedCommitmentID int null,
	[PIKFundingID]           int  null,
	[PIKPrincipalPaymentID]  int  null,
	[CurtailmentID]          int  null,
	[UpsizeAmountID]         int  null,
	[UnfundedCommitmentID]  int  null
  )


    INSERT INTO @tFeeSchedulsConfig
           select 
		    Pers.value('(FeeTypeGuID)[1]', 'nvarchar(256)')
		   ,Pers.value('(FeeTypeNameText)[1]', 'nvarchar(256)')
		   ,nullif(Pers.value('(FeePaymentFrequencyID)[1]', 'int'),0)
		   ,nullif(Pers.value('(FeeCoveragePeriodID)[1]', 'int'),0)
		   ,nullif(Pers.value('(FeeFunctionID)[1]', 'int'),0)
		   ,nullif(Pers.value('(TotalCommitmentID)[1]', 'int'),0)
		   ,nullif(Pers.value('(UnscheduledPaydownsID)[1]', 'int'),0)
		   ,nullif(Pers.value('(BalloonPaymentID)[1]', 'int'),0)
		   ,nullif(Pers.value('(LoanFundingsID)[1]', 'int'),0)
		   ,nullif(Pers.value('(ScheduledPrincipalAmortizationPaymentID)[1]', 'int'),0)
		   ,nullif(Pers.value('(CurrentLoanBalanceID)[1]', 'int'),0)
		   ,nullif(Pers.value('(InterestPaymentID)[1]', 'int'),0)
		   ,nullif(Pers.value('(FeeNameTransID)[1]', 'int'),0)
		   ,nullif(Pers.value('(ExcludeFromCashflowDownload)[1]', 'bit'),0)
		   ,nullif(Pers.value('(InitialFundingID)[1]', 'int'),0)
		   ,nullif(Pers.value('(M61AdjustedCommitmentID)[1]', 'int'),0)
		   ,nullif(Pers.value('(PIKFundingID)[1]', 'int'),0)
		   ,nullif(Pers.value('(PIKPrincipalPaymentID)[1]', 'int'),0)
		   ,nullif(Pers.value('(CurtailmentID)[1]', 'int'),0)
		   ,nullif(Pers.value('(UpsizeAmountID)[1]', 'int'),0)
		   ,nullif(Pers.value('(UnfundedCommitmentID)[1]', 'int'),0)
		   
		   FROM @FeeScheduleConfigXML.nodes('/ArrayOfFeeSchedulesConfigDataContract/FeeSchedulesConfigDataContract') as t(Pers)
     
  --insert new record
	INSERT INTO [CRE].[FeeSchedulesConfig]
           ([FeeTypeNameText]
           ,[FeePaymentFrequencyID]
           ,[FeeCoveragePeriodID]
           ,[FeeFunctionID]
           ,[TotalCommitmentID]
           ,[UnscheduledPaydownsID]
           ,[BalloonPaymentID]
           ,[LoanFundingsID]
           ,[ScheduledPrincipalAmortizationPaymentID]
           ,[CurrentLoanBalanceID]
           ,[InterestPaymentID]
           ,[FeeNameTransID]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
		   ,ExcludeFromCashflowDownload
		   ,InitialFundingID
		   ,M61AdjustedCommitmentID
		   ,[PIKFundingID]          ,
			[PIKPrincipalPaymentID] ,
			[CurtailmentID]         ,
			[UpsizeAmountID]        ,
			[UnfundedCommitmentID],
			IsActive
			)
     select
            [FeeTypeNameText]
           ,[FeePaymentFrequencyID]
           ,[FeeCoveragePeriodID]
           ,[FeeFunctionID]
           ,[TotalCommitmentID]
           ,[UnscheduledPaydownsID]
           ,[BalloonPaymentID]
           ,[LoanFundingsID]
           ,[ScheduledPrincipalAmortizationPaymentID]
           ,[CurrentLoanBalanceID]
           ,[InterestPaymentID]
		   ,[FeeNameTransID]
           ,@UserID
           ,getdate()
           ,@UserID
           ,getdate()
		   ,ExcludeFromCashflowDownload
		   ,InitialFundingID
		   ,M61AdjustedCommitmentID
		   ,[PIKFundingID]          ,
			[PIKPrincipalPaymentID] ,
			[CurtailmentID]         ,
			[UpsizeAmountID]        ,
			[UnfundedCommitmentID] ,
			1 as IsActive
		   from @tFeeSchedulsConfig where (FeeTypeGuID is null or FeeTypeGuID ='00000000-0000-0000-0000-000000000000' or FeeTypeGuID='')
		   and FeeTypeNameText not in 
			(
			  select FeeTypeNameText from CRE.FeeSchedulesConfig
			)


 --update existing record

	UPDATE [CRE].[FeeSchedulesConfig]
		SET [FeeTypeNameText] = ts.FeeTypeNameText
		  ,[FeePaymentFrequencyID] = ts.FeePaymentFrequencyID
		  ,[FeeCoveragePeriodID] = ts.FeeCoveragePeriodID
		  ,[FeeFunctionID] = ts.FeeFunctionID
		  ,[TotalCommitmentID] = ts.TotalCommitmentID
		  ,[UnscheduledPaydownsID] = ts.UnscheduledPaydownsID
		  ,[BalloonPaymentID] = ts.BalloonPaymentID
		  ,[LoanFundingsID] = ts.LoanFundingsID
		  ,[ScheduledPrincipalAmortizationPaymentID] = ts.ScheduledPrincipalAmortizationPaymentID
		  ,[CurrentLoanBalanceID] = ts.CurrentLoanBalanceID
		  ,[InterestPaymentID] = ts.InterestPaymentID
		  ,[FeeNameTransID]=ts.FeeNameTransID
		  ,[UpdatedBy] = @UserID
		  ,[UpdatedDate] = getdate()	
		  ,ExcludeFromCashflowDownload = ts.ExcludeFromCashflowDownload	
		  ,InitialFundingID = ts.InitialFundingID
		  ,M61AdjustedCommitmentID = ts.M61AdjustedCommitmentID
		  ,[PIKFundingID]          = ts.PIKFundingID
		  ,[PIKPrincipalPaymentID] = ts.PIKPrincipalPaymentID
		  ,[CurtailmentID]         = ts.CurtailmentID
		  ,[UpsizeAmountID]        = ts.UpsizeAmountID
		  ,[UnfundedCommitmentID]= ts.UnfundedCommitmentID
	   FROM
		(
				 select [FeeTypeGuID]
					   ,[FeeTypeNameText]
					   ,[FeePaymentFrequencyID]
					   ,[FeeCoveragePeriodID]
					   ,[FeeFunctionID]
					   ,[TotalCommitmentID]
					   ,[UnscheduledPaydownsID]
					   ,[BalloonPaymentID]
					   ,[LoanFundingsID]
					   ,[ScheduledPrincipalAmortizationPaymentID]
					   ,[CurrentLoanBalanceID]
					   ,[InterestPaymentID]
					   ,[FeeNameTransID]
					   ,ExcludeFromCashflowDownload
					   ,InitialFundingID
					   ,M61AdjustedCommitmentID
					   ,[PIKFundingID]          ,
						[PIKPrincipalPaymentID] ,
						[CurtailmentID]         ,
						[UpsizeAmountID]        ,
						[UnfundedCommitmentID] 
				from @tFeeSchedulsConfig where 
				(
				FeeTypeGuID is not null 
				and FeeTypeGuID <>'00000000-0000-0000-0000-000000000000'
				and FeeTypeGuID <>''
				)
		) ts 
		where cre.FeeSchedulesConfig.FeeTypeGuID = ts.FeeTypeGuID 
		and (ts.FeeTypeGuID is not null and ts.FeeTypeGuID <>'00000000-0000-0000-0000-000000000000'  and ts.FeeTypeGuID <>'')
	
	
END
