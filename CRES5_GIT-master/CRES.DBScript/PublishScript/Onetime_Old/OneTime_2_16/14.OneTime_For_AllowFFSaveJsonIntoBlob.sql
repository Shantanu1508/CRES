
IF NOT Exists(SELECT 1 from App.AppConfig WHERE [Key]='AllowFFSaveJsonIntoBlob')
BEGIN
insert into app.appconfig([Key],	[Value],	Comments,	CreatedBy,	CreatedDate,	UpdatedBy,	UpdatedDate)values
('AllowFFSaveJsonIntoBlob',	1	,'Save Future Funding JSON into Blob',	NULL,	NULL,	NULL,	NULL)
END