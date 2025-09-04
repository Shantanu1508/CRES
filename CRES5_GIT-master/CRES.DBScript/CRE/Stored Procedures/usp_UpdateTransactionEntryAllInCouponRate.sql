CREATE Procedure [CRE].[usp_UpdateTransactionEntryAllInCouponRate]  
 @NoteID uniqueidentifier,  
 @AnalysisID uniqueidentifier  
AS  
BEGIN  
 SET NOCOUNT ON;  
   
  
 Update cre.transactionentry set  cre.transactionentry.AllInCouponRate = a.AllInCouponRate  
 From(  
	select te.TransactionEntryID,te.analysisid,n.NOteID,te.date ,tblNC.allincouponrate
	FROM cre.transactionentry  te  
	 Inner join core.account acc on acc.accountid = te.AccountID
     Inner join cre.note n on n.account_accountid = acc.accountid

	--inner join Cre.Note n on n.NoteID=te.NoteID   
	left join cre.transactiontypes tym on LOWER(tym.TransactionName) = LOWER(te.Type)  
	Left Join(
		select nc.AccountID,nc.analysisid,nc.periodenddate,nc.allincouponrate 
		from cre.NotePeriodicCalc nc
		Inner join core.account acc on acc.accountid = nc.AccountID
		Inner join cre.note n on n.account_accountid = acc.accountid  
		--inner join cre.note n on n.noteid = nc.noteid
		--inner join core.account acc on acc.accountid = n.account_accountid
		where acc.isdeleted <> 1 and acc.AccounttypeID = 1
		and nc.analysisID = @AnalysisID
		and nc.[month] is not null
		and n.noteid = @NoteID
	)tblNC on tblNC.AccountID = n.noteid and tblNC.analysisid = te.analysisid and EOMONTH(te.date) = tblNC.periodenddate

	where te.analysisid = @AnalysisID and n.noteid = @NoteID  
	and te.[type] = 'InterestPaid'
	 and acc.AccounttypeID = 1
 )a  
 where  cre.transactionentry.transactionentryID = a.transactionentryID  
  

END  
  