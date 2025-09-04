
CREATE PROCEDURE [dbo].[usp_DeleteLiabilityData_ForOneTimeUpload] 
(
	@AccountID UNIQUEIDENTIFIER,
	@Type nvarchar(256)
)
AS
BEGIN

	declare @tblEventid as table(
		eventid uniqueidentIfier
	)


	--IF(@Type = 'Equity')
	--BEGIN
	--	Delete from @tblEventid

	--	INSERT INTO @tblEventid(eventid)
	--	Select eventid from(			
	--		Select eventid from [Core].[Event] where eventtypeid in (Select LookupID from core.lookup where parentid = 3 and [Name]='GeneralSetupDetailsEquity')	and AccountID = @AccountID
	--	)a

	--	Delete from [Core].[GeneralSetupDetailsEquity] where eventid in (Select eventid from @tblEventid)
	--	Delete from [Core].[Event] where eventtypeid in (Select LookupID from core.lookup where parentid = 3 and [Name]='GeneralSetupDetailsEquity') 
	--	and eventid in (Select eventid from @tblEventid)

	--	--Delete from cre.liabilityfundingscheduleAggregate where accountid = @AccountID
	--	--Delete from cre.liabilityfundingscheduleAggregate where accountid in (Select PortfolioAccountID from cre.Equity where AccountID = @AccountID)

	--END

	--IF(@Type = 'Debt')
	--BEGIN
	--	Delete from @tblEventid

	--	INSERT INTO @tblEventid(eventid)
	--	Select eventid from(			
	--		Select eventid from [Core].[Event] where eventtypeid in (Select LookupID from core.lookup where parentid = 3 and [Name]='GeneralSetupDetailsDebt')	and AccountID = @AccountID
	--	)a

	--	Delete from [Core].[GeneralSetupDetailsDebt] where eventid in (Select eventid from @tblEventid)
	--	Delete from [Core].[Event] where eventtypeid in (Select LookupID from core.lookup where parentid = 3 and [Name]='GeneralSetupDetailsDebt') 
	--	and eventid in (Select eventid from @tblEventid)

	--	--Delete from cre.liabilityfundingscheduleAggregate where accountid = @AccountID
	--	--Delete from cre.liabilityfundingscheduleAggregate where accountid in (Select PortfolioAccountID from cre.Debt where AccountID = @AccountID)

	--END


	IF(@Type = 'LiabilityNote')
	BEGIN
		Declare @AbbreviationName nvarchar(256);
		SET @AbbreviationName = (Select Replace(AbbreviationName,' ','') from cre.Equity where AccountID = @AccountID)


		declare @tblLiabilityNoteAccountID as table(
			LiabilityNoteAccountID uniqueidentIfier
		)

		INSERT INTO @tblLiabilityNoteAccountID(LiabilityNoteAccountID)
		Select AccountID from cre.liabilityNote where LiabilityNoteID like '%[_]'+@AbbreviationName+'[_]%'


		Delete from @tblEventid

		INSERT INTO @tblEventid(eventid)
		Select eventid from(			
			Select eventid from [Core].[Event] where eventtypeid in (841,909,908,914) and AccountID in (Select LiabilityNoteAccountID from @tblLiabilityNoteAccountID)
		)a

		Delete from [Core].[GeneralSetupDetailsLiabilityNote] where eventid in (Select eventid from @tblEventid)
		Delete from [Core].RateSpreadScheduleLiability where eventid in (Select eventid from @tblEventid)
		Delete from [Core].PrepayAndAdditionalFeeScheduleLiability where eventid in (Select eventid from @tblEventid)
		Delete from [Core].[InterestExpenseSchedule] where eventid in (Select eventid from @tblEventid)

		Delete from [Core].[Event] where eventtypeid in (841,909,908,914) and eventid in (Select eventid from @tblEventid)

		Delete from cre.LiabilityNoteAssetMapping where LiabilityNoteAccountId in (Select LiabilityNoteAccountID from @tblLiabilityNoteAccountID)
		
		
		Delete from CRE.TransactionEntry where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and  ParentAccountId = @AccountID
		Delete from CRE.TransactionEntryLiability where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and  ParentAccountId = @AccountID

		Delete from cre.liabilitynote where AccountId in (Select LiabilityNoteAccountID from @tblLiabilityNoteAccountID)
		Delete from cre.liabilityfundingschedule where LiabilityNoteAccountID in (Select LiabilityNoteAccountID from @tblLiabilityNoteAccountID)

		Delete from CORE.Account where AccountId in (Select LiabilityNoteAccountID from @tblLiabilityNoteAccountID) and ISNULL(accounttypeid,99) not in (1,10,183)
	END

END
