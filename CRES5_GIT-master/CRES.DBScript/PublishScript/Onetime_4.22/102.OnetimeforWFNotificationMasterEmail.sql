Delete from CRE.WFNotificationMasterEmail where ParentClient not in (
	Select ParentClient_Old from cre.FinancingSourceMaster 
)

go


--ALTER TABLE cre.WFNotificationMasterEmail ADD ParentClient_Old nvarchar(256)
--go
Update cre.WFNotificationMasterEmail set ParentClient_Old = ParentClient 

go

Update cre.WFNotificationMasterEmail set cre.WFNotificationMasterEmail.ParentClient = z.ParentClient
From(
Select distinct wf.WFNotificationMasterEmailID,fs.ParentClient ,wf.ParentClient_Old
from cre.WFNotificationMasterEmail wf
left join cre.FinancingSourceMaster fs on wf.ParentClient_Old = fs.ParentClient_Old

)z
where cre.WFNotificationMasterEmail.WFNotificationMasterEmailID = z.WFNotificationMasterEmailID


