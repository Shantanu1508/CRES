CREATE TABLE [DW].[L_NoteFundingScheduleBI] (
    [CRENoteID]     NVARCHAR (256)   NULL,
    [Date]          DATE             NULL,
    [Amount]        DECIMAL (28, 15) NULL,
    [PurposeID]     INT              NULL,
    [PurposeBI]     NVARCHAR (256)   NULL,
    [WireConfirm]   BIT              NULL,
    [Comments]      NVARCHAR (MAX)   NULL,
    [DrawFundingID] NVARCHAR (256)   NULL,
    [CreatedBy]     NVARCHAR (256)   NULL,
    [CreatedDate]   DATETIME         NULL,
    [UpdatedBy]     NVARCHAR (256)   NULL,
    [UpdatedDate]   DATETIME         NULL,
    [Projected] NVARCHAR(100) NULL,
    GeneratedBy int null,
    GeneratedByBI NVARCHAR(100) NULL
);

