
if not exists(select 1 from [CRE].[WFCheckListMaster] where CheckListName='Insurance' and [WorkFlowType]='WF_Reserve')
begin
INSERT INTO [CRE].[WFCheckListMaster]
           ([CheckListName]
           ,[IsMandatory]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
           ,[SortOrder]
           ,[WorkFlowType])
     VALUES
           ('Insurance'
           ,null
           ,null
           ,null
           ,null
           ,null
           ,4
           ,'WF_Reserve')
end
go
if not exists(select 1 from [CRE].[WFCheckListMaster] where CheckListName='Construction Consultant Approval' and [WorkFlowType]='WF_Reserve')
begin
INSERT INTO [CRE].[WFCheckListMaster]
           ([CheckListName]
           ,[IsMandatory]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
           ,[SortOrder]
           ,[WorkFlowType])
     VALUES
           ('Construction Consultant Approval'
           ,null
           ,null
           ,null
           ,null
           ,null
           ,1
           ,'WF_Reserve')
end
go
if not exists(select 1 from [CRE].[WFCheckListMaster] where CheckListName='Title Endorsement' and [WorkFlowType]='WF_Reserve')
begin
INSERT INTO [CRE].[WFCheckListMaster]
           ([CheckListName]
           ,[IsMandatory]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
           ,[SortOrder]
           ,[WorkFlowType])
     VALUES
           ('Title Endorsement'
           ,null
           ,null
           ,null
           ,null
           ,null
           ,2
           ,'WF_Reserve')
end

go
if not exists(select 1 from [CRE].[WFCheckListMaster] where CheckListName='Taxes' and [WorkFlowType]='WF_Reserve')
begin
INSERT INTO [CRE].[WFCheckListMaster]
           ([CheckListName]
           ,[IsMandatory]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
           ,[SortOrder]
           ,[WorkFlowType])
     VALUES
           ('Taxes'
           ,null
           ,null
           ,null
           ,null
           ,null
           ,3
           ,'WF_Reserve')
end
go
if not exists(select 1 from [CRE].[WFCheckListMaster] where CheckListName='Reporting Requirements' and [WorkFlowType]='WF_Reserve')
begin
INSERT INTO [CRE].[WFCheckListMaster]
           ([CheckListName]
           ,[IsMandatory]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
           ,[SortOrder]
           ,[WorkFlowType])
     VALUES
           ('Reporting Requirements'
           ,null
           ,null
           ,null
           ,null
           ,null
           ,5
           ,'WF_Reserve')
end
go
if not exists(select 1 from [CRE].[WFCheckListMaster] where CheckListName='Funding Team’s Approval Required' and [WorkFlowType]='WF_Reserve')
begin
INSERT INTO [CRE].[WFCheckListMaster]
           ([CheckListName]
           ,[IsMandatory]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
           ,[SortOrder]
           ,[WorkFlowType])
     VALUES
           ('Funding Team’s Approval Required'
           ,null
           ,null
           ,null
           ,null
           ,null
           ,6
           ,'WF_Reserve')
end

go
if not exists(select 1 from [CRE].[WFCheckListMaster] where CheckListName='Include Acore Accounting in notifications' and [WorkFlowType]='WF_Reserve')
begin
INSERT INTO [CRE].[WFCheckListMaster]
           ([CheckListName]
           ,[IsMandatory]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
           ,[SortOrder]
           ,[WorkFlowType])
     VALUES
           ('Include Acore Accounting in notifications'
           ,null
           ,null
           ,null
           ,null
           ,null
           ,7
           ,'WF_Reserve')
end
go
if not exists(select 1 from [CRE].[WFCheckListMaster] where CheckListName='Include Property Managers in notification' and [WorkFlowType]='WF_Reserve')
begin
INSERT INTO [CRE].[WFCheckListMaster]
           ([CheckListName]
           ,[IsMandatory]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
           ,[SortOrder]
           ,[WorkFlowType])
     VALUES
           ('Include Property Managers in notification'
           ,null
           ,null
           ,null
           ,null
           ,null
           ,8
           ,'WF_Reserve')
end

if not exists(select 1 from [CRE].[WFCheckListMaster] where CheckListName='Verify Servicer Balance' and [WorkFlowType]='WF_Reserve')
begin
INSERT INTO [CRE].[WFCheckListMaster]
           ([CheckListName]
           ,[IsMandatory]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
           ,[SortOrder]
           ,[WorkFlowType])
     VALUES
           ('Verify Servicer Balance'
           ,null
           ,null
           ,null
           ,null
           ,null
           ,9
           ,'WF_Reserve')
end



