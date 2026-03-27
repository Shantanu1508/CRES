CREATE Procedure [dbo].[usp_GetLiabilityCashflowExportData]    
(    
 @AccountId uniqueidentifier,    
 @AnalysisId uniqueidentifier,    
 @Type nvarchar(256)    
)    
as     
BEGIN    
 SET NOCOUNT ON;    
    
 IF(@Type ='Equity')    
 BEGIN    
 select    
 ac.Name  as Liability_Type    
 ,tr.[Date] as Transaction_Date    
 ,tr.Amount as Transaction_Amount    
 ,tr.[Type] as Transaction_Type    
 ,tr.EndingBalance as Ending_Balance    
 ,(CASE WHEN tr.[Type] = 'InterestPaid' THEN ISNULL(d.DealName,'Unallocated Interest') ELSE null END) as Deal_Name
 from cre.TransactionEntry tr    
 inner join core.account acc on acc.AccountID = tr.AccountID    
 left join core.Account ac on ac.AccountID=tr.AccountId  
 Left join cre.deal d on d.accountid = tr.DealAccountId
 --Left Join(  
 -- Select Distinct parentaccountid,Date,STRING_AGG(DealName,',') as DealName  
 -- From(  
 --  Select Distinct tr.parentaccountid,tr.date, d.DealName  
 --  from cre.TransactionEntryLiability tr  
 --  inner jOin core.account accLiTy on accLiTy.AccountID = tr.LiabilityNoteAccountID  
 --  Inner join cre.liabilitynote ln on ln.accountid = tr.LiabilityNoteAccountID  
 --  inner jOin cre.LiabilityNoteAssetMapping lnam on lnam.LiabilityNoteAccountId = ln.accountid  
 --  left Join cre.note n on n.account_accountid = lnam.AssetAccountId  
 --  left join cre.deal d on d.dealid = n.dealid  
 --  where accLiTy.IsDeleted <> 1  
 --  and tr.AnalysisID = @AnalysisID  
 --  and tr.parentaccountid = @AccountId  
 -- )z  
 -- group by parentaccountid,date  
 --)tbldeal on tbldeal.parentaccountid = tr.AccountId and tbldeal.Date = tr.Date  
 where acc.isdeleted <> 1    
 and tr.AnalysisID = @AnalysisID    
 and tr.ParentAccountId = @AccountId    
 Order by ac.Name,tr.date    
 END    
 ELSE IF(@Type ='Debt')    
 BEGIN    
 select    
 ac.Name  as Liability_Type    
 ,tr.[Date] as Transaction_Date    
 ,tr.Amount as Transaction_Amount    
 ,tr.[Type] as Transaction_Type    
 ,tr.EndingBalance as Ending_Balance   
 ,(CASE WHEN tr.[Type] = 'InterestPaid' THEN ISNULL(d.DealName,'Unallocated Interest') ELSE null END) as Deal_Name
 from cre.TransactionEntry tr    
 inner join core.account acc on acc.AccountID = tr.AccountID    
 left join core.Account ac on ac.AccountID=tr.AccountId   
 Left join cre.deal d on d.accountid = tr.DealAccountId
 --Left Join(  
 -- Select Distinct AccountId,Date,STRING_AGG(DealName,',') as DealName  
 -- From(  
 --  Select Distinct tr.LiabilityAccountID as AccountId,tr.date, d.DealName  
 --  from cre.TransactionEntryLiability tr  
 --  inner jOin core.account accLiTy on accLiTy.AccountID = tr.LiabilityNoteAccountID  
 --  Inner join cre.liabilitynote ln on ln.accountid = tr.LiabilityNoteAccountID  
 --  inner jOin cre.LiabilityNoteAssetMapping lnam on lnam.LiabilityNoteAccountId = ln.accountid  
 --  left Join cre.note n on n.account_accountid = lnam.AssetAccountId  
 --  left join cre.deal d on d.dealid = n.dealid  
 --  where accLiTy.IsDeleted <> 1  
 --  and tr.AnalysisID = @AnalysisID  
 --  and tr.LiabilityAccountID = @AccountId  
 -- )z  
 -- group by AccountId,date  
 --)tbldeal on tbldeal.AccountId = tr.AccountId and tbldeal.Date = tr.Date  
 where acc.isdeleted <> 1    
 and tr.AnalysisID = @AnalysisID    
 and tr.AccountId = @AccountId    
 Order by ac.Name,tr.date    
 END    
    
    
END