--exec [usp_SaveFeeFunctionsConfig] '',
--'<ArrayOfFeeFunctionsConfigDataContract>

--<FeeFunctionsConfigDataContract>
--<FunctionGuID>E12208C9-9FDE-47AE-BB8F-88EC4BD680FE</FunctionGuID>
--<FunctionNameText>function3</FunctionNameText>
--<FunctionTypeID>528</FunctionTypeID>
--<PaymentFrequencyID>530</PaymentFrequencyID>
--<AccrualBasisID>534</AccrualBasisID>
--<AccrualStartDateID>536</AccrualStartDateID>
--<AccrualPeriodID>540</AccrualPeriodID>
--</FeeFunctionsConfigDataContract>
--</ArrayOfFeeFunctionsConfigDataContract>'

CREATE Procedure [dbo].[usp_SaveFeeFunctionsConfig]
@UserID NVarchar(255),
@FeeFunctionsConfigXML XML

AS

BEGIN

	SET NOCOUNT ON;

  declare @tFeeFunctionsConfig table
  (
	[FunctionGuID] nvarchar(256),
	[FunctionNameText] [nvarchar](256),
	[FunctionTypeID] [int] NULL,
	[PaymentFrequencyID] [int] NULL,
	[AccrualBasisID] [int] NULL,
	[AccrualStartDateID] [int] NULL,
	[AccrualPeriodID] [int] NULL
  )
	
	--insert in to temp table from xml
	INSERT INTO @tFeeFunctionsConfig 
		SELECT 
		 Pers.value('(FunctionGuID)[1]', 'nvarchar(256)')
		 ,Pers.value('(FunctionNameText)[1]', 'nvarchar(256)')
		,nullif(Pers.value('(FunctionTypeID)[1]', 'int'),0)
		,nullif(Pers.value('(PaymentFrequencyID)[1]', 'int'),0)
		,nullif(Pers.value('(AccrualBasisID)[1]', 'int'),0)
		,nullif(Pers.value('(AccrualStartDateID)[1]', 'int'),0)
		,nullif(Pers.value('(AccrualPeriodID)[1]', 'int'),0)

	FROM @FeeFunctionsConfigXML.nodes('/ArrayOfFeeFunctionsConfigDataContract/FeeFunctionsConfigDataContract') as t(Pers)
	select * from @tFeeFunctionsConfig
--insert new record
	INSERT INTO [CRE].[FeeFunctionsConfig]
				   ([FunctionNameText]
				   ,[FunctionTypeID]
				   ,[PaymentFrequencyID]
				   ,[AccrualBasisID]
				   ,[AccrualStartDateID]
				   ,[AccrualPeriodID]
				   ,[CreatedBy]
				   ,[CreatedDate]
				   ,[UpdatedBy]
				   ,[UpdatedDate])
	select
			FunctionNameText
			,FunctionTypeID
			,PaymentFrequencyID
			,AccrualBasisID
			,AccrualStartDateID
			,AccrualPeriodID
			,@UserID
			,getdate()
			,@UserID
			,getdate()
			from @tFeeFunctionsConfig where (FunctionGuID is null or FunctionGuID ='00000000-0000-0000-0000-000000000000' or FunctionGuID='')
			and FunctionNameText not in 
			(
				select FunctionNameText from [CRE].[FeeFunctionsConfig]
			)

 --update existing record

		UPDATE [CRE].[FeeFunctionsConfig]
		   
		   SET [FunctionTypeID] = tf.FunctionTypeID
			  ,[PaymentFrequencyID] = tf.PaymentFrequencyID
			  ,[AccrualBasisID] = tf.AccrualBasisID
			  ,[AccrualStartDateID] = tf.AccrualStartDateID
			  ,[AccrualPeriodID] = tf.AccrualPeriodID
			  ,[UpdatedBy] = @UserID
			  ,[UpdatedDate] = getdate()

			  FROM
			(
			  select [FunctionGuID],[FunctionNameText]
						   ,[FunctionTypeID]
						   ,[PaymentFrequencyID]
						   ,[AccrualBasisID]
						   ,[AccrualStartDateID]
						   ,[AccrualPeriodID]
						   from @tFeeFunctionsConfig where 
						   (FunctionGuID is not null 
						   and FunctionGuID <>'00000000-0000-0000-0000-000000000000'
						   and FunctionGuID <>''
						   )
			) tf 
			where cre.FeeFunctionsConfig.FunctionGuID = tf.FunctionGuID 
			and (tf.FunctionGuID is not null and tf.FunctionGuID <>'00000000-0000-0000-0000-000000000000'  and tf.FunctionGuID <>'')

END