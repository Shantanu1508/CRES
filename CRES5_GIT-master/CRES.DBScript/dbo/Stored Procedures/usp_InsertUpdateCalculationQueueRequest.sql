
CREATE PROCEDURE [dbo].[usp_InsertUpdateCalculationQueueRequest]
@RequestID nvarchar(256),
@TransactionOutput int,
@NotePeriodicOutput int,
@StrippingOutput int,
@Prepaypremium_Output int,
@Prepayallocations_Output int,
@DailyInterestAccOutput int,
@IsRetry int,
@CreatedBy NVARCHAR (256)
AS
BEGIN
    SET NOCOUNT ON;

Declare @TrRetriesCount int;
Declare @NPCRetriesCount  int;
Declare @StrippRetriesCount  int;
Declare @PrepaypremiumRetriesCount  int;
Declare @PrepayallocationRetriesCount  int;
Declare @DailyInterestRetriesCount int;

Select @TrRetriesCount = TrRetriesCount
,@NPCRetriesCount = NPCRetriesCount
,@StrippRetriesCount = StrippRetriesCount 
,@PrepaypremiumRetriesCount = PrepaypremiumRetriesCount
,@PrepayallocationRetriesCount = PrepayallocationRetriesCount
,@DailyInterestRetriesCount = DailyInterestRetriesCount
from Core.CalculationQueueRequest Where [RequestID] = @RequestID




IF EXISTS(Select RequestID from Core.CalculationQueueRequest where RequestID = @RequestID)
BEGIN
	IF(@TransactionOutput IS NOT NULL)
	BEGIN
		


		Update Core.CalculationQueueRequest set [TransactionOutput] = @TransactionOutput,[UpdatedBy] = 'tr_'+Cast(@TransactionOutput as nvarchar(256)),[UpdatedDate] = getdate()	Where [RequestID] = @RequestID
		and [TransactionOutput] <> 266

		IF(@TransactionOutput = 265)
		BEGIN
			IF(@IsRetry = -1)
			BEGIN
				--Stop retry ex. in case of data issue				
				Update Core.CalculationQueueRequest set TrRetriesCount = 10,[UpdatedBy] = @CreatedBy,[UpdatedDate] = getdate() 
				Where [RequestID] = @RequestID  and TransactionOutput = 265

			END 
			ELSE IF(@TrRetriesCount < 3)			
			BEGIN
				Update Core.CalculationQueueRequest set [TransactionOutput] = 292,[UpdatedBy] = @CreatedBy,[UpdatedDate] = getdate(),TrRetriesCount = @TrRetriesCount + 1	
				Where [RequestID] = @RequestID  and TransactionOutput = 265
			END
		END

	END
	IF(@NotePeriodicOutput IS NOT NULL)
	BEGIN
		
		Update Core.CalculationQueueRequest set NotePeriodicOutput = @NotePeriodicOutput,[UpdatedBy] = 'NPC_'+Cast(ISNULL(@NotePeriodicOutput,123) as nvarchar(256)),[UpdatedDate] = getdate()	Where [RequestID] = @RequestID
		and NotePeriodicOutput <> 266



		IF(@NotePeriodicOutput = 265)
		BEGIN
			IF(@IsRetry = -1)
			BEGIN
				--Stop retry ex. in case of data issue				
				Update Core.CalculationQueueRequest set NPCRetriesCount = 10,[UpdatedBy] = @CreatedBy,[UpdatedDate] = getdate() 
				Where [RequestID] = @RequestID  and NotePeriodicOutput = 265

			END 
			ELSE IF(@NPCRetriesCount < 3 )			
			BEGIN
				Update Core.CalculationQueueRequest set NotePeriodicOutput = 292,[UpdatedBy] = @CreatedBy,[UpdatedDate] = getdate(),NPCRetriesCount = @NPCRetriesCount + 1	
				Where [RequestID] = @RequestID and NotePeriodicOutput = 265
			END
		END

	END


	IF(@StrippingOutput IS NOT NULL)
	BEGIN
		Update Core.CalculationQueueRequest set StrippingOutput = @StrippingOutput,[UpdatedBy] = @CreatedBy,[UpdatedDate] = getdate()	Where [RequestID] = @RequestID
		and StrippingOutput <> 266


		IF(@StrippingOutput = 265)
		BEGIN
			IF(@IsRetry = -1)
			BEGIN
				--Stop retry ex. in case of data issue				
				Update Core.CalculationQueueRequest set StrippRetriesCount = 10,[UpdatedBy] = @CreatedBy,[UpdatedDate] = getdate() 
				Where [RequestID] = @RequestID  and StrippingOutput = 265

			END 
			ELSE IF(@StrippRetriesCount < 3 )			
			BEGIN
				Update Core.CalculationQueueRequest set StrippingOutput = 292,[UpdatedBy] = @CreatedBy,[UpdatedDate] = getdate(),StrippRetriesCount = StrippRetriesCount + 1	
				Where [RequestID] = @RequestID and StrippingOutput = 265
			END
		END

	END
	 
	
	IF(@Prepaypremium_Output IS NOT NULL)
	BEGIN
		Update Core.CalculationQueueRequest set Prepaypremium_Output = @Prepaypremium_Output,[UpdatedBy] = @CreatedBy,[UpdatedDate] = getdate()	Where [RequestID] = @RequestID
		and Prepaypremium_Output <> 266

		IF(@Prepaypremium_Output = 265)
		BEGIN
			IF(@IsRetry = -1)
			BEGIN
				--Stop retry ex. in case of data issue				
				Update Core.CalculationQueueRequest set PrepaypremiumRetriesCount = 10,[UpdatedBy] = @CreatedBy,[UpdatedDate] = getdate() 
				Where [RequestID] = @RequestID  and Prepaypremium_Output = 265

			END 
			ELSE IF(@PrepaypremiumRetriesCount < 3 )
			BEGIN
				Update Core.CalculationQueueRequest set Prepaypremium_Output = 292,[UpdatedBy] = @CreatedBy,[UpdatedDate] = getdate(),PrepaypremiumRetriesCount = PrepaypremiumRetriesCount + 1	
				Where [RequestID] = @RequestID and Prepaypremium_Output = 265
			END
		END

	END



	IF(@Prepayallocations_Output IS NOT NULL)
	BEGIN
		Update Core.CalculationQueueRequest set Prepayallocations_Output = @Prepayallocations_Output,[UpdatedBy] = @CreatedBy,[UpdatedDate] = getdate()	Where [RequestID] = @RequestID
		and Prepayallocations_Output <> 266


		IF(@Prepayallocations_Output = 265)
		BEGIN
			IF(@IsRetry = -1)
			BEGIN
				--Stop retry ex. in case of data issue				
				Update Core.CalculationQueueRequest set PrepayallocationRetriesCount = 10,[UpdatedBy] = @CreatedBy,[UpdatedDate] = getdate() 
				Where [RequestID] = @RequestID  and Prepayallocations_Output = 265

			END 
			ELSE IF(@PrepayallocationRetriesCount < 3 or @IsRetry <> -1)
			BEGIN
				Update Core.CalculationQueueRequest set Prepayallocations_Output = 292,[UpdatedBy] = @CreatedBy,[UpdatedDate] = getdate(),PrepayallocationRetriesCount = PrepayallocationRetriesCount + 1	
				Where [RequestID] = @RequestID  and Prepayallocations_Output = 265
			END
		END

	END

	IF(@DailyInterestAccOutput IS NOT NULL)
	BEGIN
		
		Update Core.CalculationQueueRequest set DailyInterestAccOutput = @DailyInterestAccOutput,[UpdatedBy] = 'di_'+Cast(@DailyInterestAccOutput as nvarchar(256)),[UpdatedDate] = getdate()	Where [RequestID] = @RequestID
		and DailyInterestAccOutput <> 266

		IF(@DailyInterestAccOutput = 265)
		BEGIN
			IF(@IsRetry = -1)
			BEGIN
				--Stop retry ex. in case of data issue				
				Update Core.CalculationQueueRequest set DailyInterestRetriesCount = 10,[UpdatedBy] = @CreatedBy,[UpdatedDate] = getdate() 
				Where [RequestID] = @RequestID  and DailyInterestAccOutput = 265

			END 
			ELSE IF(@DailyInterestRetriesCount < 3  )
			BEGIN
				Update Core.CalculationQueueRequest set DailyInterestAccOutput = 292,[UpdatedBy] = @CreatedBy,[UpdatedDate] = getdate(),DailyInterestRetriesCount = @DailyInterestRetriesCount + 1	
				Where [RequestID] = @RequestID  and DailyInterestAccOutput = 265
			END
		END

	END

END
ELSE
BEGIN
	INSERT INTO [Core].[CalculationQueueRequest]
	([RequestID]
	,[TransactionOutput]
	,[NotePeriodicOutput]
	,[StrippingOutput]
	,Prepaypremium_Output
	,Prepayallocations_Output	
	,DailyInterestAccOutput
	,[TrRetriesCount]
	,[NPCRetriesCount]
	,[StrippRetriesCount]
	,PrepaypremiumRetriesCount
	,PrepayallocationRetriesCount
	,DailyInterestRetriesCount
	,[CreatedBy]
	,[CreatedDate]
	,[UpdatedBy]
	,[UpdatedDate])
	VALUES(
	@RequestID
	,@TransactionOutput
	,@NotePeriodicOutput
	,@StrippingOutput
	,@Prepaypremium_Output
	,@Prepayallocations_Output
	,@DailyInterestAccOutput
	,0,0,0,0,0,0
	,@CreatedBy,getdate(),@CreatedBy,getdate())
END





---update completed sttaus
IF EXISTS(Select RequestID from Core.CalculationQueueRequest where RequestID = @RequestID and TransactionOutput = 266 and NotePeriodicOutput = 266 and 	StrippingOutput = 266 )
BEGIN
	----Completed      
	Update Core.CalculationRequests SET [StatusID] = 266,EndTime =getdate()  where RequestID = @RequestID 
END


IF EXISTS(Select RequestID from Core.CalculationQueueRequest where RequestID = @RequestID and Prepaypremium_Output = 266 )
BEGIN
	----Completed      
	Update Core.CalculationRequests SET [StatusID] = 266,EndTime =getdate()  where RequestID = @RequestID 
END



END
