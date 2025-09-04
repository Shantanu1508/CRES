CREATE TABLE [CRE].[FundingRepaymentSequence] (
    [FundingRepaymentSequenceID]     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [NoteID]                         UNIQUEIDENTIFIER NOT NULL,
    [SequenceNo]                     INT              NULL,
    [SequenceType]                   INT              NULL,
    [Value]                          DECIMAL (28, 15) NULL,
    [CreatedBy]                      NVARCHAR (256)   NULL,
    [CreatedDate]                    DATETIME         NULL,
    [UpdatedBy]                      NVARCHAR (256)   NULL,
    [UpdatedDate]                    DATETIME         NULL,
    [FundingRepaymentSequenceAutoID] INT              IDENTITY (1, 1) NOT NULL,
    [Remark]                         NVARCHAR (256)   NULL,
    CONSTRAINT [PK_FundingRepaymentSequenceID] PRIMARY KEY CLUSTERED ([FundingRepaymentSequenceID] ASC),
    CONSTRAINT [FK_FundingRepaymentSequence_NoteID] FOREIGN KEY ([NoteID]) REFERENCES [CRE].[Note] ([NoteID])
);


GO
CREATE NONCLUSTERED INDEX [nci_wi_FundingRepaymentSequence_CE86E6382A613C142D1A63FAD38B3368]
    ON [CRE].[FundingRepaymentSequence]([NoteID] ASC)
    INCLUDE([SequenceNo], [SequenceType], [Value]);


GO
CREATE NONCLUSTERED INDEX [IX_FundingRepaymentSequence_FundingRepaymentSequenceAutoID]
    ON [CRE].[FundingRepaymentSequence]([FundingRepaymentSequenceAutoID] ASC);

