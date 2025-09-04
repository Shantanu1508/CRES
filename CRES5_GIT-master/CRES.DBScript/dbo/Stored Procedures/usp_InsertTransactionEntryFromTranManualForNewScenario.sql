-- Procedure

--[dbo].[usp_InsertTransactionEntryFromTranManualForNewScenario]  '261CA4F1-A0AF-45C1-8CF6-053DAFAAA835','B0E6697B-3534-4C09-BE0A-04473401AB93'

CREATE PROCEDURE [dbo].[usp_InsertTransactionEntryFromTranManualForNewScenario] 

@AnalysisID UNIQUEIDENTIFIER,  
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


	DELETE FROM [CRE].[TransactionEntry] WHERE AccountID in (Select Account_AccountID from cre.Note where EnableM61Calculations = 4) and AnalysisID = @AnalysisID
	
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
	,@AnalysisID
	,@StrCreatedBy
	,'M61AddInManualCashflows' as GeneratedBy
	,n.Account_AccountID
	FROM CRE.TransactionEntryManual tr
	Inner join cre.note n on n.Account_AccountID = tr.AccountID
	where tr.AccountID in (Select Account_AccountID from cre.Note where EnableM61Calculations = 4)



 
END
