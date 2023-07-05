Create table DW.ImportStagDataIntoInt_Status(
	ImportStagDataIntoInt_StatusID  int IDENTITY(1,1) not null,
	TableName nvarchar(200) null,
	[Status] nvarchar(200) null,
	StartDate dateTime null,
	EndDate dateTime null
)