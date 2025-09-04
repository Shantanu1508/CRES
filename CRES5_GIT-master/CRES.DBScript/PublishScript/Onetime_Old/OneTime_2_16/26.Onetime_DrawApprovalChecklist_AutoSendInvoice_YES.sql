--set drap fee application option to 'YES' for draw which is not 'completed'

update cre.WFCheckListDetail set cre.WFCheckListDetail.CheckListStatus=499
from
(
select distinct c.WFChecklistDetailID from cre.wftaskdetail t join cre.WFCheckListDetail c on t.taskid=c.taskid 
join cre.wfstatuspurposemapping sm on t.WFStatusPurposeMappingID=sm.WFStatusPurposeMappingID
where wfchecklistmasterid=9
and sm.WFStatusMasterID < 5 
) tbl
where cre.WFCheckListDetail.WFChecklistDetailID = tbl.WFChecklistDetailID

go
--set Auto Send Invoice 'YES' for draw which is not 'completed'
update cre.InvoiceDetail set cre.InvoiceDetail.AutoSendInvoice=571
from
(
select distinct t.TaskID from cre.wftaskdetail t 
join cre.wfstatuspurposemapping sm on t.WFStatusPurposeMappingID=sm.WFStatusPurposeMappingID
where sm.WFStatusMasterID < 5 
) tbl
where cre.InvoiceDetail.ObjectID = tbl.TaskID and ObjectTypeID=698 and InvoiceTypeId=558