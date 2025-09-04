CREATE TABLE [DW].[ImportStagDataIntoInt_Status] (
    [ImportStagDataIntoInt_StatusID] INT            IDENTITY (1, 1) NOT NULL,
    [TableName]                      NVARCHAR (200) NULL,
    [Status]                         NVARCHAR (200) NULL,
    [StartDate]                      DATETIME       NULL,
    [EndDate]                        DATETIME       NULL,
    CONSTRAINT [PK_ImportStagDataIntoInt_StatusID] PRIMARY KEY CLUSTERED ([ImportStagDataIntoInt_StatusID] ASC)
);

