CREATE TABLE [IO].[FileBatchLog] (
    [BatchLogID]      INT            IDENTITY (1, 1) NOT NULL,
    [ServcerMasterID] INT            NULL,
    [OrigFileName]    NVARCHAR (MAX) NULL,
    [BlobFileName]    NVARCHAR (MAX) NULL,
    [CreatedBy]       NVARCHAR (256) NULL,
    [CreatedDate]     DATETIME       NULL,
    [UpdatedBy]       NVARCHAR (256) NULL,
    [UpdatedDate]     DATETIME       NULL
);

go

ALTER TABLE [IO].[FileBatchLog]
ADD CONSTRAINT PK_FileBatchLog PRIMARY KEY ([BatchLogID]);