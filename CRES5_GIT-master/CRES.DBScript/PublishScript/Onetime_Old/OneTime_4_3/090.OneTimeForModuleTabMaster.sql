Print('Insert ModuleTabMaster')

go

IF NOT EXISTS(Select 1 from [App].[ModuleTabMaster] where ModuleTabName = 'Deal_Liability')
BEGIN
	Insert into [App].[ModuleTabMaster] (ModuleTabName	,ParentID	,StatusID,	CreatedBy,	CreatedDate,	UpdatedBy	,UpdatedDate,	SortOrder,	DisplayName,	ModuleType)
	values('Deal_Liability',	42,	1,	NULL,	NULL,	NULL,	NULL,	null	,'Deal_Liability',	'Tab')
END

