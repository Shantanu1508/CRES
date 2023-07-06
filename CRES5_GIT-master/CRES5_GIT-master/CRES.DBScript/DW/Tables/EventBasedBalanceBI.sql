CREATE TABLE [DW].[EventBasedBalanceBI] (
    [analysisid]             UNIQUEIDENTIFIER NULL,
    [analysisName]           NVARCHAR (256)   NULL,
    [Noteid]                 NVARCHAR (256)   NULL,
    [PeriodEndDate]          DATE             NULL,
    [EventDate]              DATE             NULL,
    [EndingBalance]          DECIMAL (28, 15) NULL,
    [Amount]                 DECIMAL (28, 15) NULL,
    [EstimatedEndingBalance] DECIMAL (28, 15) NULL
);


GO
CREATE NONCLUSTERED INDEX [iEventBasedBalanceBI_analysisid]
    ON [DW].[EventBasedBalanceBI]([analysisid] ASC);


GO
CREATE NONCLUSTERED INDEX [iEventBasedBalanceBI_Noteid]
    ON [DW].[EventBasedBalanceBI]([Noteid] ASC);

