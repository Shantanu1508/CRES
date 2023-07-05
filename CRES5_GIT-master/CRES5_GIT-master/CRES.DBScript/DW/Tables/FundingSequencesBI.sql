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
    [UpdatedDate]                DATETIME         NULL
);


GO
CREATE NONCLUSTERED INDEX [iFundingSequencesBI_CRENoteID]
    ON [DW].[FundingSequencesBI]([CRENoteID] ASC);


GO
CREATE NONCLUSTERED INDEX [iFundingSequencesBI_CRENoteID_SequenceNo]
    ON [DW].[FundingSequencesBI]([CRENoteID] ASC, [SequenceNo] ASC);

