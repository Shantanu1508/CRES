
CREATE PROCEDURE [dbo].[usp_GetAutospreadRepaymentBalances] --'5B7E557E-05FC-485F-B5B8-3D83D23B741B'
	@DealID UNIQUEIDENTIFIER
AS

BEGIN
SET NOCOUNT ON;

Declare @AnalysisID UNIQUEIDENTIFIER;
SET @AnalysisID = (Select AnalysisID from core.analysis where name = 'Default')

Select d.dealid as DealID,tr.Date,[Type],SUM(tr.Amount) as Amount
from cre.TransactionEntry tr
Inner Join core.account acc on acc.accountid = tr.accountid
inner join cre.note n on n.account_accountid = acc.AccountID
--inner join cre.note n on n.noteid = tr.noteid
inner join cre.deal d on d.dealid = n.dealid
where tr.AnalysisID =@AnalysisID and acc.AccounttypeID = 1
and [type] in ('PIKPrincipalFunding','PIKPrincipalPaid','ScheduledPrincipalPaid')
and d.dealid = @DealID
group by d.dealid,tr.Date,[Type] 

END
