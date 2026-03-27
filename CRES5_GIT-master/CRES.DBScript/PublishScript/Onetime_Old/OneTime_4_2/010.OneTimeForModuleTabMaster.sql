Print('Insert ModuleTabMaster')

go

IF NOT EXISTS(Select 1 from [App].[ModuleTabMaster] where ModuleTabName = 'Deal_ServicingWatchlist')
BEGIN
	Insert into [App].[ModuleTabMaster] (ModuleTabName	,ParentID	,StatusID,	CreatedBy,	CreatedDate,	UpdatedBy	,UpdatedDate,	SortOrder,	DisplayName,	ModuleType)
	values('Deal_ServicingWatchlist',	42,	1,	NULL,	NULL,	NULL,	NULL,	null	,'Deal_ServicingWatchlist',	'Tab')
END



