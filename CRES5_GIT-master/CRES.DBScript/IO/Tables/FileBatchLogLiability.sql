CREATE TABLE [IO].[FileBatchLogLiability] (
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

ALTER TABLE [IO].[FileBatchLogLiability]
ADD CONSTRAINT PK_FileBatchLogLiability PRIMARY KEY ([BatchLogID]);
