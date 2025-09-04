
CREATE view [dbo].[vw_LiabilityUnallocatedBalance] 
as    

Select AbbreviationName,EquityAccountID,EquityName,[Date],[UnallocatedFinancingAmount], [UnallocatedEquityAmount], [UnallocatedSublineAmount]
From(  

Select 
--tblChAcc.AccountID as LiabilityAccountID
--,tr.accountid as Cash_AccountID
--,tblChAcc.[Text]
eq.AccountID as EquityAccountID,  
acc.name as EquityName,
eq.AbbreviationName ,
tr.date
--,tr.[type]
,tr.Amount 
,CASE     
WHEN tr.Type LIKE '%Repo%' THEN 'UnallocatedFinancingAmount'    
WHEN tr.Type LIKE '%Equity%'  THEN 'UnallocatedEquityAmount'    
WHEN tr.Type LIKE '%Subline%' THEN 'UnallocatedSublineAmount'  
ELSE NULL    
END AS AmountType 

from cre.TransactionEntry tr 
left join cre.equity eq on eq.AccountID = tr.ParentAccountID
Inner join core.account acc on acc.accountid = eq.accountid
Inner Join(
	Select AccountID,PortfolioAccountID,[Text],[Type]
	From(
		Select acc.AccountID as AccountID,d.PortfolioAccountID,acc.name as [Text] ,'Debt' as [Type]  
		from cre.Debt d   
		Inner Join core.Account acc on acc.AccountID =  d.AccountID   
		where  IsDeleted<> 1   
  
		UNION ALL    
  
		Select acc.AccountID as AccountID,d.PortfolioAccountID,acc.name as [Text] ,'Equity' as [Type]  
		from cre.Equity d   
		Inner Join core.Account acc on acc.AccountID =  d.AccountID   
		where IsDeleted<> 1   
	)z
)tblChAcc on tblChAcc.PortfolioAccountID = tr.AccountId

where analysisid ='C10F3372-0FC2-4861-A9F5-148F1F80804F'

)z      
PIVOT    
(    
    SUM(Amount) FOR AmountType IN ([UnallocatedFinancingAmount], [UnallocatedEquityAmount], [UnallocatedSublineAmount])    
) AS PivotTable


