CREATE TABLE [App].[ReportSetting] (
    [ReportSettingID]     INT            IDENTITY (1, 1) NOT NULL,
    [ReportName]          NVARCHAR (256) NULL,
    [SheetName]           NVARCHAR (256) NULL,
    [DataSourceProcedure] NVARCHAR (256) NULL,
    [ReportFormat]        NVARCHAR (256) NULL,
    [ReportTemplate]      NVARCHAR (256) NULL,
    [ReportJSON]          NVARCHAR (256) NULL,
    [HeaderPosition]      INT            NULL,
    [LocatioType]         NVARCHAR (256) NULL,
    [Status]              INT            CONSTRAINT [DF__ReportSet__Statu__4A83DC1D] DEFAULT ((1)) NOT NULL
);
go
ALTER TABLE [App].[ReportSetting]
ADD CONSTRAINT PK_ReportSetting_ReportSettingID PRIMARY KEY ([ReportSettingID]);

