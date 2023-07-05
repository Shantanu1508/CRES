CREATE TABLE [CRE].[BatchDetailAsyncCalcVSTO] (
    [BatchDetailAsyncCalcVSTOId] INT            IDENTITY (1, 1) NOT NULL,
    [BatchLogAsyncCalcVSTOID]    INT            NOT NULL,
    [CRENoteID]                  NVARCHAR (256) NULL,
    [Status]                     NVARCHAR (50)  NULL,
    [StartTime]                  DATETIME       NULL,
    [EndTime]                    DATETIME       NULL,
	SizerScenario                nvarchar(256)
    CONSTRAINT [PK_BatchDetailAsyncCalcVSTOD] PRIMARY KEY CLUSTERED ([BatchDetailAsyncCalcVSTOId] ASC),
    CONSTRAINT [FK_BatchLogAsyncCalcVSTO_BatchLogAsyncCalcVSTOID] FOREIGN KEY ([BatchLogAsyncCalcVSTOID]) REFERENCES [CRE].[BatchLogAsyncCalcVSTO] ([BatchLogAsyncCalcVSTOID])
);

