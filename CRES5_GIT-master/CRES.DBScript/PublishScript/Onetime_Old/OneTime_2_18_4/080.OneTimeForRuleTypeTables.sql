
--Select * from [CRE].[RuleTypeMaster]
--Select * from [CRE].[RuleTypeDetail]
--Select * from [CRE].[AnalysisRuleTypeSetup]
--Select * from [CRE].[DealNoteRuleTypeSetup]

Print('ONe time Rule Type data')
go



declare @Identity int;

INSERT INTO [CRE].[RuleTypeMaster] (RuleTypeName,Comments,IsActive,[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate] )VALUES('Accounts',null,1,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
SET @Identity = @@IDENTITY
	INSERT INTO [CRE].[RuleTypeDetail](RuleTypeMasterID,FileName,Content,Type)VALUES(@Identity,'DefaultAccount.json',null,'json')

INSERT INTO [CRE].[RuleTypeMaster] (RuleTypeName,Comments,IsActive,[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate] )VALUES('Config',null,1,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
SET @Identity = @@IDENTITY
	INSERT INTO [CRE].[RuleTypeDetail](RuleTypeMasterID,FileName,Content,Type)VALUES(@Identity,'DefaultConfig.json',null,'json')

INSERT INTO [CRE].[RuleTypeMaster] (RuleTypeName,Comments,IsActive,[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate] )VALUES('Rules',null,1,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
SET @Identity = @@IDENTITY
	INSERT INTO [CRE].[RuleTypeDetail](RuleTypeMasterID,FileName,Content,IsBalanceAware,Type)VALUES(@Identity,'DefaultRules_BalanceAware.json',null,1,'json')
	INSERT INTO [CRE].[RuleTypeDetail](RuleTypeMasterID,FileName,Content,Type)VALUES(@Identity,'DefaultRules_non_BalanceAware.json',null,'json')



Update [CRE].[RuleTypeDetail] set Content = (Select [value] from cre.jsontemplate where [key]  = 'accounts' and JsonTemplateMasterID = 1) where RuleTypeDetailID = 1
Update [CRE].[RuleTypeDetail] set Content = (Select [value] from cre.jsontemplate where [key]  = 'config' and JsonTemplateMasterID = 1) where RuleTypeDetailID = 2
Update [CRE].[RuleTypeDetail] set Content = (Select [value] from cre.jsontemplate where [key]  = 'rules' and JsonTemplateMasterID = 1 and [Type] = 'BalanceAware') where RuleTypeDetailID = 3
Update [CRE].[RuleTypeDetail] set Content = (Select [value] from cre.jsontemplate where [key]  = 'rules' and JsonTemplateMasterID = 1 and [Type] = 'non_BalanceAware') where RuleTypeDetailID = 4


Update [CRE].[RuleTypeDetail] set [CRE].[RuleTypeDetail].DBFileName = a.DBName
From(
Select rm.RuleTypeName,RuleTypeDetailID,FileName,DBFileName ,(rm.RuleTypeName + '_'+ FileName) as DBName
from [CRE].[RuleTypeDetail] rd
inner join [CRE].[RuleTypeMaster] rm on rm.RuleTypeMasterid = rd.RuleTypeMasterid
)a
where [CRE].[RuleTypeDetail].RuleTypeDetailID = a.RuleTypeDetailID




INSERT INTO [CRE].[AnalysisRuleTypeSetup](AnalysisID,RuleTypeMasterID,RuleTypeDetailID)
select a.analysisid,RuleTypeMasterID,RuleTypeDetailID 
from [CRE].[RuleTypeDetail] ,core.analysis a
where [FileName] <> 'DefaultRules_BalanceAware.json'
--and analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'