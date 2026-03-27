ALTER TABLE CRE.Deal add AccountID UNIQUEIDENTIFIER

go

Declare @DealID UNIQUEIDENTIFIER
Declare @DealName nvarchar(256)
Declare @CREDealID nvarchar(256)
Declare @CreatedBy nvarchar(256)
Declare @CreatedDate Date
Declare @UpdatedBy nvarchar(256)
Declare @UpdatedDate Date


IF CURSOR_STATUS('global','CursorDeal')>=-1
BEGIN
	DEALLOCATE CursorDeal
END

DECLARE CursorDeal CURSOR 
for
(
	Select DealID,CREDealID,DealName,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate from cre.Deal where isdeleted <> 1
)
OPEN CursorDeal 

FETCH NEXT FROM CursorDeal
INTO @DealID,@CREDealID,@DealName,@CreatedBy,@CreatedDate,@UpdatedBy,@UpdatedDate

WHILE @@FETCH_STATUS = 0
BEGIN

	---==========================
	
	DECLARE @insertedAccountID uniqueidentifier;      
      
	DECLARE @tAccount TABLE (tAccountID UNIQUEIDENTIFIER)      
	INSERT INTO [Core].[Account]([StatusID],[Name],[ClientNoteID],BaseCurrencyID,[AccountTypeID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],isdeleted)      
	OUTPUT inserted.AccountID INTO @tAccount(tAccountID)      
	VALUES   (1,@DealName,@CREDealID,187,10, @CreatedBy,@CreatedDate,@UpdatedBy,@UpdatedDate,0)         
	
	SELECT @insertedAccountID = tAccountID FROM @tAccount;

	Update CRE.Deal SET AccountID = @insertedAccountID where DealID = @DealID
	---==========================
					 
FETCH NEXT FROM CursorDeal
INTO @DealID,@CREDealID,@DealName,@CreatedBy,@CreatedDate,@UpdatedBy,@UpdatedDate
END
CLOSE CursorDeal   
DEALLOCATE CursorDeal
