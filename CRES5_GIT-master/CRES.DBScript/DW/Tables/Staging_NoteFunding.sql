CREATE TABLE [DW].[Staging_NoteFunding] (
    [NoteID]                     UNIQUEIDENTIFIER NULL,
    [CRENoteID]                  NVARCHAR (256)   NULL,
    [TransactionDate]            DATE             NULL,
    [Amount]                     DECIMAL (28, 15) NULL,
    [WireConfirm]                BIT              NULL,
    [PurposeBI]                  NVARCHAR (256)   NULL,
    [DrawFundingID]              NVARCHAR (256)   NULL,
    [Comments]                   NVARCHAR (MAX)   NULL,
    [CreatedBy]                  NVARCHAR (256)   NULL,
    [CreatedDate]                DATETIME         NULL,
    [UpdatedBy]                  NVARCHAR (256)   NULL,
    [UpdatedDate]                DATETIME         NULL,
    [Staging_NoteFunding_AutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_Staging_NoteFunding_AutoID] PRIMARY KEY CLUSTERED ([Staging_NoteFunding_AutoID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [iStaging_NoteFunding_NoteID]
    ON [DW].[Staging_NoteFunding]([NoteID] ASC, [CRENoteID] ASC);

