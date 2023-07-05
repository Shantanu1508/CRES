if not exists (select 1 from Cre.WfCheckListMaster where WFCheckListMasterID=9)
begin
insert into Cre.WfCheckListMaster(CheckListName,SortOrder,WorkFlowType) values('Draw Fee Applicable',9,'WF_FUll')
end