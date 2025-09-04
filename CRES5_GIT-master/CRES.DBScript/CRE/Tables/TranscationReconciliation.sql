CREATE TABLE [CRE].[TranscationReconciliation] (
    [Transcationid]    UNIQUEIDENTIFIER CONSTRAINT [DF__Transcati__Trans__4CF5691D] DEFAULT (newid()) NOT NULL,
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
    [M61Value]         BIT              CONSTRAINT [DF__Transcati__M61Va__4DE98D56] DEFAULT ((0)) NULL,
    [ServicerValue]    BIT              CONSTRAINT [DF__Transcati__Servi__4EDDB18F] DEFAULT ((0)) NULL,
    [Ignore]           BIT              CONSTRAINT [DF__Transcati__Ignor__4FD1D5C8] DEFAULT ((0)) NULL,
    [OverrideValue]    DECIMAL (28, 15) NULL,
    [comments]         NVARCHAR (MAX)   NULL,
    [PostedDate]       DATETIME         NULL,
    [BatchLogID]       INT              NULL,
    [Deleted]          BIT              CONSTRAINT [DF__Transcati__Delet__50C5FA01] DEFAULT ((0)) NULL,
    [CreatedBy]        NVARCHAR (256)   NULL,
    [CreatedDate]      DATETIME         NULL,
    [UpdatedBy]        NVARCHAR (256)   NULL,
    [UpdatedDate]      DATETIME         NULL,
    [Exception]        NVARCHAR (256)   NULL,
    [Adjustment]       DECIMAL (28, 15) NULL,
    [ActualDelta]      DECIMAL (28, 15) NULL,
    [AddlInterest]     DECIMAL (28, 15) NULL,
    [TotalInterest]    DECIMAL (28, 15) NULL,
    [OverrideReason]   INT              NULL,
    [BerAddlint]       DECIMAL (28, 15) NULL,
    [InterestAdj]      DECIMAL (28, 15) NULL,
    SplitTransactionid UNIQUEIDENTIFIER NULL,

    TranscationReconciliation_AutoID int IDENTITY(1,1),
    DueDateAlreadyReconciled bit DEFAULT 0,
    [WriteOffAmount]      DECIMAL (28, 15) NULL
    
);

go
ALTER TABLE [CRE].[TranscationReconciliation]
ADD CONSTRAINT PK_TranscationReconciliation_TranscationReconciliation_AutoID PRIMARY KEY (TranscationReconciliation_AutoID);