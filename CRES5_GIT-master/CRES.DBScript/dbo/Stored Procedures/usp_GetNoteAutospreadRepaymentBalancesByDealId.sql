--[dbo].[usp_GetNoteAutospreadRepaymentBalancesByDealId] 'adefd066-82db-445b-991f-4f72126fd3e6'  
CREATE PROCEDURE [dbo].[usp_GetNoteAutospreadRepaymentBalancesByDealId]  
 @DealID UNIQUEIDENTIFIER  
AS  
  
BEGIN  
SET NOCOUNT ON;  
  
Declare @AnalysisID UNIQUEIDENTIFIER;  
SET @AnalysisID = (Select AnalysisID from core.analysis where name = 'Default')  
  
Select n.noteid as NoteID,tr.Date,[Type],tr.Amount as Amount  
from cre.TransactionEntry tr  
--inner join cre.note n on n.noteid = tr.noteid  
Inner join core.account acc on acc.accountid = tr.AccountID     
Inner join cre.note n on n.account_accountid = acc.accountid  
inner join cre.deal d on d.dealid = n.dealid  
where tr.AnalysisID =@AnalysisID  and acc.accounttypeid = 1
and [type] in ('PIKPrincipalFunding','PIKPrincipalPaid','ScheduledPrincipalPaid')  
and d.dealid = @DealID  
  
END
