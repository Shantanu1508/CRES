--IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'TaskTypeID' AND Object_ID = Object_ID(N'cre.WFTaskAdditionalDetail'))
--		  BEGIN
--			alter table  cre.WFTaskAdditionalDetail add TaskTypeID int null
--		  END

--go
--IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'TaskTypeID' AND Object_ID = Object_ID(N'cre.WFNotification'))
--		  BEGIN
--			alter table  cre.WFNotification add TaskTypeID int null
--		  END

--go
--IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'TaskTypeID' AND Object_ID = Object_ID(N'cre.WFCheckListDetail'))
--		  BEGIN
--			alter table  cre.WFCheckListDetail add TaskTypeID int null
--		  END

go

update cre.WFTaskAdditionalDetail set TaskTypeID=502 where TaskTypeID is null
go
update cre.WFNotification set TaskTypeID=502 where TaskTypeID is null
go
update cre.WFCheckListDetail set TaskTypeID=502 where TaskTypeID is null