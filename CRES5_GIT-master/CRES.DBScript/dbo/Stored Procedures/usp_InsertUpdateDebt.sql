CREATE PROCEDURE [dbo].[usp_InsertUpdateDebt]      
(   
	@DebtID int,
	@AccountID UNIQUEIDENTIFIER,
	@DebtName nvarchar(256),
	@DebtType int,
	@Status int,
	@Currency int,
	@CurrentCommitment	decimal(28,15),
	@MatchTerm	int,
	@IsRevolving	int,
	@FundingNoticeBD	int,
	@EarliestFinancingArrival	Date,
	@OriginationDate	Date,
	@OriginationFees	decimal(28,15),
	@RateType	int, 
	@DrawLag	int,
	@PaydownDelay	int, 
	@EffectiveDate Date,
	@Commitment   decimal(28,15),
	@InitialMaturityDate	 Date,
	@ExitFee	 decimal(28,15),
	@ExtensionFees decimal(28,15),	
	@InitialFundingDelay int,
	@MaxAdvanceRate    decimal(28,15),
	@TargetAdvanceRate decimal(28,15),
	@FundDelay int,
	@FundingDay int,
	@UserID nvarchar(256),
	@DebtAccountID UNIQUEIDENTIFIER OUTPUT,
	@DebtGUID_Output UNIQUEIDENTIFIER OUTPUT,
	@CashAccountID UNIQUEIDENTIFIER,
	@LiabilityBankerID INT,
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
		,CurrentCommitment
		,MatchTerm
		,IsRevolving
		,FundingNoticeBD
		,EarliestFinancingArrival
		,OriginationDate
		,OriginationFees
		,RateType	 
		,DrawLag
		,PaydownDelay	
		,InitialFundingDelay
		,MaxAdvanceRate 
		,TargetAdvanceRate
		,FundDelay
		,FundingDay
		,CreatedBy 
		,CreatedDate
		,UpdatedBy 
		,UpdatedDate
		,LiabilityBankerID
		,AbbreviationName
		,LinkedFundID
		)  
		VALUES(   
		@insertedAccountIDdt
		,@CurrentCommitment
		,@MatchTerm
		,@IsRevolving
		,@FundingNoticeBD
		,@EarliestFinancingArrival
		,@OriginationDate
		,@OriginationFees
		,@RateType	 
		,@DrawLag
		,@PaydownDelay	 		
		,@InitialFundingDelay
		,@MaxAdvanceRate 
		,@TargetAdvanceRate
		,@FundDelay
		,@FundingDay
		,@UserID
		,GETDATE()   
		,@UserID     
		,GETDATE() 
		,@LiabilityBankerID
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
		CurrentCommitment = @CurrentCommitment
		,MatchTerm = @MatchTerm
		,IsRevolving = @IsRevolving
		,FundingNoticeBD = @FundingNoticeBD
		,EarliestFinancingArrival = @EarliestFinancingArrival
		,OriginationDate = @OriginationDate
		,OriginationFees = @OriginationFees
		,RateType = @RateType	 
		,DrawLag = @DrawLag
		,PaydownDelay = @PaydownDelay	 
		,InitialFundingDelay = @InitialFundingDelay
		,MaxAdvanceRate  = @MaxAdvanceRate
		,TargetAdvanceRate = @TargetAdvanceRate
		,FundDelay = @FundDelay
		,FundingDay = @FundingDay
		,[UpdatedBy] = @UserID
		,[UpdatedDate] = GETDATE()
		,[PortfolioAccountID] = @CashAccountID
		,LiabilityBankerID = @LiabilityBankerID
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
	

	IF(@EffectiveDate iS NOT NULL)
	BEGIN
		EXEC [dbo].[usp_InsertUpdateGeneralSetupDetailsDebt] @l_AccountID,@EffectiveDate,@Commitment,@InitialMaturityDate,@ExitFee,@ExtensionFees,@UserID
	END

	SELECT @DebtAccountID as DebtAccountID,@DebtGUID_Output as DebtGUID_Output
      
END
GO

