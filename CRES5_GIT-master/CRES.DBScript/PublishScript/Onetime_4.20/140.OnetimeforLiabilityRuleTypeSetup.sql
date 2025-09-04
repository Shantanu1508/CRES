insert into [CRE].[RuleTypeMaster] (RuleTypeName,IsActive,CreatedBy,	CreatedDate	,UpdatedBy,	UpdatedDate) 
values ('Liability_Fee_Accounts',1,'B0E6697B-3534-4C09-BE0A-04473401AB93',GETDATE(),'B0E6697B-3534-4C09-BE0A-04473401AB93',GETDATE())
 
insert into [CRE].[RuleTypeMaster] (RuleTypeName,IsActive,CreatedBy,	CreatedDate	,UpdatedBy,	UpdatedDate) 
values ('Liability_Fee_Rules',1,'B0E6697B-3534-4C09-BE0A-04473401AB93',GETDATE(),'B0E6697B-3534-4C09-BE0A-04473401AB93',GETDATE())
 
insert into [CRE].[RuleTypeMaster] (RuleTypeName,IsActive,CreatedBy,	CreatedDate	,UpdatedBy,	UpdatedDate) 
values ('Liability_Fee_Config',1,'B0E6697B-3534-4C09-BE0A-04473401AB93',GETDATE(),'B0E6697B-3534-4C09-BE0A-04473401AB93',GETDATE())



go

 
UPDATE cre.RuleTypeMaster Set GroupName='Liability Calculator Fee' Where RuleTypeName IN ('Liability_Fee_Accounts','Liability_Fee_Rules','Liability_Fee_Config');  