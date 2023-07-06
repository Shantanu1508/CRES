CREATE TABLE [App].[ReportFileSheet] (
    [ReportFileSheetID]   INT            IDENTITY (1, 1) NOT NULL,
    [ReportFileID]        INT            NULL,
    [SheetName]           NVARCHAR (256) NULL,
    [DataSourceProcedure] NVARCHAR (256) NULL,
    [DefaultAttributes]   NVARCHAR (MAX) NULL,
    [HeaderPosition]      INT            CONSTRAINT [DF__ReportFil__Heade__1BFDF75E] DEFAULT ((0)) NOT NULL,
	[IsIncludeHeader]     BIT NULL,
	[AdditionalParameters] NVARCHAR(MAX) NULL,
    CONSTRAINT [PK_ReportFileSheetID] PRIMARY KEY CLUSTERED ([ReportFileSheetID] ASC),
    CONSTRAINT [FK_ReportFileSheet_ReportFileID] FOREIGN KEY ([ReportFileID]) REFERENCES [App].[ReportFile] ([ReportFileID])
);

