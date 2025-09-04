CREATE TABLE [DW].[NoteFundingScheduleBI] (
    [CRENoteID]                    NVARCHAR (256)   NULL,
    [Date]                         DATE             NULL,
    [Amount]                       DECIMAL (28, 15) NULL,
    [PurposeID]                    INT              NULL,
    [PurposeBI]                    NVARCHAR (256)   NULL,
    [WireConfirm]                  BIT              NULL,
    [Comments]                     NVARCHAR (MAX)   NULL,
    [DrawFundingID]                NVARCHAR (256)   NULL,
    [CreatedBy]                    NVARCHAR (256)   NULL,
    [CreatedDate]                  DATETIME         NULL,
    [UpdatedBy]                    NVARCHAR (256)   NULL,
    [UpdatedDate]                  DATETIME         NULL,
    [Projected]                    NVARCHAR (100)   NULL,
    [GeneratedBy]                  INT              NULL,
    [GeneratedByBI]                NVARCHAR (100)   NULL,
    [NoteFundingScheduleBI_AutoID] INT              IDENTITY (1, 1) NOT NULL,
    AdjustmentType int,
    AdjustmentTypeBI nvarchar(256),
    WF_CurrentStatusDisplayName nvarchar(256)
    CONSTRAINT [PK_NoteFundingScheduleBI_AutoID] PRIMARY KEY CLUSTERED ([NoteFundingScheduleBI_AutoID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [iNoteFundingScheduleBI_CRENoteID]
    ON [DW].[NoteFundingScheduleBI]([CRENoteID] ASC);


GO
CREATE NONCLUSTERED INDEX [iNoteFundingScheduleBI_CRENoteID_Date]
    ON [DW].[NoteFundingScheduleBI]([CRENoteID] ASC, [Date] ASC);

