CREATE TYPE [dbo].[tempOutputNPVdata] AS TABLE (
    [NoteID]                           UNIQUEIDENTIFIER NULL,
    [NPVdate]                          DATE             NULL,
    [CashFlowUsedForLevelYieldPrecap]  DECIMAL (28, 15) NULL,
    [CashFlowUsedForLevelYieldAmort]   DECIMAL (28, 15) NULL,
    [CashFlowAdjustedForServicingInfo] DECIMAL (28, 15) NULL,
    [TotalStrippedCashFlow]            DECIMAL (28, 15) NULL,
    [CreatedBy]                        NVARCHAR (256)   NULL,
    [CreatedDate]                      DATETIME         NULL,
    [UpdatedBy]                        NVARCHAR (256)   NULL,
    [UpdatedDate]                      DATETIME         NULL);

