CREATE PROCEDURE [dbo].[usp_InsertUpdateEquity_OnetimefromFile]      
(   
	@EquityID int,
	@AccountID UNIQUEIDENTIFIER,
	@EquityName nvarchar(256),
	@EquityType int,
	@Status int,
	@Currency int,
	@InvestorCapital decimal(28,15),
	@CapitalReserveRequirement decimal(28,15),
	@ReserveRequirement decimal(28,15),
	@CommittedCapital decimal(28,15),
	@CapitalReserve  decimal(28,15),
	@UncommittedCapital  decimal(28,15),
	@CapitalCallNoticeBusinessDays int,
	@EarliestEquityArrival Date,
	@FundBalanceexcludingReserves   decimal(28,15),
	@LinkedShortTermBorrowingFacility nvarchar(256),
	@UserID nvarchar(256),
	@EquityAccountID UNIQUEIDENTIFIER OUTPUT,
	@EquityGUID_Output UNIQUEIDENTIFIER OUTPUT,
	@CashAccountID UNIQUEIDENTIFIER ,
	@AbbreviationName nvarchar(256) = null,
	@StructureID int
)       
AS      
BEGIN      

	Declare @EquityGUID uniqueidentifier;
	Declare @l_AccountID uniqueidentifier;


	IF(@EquityID = 0)      
	BEGIN         
		---=====Insert into Account table=====  
		DECLARE @insertedAccountID uniqueidentifier;        
        DECLARE @CashAccountName nvarchar(256);
		DECLARE @tAccount TABLE (tAccountID UNIQUEIDENTIFIER)        
  
		INSERT INTO [Core].[Account] ([StatusID],[Name],[AccountTypeID],BaseCurrencyID,[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],isdeleted)        
		OUTPUT inserted.AccountID INTO @tAccount(tAccountID)        
		VALUES(@Status,@EquityName,@EquityType,@Currency,@UserID,GETDATE(),@UserID,GetDATE(),0)        
  
		SELECT @insertedAccountID = tAccountID FROM @tAccount;        
		-------------------------------------------   
      
		INSERT INTO [CRE].[Equity]
		([AccountID]
		,[InvestorCapital]
		,[CapitalReserveRequirement]
		,[ReserveRequirement]
		,[CommittedCapital]
		,[CapitalReserve]
		,[UncommittedCapital]
		,[CapitalCallNoticeBusinessDays]
		,[EarliestEquityArrival]
		,[FundBalanceexcludingReserves]
		,[LinkedShortTermBorrowingFacility]
		,[CreatedBy]
		,[CreatedDate]
		,[UpdatedBy]
		,[UpdatedDate]
		,AbbreviationName
		,StructureID)  
		VALUES(   
		@insertedAccountID
		,@InvestorCapital
		,@CapitalReserveRequirement
		,@ReserveRequirement
		,@CommittedCapital
		,@CapitalReserve
		,@UncommittedCapital
		,@CapitalCallNoticeBusinessDays
		,@EarliestEquityArrival
		,@FundBalanceexcludingReserves
		,@LinkedShortTermBorrowingFacility
		,@UserID
		,GETDATE()   
		,@UserID     
		,GETDATE()
		,@AbbreviationName
		,@StructureID
		) 

		SET @EquityGUID = (Select EquityGUID from cre.Equity where EquityID = @@IDENTITY )
		SET @l_AccountID = @insertedAccountID;
		SET @EquityAccountID = @insertedAccountID;
		SET @EquityGUID_Output = @EquityGUID;
		SET @CashAccountName = CONCAT(@EquityName,  ' Portfolio');
		
		EXEC  [dbo].[usp_InsertUpdateCash] @EquityAccountID, @CashAccountName, 'Equity', @userID
	END      
	ELSE      
	BEGIN          
      
		UPDATE [Core].[Account]      
		SET [AccountTypeID] = @EquityType
		,[StatusID] = @status     
		,[Name] = @EquityName  
		,BaseCurrencyID = @Currency    	
		,[UpdatedBy] = @UserID      
		,[UpdatedDate] = GETDATE()  
		
		WHERE AccountID = @AccountID      
      
      
		UPDATE CRE.Equity SET   		  
		InvestorCapital	 = 	@InvestorCapital	,
		CapitalReserveRequirement	 = 	@CapitalReserveRequirement	,
		ReserveRequirement	 = 	@ReserveRequirement	,
		CommittedCapital	 = 	@CommittedCapital	,
		CapitalReserve	 = 	@CapitalReserve	,
		UncommittedCapital	 = 	@UncommittedCapital	,
		CapitalCallNoticeBusinessDays	 = 	@CapitalCallNoticeBusinessDays	,
		EarliestEquityArrival	 = 	@EarliestEquityArrival	,
		FundBalanceexcludingReserves	 = 	@FundBalanceexcludingReserves	,
		LinkedShortTermBorrowingFacility	 = 	@LinkedShortTermBorrowingFacility,
		[UpdatedBy] = @UserID,
		[UpdatedDate] = GETDATE()
		,[PortfolioAccountID] = @CashAccountID
		,AbbreviationName = @AbbreviationName
		,StructureID=@StructureID
		WHERE EquityID = @EquityID 


		SET @EquityGUID = (Select EquityGUID from cre.Equity where EquityID = @EquityID )
		SET @l_AccountID = @AccountID;
		SET @EquityAccountID = @AccountID;
		SET @EquityGUID_Output = @EquityGUID;

		SET @CashAccountName = CONCAT(@EquityName,  ' Portfolio');
		
		EXEC  [dbo].[usp_InsertUpdateCash] @EquityAccountID, @CashAccountName, 'Equity', @userID
	END      
      
    EXEC [App].[usp_AddUpdateObject] @EquityGUID,843 ,'Kbaderia','Kbaderia'     

	exec [dbo].[usp_UpdateLiabilityCommitted_UnCommitted_Capital] @EquityAccountID

	SELECT @EquityAccountID as EquityAccountID,@EquityGUID_Output as EquityGUID_Output
    
END
GO

