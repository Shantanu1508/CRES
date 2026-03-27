
CREATE Procedure [dbo].[usp_UpdateTransactionEntryBalloonRepayAmountForEnableM61CalcN]
	@dealid UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;


Update cre.transactionentry set cre.transactionentry.BalloonRepayAmount = (a.BalloonRepayAmount * -1)
From(

	Select tr.TransactionEntryID,tr.AccountId,fs.Value  as BalloonRepayAmount 
	from cre.transactionentry tr
	Inner join cre.note n on n.Account_AccountID = tr.AccountId
	Inner Join(
		Select n.Account_AccountID,SUM(fs.[value]) as [Value]
		from [CORE].FundingSchedule fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
		INNER JOIN (						
			Select 
				(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
				MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
				from [CORE].[Event] eve
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
				where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
				and n.dealid = @dealid
				and acc.IsDeleted = 0
				and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
				GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
		) sEvent
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
		left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
		left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
		left JOIN [CORE].[Lookup] LAdjustmentType ON LAdjustmentType.LookupID = fs.AdjustmentType 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID

		where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
		and fs.date = n.ActualPayoffdate
		and n.dealid = @dealid
		and n.EnableM61Calculations = 4
		and fs.PurposeID <> 351
		group by n.Account_AccountID

	)fs on fs.Account_AccountID = tr.AccountId
	where analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	and [type] = 'Balloon'
	and n.EnableM61Calculations = 4
	and n.dealid = @dealid

)a
where cre.transactionentry.TransactionEntryID = a.TransactionEntryID

END