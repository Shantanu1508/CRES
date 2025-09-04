---[CRE].[usp_UpdateTransactionEntryDecode]  '0E8B30CE-4B90-4D39-BC74-AB82C0FF94E1','C10F3372-0FC2-4861-A9F5-148F1F80804F'

CREATE Procedure [CRE].[usp_UpdateTransactionEntryDecode] 
 @NoteID uniqueidentifier,  
 @AnalysisID uniqueidentifier  
AS  
BEGIN  
 SET NOCOUNT ON;  
   
  
 Update cre.transactionentry set  cre.transactionentry.DecodeName = z.DecodeName
 From(  
	select te.TransactionEntryID,te.analysisid,n.NOteID,a.DecodeName
	FROM cre.transactionentry  te  
	Inner join core.account acc on acc.accountid = te.AccountID
	Inner join cre.note n on n.account_accountid = acc.accountid
	Left Join(
		Select TransactionName,DecodeName,FeeType from  [CRE].[TransactionTypesDecodeMapping] where TransactionName is not NULL
		and FeeType is not null
	)a on te.[Type] = a.TransactionName and te.FeeTypeName = a.FeeType	
	where te.analysisid = @AnalysisID and n.noteid = @NoteID  
	and acc.AccounttypeID = 1 and a.DecodeName is not null


	UNION ALL

	select te.TransactionEntryID,te.analysisid,n.NOteID,a.DecodeName
	FROM cre.transactionentry  te  
	Inner join core.account acc on acc.accountid = te.AccountID
	Inner join cre.note n on n.account_accountid = acc.accountid
	Inner Join(
		Select TransactionName,DecodeName,FeeType from  [CRE].[TransactionTypesDecodeMapping] where TransactionName is not NULL
		and FeeType is null
	)a on te.[Type] = a.TransactionName 	
	where te.analysisid = @AnalysisID and n.noteid = @NoteID  
	and acc.AccounttypeID = 1 

 )z 
 where  cre.transactionentry.transactionentryID = z.transactionentryID  
  

END  
  