-- Procedure
      
CREATE PROCEDURE [dbo].[usp_AddUpdateNoteFromDealDetail]      
(      
  @UserID [uniqueidentifier],      
  @NoteID [uniqueidentifier],      
  @Account_AccountID [uniqueidentifier],      
  @DealID [uniqueidentifier],      
  @CRENoteID [nvarchar](256),      
  @ClosingDate [datetime],      
  @UseRuletoDetermineNoteFunding [int] ,      
  @NoteFundingRule [int] ,      
  @FundingPriority [int] ,      
  @NoteBalanceCap [decimal](28, 15) ,      
  @RepaymentPriority [int] ,      
  @CreatedBy [nvarchar](256),      
  @CreatedDate [datetime],      
  @UpdatedBy [nvarchar](256),      
  @UpdatedDate [datetime],      
  --Account table      
  @name varchar(256),      
 -- @PayFrequency [int],      
  @TotalCommitment [decimal](28, 15) ,      
  --@ExtendedMaturityScenario1 date ,       
 -- @InitialMaturityDate  [datetime], 
       
  @Priority [int],      
  @statusID int,      
  @NoteRule nvarchar(2000),      
  @AggregatedTotal [decimal](28,15),      
  @AdjustedTotalCommitment [decimal](28,15),      
  @RoundingNote int,      
  @StraightLineAmortOverride [decimal](28,15),      
  @UseRuletoDetermineAmortization int,      
  @OriginalTotalCommitment [decimal](28,15),  
  @WeightedSpread [decimal](28,15),
  @NetCapitalInvested [decimal](28,15),
  @newnoteId varchar(256) OUTPUT      
      
)       
AS      
BEGIN      
      
DECLARE @tNote TABLE (tNewNoteId UNIQUEIDENTIFIER)      
DECLARE @insertedAccountID uniqueidentifier;      
DECLARE @tAccount TABLE (tAccountID UNIQUEIDENTIFIER)      
Declare  @EventTypeMaturity  int  = 11;        
Declare @MaturityID UNIQUEIDENTIFIER;      
DECLARE @EFFDate date;      
DECLARE @accountID UNIQUEIDENTIFIER;      
         
                  
IF (@Priority=0)      
 SET @Priority = NULL      
      
IF(@NoteID='00000000-0000-0000-0000-000000000000')      
BEGIN      
      
      
INSERT INTO [Core].[Account]      
(       
  [StatusID]      
 ,[Name]        
 ,[ClientNoteID]       
 --,PayFrequency      
 ,AccountTypeID      
 ,[CreatedBy]      
 ,[CreatedDate]      
 ,[UpdatedBy]      
 ,[UpdatedDate]      
 ,Isdeleted      
)      
OUTPUT inserted.AccountID INTO @tAccount(tAccountID)      
VALUES      
(      
(case when (@statusID is not null and @statusID<>0) then @statusID else (Select LookupID from CORE.Lookup where Name = 'Active' and Parentid = 1) end),       
@name,      
@CRENoteID,      
--@PayFrequency,      
1,  --182,      
@CreatedBy,      
GETDATE(),      
@UpdatedBy,      
GetDATE(),0      
)      
      
      
   SELECT @insertedAccountID = tAccountID FROM @tAccount;      
 INSERT INTO [CRE].[Note]      
           (      
     [Account_AccountID]      
    ,[DealID]      
    ,[CRENoteID]      
    ,ClosingDate      
    ,[UseRuletoDetermineNoteFunding]      
    ,[NoteFundingRule]      
    ,[FundingPriority]      
    ,[NoteBalanceCap]      
    ,[RepaymentPriority]      
    ,[TotalCommitment]          
    --,ExtendedMaturityScenario1          
    ,[CreatedBy]      
    ,[CreatedDate]      
    ,[UpdatedBy]      
    ,[UpdatedDate]      
    ,[ClientNoteID]      
    ,[Priority]      
    ,[NoteRule]      
    ,[AggregatedTotal]      
    ,AdjustedTotalCommitment      
    ,OriginalTotalCommitment  
	,CommitmentUsedInFFDistribution
	--,WeightedSpread
	,NetCapitalInvested
          
   )      
      OUTPUT inserted.NoteID INTO @tNote(tNewNoteId)      
     VALUES      
  (      
  @insertedAccountID ,      
  @DealID ,      
  @CRENoteID ,        
  @ClosingDate,        
  @UseRuletoDetermineNoteFunding ,      
  @NoteFundingRule  ,      
  @FundingPriority  ,      
  @NoteBalanceCap  ,      
     @RepaymentPriority  ,       
  @TotalCommitment,         
  --@ExtendedMaturityScenario1,        
  @CreatedBy ,      
  GETDATE(),      
  @UpdatedBy ,      
  GETDATE(),      
  @CRENoteID,      
  @Priority,      
  @NoteRule,      
     @AggregatedTotal,      
  @AdjustedTotalCommitment,      
  @OriginalTotalCommitment ,
  @OriginalTotalCommitment,
  --@WeightedSpread,
  @NetCapitalInvested
)   

 ----WeightedSpread updating fromm usp_UpdateNoteCalculatedWeightedSpread  --Readonly    
       
--IF(@InitialMaturityDate is not null)      
-- BEGIN      
       
  --IF EXISTS(Select * from [CORE].Maturity mat INNER JOIN [CORE].[Event] eve ON mat.eventid = eve.eventid INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID where EventTypeID = @EventTypeMaturity and n.crenoteid = @CRENoteID)      
  --BEGIN      
        
      
      
  -- Select @MaturityID = mat.MaturityID      
  -- from [CORE].Maturity mat      
  -- INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId      
  -- INNER JOIN       
  --  (      
            
  --   Select       
  --    (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,      
  --    MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve      
  --    INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID      
  --    INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID      
  --    where EventTypeID = @EventTypeMaturity      
  --    and n.CRENoteID = @CRENoteID      
  --    GROUP BY n.Account_AccountID,EventTypeID      
      
  --  ) sEvent      
  -- ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID      
      
      
  -- Update [CORE].Maturity set SelectedMaturityDate = @InitialMaturityDate where MaturityID = @MaturityID      
      
  --END      
  --ELSE      
  --BEGIN      
  -- PRINT('New schedule for note id = '+ @CRENoteID)      
  -- Select @EFFDate = (CASE WHEN ClosingDate is null then GETDATE() ELSE ClosingDate end),@accountID = Account_AccountID from cre.note where crenoteid = @CRENoteID      
         
  -- --Insert into event table      
  -- INSERT INTO Core.[Event]([EffectiveStartDate],[AccountID],[Date],[EventTypeID],[EffectiveEndDate],[SingleEventValue],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])      
  -- Select @EFFDate,Account_AccountID,GETDATE(),@EventTypeMaturity,NULL,NULL,@CreatedBy,getdate(),@UpdatedBy,getdate()      
  -- from cre.note where crenoteid = @CRENoteID      
      
  -- --Insert into Maturity table      
  -- INSERT INTO core.Maturity (EventId, SelectedMaturityDate, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)      
  -- Select       
  -- (SELECT TOP 1 EventId FROM CORE.[event] e WHERE e.[EffectiveStartDate] = CONVERT(date, @EFFDate, 101) AND e.[EventTypeID] = @EventTypeMaturity AND e.AccountID = @accountID),      
  -- @InitialMaturityDate,      
  -- @CreatedBy,      
  -- GETDATE(),      
  -- @UpdatedBy,      
  -- GETDATE()      
        
  --END      
 --END       
      
      
  SELECT @newnoteId = tNewNoteId FROM @tNote;      
  --Log activity      
   EXEC dbo.usp_InsertActivityLog @DealID,283,@newnoteId,414,'Inserted',@UpdatedBy      
END      
ELSE      
BEGIN      
      
--Log activity      
       
 --log if status changes      
 IF EXISTS(select  1 FROM [Core].[Account] WHERE AccountID = @Account_AccountID and [StatusID] <> @statusID and  @statusID IS NOT NULL and @statusID<>0)      
 BEGIN      
    EXEC dbo.usp_InsertActivityLog @DealID,283,@NoteID,419,'Updated',@UpdatedBy      
 END      
 ELSE      
 BEGIN      
  DECLARE @SourceTable int, @countAll int;      
  Select @SourceTable = count(NoteID) FROM CRE.Note WHERE noteid = @NoteID      
      
 --Comparing both tables      
  SELECT @countAll = COUNT(CRENoteID) from      
  (      
  select  CRENoteID,      
    (select  [Name] FROM [Core].[Account] WHERE AccountID = @Account_AccountID) as Name,      
    ClientNoteID,          
    CONVERT(date, ClosingDate, 101) as ClosingDate,      
    TotalCommitment,      
    UseRuletoDetermineNoteFunding,      
    NoteFundingRule,      
    FundingPriority,      
    NoteBalanceCap,      
    RepaymentPriority,           
    --ExtendedMaturityScenario1,           
    [Priority],      
    AdjustedTotalCommitment,      
    AggregatedTotal,      
    OriginalTotalCommitment
	--WeightedSpread
	,NetCapitalInvested
     FROM CRE.Note      
     WHERE NoteID = @NoteID      
  UNION      
      
  select  @CRENoteID ,      
    @name as Name,      
    @CRENoteID ,          
    CONVERT(date, @ClosingDate, 101),      
    @TotalCommitment,      
    @UseRuletoDetermineNoteFunding ,      
    @NoteFundingRule  ,      
    @FundingPriority  ,      
    @NoteBalanceCap  ,      
    @RepaymentPriority  ,           
    --@ExtendedMaturityScenario1,           
    @Priority,      
    @AdjustedTotalCommitment,      
    @AggregatedTotal,      
    @OriginalTotalCommitment,
	--@WeightedSpread
	@NetCapitalInvested
  )a      
      
  IF(@SourceTable <> @countAll )      
   EXEC dbo.usp_InsertActivityLog @DealID,283,@NoteID,414,'Updated',@UpdatedBy      
      
 END      
      
UPDATE [Core].[Account]      
   SET [AccountTypeID] = 1  ---(Select LookupID from CORE.Lookup where name = 'Note')            
      ,[Name] = @name      
   ,[StatusID] = ISNULL(@statusID,1)      
      ,[UpdatedBy] = @UpdatedBy      
      ,[UpdatedDate] = GETDATE()      
   ,Isdeleted = 0      
 WHERE AccountID = @Account_AccountID      
      
UPDATE CRE.Note SET      
[CRENoteID]  =  @CRENoteID ,      
ClientNoteID= @CRENoteID ,          
ClosingDate =@ClosingDate,      
TotalCommitment =@TotalCommitment,      
[UseRuletoDetermineNoteFunding]  = @UseRuletoDetermineNoteFunding ,      
[NoteFundingRule]  =   @NoteFundingRule  ,      
[FundingPriority]  =   @FundingPriority  ,      
[NoteBalanceCap]  =   @NoteBalanceCap  ,      
[RepaymentPriority]  =   @RepaymentPriority  ,           
--ExtendedMaturityScenario1=   @ExtendedMaturityScenario1,           
[UpdatedBy]  =  @UpdatedBy ,      
[UpdatedDate]  =  GETDATE(),      
[Priority] = @Priority,      
[NoteRule]=@NoteRule,      
[AggregatedTotal] = @AggregatedTotal,      
[AdjustedTotalCommitment] = @AdjustedTotalCommitment,      
RoundingNote = @RoundingNote,      
StraightLineAmortOverride = @StraightLineAmortOverride,      
UseRuletoDetermineAmortization = @UseRuletoDetermineAmortization,      
OriginalTotalCommitment = @OriginalTotalCommitment,
--WeightedSpread = @WeightedSpread
NetCapitalInvested = @NetCapitalInvested

WHERE NoteID = @NoteID      
      
----Update
UPDATE CRE.Note SET CommitmentUsedInFFDistribution = (CASE WHEN CommitmentUsedInFFDistribution is null THEN OriginalTotalCommitment ELSE CommitmentUsedInFFDistribution END) WHERE NoteID = @NoteID

--UPDATE CRE.Note SET CommitmentUsedInFFDistribution = (CASE WHEN ISNULL(CommitmentUsedInFFDistribution,0) <> 0 THEN CommitmentUsedInFFDistribution ELSE OriginalTotalCommitment END) 
--WHERE NoteID = @NoteID														
      
      
--IF(@InitialMaturityDate is not null)      
-- BEGIN      
         
       
--  IF EXISTS(Select * from [CORE].Maturity mat INNER JOIN [CORE].[Event] eve ON mat.eventid = eve.eventid INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID where EventTypeID = @EventTypeMaturity and n.crenoteid = @CRENoteID)      
--  BEGIN      
        
      
--   Select @MaturityID = mat.MaturityID      
--   from [CORE].Maturity mat      
--   INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId      
--   INNER JOIN       
--    (      
            
--     Select       
--      (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,      
--      MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve      
--      INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID      
--      INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID      
--      where EventTypeID = @EventTypeMaturity      
--      and n.CRENoteID = @CRENoteID      
--      GROUP BY n.Account_AccountID,EventTypeID      
      
--    ) sEvent      
--   ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID      
      
      
--   Update [CORE].Maturity set SelectedMaturityDate = @InitialMaturityDate where MaturityID = @MaturityID      
      
--  END      
--  ELSE      
--  BEGIN      
--   PRINT('New schedule for note id = '+ @CRENoteID)      
      
--   Select @EFFDate = (CASE WHEN ClosingDate is null then GETDATE() ELSE ClosingDate end),@accountID = Account_AccountID from cre.note where crenoteid = @CRENoteID      
         
--   --Insert into event table      
--   INSERT INTO Core.[Event]([EffectiveStartDate],[AccountID],[Date],[EventTypeID],[EffectiveEndDate],[SingleEventValue],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])      
--   Select @EFFDate,Account_AccountID,GETDATE(),@EventTypeMaturity,NULL,NULL,@CreatedBy,getdate(),@UpdatedBy,getdate()      
--   from cre.note where crenoteid = @CRENoteID      
      
--   --Insert into Maturity table      
--   INSERT INTO core.Maturity (EventId, SelectedMaturityDate, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)      
--   Select       
--   (SELECT TOP 1 EventId FROM CORE.[event] e WHERE e.[EffectiveStartDate] = CONVERT(date, @EFFDate, 101) AND e.[EventTypeID] = @EventTypeMaturity AND e.AccountID = @accountID),      
--   @InitialMaturityDate,      
--   @CreatedBy,      
--   GETDATE(),      
--   @UpdatedBy,      
--   GETDATE()      
        
--  END      
-- END       
      
      
 SELECT @newnoteId = @NoteID      
      
END      
      
      
      
      
END  
  