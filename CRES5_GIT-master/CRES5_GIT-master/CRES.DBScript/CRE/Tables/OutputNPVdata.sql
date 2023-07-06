CREATE TABLE [CRE].[OutputNPVdata] (
    [OutputNPVdataID]                  UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [NoteID]                           UNIQUEIDENTIFIER NULL,
    [NPVdate]                          DATE             NULL,
    [CashFlowUsedForLevelYieldPrecap]  DECIMAL (28, 15) NULL,
    [CashFlowUsedForLevelYieldAmort]   DECIMAL (28, 15) NULL,
    [CashFlowAdjustedForServicingInfo] DECIMAL (28, 15) NULL,
    [CreatedBy]                        NVARCHAR (256)   NULL,
    [CreatedDate]                      DATETIME         NULL,
    [UpdatedBy]                        NVARCHAR (256)   NULL,
    [UpdatedDate]                      DATETIME         NULL,
    [TotalStrippedCashFlow]            DECIMAL (28, 15) NULL,
    CONSTRAINT [PK_OutputNPVdataID] PRIMARY KEY CLUSTERED ([OutputNPVdataID] ASC),
    CONSTRAINT [FK_OutputNPVdata_NoteID] FOREIGN KEY ([NoteID]) REFERENCES [CRE].[Note] ([NoteID])
);

