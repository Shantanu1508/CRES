CREATE TABLE [IO].[BatchLogGeneric] (
    [BatchLogGenericID] INT            IDENTITY (1, 1) NOT NULL,
    [BatchName]         NVARCHAR (50)  NULL,
    [BatchStartTime]    DATETIME       NOT NULL,
    [BatchEndTime]      DATETIME       NULL,
    [StartedBy]         NVARCHAR (50)  NULL,
    [ErrorMessage]      NVARCHAR (MAX) NULL,
    [Status]            NVARCHAR (MAX) NULL,
    [RecordCount]       INT            NULL,
    CONSTRAINT [PK_BatchLogGeneric] PRIMARY KEY CLUSTERED ([BatchLogGenericID] ASC)
);

