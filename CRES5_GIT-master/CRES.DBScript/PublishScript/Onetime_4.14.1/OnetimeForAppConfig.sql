
IF NOT EXISTS(Select * from [App].[AppConfig]  where  [key] = 'StopV1NoteCalculation')
BEGIN
	Insert into [App].[AppConfig] ([Key],[Value],[Comments]) values ('StopV1NoteCalculation', 0, 'Flag to enable disable V1 Note calculation')
END



