-- Procedure

CREATE PROCEDURE [dbo].[usp_GetPikPaidTransactionByCREnoteID]  --'9920' 
(
  @crenoteid nvarchar(50) 
)
AS
BEGIN
 
 DECLARE  @noteid VARCHAR(50);
	set @noteid =(select noteid from cre.note n join Core.Account ac on ac.AccountID=n.Account_AccountID
				where ac.Isdeleted=0 and crenoteid = @crenoteid)

	  select  @noteid as NoteID ,sum( CalculatedAmount) as Amount,'Actual' as Tabletype 
	  from cre.NoteTransactionDetail 
	 where  TransactionType  in ( select TransactionTypesID  from cre.transactiontypes where TransactionName ='PIKPrincipalPaid') 
	 and noteid  =@noteid
	 and RelatedtoModeledPMTDate <= Cast(getdate() as date)

 union all

	 select  @noteid as NoteID,sum( Amount)*-1 as Amount  ,'CashFlow'  as Tabletype 
	 from  cre.transactionentry 
	 where noteid  =@noteid
	 and [Date] <= Cast(getdate() as date)
	 and AnalysisID in (  select AnalysisID from core.analysis where [name] ='Default')
	 and type ='PIKPrincipalFunding'  
END 
