CREATE TABLE [CRE].[TransactionEntryVSTO] (
    [TransactionEntryVSTOID]     INT              IDENTITY (1, 1) NOT NULL,
    [BatchDetailAsyncCalcVSTOId] INT              NOT NULL,
    [CRENoteID]                  NVARCHAR (256)   NOT NULL,
    [Date]                       DATETIME         NULL,
    [Amount]                     DECIMAL (28, 15) NULL,
    [Type]                       NVARCHAR (256)   NULL,
    [FeeName]                    NVARCHAR (256)   NULL,
	SizerScenario                nvarchar(256)   null,
     NoteName                     nvarchar(256) null,
    CONSTRAINT [PK_TransactionEntryVSTOID] PRIMARY KEY CLUSTERED ([TransactionEntryVSTOID] ASC)
);

 