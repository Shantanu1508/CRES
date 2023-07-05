  
CREATE VIEW [dbo].[WF_Insurance] AS  
select
n.TaxVendorLoanNumber as VendorLoanNumber,  
'GRO' as InsuranceCompanyID  ,  
  'GRO' as InsuranceAgentID  ,  
 'HZ' as InsuranceType,
 Cast(Format( eomonth(ClosingDate,-1) ,'MMddyyyy') as nvarchar(256)) as EffectiveDate,
 Cast(Format( eomonth(ClosingDate,-1) ,'MMddyyyy') as nvarchar(256))  as PolicyExpRsvMature, 
  '' as PolicyFHACase  ,  
1 as PropertyLocSeq  ,  
 '' as PendingLossesProcessed  ,  
 '' as DocNoticeCode  ,   
 InsuranceBillStatusCode as BillStatusCode,
 Cast(Format( eomonth(ClosingDate,-1) ,'MMddyyyy') as nvarchar(256))  as NextRemitDate,
 '' as PremiumFHAAmountDue,

InsEscrowConstant as MonthlyPayment,

 12 as Numberofmonthstoremit  ,  
12 as FreqOfDisbursement  ,  
 'N' as AutoBillEntry  ,  
 '' as RollExpDate  ,  
 'N' as OverNegBalance ,

 CreDealID,  
dealname, 
n.CRENoteID as CRENoteID

from cre.note n 
inner join  cre.deal d  on n.DealID=d.DealID 
--left join cre.Property p  on p.deal_dealid=d.dealid 
  