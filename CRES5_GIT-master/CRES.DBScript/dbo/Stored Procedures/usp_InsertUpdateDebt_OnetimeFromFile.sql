CREATE PROCEDURE [dbo].[usp_InsertUpdateDebt_OnetimeFromFile]      
(   
	@DebtID int,
	@AccountID UNIQUEIDENTIFIER,
	@DebtName nvarchar(256),
	@DebtType int,
	@Status int,
	@Currency int,
	@UserID nvarchar(256),
	@DebtAccountID UNIQUEIDENTIFIER OUTPUT,
	@DebtGUID_Output UNIQUEIDENTIFIER OUTPUT,	
	@AbbreviationName nvarchar(256),
	@LinkedFundID UNIQUEIDENTIFIER
)       
AS      
BEGIN      

	Declare @DebtGUID uniqueidentifier;
	Declare @l_AccountID uniqueidentifier;
		
	IF(@DebtID = 0)      
	BEGIN         
		---=====Insert into Account table=====  
		DECLARE @insertedAccountIDdt uniqueidentifier;        
        DECLARE @CashAccountName nvarchar(256);
		DECLARE @tAccountdt TABLE (tAccountIDdt UNIQUEIDENTIFIER)        
  
		INSERT INTO [Core].[Account] ([StatusID],[Name],[AccountTypeID],BaseCurrencyID,[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],isdeleted)        
		OUTPUT inserted.AccountID INTO @tAccountdt(tAccountIDdt)        
		VALUES(@Status,@DebtName,@DebtType,@Currency,@UserID,GETDATE(),@UserID,GetDATE(),0)        
  
		SELECT @insertedAccountIDdt = tAccountIDdt FROM @tAccountdt;        
		-------------------------------------------   
      
		INSERT INTO [CRE].[Debt]
		(AccountID	
		,CreatedBy 
		,CreatedDate
		,UpdatedBy 
		,UpdatedDate		
		,AbbreviationName
		,LinkedFundID
		)  
		VALUES(   
		@insertedAccountIDdt
		,@UserID
		,GETDATE()   
		,@UserID     
		,GETDATE() 
		,@AbbreviationName
		,@LinkedFundID
		) 


		SET @DebtGUID = (Select DebtGUID from cre.Debt where DebtID = @@IDENTITY )
		SET @l_AccountID = @insertedAccountIDdt;
		SET @DebtAccountID = @insertedAccountIDdt;
		SET @DebtGUID_Output = @DebtGUID;
		SET @CashAccountName = CONCAT(@DebtName,  ' Portfolio');

		EXEC  [dbo].[usp_InsertUpdateCash] @insertedAccountIDdt, @CashAccountName, 'Debt', @userID
	END      
	ELSE      
	BEGIN          
      
		UPDATE [Core].[Account]      
		SET [AccountTypeID] = @DebtType
		,[StatusID] = @status     
		,[Name] = @DebtName  
		,BaseCurrencyID = @Currency    	
		,[UpdatedBy] = @UserID      
		,[UpdatedDate] = GETDATE()      
		WHERE AccountID = @AccountID      
      
      
		UPDATE CRE.Debt SET  
		[UpdatedBy] = @UserID
		,[UpdatedDate] = GETDATE()
		,AbbreviationName = @AbbreviationName
		,LinkedFundID = @LinkedFundID
		WHERE DebtID = @DebtID 

		SET @DebtGUID = (Select DebtGUID from cre.Debt where DebtID = @DebtID )
		SET @l_AccountID = @AccountID;
		SET @DebtAccountID = @AccountID;
		SET @DebtGUID_Output = @DebtGUID;

		SET @CashAccountName = CONCAT(@DebtName,  ' Portfolio');

		EXEC  [dbo].[usp_InsertUpdateCash] @DebtAccountID, @CashAccountName, 'Debt', @userID
	END      
      
    EXEC [App].[usp_AddUpdateObject] @DebtGUID,842 ,'Kbaderia','Kbaderia'     
	

	SELECT @DebtAccountID as DebtAccountID,@DebtGUID_Output as DebtGUID_Output
      
END
GO

