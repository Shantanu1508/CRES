
CREATE PROCEDURE [dbo].[usp_DeleteTransactionForEnableM61CalculationsByNoteID]   
(  
 @NoteId UNIQUEIDENTIFIER  
)  
AS  
BEGIN  
  
	IF EXISTS(Select noteid from cre.note where  EnableM61Calculations = 4 and noteid = @NoteId)
	BEGIN

		Delete From Core.CalculationRequests where noteid in (
			Select noteid from cre.note where  EnableM61Calculations = 4 and noteid = @NoteId
		)	

		Delete From cre.transactionentry where noteid in (
			Select Distinct tr.noteid
			from cre.transactionentry tr
			where analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and tr.GeneratedBy <> 'M61AddInManualCashflows'
			and tr.noteid  in (
				Select n.noteid from cre.note n
				inner join core.account acc on acc.accountid = n.account_accountid
				where EnableM61Calculations = 4 and acc.isdeleted <> 1
				and n.noteid  = @NoteId	
			)
		)





	END



END  
  
  
  
