CREATE PROCEDURE [CRE].[usp_SaveDeal]        
(        
 @DealID varchar(256),        
 @DealName nvarchar(256),        
 @DealType int,            
 @LoanProgram int ,        
 @LoanPurpose int ,        
 @Status int ,        
 @AppReceived date ,        
 @EstClosingDate date ,        
 @BorrowerRequest nvarchar(256) ,        
 @RecommendedLoan decimal(28, 15) ,        
 @TotalFutureFunding decimal(28, 15) ,        
 @Source int ,        
 @BrokerageFirm nvarchar(256) ,        
 @BrokerageContact nvarchar(256) ,        
 @Sponsor nvarchar(256) ,        
 @Principal nvarchar(256) ,        
 @NetWorth decimal(28, 15) ,        
 @Liquidity decimal(28, 15) ,        
 @ClientDealID nvarchar(256) ,        
 @CREDealID nvarchar(256) ,        
 @TotalCommitment decimal(28, 15) ,        
 @AdjustedTotalCommitment decimal(28, 15) ,        
 @AggregatedTotal decimal(28, 15) ,        
 @AssetManagerComment nvarchar(max) ,        
 @LinkedDealID  nvarchar(256) ,        
 @AssetManager  nvarchar(256) ,        
 @DealCity  nvarchar(256) ,        
 @DealState  nvarchar(256) ,        
 @DealPropertyType  nvarchar(256) ,        
 @FullyExtMaturityDate date ,        
 @UnderwritingStatusid int,        
 @CreatedBy nvarchar(256) ,        
 @CreatedDate datetime ,        
 @UpdatedBy nvarchar(256) ,        
 @UpdatedDate datetime ,        
 @DealComment  nvarchar(max) ,          
 @AllowSizerUpload int,        
 @AssetManagerID  nvarchar(256),        
 @AMTeamLeadUserID  nvarchar(256),        
 @AMSecondUserID  nvarchar(256),        
 @DealRule nvarchar(2000),        
 @BoxDocumentLink nvarchar(500),        
 @DealGroupID nvarchar(256),        
 @NewDealID nvarchar(256) OUTPUT,        
 @EnableAutoSpread bit ,        
 @AmortizationMethod int ,        
 @ReduceAmortizationForCurtailments int ,        
 @BusinessDayAdjustmentForAmort int ,        
 @NoteDistributionMethod int ,        
 @PeriodicStraightLineAmortOverride  decimal(28,15) ,        
 @FixedPeriodicPayment decimal(28,15),        
 @EquityAmount decimal(28,15),        
 @RemainingAmount decimal(28,15),        
 @AutoUpdateFromUnderwriting bit,        
 @ExpectedFullRepaymentDate date,        
 @AutoPrepayEffectiveDate date,        
 @RepaymentAutoSpreadMethodID int,        
 @EarliestPossibleRepaymentDate date,        
 @LatestPossibleRepaymentDate date,        
 @Blockoutperiod int,        
 @PossibleRepaymentdayofthemonth int,        
 @Repaymentallocationfrequency int,        
 @EnableAutoSpreadRepayments bit,      
 @DealLevelMaturity bit,      
 @ApplyNoteLevelPaydowns bit,      
 @IsREODeal bit,      
 @BalanceAware bit    
 ,@PropertyTypeMajorID int,    
 @LoanStatusID int  
 ,@PrepayDate datetime,
  @ICMFullyFundedEquity decimal(28,15), 
  @EquityatClosing decimal(28,15)
 )        
          
AS        
BEGIN        
        
--if(@DealID <> '00000000-0000-0000-0000-000000000000' or @DealID is not null)        
--BEGIN        
-- Update CRE.DealFunding set DealFundingRowno = 0 where dealid = @DealID        
--END        
        
        
        
if(@DealID='00000000-0000-0000-0000-000000000000' or @DealID is null)        
BEGIN        
        
         
        
DECLARE @tDeal TABLE (tNewDealId UNIQUEIDENTIFIER)        
        
INSERT INTO CRE.Deal        
           (        
    DealName        
    ,DealType        
    ,LoanProgram        
    ,LoanPurpose        
    ,Status        
    ,AppReceived        
    ,EstClosingDate        
    ,BorrowerRequest        
    ,RecommendedLoan        
    ,TotalFutureFunding        
    ,Source        
    ,BrokerageFirm        
    ,BrokerageContact        
    ,Sponsor        
    ,Principal        
    ,NetWorth        
    ,Liquidity        
    ,ClientDealID        
    ,CREDealID        
    ,TotalCommitment        
    ,AdjustedTotalCommitment        
    ,AggregatedTotal        
    ,AssetManagerComment        
    ,LinkedDealID        
    ,AssetManager        
    ,DealCity        
    ,DealState        
    ,DealPropertyType        
    ,FullyExtMaturityDate        
    ,UnderwritingStatus        
    ,AllowSizerUpload        
    ,CreatedBy        
    ,CreatedDate        
    ,UpdatedBy        
    ,UpdatedDate        
    ,DealComment        
    ,IsDeleted        
    ,AMUserID        
    ,AMTeamLeadUserID        
    ,AMSecondUserID        
    ,DealRule        
    ,BoxDocumentLink        
    ,DealGroupID        
    ,EnableAutoSpread        
    ,AmortizationMethod         
    ,ReduceAmortizationForCurtailments         
    ,BusinessDayAdjustmentForAmort         
    ,NoteDistributionMethod         
    ,PeriodicStraightLineAmortOverride        
    ,FixedPeriodicPayment        
    ,EquityAmount        
    ,RemainingAmount        
    ,AutoUpdateFromUnderwriting         
    ,ExpectedFullRepaymentDate         
    ,AutoPrepayEffectiveDate         
    ,RepaymentAutoSpreadMethodID         
    ,EarliestPossibleRepaymentDate         
    ,LatestPossibleRepaymentDate         
    ,Blockoutperiod         
    ,PossibleRepaymentdayofthemonth        
    ,Repaymentallocationfrequency        
    ,EnableAutoSpreadRepayments        
 --,KnownFullPayOffDate      
 ,DealLevelMaturity      
 ,ApplyNoteLevelPaydowns      
 ,IsREODeal      
 ,BalanceAware      
 ,PrepayDate 
 ,ICMFullyFundedEquity
 ,EquityAtClosing
 --,LoanStatusID    
    )        
  OUTPUT inserted.DealID INTO @tDeal(tNewDealId)        
          
     VALUES        
           (@DealName,        
   @DealType,            
   @LoanProgram,        
   @LoanPurpose ,        
   @Status,        
   @AppReceived ,        
   @EstClosingDate ,        
   @BorrowerRequest ,        
   @RecommendedLoan ,        
   @TotalFutureFunding ,        
   @Source,        
   @BrokerageFirm,        
   @BrokerageContact  ,        
   @Sponsor ,        
   @Principal,        
   @NetWorth,        
   @Liquidity,        
   nullif(@ClientDealID,''),        
   @CREDealID,        
   @TotalCommitment,        
   @AdjustedTotalCommitment,        
   @AggregatedTotal,        
   @AssetManagerComment,        
   @LinkedDealID,        
   @AssetManager,        
   @DealCity,        
   @DealState,        
   @DealPropertyType,        
   @FullyExtMaturityDate,        
   @UnderwritingStatusid,        
   @AllowSizerUpload,        
   @CreatedBy,        
   GETDATE(),        
   @UpdatedBy        
   ,GETDATE()        
   ,@DealComment        
   ,0        
   ,@AssetManagerID        
   ,@AMTeamLeadUserID        
   ,@AMSecondUserID        
   ,@DealRule        
   ,@BoxDocumentLink        
   ,@DealGroupID        
   ,@EnableAutoSpread        
   ,@AmortizationMethod         
   ,@ReduceAmortizationForCurtailments         
   ,@BusinessDayAdjustmentForAmort         
   ,@NoteDistributionMethod         
   ,@PeriodicStraightLineAmortOverride        
   ,@FixedPeriodicPayment        
   ,@EquityAmount        
   ,@RemainingAmount        
   ,@AutoUpdateFromUnderwriting         
   ,@ExpectedFullRepaymentDate         
   ,@AutoPrepayEffectiveDate         
   ,@RepaymentAutoSpreadMethodID         
   ,@EarliestPossibleRepaymentDate         
   ,@LatestPossibleRepaymentDate         
   ,@Blockoutperiod         
   ,@PossibleRepaymentdayofthemonth        
   ,@Repaymentallocationfrequency        
   ,@EnableAutoSpreadRepayments      
   --,@KnownFullPayOffDate      
   ,@DealLevelMaturity      
   ,@ApplyNoteLevelPaydowns      
   ,@IsREODeal      
   ,@BalanceAware  
   ,@PrepayDate 
   ,@ICMFullyFundedEquity
   ,@EquityatClosing
  -- , @PropertyTypeMajorID    
  -- ,@LoanStatusID    
   )        
        
   SELECT @NewDealID = tNewDealId FROM @tDeal;        
        
         
 Exec [dbo].[usp_InsertUserNotification]  @CreatedBy,'adddeal',@NewDealID        
        
END        
ELSE        
BEGIN        
        
--Log activity start        
         
 --log if status changes        
 IF EXISTS(select 1 FROM CRE.Deal where DealID=@DealID and [Status] <> @Status and  @Status IS NOT NULL and @Status<>0)        
 BEGIN        
  EXEC dbo.usp_InsertActivityLog @DealID,283,@DealID,418,'Updated',@UpdatedBy        
 END        
 ELSE        
 BEGIN        
  DECLARE @SourceTable int, @countAll int;        
  Select @SourceTable = count(DealID) FROM CRE.Deal where DealID=@DealID        
        
 --Comparing both tables        
  SELECT @countAll = COUNT(DealName) from        
  (        
  select DealName,DealType,LoanProgram,LoanPurpose,AppReceived,EstClosingDate,        
      BorrowerRequest,RecommendedLoan,TotalFutureFunding,Source,BrokerageFirm,        
      BrokerageContact,Sponsor,Principal,NetWorth,Liquidity,ClientDealID,CREDealID,            
      TotalCommitment,AdjustedTotalCommitment,AggregatedTotal,AssetManagerComment,        
      LinkedDealID,AssetManager,DealCity,DealState,DealPropertyType,FullyExtMaturityDate,        
      UnderwritingStatus,AllowSizerUpload,DealComment,AMUserID,AMTeamLeadUserID,AMSecondUserID        
      ,DealRule,BoxDocumentLink,DealGroupID,EnableAutoSpread,AmortizationMethod ,ReduceAmortizationForCurtailments         
      ,BusinessDayAdjustmentForAmort ,NoteDistributionMethod ,PeriodicStraightLineAmortOverride,FixedPeriodicPayment        
      ,EquityAmount,RemainingAmount        
        
      FROM CRE.Deal        
      where DealID=@DealID        
  UNION        
        
  select @DealName,@DealType,@LoanProgram,@LoanPurpose,@AppReceived,@EstClosingDate,        
      @BorrowerRequest,@RecommendedLoan,@TotalFutureFunding,@Source,@BrokerageFirm,        
      @BrokerageContact,@Sponsor,@Principal,@NetWorth,@Liquidity,@ClientDealID,@CREDealID,            
      @TotalCommitment,@AdjustedTotalCommitment,@AggregatedTotal,@AssetManagerComment,        
      @LinkedDealID,@AssetManager,@DealCity,@DealState,@DealPropertyType,@FullyExtMaturityDate,        
      @UnderwritingStatusid,@AllowSizerUpload,@DealComment,@AssetManagerID,@AMTeamLeadUserID,@AMSecondUserID        
      ,@DealRule,@BoxDocumentLink,@DealGroupID,@EnableAutoSpread,@AmortizationMethod ,@ReduceAmortizationForCurtailments,@BusinessDayAdjustmentForAmort         
      ,@NoteDistributionMethod ,@PeriodicStraightLineAmortOverride,@FixedPeriodicPayment,@EquityAmount,@RemainingAmount        
  )a        
        
        
        
         
  IF(@SourceTable <> @countAll )        
   EXEC dbo.usp_InsertActivityLog @DealID,283,@DealID,283,'Updated',@UpdatedBy        
        
    END        
        
--Log activity end        
        
Update CRE.Deal set         
    DealName=@DealName,        
    DealType=@DealType,            
    LoanProgram=@LoanProgram,        
    LoanPurpose =@LoanPurpose ,        
    Status= @Status,        
    AppReceived =@AppReceived ,        
    EstClosingDate =@EstClosingDate ,        
    BorrowerRequest =@BorrowerRequest ,        
    RecommendedLoan =@RecommendedLoan ,        
    TotalFutureFunding =@TotalFutureFunding ,        
    Source= @Source,        
    BrokerageFirm= @BrokerageFirm,        
    BrokerageContact  = @BrokerageContact  ,        
    Sponsor =@Sponsor ,        
    Principal=@Principal,        
    NetWorth=@NetWorth,        
    Liquidity=@Liquidity,        
    ClientDealID=(CASE WHEN @ClientDealID IS NULL THEN @CREDealID ELSE @ClientDealID END),        
    CREDealID = @CREDealID,            
    TotalCommitment =@TotalCommitment,        
    AdjustedTotalCommitment=@AdjustedTotalCommitment,        
    AggregatedTotal=@AggregatedTotal,        
    AssetManagerComment=@AssetManagerComment,        
    LinkedDealID =@LinkedDealID,        
    AssetManager=@AssetManager,        
    AMUserID=@AssetManagerID,        
    AMTeamLeadUserID=@AMTeamLeadUserID,        
    AMSecondUserID=@AMSecondUserID,        
    DealCity=@DealCity,        
    DealState=@DealState,        
    DealPropertyType=@DealPropertyType,        
    FullyExtMaturityDate=@FullyExtMaturityDate,        
    UnderwritingStatus=@UnderwritingStatusid,        
    AllowSizerUpload=@AllowSizerUpload,        
    UpdatedBy=@UpdatedBy,        
    UpdatedDate =GETDATE(),        
    DealComment= @DealComment ,        
    IsDeleted = 0,        
    DealRule= @DealRule,        
    BoxDocumentLink = @BoxDocumentLink,        
    DealGroupID = @DealGroupID,        
    EnableAutoSpread=@EnableAutoSpread,        
            
    AmortizationMethod = @AmortizationMethod,        
    ReduceAmortizationForCurtailments = @ReduceAmortizationForCurtailments,        
    BusinessDayAdjustmentForAmort = @BusinessDayAdjustmentForAmort,        
    NoteDistributionMethod = @NoteDistributionMethod,        
    PeriodicStraightLineAmortOverride = @PeriodicStraightLineAmortOverride ,        
    FixedPeriodicPayment = @FixedPeriodicPayment,        
    EquityAmount = @EquityAmount,        
    RemainingAmount = @RemainingAmount,        
    AutoUpdateFromUnderwriting = @AutoUpdateFromUnderwriting ,        
    ExpectedFullRepaymentDate = @ExpectedFullRepaymentDate ,        
    AutoPrepayEffectiveDate = @AutoPrepayEffectiveDate,         
    RepaymentAutoSpreadMethodID = @RepaymentAutoSpreadMethodID ,        
    EarliestPossibleRepaymentDate = @EarliestPossibleRepaymentDate,         
    LatestPossibleRepaymentDate = @LatestPossibleRepaymentDate ,        
    Blockoutperiod = @Blockoutperiod ,        
    PossibleRepaymentdayofthemonth= @PossibleRepaymentdayofthemonth,        
    Repaymentallocationfrequency= @Repaymentallocationfrequency,        
    EnableAutoSpreadRepayments = @EnableAutoSpreadRepayments,      
 --KnownFullPayOffDate = @KnownFullPayOffDate      
    DealLevelMaturity=@DealLevelMaturity,      
    ApplyNoteLevelPaydowns = @ApplyNoteLevelPaydowns,      
 IsREODeal = @IsREODeal,      
 BalanceAware=@BalanceAware ,  
 PrepayDate=@PrepayDate ,
 ICMFullyFundedEquity=@ICMFullyFundedEquity,
 EquityAtClosing=@EquityatClosing
 -- ,PropertyTypeMajorID=@PropertyTypeMajorID,    
 --LoanStatusID=@LoanStatusID     
    where DealID=@DealID        
      SELECT @NewDealID = @DealID         
        
 --Exec [dbo].[usp_QueueDealForCalculation]  @DealID,@UpdatedBy        
 Exec [dbo].[usp_InsertUserNotification]  @UpdatedBy,'editdeal',@NewDealID        
        
        
        
END        
        
        
END  