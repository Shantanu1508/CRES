update cre.FinancingSourceMaster set IsThirdParty=1 where FinancingSourceName='Delaware Life'

IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'ClientAbbr'
          AND Object_ID = Object_ID(N'cre.client'))
BEGIN
   Alter table cre.client add ClientAbbr nvarchar(256)
END

update cre.client set ClientAbbr = ClientName
update cre.client set ClientAbbr ='ACSS' where ClientName='ACORE Special Sits'