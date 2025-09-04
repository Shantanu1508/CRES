  CREATE TABLE [CRE].[CalculatorExtensionDbSave] 
  (
    [CalculatorExtensionDbSaveID] INT   IDENTITY (1, 1) NOT NULL,
    [NoteID]                 NVARCHAR (100)   NULL,
	[AnalysisID]             NVARCHAR (100)   NULL,
	[RequestID]             NVARCHAR (100)   NULL,
	[FileName]             NVARCHAR (256)   NULL,
    [ServerFileCount]  int ,
    [DbCount]    int  ,
    [CreatedDate]            DATETIME         NULL,
    CONSTRAINT [PK_CalculatorExtensionDbSaveID] PRIMARY KEY CLUSTERED ([CalculatorExtensionDbSaveID] ASC)
);

