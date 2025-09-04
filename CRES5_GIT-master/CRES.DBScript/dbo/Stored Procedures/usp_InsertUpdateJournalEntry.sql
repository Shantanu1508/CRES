CREATE PROCEDURE [dbo].[usp_InsertUpdateJournalEntry]
(
    @JournalEntryMasterID int,
    @JournalEntryDate Date,
    @Comment nvarchar(256),
    @tbljournalentry [TableTypeJournalEntry] READONLY,
    @UserID nvarchar(256),
    @JournalEntryMasterGUID Uniqueidentifier OUTPUT
)
AS
BEGIN
	
	declare @L_UserID Uniqueidentifier;
	IF(@UserID like REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
	BEGIN
		SET @L_UserID = @UserID
	END
	ELSE
	BEGIN
		SET @L_UserID =  (Select top 1 UserID from app.[user] where [Login] = @UserID)
	END

    IF (@JournalEntryMasterID = 0)
    BEGIN
        DECLARE @tJournalEntry TABLE (tJournalEntryMasterGUID UNIQUEIDENTIFIER) 

        INSERT INTO [Cre].[JournalEntryMaster] ([JournalEntryDate], [Comment], [CreatedBy], [CreatedDate],UpdatedBy,UpdatedDate)
        OUTPUT inserted.JournalEntryMasterGUID INTO @tJournalEntry(tJournalEntryMasterGUID)    
        VALUES (@JournalEntryDate, @Comment, @L_UserID, GETDATE() ,@L_UserID, GETDATE())

        DECLARE @JournEntryMID INT
        SET @JournEntryMID = @@IDENTITY

        INSERT INTO [Cre].[TransactionEntryManual] ([JournalEntryMasterId], [AccountId], [Date], [Type], [Amount], [Comment], [CreatedBy], [CreatedDate],UpdatedBy,UpdatedDate)
        SELECT @JournEntryMID, DebtEquityAccountID, TransactionDate, TransactionTypeText, TransactionAmount, Comment, @L_UserID, GETDATE(), @L_UserID, GETDATE()
        FROM @tbljournalentry

        SELECT @JournalEntryMasterGUID = tJournalEntryMasterGUID FROM @tJournalEntry;
    END
    ELSE
    BEGIN
        
        UPDATE [Cre].[JournalEntryMaster]
        SET
        [JournalEntryDate] = @JournalEntryDate,
        [Comment] = @Comment,
        [UpdatedBy] = @L_UserID,
        [UpdatedDate] = GETDATE()
        WHERE JournalEntryMasterId = @JournalEntryMasterID       


        INSERT INTO [Cre].[TransactionEntryManual] ([JournalEntryMasterId],[AccountId],[Date],[Type],[Amount],[Comment],[CreatedBy],[CreatedDate],UpdatedBy,UpdatedDate)     
        SELECT @JournalEntryMasterID, tje.DebtEquityAccountID, tje.TransactionDate, tje.TransactionTypeText, tje.TransactionAmount, tje.Comment, @L_UserID, GETDATE(), @L_UserID, GETDATE()
        FROM @tbljournalentry tje
        Left JOIN Cre.TransactionEntryManual tem ON  tje.TransactionEntryID = tem.TransactionEntryID
        WHERE tem.JournalEntryMasterId IS NULL
    

        Update Cre.TransactionEntryManual
        SET 
        Cre.TransactionEntryManual.AccountId = tmpjournal.DebtEquityAccountID,
        Cre.TransactionEntryManual.Date = tmpjournal.TransactionDate,
        Cre.TransactionEntryManual.Type = tmpjournal.TransactionTypeText,
        Cre.TransactionEntryManual.Amount = tmpjournal.TransactionAmount,
        Cre.TransactionEntryManual.Comment = tmpjournal.Comment,
        Cre.TransactionEntryManual.UpdatedBy= @L_UserID,
        Cre.TransactionEntryManual.UpdatedDate=GETDATE()
        FROM (
            SELECT tje.JournalEntryMasterId, tje.DebtEquityAccountID, tje.TransactionDate, tje.TransactionTypeText, tje.TransactionAmount, tje.Comment, tje.TransactionEntryID
            FROM @tbljournalentry tje Inner Join Cre.TransactionEntryManual tem ON tje.JournalEntryMasterId=tem.JournalEntryMasterId  and tje.TransactionEntryID = tem.TransactionEntryID
        ) tmpjournal
        WHERE tmpjournal.JournalEntryMasterId = Cre.TransactionEntryManual.JournalEntryMasterId and tmpjournal.TransactionEntryID=Cre.TransactionEntryManual.TransactionEntryID


        SELECT @JournalEntryMasterGUID = JournalEntryMasterGUID FROM [Cre].[JournalEntryMaster] where JournalEntryMasterId = @JournalEntryMasterID
    END

 END
GO