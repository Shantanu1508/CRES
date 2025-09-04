CREATE TABLE [CRE].[FundingRepaymentSequenceWriteOff] (
    [FundingRepaymentSequenceWriteOffID]		UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [DealID]									UNIQUEIDENTIFIER NOT NULL,
    [NoteID]									UNIQUEIDENTIFIER NOT NULL,
    [PriorityOverride]							INT              NULL,
    [CreatedBy]									NVARCHAR (256)   NULL,
    [CreatedDate]								DATETIME         NULL,
    [UpdatedBy]									NVARCHAR (256)   NULL,
    [UpdatedDate]								DATETIME         NULL,
    [FundingRepaymentSequenceWriteOffAutoID]	INT	IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_FundingRepaymentSequenceWriteOffID] PRIMARY KEY CLUSTERED ([FundingRepaymentSequenceWriteOffID] ASC),
);