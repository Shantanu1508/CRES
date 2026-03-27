if NOT EXISTS(select 1 from cre.WFCheckListMaster where CheckListName='Financing Source' and WorkFlowType='WF_FUll')
BEGIN
 INSERT INTO cre.WFCheckListMaster(CheckListName,SortOrder,WorkFlowType) VALUES('Financing Source',12,'WF_FUll')
END

go
 --for completed add checklist item with 'Yes'
insert into cre.WFCheckListDetail(TaskId,TaskTypeID,WFCheckListMasterID,CheckListStatus)
select distinct TaskId,TaskTypeID,21,880  from cre.WFCheckListdetail
where TaskTypeID=502 and IsDeleted=0 and
taskid not in (select distinct taskid from cre.WFCheckListdetail where WFCheckListMasterID=21)
and TaskId in 
(
select distinct TaskID from cre.WFTaskDetail w join  cre.WFStatusPurposeMapping st on w.WFStatusPurposeMappingID=st.WFStatusPurposeMappingID
join cre.WFStatusMaster sm on st.WFStatusMasterID=sm.WFStatusMasterID
join core.Lookup l on l.LookupID=st.PurposeTypeId and l.Value='Positive'
where (w.submittype=498 or w.submittype=497)
and w.TaskTypeID=502
)


