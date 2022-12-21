CREATE TABLE [CRE].[SizerDocuments] (
    [SizerDocumentsID] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [ObjectTypeID]     INT              NULL,
    [ObjectID]         NVARCHAR (MAX)   NULL,
    [DocLink]          NVARCHAR (MAX)   NULL,
    [DocTypeID]        INT              NULL,
    [CreatedBy]        NVARCHAR (256)   NULL,
    [CreatedDate]      DATETIME         NULL,
    [UpdatedBy]        NVARCHAR (256)   NULL,
    [UpdatedDate]      DATETIME         NULL,
    CONSTRAINT [PK_SizerDocumentsID] PRIMARY KEY CLUSTERED ([SizerDocumentsID] ASC)
);

