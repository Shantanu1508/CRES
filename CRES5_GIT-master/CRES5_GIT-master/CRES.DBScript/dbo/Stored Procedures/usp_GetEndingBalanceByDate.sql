CREATE PROCEDURE [dbo].[usp_GetEndingBalanceByDate]
	@DealID UNIQUEIDENTIFIER,
	@BalanceAsofDate datetime
AS

BEGIN
SET NOCOUNT ON;

Declare @AnalysisID UNIQUEIDENTIFIER;
SET @AnalysisID = (Select AnalysisID from core.analysis where name = 'Default')


		select SUM(di.EndingBalance ) as EndingBalance
		from [CRE].[DailyInterestAccruals] di
		Inner join cre.note n on n.noteid = di.noteid
		Inner join core.account acc on acc.accountid = n.account_accountid
		Inner join cre.deal d on d.dealid = n.dealid
		where di.AnalysisID= @AnalysisID
		and acc.isdeleted <> 1
		and d.dealid = @DealID
		and di.date = @BalanceAsofDate 

END
