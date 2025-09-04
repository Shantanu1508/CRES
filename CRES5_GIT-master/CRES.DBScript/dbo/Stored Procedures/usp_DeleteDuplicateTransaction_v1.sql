
CREATE Procedure [dbo].[usp_DeleteDuplicateTransaction_v1]
	@NoteID uniqueidentifier,
	@AnalysisID uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;
	
	Declare @l_Accountid uniqueidentifier = (Select Account_accountid from cre.note where noteid = @NoteID)


	delete from cre.transactionentry  where transactionentryid in (
		select transactionentryid
		from(
			select analysisid,transactionentryid,noteid,[type],date, amount ,
			row_number() over(partition by analysisid,n.noteid,[type],date order by analysisid,noteid,[type],date) rno
			from cre.transactionentry tr
			Inner JOin core.account acc on acc.accountID = tr.AccountID
			Inner JOin cre.note n on n.Account_Accountid = acc.AccountID
			where tr.Accountid = @l_Accountid  --noteid = @NoteID 
			and analysisid =@AnalysisID
			and [type] in ('LIBORPercentage','SpreadPercentage','RawIndexPercentage','RawPIKIndexPercentage')
			--order by analysisid,noteid,[type],date
		)a
		where rno > 1
	)

END





