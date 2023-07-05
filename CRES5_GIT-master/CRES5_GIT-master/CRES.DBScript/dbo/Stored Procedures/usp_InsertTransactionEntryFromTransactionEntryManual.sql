  
CREATE PROCEDURE [dbo].[usp_InsertTransactionEntryFromTransactionEntryManual]  

@NoteId UNIQUEIDENTIFIER,  
@CreatedBy  nvarchar(256)  
  
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

Declare @EnableM61Calculations int  = (Select EnableM61Calculations from cre.Note where noteid = @NoteId)


IF(@EnableM61Calculations = 4)
BEGIN

	DELETE FROM [CRE].[TransactionEntry] WHERE [NoteID]=@NoteId  
  
	INSERT INTO [CRE].[TransactionEntry]  
	(  
	NoteID  
	,[Date]  
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
	)  
	Select  
	@NoteId  
	,[Date]  
	,Amount  
	,Type as TransactionType  
	,@CreatedBy  
	,GETDATE()  
	,@CreatedBy  
	,GETDATE() 
	,a.AnalysisID 	
	,@StrCreatedBy
	,'M61AddInManualCashflows' as GeneratedBy
	--,tr.[Cash_NonCash]
	
	,(CASE WHEN (tr.[Type] = 'FundingOrRepayment' and tr.Cash_NonCash is not null) THEN tr.Cash_NonCash
	WHEN (tr.[Type] = 'FundingOrRepayment' and tr.Cash_NonCash is null and tr.Amount < 0) THEN 'Funding'
	WHEN (tr.[Type] = 'FundingOrRepayment' and tr.Cash_NonCash is null and tr.Amount > 0) THEN 'Repayment'
	ELSE tym.Cash_NonCash END
	) [Cash_NonCash]

	FROM CRE.TransactionEntryManual tr
	left join cre.transactiontypes tym on LOWER(tym.TransactionName) = LOWER(tr.Type)
	,core.Analysis a	 
	where Noteid = @NoteId

 END


 
END
