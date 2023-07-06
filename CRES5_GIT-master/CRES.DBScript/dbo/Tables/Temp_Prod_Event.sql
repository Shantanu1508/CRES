CREATE TABLE [dbo].[Temp_Prod_Event] (
    [EventID]            UNIQUEIDENTIFIER NULL,
    [AccountID]          UNIQUEIDENTIFIER NULL,
    [Date]               DATE             NULL,
    [EventTypeID]        INT              NULL,
    [EffectiveStartDate] DATE             NULL,
    [EffectiveEndDate]   DATE             NULL,
    [SingleEventValue]   DECIMAL (28, 15) NULL,
    [StatusID]           INT              NULL,
    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL,
    [ShardName]          NVARCHAR (256)   NULL
);

