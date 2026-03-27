CREATE TABLE [CRE].[XIRROutputDetail] (
    [XIRROutputDetailID] INT              IDENTITY (1, 1) NOT NULL,
    [XIRRConfigID]       INT              NULL,
    [AccountId]          UNIQUEIDENTIFIER NULL,
    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL,
    [AnalysisID]         UNIQUEIDENTIFIER NULL,
    [ObjectType]         NVARCHAR (256)   NULL,
    [ObjectID]           UNIQUEIDENTIFIER NULL,
    [TransactionType]    NVARCHAR (256)   NULL,
    [TransactionDate]    DATE             NULL,
    [Amount]             DECIMAL (28, 15) NULL,
    CONSTRAINT [PK_XIRROutputDetailID] PRIMARY KEY CLUSTERED ([XIRROutputDetailID] ASC),
    CONSTRAINT [FK_XIRROutputDetail_XIRRConfigID] FOREIGN KEY ([XIRRConfigID]) REFERENCES [CRE].[XIRRConfig] ([XIRRConfigID])
);
GO

