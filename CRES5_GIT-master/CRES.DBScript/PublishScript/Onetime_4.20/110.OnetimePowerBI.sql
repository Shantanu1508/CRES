--update [App].[ReportFile] set reporttype='Acore' where reportFileFormat is not null

----M61 report-production

--if not exists(select 1 from [App].[ReportFile] where ReportFileName='M61 Data Tape' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='61515428-98db-4831-b7b1-22a0c32eacaf')
--begin
--insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
--values('M61 Data Tape','fa640ae8-4ace-4edc-83bf-942df171d521','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','61515428-98db-4831-b7b1-22a0c32eacaf')
--end
----

----M61 report-Integration

--/*
--if not exists(select 1 from [App].[ReportFile] where ReportFileName='M61 Data Tape' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
--begin
--insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
--values('M61 Data Tape','8b7d7c4a-2d0f-477b-84cc-fa10a585bed4','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
--end
--*/

----
