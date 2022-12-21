CREATE TABLE [Core].[FundingScheduleArchieve] (
    [FundingScheduleArchieveID] UNIQUEIDENTIFIER CONSTRAINT [DF__FundingSc__Fundi__36D11DD4] DEFAULT (newid()) NOT NULL,
    [EventId]                   UNIQUEIDENTIFIER NOT NULL,
    [Date]                      DATE             NULL,
    [Value]                     DECIMAL (28, 15) NULL,
    [CreatedBy]                 NVARCHAR (256)   NULL,
    [CreatedDate]               DATETIME         NULL,
    [UpdatedBy]                 NVARCHAR (256)   NULL,
    [UpdatedDate]               DATETIME         NULL,
    [ArchieveDate]              DATETIME         NULL,
    [ArchieveBy]                NVARCHAR (256)   NULL
);

