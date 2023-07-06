CREATE TABLE [App].[ReportFile] (
    [ReportFileID]               INT              IDENTITY (1, 1) NOT NULL,
    [ReportFileName]             NVARCHAR (256)   NULL,
    [ReportFileFormat]           NVARCHAR (256)   NULL,
    [ReportFileJSON]             NVARCHAR (256)   NULL,
    [ReportFileGUID]             UNIQUEIDENTIFIER CONSTRAINT [DF__ReportFil__Repor__681E60A5] DEFAULT (newid()) NOT NULL,
    [ReportFileTemplate]         NVARCHAR (256)   NULL,
    [SourceStorageTypeID]        INT              NULL,
    [SourceStorageLocation]      NVARCHAR (256)   NULL,
    [DestinationStorageTypeID]   INT              NULL,
    [DestinationStorageLocation] NVARCHAR (256)   NULL,
    [Status]                     INT              CONSTRAINT [DF__ReportFil__Statu__691284DE] DEFAULT ((1)) NOT NULL,
    [Frequency]                  NVARCHAR (256)   NULL,
    [FrequencyStatus]            NVARCHAR (256)   NULL,
    [DocumentStorageID]          NVARCHAR (256)   NULL,
    [DefaultAttributes]          NVARCHAR (MAX)   NULL,
	[IsAllowInput]				 BIT			  NULL,
    CONSTRAINT [PK_ReportFileID] PRIMARY KEY CLUSTERED ([ReportFileID] ASC)
);

