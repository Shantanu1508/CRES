

CREATE PROCEDURE [dbo].[usp_InsertIntoLogTables] --'Deal','D2D46DF8-351C-4937-BDC6-8A3CBD56720A'
@ObjectType nvarchar(256),
@ObjectID UNIQUEIDENTIFIER

AS
BEGIN

DECLARE @SaveFundingSequenceChanges int = (SELECT max([Value]) FROM App.AppConfig WHERE [Key]='AllowDealFundingLog')
IF(@SaveFundingSequenceChanges = 1)
BEGIN
	IF(@ObjectType='DealFunding')
	BEGIN
		INSERT INTO CRE.DealFundingLog (
				DealFundingID,
				DealID ,
				[Date],
				Amount,
				Comment ,
				PurposeID ,
				Applied ,
				DrawFundingId,
				DealFundingRowno  ,
				EquityAmount,
				RemainingFFCommitment,
				RemainingEquityCommitment,
				SubPurposeType,
				CreatedBy,     
				CreatedDate,    
				UpdatedBy,      
				UpdatedDate ,
				LogDate)

		SELECT
				 DealFundingID,
				 DealID,    
				 [Date],
				 Amount,	 
				 Comment,
				 PurposeID,
				 Applied,
				 DrawFundingId,
				 DealFundingRowno,
				 EquityAmount,
				 RemainingFFCommitment,
				 RemainingEquityCommitment,
				 SubPurposeType,
				 CreatedBy,
				 CreatedDate,
				 UpdatedBy,
				 UpdatedDate,
				 getdate()
		FROM CRE.DealFunding  WHERE DealID = @ObjectID
	END

	IF(@ObjectType='FundingRepaymentSequence')
	BEGIN
		INSERT INTO [CRE].[FundingRepaymentSequenceLog]
			   ([FundingRepaymentSequenceID]
			   ,[NoteID]
			   ,[SequenceNo]
			   ,[SequenceType]
			   ,[Value]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate]
			   ,LogDate)
		Select
			    FundingRepaymentSequenceID
			   ,NoteID 
			   ,SequenceNo
			   ,SequenceType 
			   ,[Value] 
			   ,CreatedBy
			   ,CreatedDate
			   ,UpdatedBy
			   ,UpdatedDate
			   ,getdate()
		FROM  [CRE].[FundingRepaymentSequence]  WHERE NoteID IN (SELECT NoteID FROM CRE.Note WHERE DealID = @ObjectID)
	END


	IF(@ObjectType='FundingSchedule')
	BEGIN
		 INSERT INTO [CORE].[FundingScheduleLog] (
		    LogDate,
			EffectiveDate,
			NoteID,
			FundingScheduleID,
			EventId,
			[Date],
			[Value],
			CreatedBy,
			CreatedDate,
			UpdatedBy,
			UpdatedDate,
			PurposeID,
			Applied,
			DrawFundingId,
			Comments,
			Issaved,
			DealFundingRowno,
			DealFundingID,
			WF_CurrentStatus
			)

		SELECT 
			getdate(),
			e.EffectiveStartDate,
			n.noteid,
			fs.FundingScheduleID,
			fs.EventId,
			fs.[Date],
			fs.[Value],
			fs.CreatedBy,
			fs.CreatedDate,
			fs.UpdatedBy,
			fs.UpdatedDate,
			fs.PurposeID,
			fs.Applied,
			fs.DrawFundingId,
			fs.Comments,
			fs.Issaved,
			fs.DealFundingRowno,
			fs.DealFundingID,
			fs.WF_CurrentStatus
			
		from [CORE].FundingSchedule fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
		INNER JOIN 
		(
				Select 
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
					from [CORE].[Event] eve
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
					where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
					and n.Dealid = @ObjectID 
					and acc.IsDeleted = 0
					and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
					GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
			        ) sEvent

				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
				left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
				left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
				where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
				order by n.noteid
	END
	

END

END

