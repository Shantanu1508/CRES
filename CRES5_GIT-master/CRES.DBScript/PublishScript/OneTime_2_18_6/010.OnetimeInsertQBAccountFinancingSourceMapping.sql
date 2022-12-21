truncate table [CRE].[QBAccountFinancingSourceMapping]
 go
 --for Draw Fee
 insert into [CRE].[QBAccountFinancingSourceMapping]( FinancingSourceID,QBAccountNo,InvoiceTypeID,QBItemName)
 select FinancingSourceMasterID,null,558,null from cre.financingsourcemaster where IsThirdParty=0
 go
 update [CRE].[QBAccountFinancingSourceMapping] set QBAccountNo='44000',QBItemName='Draw Fees'
 where FinancingSourceID in 
 (
  select FinancingSourceMasterID from cre.financingsourcemaster where IsThirdParty=0 and FinancingsourceName in 
  (
    'Delphi Portfolio',
	'Delphi ACORE',
	'Delphi Warehouse Line',
	'Delphi Offshore',
	'Delphi Fixed',
	'Delphi Warehouse Hold',
	'AFLAC US',
	'TRE ACR',
	'Delaware Life',
	'BcIMC Sidecar',
	'AFLAC US - C',
	'TRE ACR GL allocations',
	'TRE ACR Portfolio',
	'Harel Participation',
	'Winthrop – Participation'
  )
 )
 and InvoiceTypeID=558
 go

 update [CRE].[QBAccountFinancingSourceMapping] set QBAccountNo='44000.1',QBItemName='Draw Fees - 44000.1'
 where FinancingSourceID in 
 (
  select FinancingSourceMasterID from cre.financingsourcemaster where IsThirdParty=0 and FinancingsourceName in 
  (
    'ACORE Credit IV',
	'ACORE Credit IV - Offshore',
	'ACORE Credit IV - DB',
	'ACORE Credit IV - WF',
	'ACORE Credit IV - DB Offshore',
	'ACORE Credit IV - GS 2018 Offshore',
	'ACORE Credit IV - MS Offshore - MS',
	'ACORE Credit IV - WF Offshore',
	'ACORE Credit IV - GS 2018',
	'ACORE Credit IV - MS',
	'ACORE Credit IV – Axos 2021',
	'ACORE Credit IV – Axos 2021 Offshore'
  )
 )
 and InvoiceTypeID=558

 go
 update [CRE].[QBAccountFinancingSourceMapping] set QBAccountNo='44000.2',QBItemName='Draw Fees - 44000.2'
 where FinancingSourceID in 
 (
  select FinancingSourceMasterID from cre.financingsourcemaster where IsThirdParty=0 and FinancingsourceName in 
  (
    'ACSS Real Estate Funding, LLC',
	'ACORE Spec Sits'
  )
 )
 and InvoiceTypeID=558

 go
 update [CRE].[QBAccountFinancingSourceMapping] set QBAccountNo='44000.4',QBItemName='Draw Fees - 44000.4'
 where FinancingSourceID in 
 (
  select FinancingSourceMasterID from cre.financingsourcemaster where IsThirdParty=0 and FinancingsourceName in 
  (
    'ACORE Credit Partners II'
  )
 )
 and InvoiceTypeID=558

 --for deal level invoices
 --account 44000
 insert into [CRE].[QBAccountFinancingSourceMapping]( FinancingSourceID,QBAccountNo,InvoiceTypeID,QBItemName)
 select FinancingSourceMasterID,null,748,null from cre.financingsourcemaster where IsThirdParty=0 union
select FinancingSourceMasterID,null,749,null from cre.financingsourcemaster where IsThirdParty=0 union
select FinancingSourceMasterID,null,750,null from cre.financingsourcemaster where IsThirdParty=0 union
select FinancingSourceMasterID,null,751,null from cre.financingsourcemaster where IsThirdParty=0 union
select FinancingSourceMasterID,null,752,null from cre.financingsourcemaster where IsThirdParty=0 union
select FinancingSourceMasterID,null,753,null from cre.financingsourcemaster where IsThirdParty=0 union
select FinancingSourceMasterID,null,754,null from cre.financingsourcemaster where IsThirdParty=0 union
select FinancingSourceMasterID,null,755,null from cre.financingsourcemaster where IsThirdParty=0 union
select FinancingSourceMasterID,null,756,null from cre.financingsourcemaster where IsThirdParty=0 union
select FinancingSourceMasterID,null,757,null from cre.financingsourcemaster where IsThirdParty=0 union
select FinancingSourceMasterID,null,758,null from cre.financingsourcemaster where IsThirdParty=0 union
select FinancingSourceMasterID,null,759,null from cre.financingsourcemaster where IsThirdParty=0 union
select FinancingSourceMasterID,null,760,null from cre.financingsourcemaster where IsThirdParty=0 union
select FinancingSourceMasterID,null,761,null from cre.financingsourcemaster where IsThirdParty=0 union
select FinancingSourceMasterID,null,762,null from cre.financingsourcemaster where IsThirdParty=0 union
select FinancingSourceMasterID,null,763,null from cre.financingsourcemaster where IsThirdParty=0 union
select FinancingSourceMasterID,null,764,null from cre.financingsourcemaster where IsThirdParty=0 union
select FinancingSourceMasterID,null,765,null from cre.financingsourcemaster where IsThirdParty=0 union
select FinancingSourceMasterID,null,766,null from cre.financingsourcemaster where IsThirdParty=0 union
select FinancingSourceMasterID,null,767,null from cre.financingsourcemaster where IsThirdParty=0 union
select FinancingSourceMasterID,null,768,null from cre.financingsourcemaster where IsThirdParty=0 union
select FinancingSourceMasterID,null,769,null from cre.financingsourcemaster where IsThirdParty=0 union
select FinancingSourceMasterID,null,770,null from cre.financingsourcemaster where IsThirdParty=0 union
select FinancingSourceMasterID,null,771,null from cre.financingsourcemaster where IsThirdParty=0 union
select FinancingSourceMasterID,null,772,null from cre.financingsourcemaster where IsThirdParty=0 

update [CRE].[QBAccountFinancingSourceMapping] set QBAccountNo='44000',QBItemName=(select name from core.Lookup where LookupID=[CRE].[QBAccountFinancingSourceMapping].InvoiceTypeID)
 where FinancingSourceID in 
 (
  select FinancingSourceMasterID from cre.financingsourcemaster where IsThirdParty=0 and FinancingsourceName in 
  (
    'Delphi Portfolio',
	'Delphi ACORE',
	'Delphi Warehouse Line',
	'Delphi Offshore',
	'Delphi Fixed',
	'Delphi Warehouse Hold',
	'AFLAC US',
	'TRE ACR',
	'Delaware Life',
	'BcIMC Sidecar',
	'AFLAC US - C',
	'TRE ACR GL allocations',
	'TRE ACR Portfolio',
	'Harel Participation',
	'Winthrop – Participation'
  )
 )
 and InvoiceTypeID in (select lookupid from core.Lookup where ParentID=126)

 update [CRE].[QBAccountFinancingSourceMapping] set QBAccountNo='44000.1',QBItemName=(select name+' -1' from core.Lookup where LookupID=[CRE].[QBAccountFinancingSourceMapping].InvoiceTypeID)
 where FinancingSourceID in 
 (
  select FinancingSourceMasterID from cre.financingsourcemaster where IsThirdParty=0 and FinancingsourceName in 
  (
    'ACORE Credit IV',
	'ACORE Credit IV - Offshore',
	'ACORE Credit IV - DB',
	'ACORE Credit IV - WF',
	'ACORE Credit IV - DB Offshore',
	'ACORE Credit IV - GS 2018 Offshore',
	'ACORE Credit IV - MS Offshore - MS',
	'ACORE Credit IV - WF Offshore',
	'ACORE Credit IV - GS 2018',
	'ACORE Credit IV - MS',
	'ACORE Credit IV – Axos 2021',
	'ACORE Credit IV – Axos 2021 Offshore'
  )
 )
 and InvoiceTypeID in (select lookupid from core.Lookup where ParentID=126)

 update [CRE].[QBAccountFinancingSourceMapping] set QBAccountNo='44000.2',QBItemName=(select name+' -2' from core.Lookup where LookupID=[CRE].[QBAccountFinancingSourceMapping].InvoiceTypeID)
 where FinancingSourceID in 
 (
  select FinancingSourceMasterID from cre.financingsourcemaster where IsThirdParty=0 and FinancingsourceName in 
  (
    'ACSS Real Estate Funding, LLC',
	'ACORE Spec Sits'
  )
 )
 and InvoiceTypeID in (select lookupid from core.Lookup where ParentID=126)

 update [CRE].[QBAccountFinancingSourceMapping] set QBAccountNo='44000.4',QBItemName=(select name+' -4' from core.Lookup where LookupID=[CRE].[QBAccountFinancingSourceMapping].InvoiceTypeID)
 where FinancingSourceID in 
 (
  select FinancingSourceMasterID from cre.financingsourcemaster where IsThirdParty=0 and FinancingsourceName in 
  (
    'ACORE Credit Partners II'
  )
 )
 and InvoiceTypeID in (select lookupid from core.Lookup where ParentID=126)

 update [CRE].[QBAccountFinancingSourceMapping] set QBItemName='Lease Approval (Major)' where QBItemName='Lease Approval (Major, compliant)' and QBAccountNo='44000'
update [CRE].[QBAccountFinancingSourceMapping] set QBItemName='Easement / Condemnation' where QBItemName='Easement / Condemnation (Material)' and QBAccountNo='44000'
update [CRE].[QBAccountFinancingSourceMapping] set QBItemName='Moderate Extension' where QBItemName='Moderate Extension / Restructuring' and QBAccountNo='44000'
update [CRE].[QBAccountFinancingSourceMapping] set QBItemName='Accrued Int Waiver <31 days' where QBItemName='Accrued Interest Waiver <31 days' and QBAccountNo='44000'
update [CRE].[QBAccountFinancingSourceMapping] set QBItemName='Material Extension' where QBItemName='Material Extension / Restructuring' and QBAccountNo='44000'
--
update [CRE].[QBAccountFinancingSourceMapping] set QBItemName='Lease Approval (Major) -1' where QBItemName='Lease Approval (Major, compliant) -1' and QBAccountNo='44000.1'
update [CRE].[QBAccountFinancingSourceMapping] set QBItemName='Easement / Condemnation -1' where QBItemName='Easement / Condemnation (Material) -1' and QBAccountNo='44000.1'
update [CRE].[QBAccountFinancingSourceMapping] set QBItemName='Moderate Extension -1' where QBItemName='Moderate Extension / Restructuring -1' and QBAccountNo='44000.1'
update [CRE].[QBAccountFinancingSourceMapping] set QBItemName='Accrued Int Waiver <31 days -1' where QBItemName='Accrued Interest Waiver <31 days -1' and QBAccountNo='44000.1'
update [CRE].[QBAccountFinancingSourceMapping] set QBItemName='Material Extension -1' where QBItemName='Material Extension / Restructuring -1' and QBAccountNo='44000.1'

update [CRE].[QBAccountFinancingSourceMapping] set QBItemName='Lease Approval (Major) -2' where QBItemName='Lease Approval (Major, compliant) -2' and QBAccountNo='44000.2'
update [CRE].[QBAccountFinancingSourceMapping] set QBItemName='Easement / Condemnation -2' where QBItemName='Easement / Condemnation (Material) -2' and QBAccountNo='44000.2'
update [CRE].[QBAccountFinancingSourceMapping] set QBItemName='Moderate Extension -2' where QBItemName='Moderate Extension / Restructuring -2' and QBAccountNo='44000.2'
update [CRE].[QBAccountFinancingSourceMapping] set QBItemName='Accrued Int Waiver <31 days -2' where QBItemName='Accrued Interest Waiver <31 days -2' and QBAccountNo='44000.2'
update [CRE].[QBAccountFinancingSourceMapping] set QBItemName='Material Extension -2' where QBItemName='Material Extension / Restructuring -2' and QBAccountNo='44000.2'
