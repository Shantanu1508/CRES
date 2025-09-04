CREATE PROCEDURE [dbo].[usp_InsertUpdateLiabilityNote]        
(        
		@LiabilityNoteAutoID    INT ,     
		@AccountID UNIQUEIDENTIFIER,  
		@DealAccountID UNIQUEIDENTIFIER,  
		@LiabilityNoteID nvarchar(256),  
		@LiailityNoteName nvarchar(256),  
		@LiabilityTypeID UNIQUEIDENTIFIER,  
		@AssetAccountID nvarchar(256),  
		@Status int,  
		@CurrentAdvanceRate decimal(28,15),  
		@CurrentBalance decimal(28,15),  
		@UndrawnCapacity decimal(28,15),  
		@PledgeDate Date,   
		@PaydownAdvanceRate   decimal(28,15),  
		@FundingAdvanceRate  decimal(28,15),  
		@TargetAdvanceRate  decimal(28,15),  
		@MaturityDate Date,    
		@tblNoteAssetMap [TableTypeLiabilityNoteAssetMapping] READONLY,   
		@UserID nvarchar(256) ,
		@LiabilityNoteAccountID UNIQUEIDENTIFIER OUTPUT,
		@ThirdPartyOwnership decimal(28,15),
		@PaymentFrequency                        INT             ,
		@AccrualEndDateBusinessDayLag			 INT             ,
		@AccrualFrequency                        INT             ,
		@Roundingmethod                          INT             ,
		@IndexRoundingRule                       INT             ,
		@FinanacingSpreadRate                    DECIMAL (28, 15),
		@IntActMethod                            INT             ,
		@DefaultIndexName                        INT       ,      
		@EffectiveDate Date,
		@UseNoteLevelOverride bit,
		@DebtEquityTypeID int,
		@LiabilitySource int ,
		@pmtdtaccper int,
		@ResetIndexDaily  int,
		@ActiveLiabilityNote int
)         
AS        
BEGIN        
  
   
 Declare @AccountTypeID int = 0;  
 Declare @L_AccountID UNIQUEIDENTIFIER;  
  
	IF EXISTS(Select d.DebtID from cre.Debt d Inner Join core.Account acc on acc.AccountID =  d.AccountID where IsDeleted<> 1 and  acc.AccountID = @LiabilityTypeID)   
	BEGIN  
		SET @AccountTypeID = (Select AccountCategoryID from core.AccountCategory where name  = 'Debt Note')  
	END  
	IF EXISTS(Select d.EquityID from cre.Equity d Inner Join core.Account acc on acc.AccountID =  d.AccountID where IsDeleted<> 1 and  acc.AccountID = @LiabilityTypeID)   
	BEGIN  
		SET @AccountTypeID = (Select AccountCategoryID from core.AccountCategory where name  = 'Equity Note')  
	END 
 
	IF EXISTS(Select d.CashID from cre.Cash d Inner Join core.Account acc on acc.AccountID =  d.AccountID where IsDeleted<> 1 and  acc.AccountID = @LiabilityTypeID)   
	BEGIN  
		SET @AccountTypeID = (Select AccountCategoryID from core.AccountCategory where [name]  = 'Cash')  
	END
  
 declare @LiabilityNoteGUID UNIQUEIDENTIFIER  
  
 SET @LiailityNoteName = @LiabilityNoteID;  
  
  
 IF(@LiabilityNoteAutoID = 0)        
 BEGIN           
  ---=====Insert into Account table=====    
  DECLARE @insertedAccountID uniqueidentifier;          
          
  DECLARE @tAccount TABLE (tAccountID UNIQUEIDENTIFIER)          
    
  INSERT INTO [Core].[Account] ([StatusID],[Name],[AccountTypeID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],isdeleted)          
  OUTPUT inserted.AccountID INTO @tAccount(tAccountID)          
  VALUES(1,@LiailityNoteName,@AccountTypeID,@UserID,GETDATE(),@UserID,GetDATE(),0)          
    
  SELECT @insertedAccountID = tAccountID FROM @tAccount;          
  -------------------------------------------     
            
  
  INSERT INTO [CRE].[LiabilityNote]        
  (  
  AccountID  
  ,DealAccountID  
  ,LiabilityNoteID  
  ,LiabilityTypeID  
  ,AssetAccountID  
  --,PledgeDate  
  ,CurrentAdvanceRate  
  ,TargetAdvanceRate  
  ,CurrentBalance  
  ,UndrawnCapacity  
  ,[CreatedBy]  
  ,[CreatedDate]  
  ,[UpdatedBy]  
  ,[UpdatedDate]  
  ,ThirdPartyOwnership
  ,PaymentFrequency                        
  ,AccrualEndDateBusinessDayLag			  
  ,AccrualFrequency                        
  ,Roundingmethod                          
  ,IndexRoundingRule                       
  ,FinanacingSpreadRate                    
  ,IntActMethod                            
  ,DefaultIndexName     
  ,UseNoteLevelOverride
  ,DebtEquityTypeID
  --,LiabilitySource  
  ,pmtdtaccper  
  ,ResetIndexDaily  
  ,ActiveLiabilityNote
  )     
  VALUES(     
  @insertedAccountID  
  ,@DealAccountID  
  ,@LiabilityNoteID  
  ,@LiabilityTypeID  
  ,@AssetAccountID  
  --,@PledgeDate  
  ,@CurrentAdvanceRate  
  ,@TargetAdvanceRate  
  ,@CurrentBalance  
  ,@UndrawnCapacity  
  ,@UserID  
  ,GETDATE()     
  ,@UserID       
  ,GETDATE()   
  ,@ThirdPartyOwnership
  ,@PaymentFrequency                        
  ,@AccrualEndDateBusinessDayLag			  
  ,@AccrualFrequency                        
  ,@Roundingmethod                          
  ,@IndexRoundingRule                       
  ,@FinanacingSpreadRate                    
  ,@IntActMethod                            
  ,@DefaultIndexName   
  ,@UseNoteLevelOverride
  ,@DebtEquityTypeID
  --,@LiabilitySource  
  ,@pmtdtaccper  
  ,@ResetIndexDaily  
  ,@ActiveLiabilityNote
  )   
  
  
  SET @LiabilityNoteGUID = (Select LiabilityNoteGUID from cre.LiabilityNote where LiabilityNoteAutoID = @@IDENTITY )  
  SET @L_AccountID = @insertedAccountID; 
  SET @LiabilityNoteAccountID = @insertedAccountID;
 END        
 ELSE        
 BEGIN            
        
  UPDATE [Core].[Account]        
  SET [AccountTypeID] = @AccountTypeID  
  ,[StatusID] = @status       
  ,[Name] = @LiailityNoteName         
  ,[UpdatedBy] = @UserID        
  ,[UpdatedDate] = GETDATE()        
  WHERE AccountID = @AccountID        
        
        
  UPDATE CRE.LiabilityNote SET         
  LiabilityNoteID = @LiabilityNoteID  
  ,LiabilityTypeID = @LiabilityTypeID  
  ,AssetAccountID = @AssetAccountID  
  --,PledgeDate = @PledgeDate  
  ,CurrentAdvanceRate = @CurrentAdvanceRate  
  ,TargetAdvanceRate = @TargetAdvanceRate  
  ,CurrentBalance = @CurrentBalance  
  ,UndrawnCapacity = @UndrawnCapacity  
  ,ThirdPartyOwnership=@ThirdPartyOwnership
  ,PaymentFrequency = @PaymentFrequency                      
  ,AccrualEndDateBusinessDayLag	= @AccrualEndDateBusinessDayLag		  
  ,AccrualFrequency = @AccrualFrequency                       
  ,Roundingmethod = @Roundingmethod                         
  ,IndexRoundingRule = @IndexRoundingRule                      
  ,FinanacingSpreadRate = @FinanacingSpreadRate                   
  ,IntActMethod = @IntActMethod                           
  ,DefaultIndexName = @DefaultIndexName        
  ,UseNoteLevelOverride=@UseNoteLevelOverride
  ,DebtEquityTypeID=@DebtEquityTypeID
  --,LiabilitySource = @LiabilitySource
  ,pmtdtaccper  =  @pmtdtaccper
  ,ResetIndexDaily =@ResetIndexDaily
  ,ActiveLiabilityNote=@ActiveLiabilityNote

  WHERE LiabilityNoteAutoID = @LiabilityNoteAutoID   
  
  SET @LiabilityNoteGUID = (Select LiabilityNoteGUID from cre.LiabilityNote where LiabilityNoteAutoID = @LiabilityNoteAutoID )  
  SET @L_AccountID = @AccountID;  
  SET @LiabilityNoteAccountID = @AccountID;

 END        
        
      
   
 EXEC [App].[usp_AddUpdateObject] @LiabilityNoteGUID,844 ,'Kbaderia','Kbaderia'  
      
 IF(@EffectiveDate IS NOT NULL)  
 BEGIN  
  EXEC [dbo].[usp_InsertUpdateGeneralSetupDetailsLiabilityNote] @L_AccountID,@EffectiveDate,@PaydownAdvanceRate,@FundingAdvanceRate,@TargetAdvanceRate,@MaturityDate,@UserID,@PledgeDate,@LiabilitySource   
 END  
  
  
 ---Insert liability note asset mapping  
 IF EXISTS(Select * from @tblNoteAssetMap)  
 BEGIN  
  declare @tblliaAssetnotemapping [TableTypeLiabilityNoteAssetMapping]    
  Insert into @tblliaAssetnotemapping(LiabilityNoteId,DealAccountId,LiabilityNoteAccountId,AssetAccountId)    
  Select LiabilityNoteId,@DealAccountID as DealAccountId,@L_AccountID as LiabilityNoteAccountId,AssetAccountId  From @tblNoteAssetMap  
  where LiabilityNoteId = @LiabilityNoteID  
  
  exec [dbo].[usp_InsertUpdateLiabilityNoteAssetMapping] @tblliaAssetnotemapping,@UserID  
 END  
 ELSE
 BEGIN
    DELETE FROM [CRE].[LiabilityNoteAssetMapping] WHERE LiabilityNoteAccountId = @L_AccountID
  
 END
  


  Select @LiabilityNoteAccountID as LiabilityNoteAccountID
  
END  