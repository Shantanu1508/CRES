CREATE TABLE [App].[TaskDocument] (
    [TaskDocumentID] UNIQUEIDENTIFIER CONSTRAINT [DF__TaskDocum__TaskD__7908F585] DEFAULT (newid()) NOT NULL,
    [Filename]       NVARCHAR (256)   NULL,
    [FileType]       NVARCHAR (256)   NULL,
    [TaskObjectType] INT              NULL,
    [TaskObjectID]   UNIQUEIDENTIFIER NULL,
    [CreatedBy]      NVARCHAR (256)   NULL,
    [CreatedDate]    DATETIME         NULL,
    [UpdatedBy]      NVARCHAR (256)   NULL,
    [UpdatedDate]    DATETIME         NULL,
    CONSTRAINT [PK_TaskDocumentID] PRIMARY KEY CLUSTERED ([TaskDocumentID] ASC)
);

