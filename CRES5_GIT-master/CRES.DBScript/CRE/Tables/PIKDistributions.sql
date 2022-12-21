CREATE TABLE [CRE].[PIKDistributions] (
    [PIKDistributionsID] UNIQUEIDENTIFIER CONSTRAINT [DF__PIKDistri__PIKDi__473C8FC7] DEFAULT (newid()) NOT NULL,
    [SourceNoteID]       UNIQUEIDENTIFIER NULL,
    [ReceiverNoteID]     UNIQUEIDENTIFIER NULL,
    [TransactionDate]    DATETIME         NULL,
    [Amount]             DECIMAL (28, 15) NULL,
    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL,
    CONSTRAINT [PK_PIKDistributionsID] PRIMARY KEY CLUSTERED ([PIKDistributionsID] ASC)
);

