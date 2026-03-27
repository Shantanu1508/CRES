Print('Insert ModuleTabMaster')

go

---Select * from [App].[ModuleTabMaster] where ModuleTabMasterID > 106


Insert into [App].[ModuleTabMaster] (ModuleTabName	,ParentID	,StatusID,	CreatedBy,	CreatedDate,	UpdatedBy	,UpdatedDate,	SortOrder,	DisplayName,	ModuleType)
values('XIRR',	null,	1,	NULL,	NULL,	NULL,	NULL,	null	,'XIRR',	'Menu')


Insert into [App].[ModuleTabMaster] (ModuleTabName	,ParentID	,StatusID,	CreatedBy,	CreatedDate,	UpdatedBy	,UpdatedDate,	SortOrder,	DisplayName,	ModuleType)
values('XIRRDetail',	null,	1,	NULL,	NULL,	NULL,	NULL,	null	,'XIRRDetail',	'Page')

Declare @XIRRParentID int = @@Identity

Update [App].[ModuleTabMaster] set Parentid = @XIRRParentID where ModuleTabName = 'XIRRDetail'

Insert into [App].[ModuleTabMaster] (ModuleTabName	,ParentID	,StatusID,	CreatedBy,	CreatedDate,	UpdatedBy	,UpdatedDate,	SortOrder,	DisplayName,	ModuleType)
values('XIRR_DashBoard',	@XIRRParentID,	1,	NULL,	NULL,	NULL,	NULL,	null	,'XIRR DashBoard',	'Tab')

Insert into [App].[ModuleTabMaster] (ModuleTabName	,ParentID	,StatusID,	CreatedBy,	CreatedDate,	UpdatedBy	,UpdatedDate,	SortOrder,	DisplayName,	ModuleType)
values('XIRR_Setup',	@XIRRParentID,	1,	NULL,	NULL,	NULL,	NULL,	null	,'XIRR Setup',	'Tab')

Insert into [App].[ModuleTabMaster] (ModuleTabName	,ParentID	,StatusID,	CreatedBy,	CreatedDate,	UpdatedBy	,UpdatedDate,	SortOrder,	DisplayName,	ModuleType)
values('XIRR_Archive',	@XIRRParentID,	1,	NULL,	NULL,	NULL,	NULL,	null	,'Archive XIRR',	'Tab')

Insert into [App].[ModuleTabMaster] (ModuleTabName	,ParentID	,StatusID,	CreatedBy,	CreatedDate,	UpdatedBy	,UpdatedDate,	SortOrder,	DisplayName,	ModuleType)
values('Tags',	@XIRRParentID,	1,	NULL,	NULL,	NULL,	NULL,	null	,'Tags',	'Tab')


----Button
Insert into [App].[ModuleTabMaster] (ModuleTabName	,ParentID	,StatusID,	CreatedBy,	CreatedDate,	UpdatedBy	,UpdatedDate,	SortOrder,	DisplayName,	ModuleType)
values('btnEditHistory',	43,	1,	NULL,	NULL,	NULL,	NULL,	null	,'btnEditHistory',	'Control')