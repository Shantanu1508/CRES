  
CREATE VIEW [dbo].[WF_Tax] AS  
select

TaxVendorLoanNumber as VendorLoanNumber,  
 '1' as PROPERTYSEQ  ,  
 '' as PARCELNUMBER  ,  
 'C' as TYPEOFTAX  ,  
 'CMBS' as TAXAUTHID  ,
TAXBILLSTATUS,  
12 as FREQOFDISB  ,  
 '1/01/2010' as NEXTDISBDATE  ,  
 '' as TAXAMTDUE  ,  
 'FL' as LASTBILLTYPEPAID  ,  
 '' as LASTTAXAMOUNTPAID  ,  
d.TaxEscrowConstant as CURRTAXCONSTANT,  
4 as TAXSERVICECODE  ,  
 '' as TaxServiceAgencyID  ,  
 '' as TAXSERVICECONTRACT  ,  
 '007' as TaxServiceOrigOffice  ,  
 '' as TaxServiceContractMod  ,  
 'N' as AutoBillEntry  ,  
 'N' as OverrideNegetiveBal,
 
 
 CreDealID,  
dealname, 
n.CRENoteID as CRENoteID
  
from cre.note n  
inner join Core.Account acc on acc.AccountID=n.Account_AccountID  
inner join cre.Deal d on d.DealId=n.DealId  




 