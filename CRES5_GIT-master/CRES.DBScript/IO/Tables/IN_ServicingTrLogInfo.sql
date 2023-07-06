CREATE TABLE [IO].[IN_ServicingTrLogInfo] (
    [IN_ServicingTrLogInfoID] INT            IDENTITY (1, 1) NOT NULL,
    [MinDate]                 DATE           NULL,
    [MaxDate]                 DATE           NULL,
    [FileName]                NVARCHAR (256) NULL,
    [Status]                  NVARCHAR (256) NULL,
    [CreatedBy]               NVARCHAR (256) NULL,
    [CreatedDate]             DATETIME       NULL,
    [UpdatedBy]               NVARCHAR (256) NULL,
    [UpdatedDate]             DATETIME       NULL,
    [ErrorMsg]                NVARCHAR (256) NULL,
    [OrignalFileName]         NVARCHAR (256) NULL,
    [StorageType]             INT            NULL,
    [StatusId]                INT            NULL,
    CONSTRAINT [PK_IN_ServicingTrLogInfoID] PRIMARY KEY CLUSTERED ([IN_ServicingTrLogInfoID] ASC)
);

