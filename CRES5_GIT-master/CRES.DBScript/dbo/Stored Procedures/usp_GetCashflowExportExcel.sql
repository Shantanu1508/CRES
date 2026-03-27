CREATE Procedure [dbo].[usp_GetCashflowExportExcel]
(
 @AccountId uniqueidentifier,
 @AnalysisId uniqueidentifier
)
as 
BEGIN
	SET NOCOUNT ON;

	select
	 ac.Name  as AccountName
	,tr.[Date] as Transaction_Date
	,tr.Amount as Transaction_Amount
	,tr.[Type] as Transaction_Type
	,tr.EndingBalance as Ending_Balance
	from cre.TransactionEntry tr
	inner join core.account acc on acc.AccountID = tr.AccountID
	left join core.Account ac on ac.AccountID=tr.AccountId
	where acc.isdeleted <> 1
	and tr.AnalysisID = @AnalysisID
	and tr.ParentAccountId = @AccountId
	Order by ac.Name,tr.date

END