CREATE TABLE [App].[ReportFileLog] (
    [ReportFileLogID]       INT              IDENTITY (1, 1) NOT NULL,
    [UploadedDocumentLogID] UNIQUEIDENTIFIER CONSTRAINT [DF__ReportFil__Uploa__6ECB5E34] DEFAULT (newid()) NOT NULL,
    [ObjectTypeID]          INT              NULL,
    [ObjectGUID]            NVARCHAR (256)   NULL,
    [ObjectID]              INT              NULL,
    [FileName]              NVARCHAR (MAX)   NULL,
    [OriginalFileName]      NVARCHAR (MAX)   NULL,
    [CreatedBy]             NVARCHAR (256)   NULL,
    [CreatedDate]           DATETIME         NULL,
    [UpdatedBy]             NVARCHAR (256)   NULL,
    [UpdatedDate]           DATETIME         NULL,
    [StorageTypeID]         INT              NULL,
    [StorageLocation]       NVARCHAR (MAX)   NULL,
    [Comment]               NVARCHAR (MAX)   NULL,
    [IsDeleted]             BIT              CONSTRAINT [DF__ReportFil__IsDel__6FBF826D] DEFAULT ((0)) NOT NULL,
    [Status]                INT              CONSTRAINT [DF__ReportFil__Statu__70B3A6A6] DEFAULT ((1)) NOT NULL,
    [DocumentStorageID]     NVARCHAR (256)   NULL,
    [ReportFileAttributes]  NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_ReportFileLogID] PRIMARY KEY CLUSTERED ([ReportFileLogID] ASC)
);

