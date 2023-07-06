CREATE TABLE [App].[ModuleTabMaster] (
    [ModuleTabMasterID] INT            IDENTITY (1, 1) NOT NULL,
    [ModuleTabName]     NVARCHAR (MAX) NOT NULL,
    [ParentID]          INT            NULL,
    [StatusID]          INT            NULL,
    [CreatedBy]         NVARCHAR (256) NULL,
    [CreatedDate]       DATETIME       NULL,
    [UpdatedBy]         NVARCHAR (256) NULL,
    [UpdatedDate]       DATETIME       NULL,
    [SortOrder]         INT            NULL,
    [DisplayName]       NVARCHAR (MAX) NULL,
    [ModuleType]        NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_ModuleTabMaster] PRIMARY KEY CLUSTERED ([ModuleTabMasterID] ASC)
);

