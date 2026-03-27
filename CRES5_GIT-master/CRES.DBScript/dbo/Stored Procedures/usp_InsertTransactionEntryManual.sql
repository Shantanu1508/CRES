-- Procedure


CREATE PROCEDURE [dbo].[usp_InsertTransactionEntryManual]  
@BatchLogGenericID int,
@CreatedBy nvarchar(256)
AS  
BEGIN  
    SET NOCOUNT ON;  

	Declare @StrCreatedBy nvarchar(256);
	IF(@CreatedBy like REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
	BEGIN
		SET @StrCreatedBy = (Select top 1 [Login] from app.[user] where userid = @CreatedBy)
	END
	ELSE
	BEGIN
		SET @StrCreatedBy =  @CreatedBy
	END


	--Ignore records if flag set to EnableM61Calculations = Y
	Update [IO].[L_M61AddinLanding] set [Status] = 'Ignore' ,Comment = 'Enable M61 Calculations flag on accounting tab is not set to N' where M61AddinLandingID in (	
		Select mch.M61AddinLandingID
		from [IO].[L_M61AddinLanding] mch
		inner join cre.note n on n.crenoteid = mch.Noteid
		where TableName = 'M61.Tables.ManualCashflows' 
		and BatchLogGenericID = @BatchLogGenericID
		and [Status] = 'InProcess'
		and ISNULL(EnableM61Calculations,3) = 3
	)
	
	

	DELETE FROM [CRE].[TransactionEntryManual] WHERE AccountID in (

		Select Distinct n.Account_AccountID from [IO].[L_M61AddinLanding] mch
		inner join cre.note n on n.crenoteid = mch.Noteid
		where TableName = 'M61.Tables.ManualCashflows' 
		and BatchLogGenericID = @BatchLogGenericID 
		and [Status] = 'InProcess'
		and EnableM61Calculations = 4
	)
  

	INSERT INTO [CRE].[TransactionEntryManual]  
	(  
		AccountID  
		,[Date]  
		,Amount  
		,[Type]  
		,CreatedBy  
		,CreatedDate  
		,UpdatedBy  
		,UpdatedDate		
		
		,StrCreatedBy
		,GeneratedBy
		,[Cash_NonCash]
	) 
	Select 
	 n.Account_AccountID  
	 ,mch.DueDate
	 ,mch.Value as Amount  
	 ,ty.TransactionName as TransactionType  
	 ,mch.CreatedBy  
	 ,GETDATE()  
	 ,mch.CreatedBy  
	 ,GETDATE() 	 
	
	 ,@StrCreatedBy
	 ,'M61AddInManualCashflows' as GeneratedBy 
	 ,mch.[Cash_NonCash]
	from [IO].[L_M61AddinLanding] mch
	inner join cre.note n on n.crenoteid = mch.Noteid
	inner join cre.TransactionTypes ty on ty.TransactionTypesID = mch.TransactionTypeID

	where TableName = 'M61.Tables.ManualCashflows' 
		and BatchLogGenericID = @BatchLogGenericID 
		and [Status] = 'InProcess'
		and n.EnableM61Calculations = 4
  

 
  
   Update [IO].[L_M61AddinLanding] set [Status] = 'Imported' where TableName = 'M61.Tables.ManualCashflows' and BatchLogGenericID = @BatchLogGenericID and [Status] = 'InProcess'
  

  
	
	----Insert into Transaction entry table
	DELETE FROM [CRE].[TransactionEntry] WHERE AccountID in (
			Select Distinct n.Account_AccountID 
			from [IO].[L_M61AddinLanding] l 
			inner join cre.Note n on n.crenoteid = l.NoteID
			where TableName = 'M61.Tables.ManualCashflows' and BatchLogGenericID = @BatchLogGenericID and [Status] = 'Imported'
			and n.EnableM61Calculations = 4
		)
  
	INSERT INTO [CRE].[TransactionEntry]  
	(  
	--NoteID  
	[Date]  
	,Amount  
	,[Type]  
	,CreatedBy  
	,CreatedDate  
	,UpdatedBy  
	,UpdatedDate
	,AnalysisID  		
	,StrCreatedBy
	,GeneratedBy
	,[Cash_NonCash]
	,AccountID
	)  
	Select  
	--tr.NoteId  
	[Date]  
	,Amount  
	,Type as TransactionType  
	,@CreatedBy  
	,GETDATE()  
	,@CreatedBy  
	,GETDATE() 
	,a.AnalysisID 	
	,@StrCreatedBy
	,'M61AddInManualCashflows' as GeneratedBy
	--,[Cash_NonCash]

	,(CASE WHEN (tr.[Type] = 'FundingOrRepayment' and tr.Cash_NonCash is not null) THEN tr.Cash_NonCash
	WHEN (tr.[Type] = 'FundingOrRepayment' and tr.Cash_NonCash is null and tr.Amount < 0) THEN 'Funding'
	WHEN (tr.[Type] = 'FundingOrRepayment' and tr.Cash_NonCash is null and tr.Amount > 0) THEN 'Repayment'
	ELSE tym.Cash_NonCash END
	) [Cash_NonCash]

	,n.Account_AccountID

	FROM CRE.TransactionEntryManual tr
	Inner join cre.note n on n.Account_AccountID = tr.AccountID
	left join cre.transactiontypes tym on LOWER(tym.TransactionName) = LOWER(tr.Type)
	,core.Analysis a	 
	where tr.AccountID in (
			Select Distinct n.Account_AccountID 
			from [IO].[L_M61AddinLanding] l 
			inner join cre.Note n on n.crenoteid = l.NoteID
			where TableName = 'M61.Tables.ManualCashflows' and BatchLogGenericID = @BatchLogGenericID and [Status] = 'Imported'
			and n.EnableM61Calculations = 4
		)




END  
