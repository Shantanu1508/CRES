
--Drop TABLE [CRE].[TransactionReconciliationDetail]

CREATE TABLE [CRE].[TransactionReconciliationDetail] (
    [Transactiondetailid]    UNIQUEIDENTIFIER  DEFAULT (newid()) NOT NULL,
	[Transactionid]    UNIQUEIDENTIFIER NULL,
    [DateDue]          DATE             NULL,
    [RemittanceDate]   DATETIME         NULL,
    [ServcerMasterID]  INT              NULL,
    [DealId]           UNIQUEIDENTIFIER NULL,
    [NoteID]           UNIQUEIDENTIFIER NULL,
    [TransactionType]  NVARCHAR (250)   NULL,
    [TransactionDate]  DATETIME         NULL,
    [ServicingAmount]  DECIMAL (28, 15) NULL,
    [CalculatedAmount] DECIMAL (28, 15) NULL,
    [Delta]            DECIMAL (28, 15) NULL,
    [M61Value]         BIT              DEFAULT ((0)) NULL,
    [ServicerValue]    BIT              DEFAULT ((0)) NULL,
    [Ignore]           BIT              DEFAULT ((0)) NULL,
    [OverrideValue]    DECIMAL (28, 15) NULL,
    [comments]         NVARCHAR (MAX)   NULL,
    [PostedDate]       DATETIME         NULL,
    [BatchLogID]       INT              NULL,
    [Deleted]          BIT               DEFAULT ((0)) NULL,
    [Exception]        NVARCHAR (256)   NULL,
    [Adjustment]       DECIMAL (28, 15) NULL,
    [ActualDelta]      DECIMAL (28, 15) NULL,
    [AddlInterest]     DECIMAL (28, 15) NULL,
    [TotalInterest]    DECIMAL (28, 15) NULL,
    [OverrideReason]   INT              NULL,
    [BerAddlint]       DECIMAL (28, 15) NULL,
    [InterestAdj]      DECIMAL (28, 15) NULL,
    TransactionReconciliationDetail_AutoID int IDENTITY(1,1)
);

go
ALTER TABLE [CRE].[TransactionReconciliationDetail]
ADD CONSTRAINT PK_TransactionReconciliationDetail_TransactionReconciliationDetail_AutoID PRIMARY KEY (TransactionReconciliationDetail_AutoID);