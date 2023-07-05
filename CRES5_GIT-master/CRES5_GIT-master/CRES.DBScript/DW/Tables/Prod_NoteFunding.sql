CREATE TABLE [DW].[Prod_NoteFunding] (
    [NoteID]          UNIQUEIDENTIFIER NULL,
    [CRENoteID]       NVARCHAR (256)   NULL,
    [TransactionDate] DATE             NULL,
    [Amount]          DECIMAL (28, 15) NULL,
    [WireConfirm]     BIT              NULL,
    [PurposeBI]       NVARCHAR (256)   NULL,
    [DrawFundingID]   NVARCHAR (256)   NULL,
    [Comments]        NVARCHAR (MAX)   NULL,
    [CreatedBy]       NVARCHAR (256)   NULL,
    [CreatedDate]     DATETIME         NULL,
    [UpdatedBy]       NVARCHAR (256)   NULL,
    [UpdatedDate]     DATETIME         NULL
);


GO
CREATE NONCLUSTERED INDEX [iProd_NoteFunding_NoteID]
    ON [DW].[Prod_NoteFunding]([NoteID] ASC, [CRENoteID] ASC);

