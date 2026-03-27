if NOT EXISTS(select 1 from cre.WFCheckListMaster where CheckListName='Checked Note Allocations in M61' and WorkFlowType='WF_UNDERREVIEW')
BEGIN
 INSERT INTO cre.WFCheckListMaster(CheckListName,SortOrder,WorkFlowType) VALUES('Checked Note Allocations in M61',8,'WF_UNDERREVIEW')
END

go
update cre.WFCheckListMaster   set SortOrder = 9 where CheckListName='Receipt of Funds Confirmed' and WorkFlowType='WF_UNDERREVIEW'
update cre.WFCheckListMaster   set SortOrder = 10 where CheckListName='Draw Fee Applicable' and WorkFlowType='WF_FUll'
update cre.WFCheckListMaster   set SortOrder = 11 where CheckListName='Outstanding Draw Fees' and WorkFlowType='WF_FUll'


 
 go
 --for completed add checklist item with 'Yes'
insert into cre.WFCheckListDetail(TaskId,TaskTypeID,WFCheckListMasterID,CheckListStatus)
select distinct TaskId,TaskTypeID,20,499  from cre.WFCheckListdetail
where TaskTypeID=502 and IsDeleted=0 and
taskid not in (select distinct taskid from cre.WFCheckListdetail where WFCheckListMasterID=20)
and TaskId in 
(
select w.TaskID from cre.WFTaskDetail w join  cre.WFStatusPurposeMapping st on w.WFStatusPurposeMappingID=st.WFStatusPurposeMappingID
join cre.WFStatusMaster sm on st.WFStatusMasterID=sm.WFStatusMasterID
where w.submittype=498
and w.TaskTypeID=502
and sm.WFStatusMasterID=5
and PurposeTypeId in (630,631)
)

go
 --for non completed add checklist item with 'No'
insert into cre.WFCheckListDetail(TaskId,TaskTypeID,WFCheckListMasterID,CheckListStatus)
select distinct TaskId,TaskTypeID,20,616  from cre.WFCheckListdetail
where TaskTypeID=502 and IsDeleted=0 and
taskid not in (select distinct taskid from cre.WFCheckListdetail where WFCheckListMasterID=20)
and TaskId in 
(
select w.TaskID from cre.WFTaskDetail w join  cre.WFStatusPurposeMapping st on w.WFStatusPurposeMappingID=st.WFStatusPurposeMappingID
join cre.WFStatusMaster sm on st.WFStatusMasterID=sm.WFStatusMasterID
where w.submittype=498
and w.TaskTypeID=502
and sm.WFStatusMasterID<>5
and PurposeTypeId in (630,631)
)

