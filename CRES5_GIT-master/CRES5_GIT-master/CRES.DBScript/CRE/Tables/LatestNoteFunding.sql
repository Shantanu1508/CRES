CREATE TABLE [CRE].[LatestNoteFunding] (
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
    [UpdatedDate]     DATETIME         NULL,
    LatestNoteFundingID int IDENTITY(1,1)
);


go
ALTER TABLE [CRE].[LatestNoteFunding]
ADD CONSTRAINT PK_LatestNoteFunding_LatestNoteFundingID PRIMARY KEY (LatestNoteFundingID);
