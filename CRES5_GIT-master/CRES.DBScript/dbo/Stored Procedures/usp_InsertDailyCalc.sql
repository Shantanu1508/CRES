
CREATE PROCEDURE [dbo].[usp_InsertDailyCalc]

@TableTypeDailyCalc [TableTypeDailyCalc] READONLY,
@NoteId UNIQUEIDENTIFIER,
@CreatedBy  nvarchar(256)

AS
BEGIN
    SET NOCOUNT ON;


DECLARE @AccountID UNIQUEIDENTIFIER;
SET @AccountID = (Select n.Account_AccountID from CRE.note n inner join Core.Account acc on n.Account_AccountID=acc.AccountID   where noteid = @NoteId and acc.IsDeleted=0 )


DECLARE @CurrencyID int = (Select BaseCurrencyID from CORE.Account where AccountID = @AccountID and AccountTypeID  = 1) ----in (Select LookupID from CORE.Lookup where Name = 'Note')


DELETE FROM [Core].[DailyCalc] WHERE AccountID  = @AccountID 

INSERT INTO [Core].[DailyCalc]
           ([AccountID]
           ,[CalcValueID]
           ,[Date]
           ,[Amount]
           ,[IsActual]
           ,[CurrencyID]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
	Select
	@AccountID,
	(Select LookupID from CORE.Lookup where Name = TransactionType and ParentID = 49),
	[Date],
	[Amount],
	0 as [IsActual],
	@CurrencyID as [CurrencyID],
	@CreatedBy,
	GETDATE(),
	@CreatedBy,
	GETDATE()
	FROM @TableTypeDailyCalc





    
END
