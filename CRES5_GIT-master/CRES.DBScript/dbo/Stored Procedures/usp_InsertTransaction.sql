
CREATE PROCEDURE [dbo].[usp_InsertTransaction]

@TableTypeTransaction [TableTypeTransaction] READONLY,
@NoteId UNIQUEIDENTIFIER,
@RegisterName nvarchar(256),
@CreatedBy  nvarchar(256)

AS
BEGIN
    SET NOCOUNT ON;

DECLARE @AccountID UNIQUEIDENTIFIER;
SET @AccountID = (Select n.Account_AccountID from CRE.note n inner join Core.Account acc on n.Account_AccountID=acc.AccountID where noteid = @NoteId and acc.IsDeleted=0)



DECLARE @ttable TABLE (tID UNIQUEIDENTIFIER)
Declare @ID uniqueidentifier;

IF NOT EXISTS(Select RegisterID from CORE.Register where AccountID = @AccountID and Name = @RegisterName)
BEGIN

	--HardCoded
	DECLARE @AnalysisID UNIQUEIDENTIFIER = (Select AnalysisID from CORE.Analysis where Name = 'temp')
	-------------

	INSERT INTO [Core].[Register] ([AccountID],[AnalysisID] ,[Name],[StatusID] ,[CreatedBy] ,[CreatedDate],[UpdatedBy],[UpdatedDate])
	OUTPUT inserted.RegisterID INTO @ttable(tID)
	VALUES(@AccountID,@AnalysisID,@RegisterName,(Select LookupID from CORE.Lookup where Name = 'Active'  and Parentid = 1),@CreatedBy,GETDATE(),@CreatedBy,GETDATE())

	Select @ID = tID FROM @ttable;

END
ELSE
BEGIN
	SET @ID = (Select RegisterID from CORE.Register where AccountID = @AccountID  and Name = @RegisterName)
END


DECLARE @CurrencyID int = (Select BaseCurrencyID from CORE.Account where AccountID = @AccountID and AccountTypeID  = 1)  ---in (Select LookupID from CORE.Lookup where Name = 'Note')

--HardCoded
DECLARE @PeriodID UNIQUEIDENTIFIER = (Select PeriodID from CORE.Period where Name = 'temp')
-------------
DELETE FROM [Core].[Transaction] WHERE [RegisterID] in (Select RegisterID from CORE.Register where AccountID = @AccountID  and Name = @RegisterName)

INSERT INTO [Core].[Transaction]
           ([PeriodID]
           ,[RegisterID]
           ,[TransactionTypeID]
           ,[Date]
           ,[Amount]
           ,[IsActual]
           ,[CurrencyID]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
	Select
	@PeriodID,
	@ID,
	(Select LookupID from CORE.Lookup where Name = TransactionType and ParentID = 48),
	[Date],
	[Amount],
	0 as [IsActual],
	@CurrencyID as [CurrencyID],
	@CreatedBy,
	GETDATE(),
	@CreatedBy,
	GETDATE()
	FROM @TableTypeTransaction





    
END
