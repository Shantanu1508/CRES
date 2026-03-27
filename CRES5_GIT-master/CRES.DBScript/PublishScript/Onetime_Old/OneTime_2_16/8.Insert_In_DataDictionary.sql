
Print ('Insert into datadictionary')
GO
IF NOT EXISTS(Select NamedCell from app.datadictionary where NamedCell = 'SCCRENoteID')
	INSERT INTO app.datadictionary (DataType,[Required],NamedRange,NamedCell,DBField,IsDropDown,UsedInSizer,UsedInBatchUpload) VALUES ('String',1,'M61.Tables.Scenario','SCCRENoteID','CRENoteID','N','Y',NULL)
IF NOT EXISTS(Select NamedCell from app.datadictionary where NamedCell = 'SCMaturity')
	INSERT INTO app.datadictionary (DataType,[Required],NamedRange,NamedCell,DBField,IsDropDown,UsedInSizer,UsedInBatchUpload) VALUES ('Integer',1,'M61.Tables.Scenario','SCMaturity','Maturity','N','Y',NULL)
IF NOT EXISTS(Select NamedCell from app.datadictionary where NamedCell = 'SCSpread')
	INSERT INTO app.datadictionary (DataType,[Required],NamedRange,NamedCell,DBField,IsDropDown,UsedInSizer,UsedInBatchUpload) VALUES ('Double',1,'M61.Tables.Scenario','SCSpread','Spread','N','Y',NULL)

GO