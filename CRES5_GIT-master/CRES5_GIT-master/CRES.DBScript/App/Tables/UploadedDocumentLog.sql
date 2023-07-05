CREATE TABLE [App].[UploadedDocumentLog] (
    [UploadedDocumentLogID] UNIQUEIDENTIFIER CONSTRAINT [DF__UploadedD__Uploa__0D0FEE32] DEFAULT (newid()) NOT NULL,
    [ObjectTypeID]          INT              NULL,
    [ObjectID]              NVARCHAR (MAX)   NULL,
    [FileName]              NVARCHAR (MAX)   NULL,
    [OriginalFileName]      NVARCHAR (MAX)   NULL,
    [CreatedBy]             NVARCHAR (256)   NULL,
    [CreatedDate]           DATETIME         NULL,
    [UpdatedBy]             NVARCHAR (256)   NULL,
    [UpdatedDate]           DATETIME         NULL,
    [StorageTypeID]         INT              NULL,
    [Comment]               NVARCHAR (MAX)   NULL,
    [DocumentTypeID]        NVARCHAR (MAX)   NULL,
    [IsDeleted]             BIT              CONSTRAINT [DF__UploadedD__IsDel__0FEC5ADD] DEFAULT ((0)) NOT NULL,
    [Status]                INT              CONSTRAINT [DF__UploadedD__Statu__12C8C788] DEFAULT ((1)) NOT NULL,
    [DocumentStorageID]     NVARCHAR (256)   NULL,
    CONSTRAINT [PK_UploadedDocumentLogID] PRIMARY KEY CLUSTERED ([UploadedDocumentLogID] ASC)
);

