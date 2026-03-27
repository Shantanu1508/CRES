Print('Insert ModuleTabMaster')

go

IF NOT EXISTS(Select 1 from [App].[ModuleTabMaster] where ModuleTabName = 'Deal_AccountingClose')
BEGIN
	Insert into [App].[ModuleTabMaster] (ModuleTabName	,ParentID	,StatusID,	CreatedBy,	CreatedDate,	UpdatedBy	,UpdatedDate,	SortOrder,	DisplayName,	ModuleType)
	values('Deal_AccountingClose',	42,	1,	NULL,	NULL,	NULL,	NULL,	null	,'Deal_AccountingClose',	'Tab')
END




Update [App].[ModuleTabMaster] set ModuleTabName = 'Accounting_Close' where ModuleType = 'Menu' and ModuleTabName = 'Periodic_Close'
