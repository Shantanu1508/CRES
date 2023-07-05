CREATE TYPE [dbo].[TableTypeTransactionEntryVSTO] AS TABLE (
    [BatchDetailAsyncCalcVSTOId] INT              NULL,
    [CRENoteID]                  NVARCHAR (256)   NULL,
    [Type]                       NVARCHAR (256)   NULL,
    [Date]                       DATE             NULL,
    [Amount]                     DECIMAL (28, 15) NULL,
    [FeeName]                    NVARCHAR (256)   NULL,
	SizerScenario                 nvarchar(256) null,
	NoteName                     nvarchar(256) null
	);

