
IF NOT EXISTS(Select * from [App].[AppConfig]  where  [key] = 'StopC#NoteCalculation')
BEGIN
	Insert into [App].[AppConfig] ([Key],[Value],[Comments]) values ('StopC#NoteCalculation', 0, 'Flag to enable disable C# Note calculation')
END