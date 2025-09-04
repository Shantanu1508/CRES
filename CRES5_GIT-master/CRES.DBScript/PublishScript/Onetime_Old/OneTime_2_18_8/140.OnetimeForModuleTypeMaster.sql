IF NOT EXISTS(Select 1 from [App].[ModuleTabMaster] where ModuleTabName = 'Note_Rules')
BEGIN
	Insert into [App].[ModuleTabMaster] (ModuleTabName	,ParentID	,StatusID,	CreatedBy,	CreatedDate,	UpdatedBy	,UpdatedDate,	SortOrder,	DisplayName,	ModuleType)
	values('Note_Rules',	43,	1,	NULL,	NULL,	NULL,	NULL,	1	,'Note_Rules',	'Tab')
END

IF NOT EXISTS(Select 1 from [App].[ModuleTabMaster] where ModuleTabName = 'Deal_Prepay')
BEGIN
	insert into [App].[ModuleTabMaster](ModuleTabName,ParentID,StatusID,SortOrder,DisplayName,ModuleType)
	values('Deal_Prepay',42,1,1,'Deal_Prepay','Tab')
END