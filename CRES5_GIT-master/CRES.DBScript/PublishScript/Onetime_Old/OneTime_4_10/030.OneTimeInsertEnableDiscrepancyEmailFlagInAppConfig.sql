IF NOT EXISTS (Select [VALUE] from [App].[AppConfig] WHERE [KEY]='EnableDiscrepancyEmail')
BEGIN
	INSERT INTO  [App].[AppConfig] ([Key],[Value],[Comments],[CreatedDate],[UpdatedDate])
	Values ('EnableDiscrepancyEmail', 1, 'Flag to enable disable discrepancy email',GETDATE(),GETDATE());
END