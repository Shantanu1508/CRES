CREATE TABLE [DW].[L_DealFundingSchduleBI] (
    [DealFundingID] UNIQUEIDENTIFIER NOT NULL,
    [DealID]        UNIQUEIDENTIFIER NOT NULL,
    [CREDealID]     NVARCHAR (256)   NULL,
    [Date]          DATE             NULL,
    [Amount]        DECIMAL (28, 15) NULL,
    [Comment]       NVARCHAR (MAX)   NULL,
    [PurposeID]     INT              NULL,
    [PurposeBI]     NVARCHAR (256)   NULL,
    [Applied]       BIT              NULL,
    [DrawFundingId] NVARCHAR (256)   NULL,
    [CreatedBy]     NVARCHAR (256)   NULL,
    [CreatedDate]   DATETIME         NULL,
    [UpdatedBy]     NVARCHAR (256)   NULL,
    [UpdatedDate]   DATETIME         NULL,
    [Projected] NVARCHAR(100) NULL,
    GeneratedBy int null,
    GeneratedByBI NVARCHAR(100) NULL
);

