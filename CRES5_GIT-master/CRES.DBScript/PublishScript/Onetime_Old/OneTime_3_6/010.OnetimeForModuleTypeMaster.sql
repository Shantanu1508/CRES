IF NOT EXISTS(Select 1 from [App].[ModuleTabMaster] where ModuleTabName = 'GenerateAutomation')
BEGIN
	Insert into [App].[ModuleTabMaster] (ModuleTabName	,ParentID	,StatusID,	CreatedBy,	CreatedDate,	UpdatedBy	,UpdatedDate,	SortOrder,	DisplayName,	ModuleType)
	values('GenerateAutomation',	null,	1,	NULL,	NULL,	NULL,	NULL,	null	,'GenerateAutomation',	'Menu')
END
