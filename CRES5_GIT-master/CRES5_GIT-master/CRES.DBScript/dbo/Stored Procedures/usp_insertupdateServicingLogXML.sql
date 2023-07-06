

CREATE procedure [dbo].[usp_insertupdateServicingLogXML]
(
@XMLServicingLog XML
 )
	  as
	  BEGIN


	 declare @TempServicing table
	(
	    ID int identity,
		NoteTransactionDetailID uniqueidentifier,
      NoteID uniqueidentifier,
	  TransactionDate date,
	  TransactionType int,
      Amount decimal(28, 15),
      RelatedtoModeledPMTDate   date,
	  ModeledPayment decimal(28, 15),
      AmountOutstandingafterCurrentPayment decimal(28, 15),
      CreatedBy nvarchar(256),
      UpdatedBy nvarchar(256)  ,
	  ServicingAmount  decimal(28, 15),
	  CalculatedAmount decimal(28, 15),
	  Delta decimal(28, 15),
	  M61Value bit,
	  ServicerValue bit,
	  Ignore bit,
	  OverrideValue decimal(28, 15)	,  
	  TransactionTypeText nvarchar(256) ,
	  RemittanceDate date,
	  Adjustment decimal(28, 15),
	  ActualDelta decimal(28, 15),
	  Comment nvarchar(256),
	 ServicerMasterID int,
	 TransactionEntryAmount decimal(28, 15)
	)

	INSERT INTO @TempServicing
	select 
	ISNULL(nullif(Pers.value('(TransactionId)[1]', 'varchar(256)'), ''),'00000000-0000-0000-0000-000000000000'),  
	nullif(Pers.value('(NoteID)[1]', 'varchar(256)'), ''),
	Pers.value('(TransactionDate)[1]', 'datetime'),
	Pers.value('(TransactionType)[1]', 'int'),
	Pers.value('(Amount)[1]', 'decimal(28, 15)'),
	Pers.value('(RelatedtoModeledPMTDate)[1]', 'datetime'), 
	Pers.value('(ModeledPayment)[1]', 'decimal(28, 15)'), 
	Pers.value('(AmountOutstandingafterCurrentPayment)[1]', 'decimal(28, 15)'), 
	Pers.value('(CreatedBy)[1]', 'varchar(256)'), 
	Pers.value('(UpdatedBy)[1]', 'varchar(256)'),
	Pers.value('(ServicingAmount)[1]', 'decimal(28, 15)'), 
	Pers.value('(CalculatedAmount)[1]', 'decimal(28, 15)'), 
	Pers.value('(Delta)[1]', 'decimal(28, 15)'), 
	Pers.value('(M61Value)[1]', 'bit'), 
	Pers.value('(ServicerValue)[1]', 'bit'), 
	Pers.value('(Ignore)[1]', 'bit'),  
	Pers.value('(OverrideValue)[1]', 'decimal(28, 15)'), 
	Pers.value('(TransactionTypeText)[1]', 'varchar(256)'), 
	Pers.value('(RemittanceDate)[1]', 'datetime'), 
	Pers.value('(Adjustment)[1]', 'decimal(28, 15)'), 
	Pers.value('(ActualDelta)[1]', 'decimal(28, 15)'), 
	Pers.value('(Comment)[1]', 'varchar(256)'),  
	Pers.value('(ServicerMasterID)[1]', 'INT'),
	Pers.value('(TransactionEntryAmount)[1]', 'decimal(28, 15)')
	FROM @XMLServicingLog.nodes('/ArrayOfNoteServicingLogDataContract/NoteServicingLogDataContract') as t(Pers)
	WHERE Pers.value('(TransactionId)[1]', 'varchar(256)') != ''

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
	select 
      NoteID ,
	  TransactionDate ,
	  TransactionType ,
      Amount ,
      RelatedtoModeledPMTDate   ,
	  ModeledPayment ,
      AmountOutstandingafterCurrentPayment ,
      CreatedBy ,
      UpdatedBy   ,
	  ServicingAmount  ,
	  CalculatedAmount ,
	  Delta ,
	  M61Value ,
	  ServicerValue ,
	  Ignore ,
	  OverrideValue 	,  
	  TransactionTypeText  ,
	  RemittanceDate ,
	  Adjustment ,
	  ActualDelta ,
	  Comment ,
	 ServicerMasterID ,
	 TransactionEntryAmount  from  @TempServicing
	 WHERE [NoteTransactionDetailID] ='00000000-0000-0000-0000-000000000000'
		


UPDATE nt
	SET 
	nt.[TransactionDate] = tmp.TransactionDate
      ,nt.[TransactionType] = tmp.TransactionType
      ,nt.[Amount] = tmp.Amount
      ,nt.[RelatedtoModeledPMTDate] = tmp.RelatedtoModeledPMTDate
      ,nt.[ModeledPayment] = tmp.ModeledPayment
      ,nt.[AmountOutstandingafterCurrentPayment] = tmp.AmountOutstandingafterCurrentPayment     
      ,nt.[UpdatedBy] = tmp.UpdatedBy
      ,nt.[UpdatedDate] = GeTdate()
	   ,nt.ServicingAmount=tmp.ServicingAmount
	  ,nt.CalculatedAmount=tmp.CalculatedAmount
	  ,nt.Delta=tmp.Delta
	  ,nt.M61Value=tmp.M61Value
	  ,nt.ServicerValue=tmp.ServicerValue
	  ,nt.Ignore=tmp.Ignore
	  ,nt.OverrideValue=tmp.OverrideValue
	  ,nt.TransactionTypeText=tmp.TransactionTypeText
	  ,nt.RemittanceDate=tmp.RemittanceDate
	  ,Adjustment=tmp.Adjustment
	  ,nt.ActualDelta=tmp.ActualDelta
	  ,nt.comments=tmp.Comment
	  ,nt.ServicerMasterID=tmp.ServicerMasterID
	
	FROM @TempServicing tmp
	INNER JOIN
	[CRE].[NoteTransactionDetail] nt
	ON nt.NoteTransactionDetailID = tmp.NoteTransactionDetailID


END
