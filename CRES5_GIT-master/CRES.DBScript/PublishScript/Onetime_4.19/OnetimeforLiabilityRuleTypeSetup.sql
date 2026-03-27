insert into [CRE].[RuleTypeMaster] (RuleTypeName,IsActive,CreatedBy,	CreatedDate	,UpdatedBy,	UpdatedDate) 
values ('Liability_Accounts',1,'B0E6697B-3534-4C09-BE0A-04473401AB93',GETDATE(),'B0E6697B-3534-4C09-BE0A-04473401AB93',GETDATE())
 
insert into [CRE].[RuleTypeMaster] (RuleTypeName,IsActive,CreatedBy,	CreatedDate	,UpdatedBy,	UpdatedDate) 
values ('Liability_Rules',1,'B0E6697B-3534-4C09-BE0A-04473401AB93',GETDATE(),'B0E6697B-3534-4C09-BE0A-04473401AB93',GETDATE())
 
insert into [CRE].[RuleTypeMaster] (RuleTypeName,IsActive,CreatedBy,	CreatedDate	,UpdatedBy,	UpdatedDate) 
values ('Liability_Config',1,'B0E6697B-3534-4C09-BE0A-04473401AB93',GETDATE(),'B0E6697B-3534-4C09-BE0A-04473401AB93',GETDATE())



go

UPDATE cre.RuleTypeMaster Set GroupName='Asset Calculator' Where RuleTypeName IN ('Accounts','Config','Rules','Prepay');
UPDATE cre.RuleTypeMaster Set GroupName='Liability Calculator' Where RuleTypeName IN ('Liability_Accounts','Liability_Rules','Liability_Config');