CREATE TABLE [App].[ActivityLog] (
    [ActivityLogID]      UNIQUEIDENTIFIER CONSTRAINT [DF__ActivityL__Activ__735B0927] DEFAULT (newid()) NOT NULL,
    [ParentModuleID]     UNIQUEIDENTIFIER NULL,
    [ParentModuleTypeID] INT              NULL,
    [ModuleID]           UNIQUEIDENTIFIER NULL,
    [ActivityType]       INT              NULL,
    [DisplayMessage]     NVARCHAR (MAX)   NULL,
    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL,
    [ActivityLogAutoID]  INT              IDENTITY (1, 1) NOT NULL,
    [ModuleIDInt]        INT              NULL,
    CONSTRAINT [PK_ActivityLogID] PRIMARY KEY CLUSTERED ([ActivityLogID] ASC)
);

