CREATE PROCEDURE [dbo].[usp_InsertUpdatePrepayPremium]      
@DealId UNIQUEIDENTIFIER,    
@EffectiveDate date,     
@CalcThru date,    
@PrepaymentMethod int,    
@BaseAmountType int,    
@SpreadCalcMethod int,    
@GreaterOfSMOrBaseAmtTimeSpread bit,    
@HasNoteLevelSMSchedule bit,    
@Includefeesincredits bit,    
@CreatedBy nvarchar(256),     
@tblPrepayAdjustment [tblPrepayAdjustment] READONLY,      
@tblSpreadMaintenanceSchedule [tblSpreadMaintenanceSchedule] READONLY,      
@tblMinMultSchedule [tblMinMultSchedule] READONLY,      
@tblFeeCredits [tblFeeCredits] READONLY ,
@PrepayDate date,
@OpenPaymentDate date,
@MinimumMultipleDue decimal (28,15)

AS          
BEGIN      
SET NOCOUNT ON;          
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
    
    
Declare @SpreadMaintenance int = 738    
Declare @MinSpread int = 739    
Declare @Minnterest int = 740    
Declare @GreaterOfSMorMinMult int = 741    
    
    
Declare @EventTypeID int = (Select Lookupid from core.lookup where name = 'PrepaymentEvent' and parentid = 122)    
Declare @min_ClosingDate date     
    
Select @min_ClosingDate = MIN(ClosingDate) from cre.note n    
inner join core.account acc on acc.accountid = n.account_accountid    
inner join cre.deal d on d.dealid = n.dealid    
where acc.isdeleted <> 1 and d.dealid = @DealId    
    
Declare @max_EffDate date;    
    
    
Select @max_EffDate = MAX(EffectiveDate)    
from core.EventDeal     
where dealid = @DealId and StatusId = 1 and EventTypeID = @EventTypeID    
    
    
Declare @L_EventDealID int;    
Declare @L_PrepayScheduleID int;   

UPDATE [CRE].[Deal] set  PrepayDate=@PrepayDate where DealID=@DealId        
    
IF(@max_EffDate is null)    
BEGIN    
    
 SET @EffectiveDate = @min_ClosingDate;    
    
 INSERT INTO core.EventDeal (DealID,EventTypeID,EffectiveDate,StatusID)VALUES(@DealID,@EventTypeID,@EffectiveDate,1)    
 SET @L_EventDealID = @@IDENTITY    
    
 INSERT INTO [Core].[PrepaySchedule]([EventDealID],[CalcThru],[PrepaymentMethod],[BaseAmountType],[SpreadCalcMethod],[GreaterOfSMOrBaseAmtTimeSpread],[HasNoteLevelSMSchedule],[Includefeesincredits],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],[MinimumMultipleDue],[OpenPaymentDate])    
 VALUES( @L_EventDealID,@CalcThru,@PrepaymentMethod,@BaseAmountType,@SpreadCalcMethod,@GreaterOfSMOrBaseAmtTimeSpread,@HasNoteLevelSMSchedule,@Includefeesincredits,@CreatedBy,getdate(),@CreatedBy,getdate(),@MinimumMultipleDue,@OpenPaymentDate)     
 SET @L_PrepayScheduleID = @@Identity    
    
    
 INSERT INTO [Core].[PrepayAdjustment]([PrepayScheduleID],[Date],[PrepayAdjAmt],[Comment],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])    
 Select @L_PrepayScheduleID,pa.date,pa.PrepayAdjAmt,pa.Comment,@CreatedBy,getdate(),@CreatedBy,getdate()    
 From @tblPrepayAdjustment pa    
    
  
  INSERT INTO [Core].[SpreadMaintenanceSchedule]([PrepayScheduleID],NOteID,[Date],[Spread],[CalcAfterPayoff],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])    
  select @L_PrepayScheduleID,sm.noteid,sm.Date,sm.Spread,sm.CalcAfterPayoff,@CreatedBy,getdate(),@CreatedBy,getdate()    
  from @tblSpreadMaintenanceSchedule sm    
   
    
  INSERT INTO Core.MinMultSchedule([PrepayScheduleID],Date,MinMultAmount)    
  Select @L_PrepayScheduleID,ms.date,ms.MinMultAmount    
  from @tblMinMultSchedule ms    
    
  IF(@Includefeesincredits = 1)    
  BEGIN    
   INSERT INTO Core.FeeCredits([PrepayScheduleID],FeeType,UseActualFees,FeeCreditOverride)    
   Select @L_PrepayScheduleID,mf.FeeType,mf.UseActualFees,mf.FeeCreditOverride    
   from @tblFeeCredits mf    
  END    
     
    
    
END    
ELSE     
BEGIN     
 IF(@EffectiveDate = @max_EffDate)    
 BEGIN    
  Print '---update'    
      
  Declare @max_EventDealID int;    
  Declare @max_PrepayScheduleID int;    
    
  Select @max_EventDealID = EventDealID    
  from core.EventDeal     
  where dealid = @DealId and StatusId = 1 and EventTypeID = @EventTypeID and EffectiveDate = @EffectiveDate    
    
  SET @max_PrepayScheduleID = (select PrepayScheduleID from [Core].[PrepaySchedule] Where EventDealID = @max_EventDealID)    
      
  update [Core].[PrepaySchedule] set     
      
  [CalcThru] = @CalcThru,    
  [PrepaymentMethod] = @PrepaymentMethod,    
  [BaseAmountType] =@BaseAmountType,    
  [SpreadCalcMethod] = @SpreadCalcMethod,    
  [GreaterOfSMOrBaseAmtTimeSpread] = @GreaterOfSMOrBaseAmtTimeSpread,    
  [HasNoteLevelSMSchedule] = @HasNoteLevelSMSchedule,    
  [Includefeesincredits] = @Includefeesincredits,    
  [UpdatedBy] = @CreatedBy,    
  [UpdatedDate] = getdate(),
  [OpenPaymentDate] = @OpenPaymentDate,
  [MinimumMultipleDue] = @MinimumMultipleDue
  
  Where EventDealID = @max_EventDealID    
      
  Update [Core].[PrepayAdjustment] SET [Core].[PrepayAdjustment].[Date] = a.date     
  ,[Core].[PrepayAdjustment].[PrepayAdjAmt] = a.PrepayAdjAmt    
  ,[Core].[PrepayAdjustment].[Comment] = a.Comment    
  ,[Core].[PrepayAdjustment].[UpdatedBy] = @CreatedBy    
  ,[Core].[PrepayAdjustment].[UpdatedDate] = getdate()    
  from (    
   Select pa.PrepayAdjustmentId,pa.date,pa.PrepayAdjAmt,pa.Comment, pa.Isdeleted    
   From @tblPrepayAdjustment pa     
   where PrepayAdjustmentId <> 0   
		and ISNULL(pa.Isdeleted, 0) <> 1    
  )a    
  where [Core].[PrepayAdjustment].PrepayAdjustmentId = a.PrepayAdjustmentId    
  and [Core].[PrepayAdjustment].PrepayScheduleID = @max_PrepayScheduleID    
    
  INSERT INTO [Core].[PrepayAdjustment]([PrepayScheduleID],[Date],[PrepayAdjAmt],[Comment],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])    
  Select @max_PrepayScheduleID,pa.date,pa.PrepayAdjAmt,pa.Comment,@CreatedBy,getdate(),@CreatedBy,getdate()    
  From @tblPrepayAdjustment pa    
  where PrepayAdjustmentId = 0 and ISNULL(pa.Isdeleted, 0) <> 1

  DELETE FROM [Core].[PrepayAdjustment]
		WHERE PrepayAdjustmentId IN (
		SELECT ts.PrepayAdjustmentId 
		FROM @tblPrepayAdjustment ts
		WHERE ISNULL(ts.Isdeleted, 0) = 1)
    
  IF EXISTS(select * from @tblSpreadMaintenanceSchedule)  
  BEGIN    
   Delete from [Core].[SpreadMaintenanceSchedule] where [PrepayScheduleID] = @max_PrepayScheduleID    
    
   INSERT INTO [Core].[SpreadMaintenanceSchedule]([PrepayScheduleID],NOteID,[Date],[Spread],[CalcAfterPayoff],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])    
   select @max_PrepayScheduleID,sm.noteid,sm.Date,sm.Spread,sm.CalcAfterPayoff,@CreatedBy,getdate(),@CreatedBy,getdate()    
   from @tblSpreadMaintenanceSchedule sm    
       
  END    
  ELSE    
  BEGIN    
   Update [Core].[SpreadMaintenanceSchedule] set Isdeleted = 1 where [PrepayScheduleID] = @max_PrepayScheduleID    
  END    
    
  IF Exists (select * from @tblMinMultSchedule)    
  BEGIN    
    
   Update [Core].MinMultSchedule SET     
   [Core].MinMultSchedule.[Date] = a.Date,    
   [Core].MinMultSchedule.MinMultAmount = a.MinMultAmount,    
   [Core].MinMultSchedule.[UpdatedBy] = @CreatedBy,    
   [Core].MinMultSchedule.[UpdatedDate] = getdate()    
   from(    
    Select MinMultScheduleID,ms.date,ms.MinMultAmount    
    from @tblMinMultSchedule ms    
    where ms.MinMultScheduleID <> 0    
   )a    
   Where [Core].MinMultSchedule.MinMultScheduleID = a.MinMultScheduleID    
   and [Core].MinMultSchedule.PrepayScheduleID = @max_PrepayScheduleID    
    
   INSERT INTO Core.MinMultSchedule([PrepayScheduleID],Date,MinMultAmount)    
   Select @max_PrepayScheduleID,ms.date,ms.MinMultAmount    
   from @tblMinMultSchedule ms    
   where ms.MinMultScheduleID = 0    
   END    
  ELSE    
  BEGIN    
   Update [Core].MinMultSchedule set Isdeleted = 1 where [PrepayScheduleID] = @max_PrepayScheduleID    
  END   
    
   IF(@Includefeesincredits = 1)    
   BEGIN    
    Update [Core].FeeCredits SET     
    [Core].FeeCredits.UseActualFees = a.UseActualFees,    
    [Core].FeeCredits.FeeCreditOverride = a.FeeCreditOverride,    
    [Core].FeeCredits.FeeType = a.FeeType,    
    [Core].FeeCredits.[UpdatedBy] = @CreatedBy,    
    [Core].FeeCredits.[UpdatedDate] = getdate()    
    from(    
     Select FeeCreditsID,mf.FeeType,mf.UseActualFees,mf.FeeCreditOverride,mf.Isdeleted
     from @tblFeeCredits mf    
     where FeeCreditsID <>  0     
			and ISNULL(mf.Isdeleted, 0) <> 1      
    )a    
    Where [Core].FeeCredits.FeeCreditsID = a.FeeCreditsID    
    and [Core].FeeCredits.PrepayScheduleID = @max_PrepayScheduleID  
    
    INSERT INTO Core.FeeCredits([PrepayScheduleID],FeeType,UseActualFees,FeeCreditOverride)    
    Select @max_PrepayScheduleID,mf.FeeType,mf.UseActualFees,mf.FeeCreditOverride    
    from @tblFeeCredits mf    
    where FeeCreditsID =  0 and ISNULL(mf.Isdeleted, 0) <> 1            
      
	DELETE FROM [Core].FeeCredits
		WHERE FeeCreditsID IN (
		SELECT ts.FeeCreditsID 
		FROM @tblFeeCredits ts
		WHERE ISNULL(ts.Isdeleted, 0) = 1)
   END   
   
 END

 ELSE    
 BEGIN    
  IF(@EffectiveDate < @max_EffDate)    
  BEGIN    
   Update Core.EventDeal SET StatusID = 2 where dealid = @DealId and EventTypeID = @EventTypeID and EffectiveDate > @EffectiveDate    
  END    
      
  INSERT INTO core.EventDeal (DealID,EventTypeID,EffectiveDate,StatusID)VALUES(@DealID,@EventTypeID,@EffectiveDate,1)    
  SET @L_EventDealID = @@IDENTITY    
    
  INSERT INTO [Core].[PrepaySchedule]([EventDealID],[CalcThru],[PrepaymentMethod],[BaseAmountType],[SpreadCalcMethod],[GreaterOfSMOrBaseAmtTimeSpread],[HasNoteLevelSMSchedule],[Includefeesincredits],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],[MinimumMultipleDue],[OpenPaymentDate])    
  VALUES( @L_EventDealID,@CalcThru,@PrepaymentMethod,@BaseAmountType,@SpreadCalcMethod,@GreaterOfSMOrBaseAmtTimeSpread,@HasNoteLevelSMSchedule,@Includefeesincredits,@CreatedBy,getdate(),@CreatedBy,getdate(),@MinimumMultipleDue,@OpenPaymentDate)     
  SET @L_PrepayScheduleID = @@Identity    
    
    
  INSERT INTO [Core].[PrepayAdjustment]([PrepayScheduleID],[Date],[PrepayAdjAmt],[Comment],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])    
  Select @L_PrepayScheduleID,pa.date,pa.PrepayAdjAmt,pa.Comment,@CreatedBy,getdate(),@CreatedBy,getdate()    
  From @tblPrepayAdjustment pa    
    
     
   INSERT INTO [Core].[SpreadMaintenanceSchedule]([PrepayScheduleID],NOteID,[Date],[Spread],[CalcAfterPayoff],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])    
   select @L_PrepayScheduleID,sm.noteid,sm.Date,sm.Spread,sm.CalcAfterPayoff,@CreatedBy,getdate(),@CreatedBy,getdate()    
   from @tblSpreadMaintenanceSchedule sm    
     
    
     
   INSERT INTO Core.MinMultSchedule([PrepayScheduleID],Date,MinMultAmount)    
   Select @L_PrepayScheduleID,ms.date,ms.MinMultAmount    
   from @tblMinMultSchedule ms    
    
   IF(@Includefeesincredits = 1)    
   BEGIN    
    INSERT INTO Core.FeeCredits([PrepayScheduleID],FeeType,UseActualFees,FeeCreditOverride)    
    Select @L_PrepayScheduleID,mf.FeeType,mf.UseActualFees,mf.FeeCreditOverride    
    from @tblFeeCredits mf    
   END    
      
    
 END    
END    
    
    
    
    
    
    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
          
END        