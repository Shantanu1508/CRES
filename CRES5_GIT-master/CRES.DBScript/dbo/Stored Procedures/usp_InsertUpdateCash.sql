CREATE PROCEDURE [dbo].[usp_InsertUpdateCash]
(   
	@AccountID UNIQUEIDENTIFIER,
	@CashAccountName nvarchar(256),
	@TranType nvarchar(256),
	@UserID nvarchar(256)
)       
AS      
BEGIN      
	DECLARE @insertedAccountID uniqueidentifier;        
        
	DECLARE @tAccount TABLE (tAccountID UNIQUEIDENTIFIER);
	DECLARE @AccountTypeID int;
	
	Set @AccountTypeID = (Select Top 1 AccountCategoryID from [CORE].[AccountCategory] Where [Name]='Cash' AND [Type]='Short Term Assets');
	
	IF EXISTS(Select * from [CORE].[Account] where AccountTypeID = @AccountTypeID and [name] = @CashAccountName)
	BEGIN
		SET @insertedAccountID = (Select AccountID from [CORE].[Account] where AccountTypeID = @AccountTypeID and [name] = @CashAccountName)
	END
	ELSE
	BEGIN
	
		INSERT INTO [Core].[Account] ([StatusID],[Name],[AccountTypeID],BaseCurrencyID,[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],isdeleted)
		OUTPUT inserted.AccountID INTO @tAccount(tAccountID)        
		VALUES(1,@CashAccountName,@AccountTypeID,NULL,@UserID,GETDATE(),@UserID,GetDATE(),0);
  
		SELECT @insertedAccountID = tAccountID FROM @tAccount;

		INSERT INTO [CRE].[Cash] (AccountID,[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		VALUES (@insertedAccountID,@UserID,GETDATE(),@UserID,GetDATE());
	END

	IF @TranType='Debt'
	BEGIN
		UPDATE [CRE].[Debt] SET PortfolioAccountID = @insertedAccountID Where AccountID = @AccountID ;
	END
	ELSE IF @TranType = 'Equity'
	BEGIN
		UPDATE [CRE].[Equity] SET PortfolioAccountID = @insertedAccountID Where AccountID = @AccountID;
	END  
    
	
END