CREATE TABLE [DW].[L_FundingSequencesBI] (
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

