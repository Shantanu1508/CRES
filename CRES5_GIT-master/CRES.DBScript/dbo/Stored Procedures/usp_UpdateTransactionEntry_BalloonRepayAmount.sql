
---[CRE].[usp_UpdateTransactionEntry_BalloonRepayAmount] 'ef34a011-05c6-43f3-8b07-74688659b54a','C10F3372-0FC2-4861-A9F5-148F1F80804F'

CREATE Procedure [CRE].[usp_UpdateTransactionEntry_BalloonRepayAmount] 
 @NoteID uniqueidentifier,  
 @AnalysisID uniqueidentifier  
AS  
BEGIN  
 SET NOCOUNT ON;  
 
 
Declare @AccountID UNIQUEIDENTIFIER;
Declare @BalloonRepayAmount Decimal(28,15);

SET @AccountID = (Select Account_Accountid from cre.note where noteid = @NoteID )

IF EXISTS(Select accountid from core.CalculationRequests where accountid = @AccountID and analysisid = @AnalysisID and CalcEngineType = 798 ) ---V1 calc
BEGIN

	Select @BalloonRepayAmount = SUM(fs.Value) 
	from [CORE].FundingSchedule fs
	INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
	INNER JOIN (						
		Select 
			(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
			MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
			from [CORE].[Event] eve
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
			where EventTypeID = 10
			and n.NoteID = @NoteId  and acc.IsDeleted = 0
			and eve.StatusID = 1
			GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
	) sEvent
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID

	left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
	left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
	left JOIN [CORE].[Lookup] LAdjustmentType ON LAdjustmentType.LookupID = fs.AdjustmentType 
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
	and fs.value < 0
	and fs.date = n.ActualPayOffDate
	and purposeid not in (351,840)   ----Principal Writeoff, Amortization


	Update cre.TransactionEntry SET BalloonRepayAmount = ABS(@BalloonRepayAmount)  where accountid = @AccountID and analysisid = @AnalysisID and [type] ='Balloon'

END



END
GO

