CREATE TABLE [CRE].[PayruleDistributions] (
    [PayruleDistributionsID]     UNIQUEIDENTIFIER CONSTRAINT [DF__PayruleDi__Payru__24B26D99] DEFAULT (newid()) NOT NULL,
    [SourceNoteID]               UNIQUEIDENTIFIER NULL,
    [ReceiverNoteID]             UNIQUEIDENTIFIER NULL,
    [TransactionDate]            DATETIME         NULL,
    [Amount]                     DECIMAL (28, 15) NULL,
    [RuleID]                     INT              NULL,
    [CreatedBy]                  NVARCHAR (256)   NULL,
    [CreatedDate]                DATETIME         NULL,
    [UpdatedBy]                  NVARCHAR (256)   NULL,
    [UpdatedDate]                DATETIME         NULL,
    [FeeName]                    NVARCHAR (256)   NULL,
    [AnalysisID]                 UNIQUEIDENTIFIER NULL,
    [PayruleDistributionsAutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_PayruleDistributionsID] PRIMARY KEY CLUSTERED ([PayruleDistributionsID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [nci_wi_PayruleDistributions_91D48F987244745C408A42894562D895]
    ON [CRE].[PayruleDistributions]([ReceiverNoteID] ASC, [SourceNoteID] ASC);

