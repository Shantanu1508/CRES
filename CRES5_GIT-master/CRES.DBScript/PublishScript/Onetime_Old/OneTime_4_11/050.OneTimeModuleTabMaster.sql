
Declare @ID int;
insert into [App].[ModuleTabMaster] Values('Indexes_Detail',6,1,null,null,null,null,1,'Indexes_Detail','Page')
SET @ID = @@IDENTITY
insert into [App].[ModuleTabMaster] Values('Indexes_btnSave',@ID,1,null,null,null,null,1,'Indexes_btnSave','Control')
insert into [App].[ModuleTabMaster] Values('Indexes_btnRefresh',@ID,1,null,null,null,null,1,'Indexes_btnRefresh','Control')
insert into [App].[ModuleTabMaster] Values('Indexes_btnImport',@ID,1,null,null,null,null,1,'Indexes_btnImport','Control')