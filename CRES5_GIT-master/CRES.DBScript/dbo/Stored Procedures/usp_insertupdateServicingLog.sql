-- Procedure

CREATE procedure [dbo].[usp_insertupdateServicingLog]
(
	  @NoteTransactionDetailID uniqueidentifier
      ,@NoteID uniqueidentifier
	  ,@TransactionDate date
	  ,@TransactionType int
      ,@Amount decimal(28, 15)
      ,@RelatedtoModeledPMTDate   date
	  ,@ModeledPayment decimal(28, 15)
      ,@AmountOutstandingafterCurrentPayment decimal(28, 15)
      ,@CreatedBy nvarchar(256)
      ,@UpdatedBy nvarchar(256)  
	  ,@ServicingAmount  decimal(28, 15)
	  ,@CalculatedAmount decimal(28, 15)
	  ,@Delta decimal(28, 15)
	  ,@M61Value bit
	  ,@ServicerValue bit
	  ,@Ignore bit
	  ,@OverrideValue decimal(28, 15)	  
	  ,@TransactionTypeText nvarchar(256) 
	  ,@RemittanceDate date
	  ,@Adjustment decimal(28, 15)
	  ,@ActualDelta decimal(28, 15)
	  ,@Comment nvarchar(256)
	 ,@ServicerMasterID int
	 ,@TransactionEntryAmount decimal(28, 15)
	  )
	  as
	  BEGIN

	  if(isnumeric(@TransactionTypeText)=1 or nullif(@TransactionTypeText,'')='') 
	  Begin
	  set @TransactionTypeText=(select TransactionName from cre.transactiontypes where TransactionTypesID=@TransactionType)
	  End

if(@NoteTransactionDetailID='00000000-0000-0000-0000-000000000000')
BEGIN

	
	IF EXISTS(Select NoteTransactionDetailID from cre.NoteTransactionDetail where NoteID = @NoteID and TransactionTypeText = @TransactionTypeText and RelatedtoModeledPMTDate = @RelatedtoModeledPMTDate and RemittanceDate = @RemittanceDate and TransactionDate = @TransactionDate and ServicerMasterID = @ServicerMasterID)
	BEGIN
		print 'do nothing'
	END
	ELSE
	BEGIN
		INSERT INTO [CRE].[NoteTransactionDetail]
		([NoteID]
		,[TransactionDate]
		,[TransactionType]
		,[Amount]
		,[RelatedtoModeledPMTDate]
		,[ModeledPayment]
		,[AmountOutstandingafterCurrentPayment]
		,[CreatedBy]
		,[CreatedDate]
		,ServicingAmount
		,CalculatedAmount
		,Delta
		,M61Value
		,ServicerValue
		,Ignore
		,OverrideValue
		,TransactionTypeText
		,RemittanceDate
		,Adjustment
		,ActualDelta
		,comments	  
		,ServicerMasterID
		,TransactionEntryAmount
		)
		VALUES
		(@NoteID
		,@TransactionDate
		,@TransactionType
		,@Amount
		,@RelatedtoModeledPMTDate
		,@ModeledPayment
		,@AmountOutstandingafterCurrentPayment
		,@CreatedBy
		,GeTdate()
		,@ServicingAmount
		,@CalculatedAmount
		,@Delta
		,@M61Value
		,@ServicerValue
		,@Ignore
		,@OverrideValue
		,@TransactionTypeText
		,@RemittanceDate
		,@Adjustment
		,@ActualDelta
		,@Comment
		,@ServicerMasterID
		,@TransactionEntryAmount
		)
	END
END
Else
BEGIN
	UPDATE [CRE].[NoteTransactionDetail]
	SET 
      [TransactionDate] = @TransactionDate
      ,[TransactionType] = @TransactionType
      ,[Amount] = @Amount
      ,[RelatedtoModeledPMTDate] = @RelatedtoModeledPMTDate
      ,[ModeledPayment] = @ModeledPayment
      ,[AmountOutstandingafterCurrentPayment] = @AmountOutstandingafterCurrentPayment     
      ,[UpdatedBy] = @UpdatedBy
      ,[UpdatedDate] = GeTdate()
	   ,ServicingAmount=@ServicingAmount
	  ,CalculatedAmount=@CalculatedAmount
	  ,Delta=@Delta
	  ,M61Value=@M61Value
	  ,ServicerValue=@ServicerValue
	  ,Ignore=@Ignore
	  ,OverrideValue=@OverrideValue
	  ,TransactionTypeText=@TransactionTypeText
	  ,RemittanceDate=@RemittanceDate
	  ,Adjustment=@Adjustment
	  ,ActualDelta=@ActualDelta
	  ,comments=@Comment
	  ,ServicerMasterID=@ServicerMasterID
		WHERE [NoteTransactionDetailID] = @NoteTransactionDetailID and noteid = @noteid
		END
END


