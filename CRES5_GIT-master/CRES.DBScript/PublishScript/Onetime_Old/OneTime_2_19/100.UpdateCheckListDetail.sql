

--update [CRE].[WFCheckListDetail] set IsDeleted = 0
--update [CRE].[WFCheckListDetail] set IsDeleted = 1 where taskid in (select (taskid) from [CRE].[WFTaskDetail] where IsDeleted = 1)