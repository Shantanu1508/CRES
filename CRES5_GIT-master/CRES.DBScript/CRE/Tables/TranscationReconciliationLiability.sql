CREATE TABLE [CRE].[TransactionReconciliationLiability] (
    [Transactionid]    UNIQUEIDENTIFIER CONSTRAINT [DF__Transacti__L_Trans__4CF5691D] DEFAULT (newid()) NOT NULL,
    [DateDue]          DATE             NULL,
    [RemittanceDate]   DATETIME         NULL,
    [ServcerMasterID]  INT              NULL,
    [LiabilityAccountID]    UNIQUEIDENTIFIER NULL,
    [TransactionMode]       NVARCHAR (256)   NULL,
    [DealAccountID]         UNIQUEIDENTIFIER NULL,
    [NoteAccountID]         UNIQUEIDENTIFIER NULL,
    [TransactionType]  NVARCHAR (250)   NULL,
    [TransactionDate]  DATETIME         NULL,
    [ServicingAmount]  DECIMAL (28, 15) NULL,
    [CalculatedAmount] DECIMAL (28, 15) NULL,
    [Delta]            DECIMAL (28, 15) NULL,
    [M61Value]         BIT              CONSTRAINT [DF__Transacti__L_M61Va__4DE98D56] DEFAULT ((0)) NULL,
    [ServicerValue]    BIT              CONSTRAINT [DF__Transacti__L_Servi__4EDDB18F] DEFAULT ((0)) NULL,
    [Ignore]           BIT              CONSTRAINT [DF__Transacti__L_Ignor__4FD1D5C8] DEFAULT ((0)) NULL,
    [OverrideValue]    DECIMAL (28, 15) NULL,
    [comments]         NVARCHAR (MAX)   NULL,
    [PostedDate]       DATETIME         NULL,
    [BatchLogID]       INT              NULL,
    [Deleted]          BIT              CONSTRAINT [DF__Transacti__L_Delet__50C5FA01] DEFAULT ((0)) NULL,
    [CreatedBy]        NVARCHAR (256)   NULL,
    [CreatedDate]      DATETIME         NULL,
    [UpdatedBy]        NVARCHAR (256)   NULL,
    [UpdatedDate]      DATETIME         NULL,
    [Exception]        NVARCHAR (256)   NULL,
    [Adjustment]       DECIMAL (28, 15) NULL,
    [ActualDelta]      DECIMAL (28, 15) NULL,
    [OverrideReason]   INT              NULL,
    SplitTransactionid UNIQUEIDENTIFIER NULL,
    TransactionReconciliation_AutoID int IDENTITY(1,1),
    DueDateAlreadyReconciled bit DEFAULT 0,
    [WriteOffAmount]      DECIMAL (28, 15) NULL
    
);

go
ALTER TABLE [CRE].[TransactionReconciliationLiability]
ADD CONSTRAINT PK_TransactionReconciliation__L_TransactionReconciliation_AutoID PRIMARY KEY (TransactionReconciliation_AutoID);