if not exists (select 1 from Cre.WFCheckListDetail where WFCheckListMasterID=9)
begin
INSERT INTO [CRE].[WFCheckListDetail]
           ([TaskId]
           ,[WFCheckListMasterID]
           ,[CheckListName]
           ,[CheckListStatus]
           ,[Comment]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
select distinct taskid,9,null,616,null,CreatedBy,getdate(),updatedby,getdate() from cre.WFCheckListDetail where wfchecklistmasterid not in (7,8)
end
go

update cre.WFCheckListDetail set CheckListStatus=616 where wfchecklistmasterid=9 and checkliststatus is null