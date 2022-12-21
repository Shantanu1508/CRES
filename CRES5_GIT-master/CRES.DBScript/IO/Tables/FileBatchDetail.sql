CREATE TABLE [IO].[FileBatchDetail] (
    [FileBatchDetailID] INT            IDENTITY (1, 1) NOT NULL,
    [BatchLogID]        INT            NOT NULL,
    [ProcessName]       NVARCHAR (MAX) NULL,
    [ErrorMsg]          NVARCHAR (MAX) NULL,
    [CreatedBy]         NVARCHAR (256) NULL,
    [CreatedDate]       DATETIME       NULL,
    [UpdatedBy]         NVARCHAR (256) NULL,
    [UpdatedDate]       DATETIME       NULL
);
go
ALTER TABLE [IO].[FileBatchDetail]
ADD CONSTRAINT PK_FileBatchDetail_FileBatchDetailID PRIMARY KEY (FileBatchDetailID);

