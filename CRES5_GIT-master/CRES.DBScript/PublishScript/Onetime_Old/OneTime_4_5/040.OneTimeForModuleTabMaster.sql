Print('Insert ModuleTabMaster')

go

IF NOT EXISTS(Select 1 from [App].[ModuleTabMaster] where ModuleTabName = 'Deal_XIRR')
BEGIN
	Insert into [App].[ModuleTabMaster] (ModuleTabName	,ParentID	,StatusID,	CreatedBy,	CreatedDate,	UpdatedBy	,UpdatedDate,	SortOrder,	DisplayName,	ModuleType)
	values('Deal_XIRR',	42,	1,	NULL,	NULL,	NULL,	NULL,	null	,'Deal_XIRR',	'Tab')
END

IF NOT EXISTS(Select 1 from [App].[ModuleTabMaster] where ModuleTabName = 'Dynamic_Portfolio_XIRR')
BEGIN
	Insert into [App].[ModuleTabMaster] (ModuleTabName	,ParentID	,StatusID,	CreatedBy,	CreatedDate,	UpdatedBy	,UpdatedDate,	SortOrder,	DisplayName,	ModuleType)
	values('Dynamic_Portfolio_XIRR',	77,	1,	NULL,	NULL,	NULL,	NULL,	null	,'Dynamic_Portfolio_XIRR',	'Tab')
END

