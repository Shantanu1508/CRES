CREATE TABLE [App].[SchedulerConfig] (
    [SchedulerConfigID]      INT            IDENTITY (1, 1) NOT NULL,
    [SchedulerName]          NVARCHAR (256) NULL,
    [APIname]                NVARCHAR (500) NULL,
    [Description]            NVARCHAR (MAX) NULL,
    [ObjectTypeID]           NVARCHAR (256) NULL,
    [ObjectID]               INT            NULL,
    [ExecutionTime]          NVARCHAR (50)  NULL,
    [NextexecutionTime]      DATETIME       NULL,
    [Frequency]              NVARCHAR (256) NULL,
    [Status]                 INT            DEFAULT ((0)) NULL,
    [JobStatus]              NVARCHAR (256) NULL,
    [IsEnableDayLightSaving] INT            DEFAULT ((0)) NULL,
    [Timezone]               NVARCHAR (256) NULL,
    [FailureCount]           INT            DEFAULT ((0)) NULL,
    [CreatedBy]              NVARCHAR (256) NULL,
    [CreatedDate]            DATETIME       NULL,
    [UpdatedBy]              NVARCHAR (256) NULL,
    [UpdatedDate]            DATETIME       NULL,
    [GroupID]                INT            DEFAULT ((1)) NULL,
    [ServerIndex]            INT            DEFAULT ((1)) NULL,
    [SortOrder]              INT            NULL,
    CONSTRAINT [PK_SchedulerConfig_SchedulerConfigID] PRIMARY KEY CLUSTERED ([SchedulerConfigID] ASC)
);



