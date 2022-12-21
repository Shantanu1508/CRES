  
CREATE VIEW [dbo].[WF_Reserves] AS  


select

n.TaxVendorLoanNumber as VendorLoanNumber,  
lResDescOwnName.Value as RESERVETYPE,  
ResDescOwnName,  
MONTHLYPAYMENTAMT,  
'N' as REMITIOR  ,  
IORPLANCODE,  
'N' as IORPRINTCHK  ,  
1 as BANKNUMBER  ,  
'' as DDANumber  ,  
'' as MATURITYDATE  ,  
'' as RATE  ,  
'' as INVPOOLNUMBER  ,  
'' as InvestmentS  ,

CreDealID,  
dealname, 
n.CRENoteID as CRENoteID

from cre.note n  
inner join Core.Account acc on acc.AccountID=n.Account_AccountID  
inner join cre.Deal d on d.DealId=n.DealId  
left join core.lookup lResDescOwnName on lResDescOwnName.name = n.ResDescOwnName and ParentID = 76
