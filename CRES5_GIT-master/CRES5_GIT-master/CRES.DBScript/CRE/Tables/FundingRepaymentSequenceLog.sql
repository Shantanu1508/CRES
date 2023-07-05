CREATE TABLE [CRE].[FundingRepaymentSequenceLog] (
    [FundingRepaymentSequenceLogID] INT              IDENTITY (1, 1) NOT NULL,
    [FundingRepaymentSequenceID]    UNIQUEIDENTIFIER NOT NULL,
    [NoteID]                        UNIQUEIDENTIFIER NOT NULL,
    [SequenceNo]                    INT              NULL,
    [SequenceType]                  INT              NULL,
    [Value]                         DECIMAL (28, 15) NULL,
    [CreatedBy]                     NVARCHAR (256)   NULL,
    [CreatedDate]                   DATETIME         NULL,
    [UpdatedBy]                     NVARCHAR (256)   NULL,
    [UpdatedDate]                   DATETIME         NULL,
    [LogDate]                       DATETIME         NULL
);

go
ALTER TABLE [CRE].[FundingRepaymentSequenceLog]
ADD CONSTRAINT PK_FundingRepaymentSequenceLog_FundingRepaymentSequenceLogID PRIMARY KEY ([FundingRepaymentSequenceLogID]);