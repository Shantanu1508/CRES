CREATE TABLE [CRE].[DealArchieveTable] (
    [ScheduleArchieveTableid] UNIQUEIDENTIFIER CONSTRAINT [DF__DealArchi__Sched__6CA31EA0] DEFAULT (newid()) NOT NULL,
    [DealFundingID]           UNIQUEIDENTIFIER NULL,
    [DealID]                  UNIQUEIDENTIFIER NOT NULL,
    [Date]                    DATE             NULL,
    [Amount]                  DECIMAL (28, 15) NULL,
    [Comment]                 NVARCHAR (MAX)   NULL,
    [PurposeID]               INT              NULL,
    [CreatedBy]               NVARCHAR (256)   NULL,
    [CreatedDate]             DATETIME         NULL,
    [UpdatedBy]               NVARCHAR (256)   NULL,
    [UpdatedDate]             DATETIME         NULL,
    [ArchieveBy]              NVARCHAR (256)   NULL,
    [ArchieveDate]            DATE             NULL
);

