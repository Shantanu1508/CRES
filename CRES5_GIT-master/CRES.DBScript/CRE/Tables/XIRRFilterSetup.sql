CREATE TABLE [CRE].[XIRRFilterSetup] (
    [XIRRFilterSetupID]        INT            IDENTITY (1, 1) NOT NULL,
    [Name]                     NVARCHAR (256) NULL,
    [SortOrder]                INT            NULL,
    [FilterDataType]           NVARCHAR (256) NULL,
    [CreatedBy]                NVARCHAR (256) NULL,
    [CreatedDate]              DATETIME       NULL,
    [UpdatedBy]                NVARCHAR (256) NULL,
    [UpdatedDate]              DATETIME       NULL,
    [ReferenceTableName]       NVARCHAR (256) NULL,
    [ReferenceColumnName]      NVARCHAR (256) NULL,
    [ReferenceColumnAliasName] NVARCHAR (256) NULL,
    CONSTRAINT [PK_XIRRFilterSetupID] PRIMARY KEY CLUSTERED ([XIRRFilterSetupID] ASC)
);
GO

