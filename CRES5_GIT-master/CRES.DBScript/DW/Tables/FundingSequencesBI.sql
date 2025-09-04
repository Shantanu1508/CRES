CREATE TABLE [DW].[FundingSequencesBI] (
    [FundingRepaymentSequenceID] UNIQUEIDENTIFIER NULL,
    [NoteID]                     UNIQUEIDENTIFIER NULL,
    [CRENoteID]                  NVARCHAR (256)   NULL,
    [SequenceNo]                 INT              NULL,
    [SequenceType]               INT              NULL,
    [SequenceTypeBI]             NVARCHAR (256)   NULL,
    [Value]                      DECIMAL (28, 15) NULL,
    [CreatedBy]                  NVARCHAR (256)   NULL,
    [CreatedDate]                DATETIME         NULL,
    [UpdatedBy]                  NVARCHAR (256)   NULL,
    [UpdatedDate]                DATETIME         NULL,
    [FundingSequencesBI_AutoID]  INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_FundingSequencesBI_AutoID] PRIMARY KEY CLUSTERED ([FundingSequencesBI_AutoID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [iFundingSequencesBI_CRENoteID]
    ON [DW].[FundingSequencesBI]([CRENoteID] ASC);


GO
CREATE NONCLUSTERED INDEX [iFundingSequencesBI_CRENoteID_SequenceNo]
    ON [DW].[FundingSequencesBI]([CRENoteID] ASC, [SequenceNo] ASC);

