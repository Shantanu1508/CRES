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
	'TRE ACR Portfolio'
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
	'ACORE Credit IV - MS'
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
