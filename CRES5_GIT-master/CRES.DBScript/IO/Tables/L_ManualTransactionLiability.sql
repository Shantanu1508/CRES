
CREATE TABLE [IO].[L_ManualTransactionLiability] (
    [LandingID]      UNIQUEIDENTIFIER CONSTRAINT [DF__L_ManualTL__Landi__7ABC33CD] DEFAULT (newid()) NOT NULL,
    [FileBatchlogid] INT              NULL,
    [LiabilityName]  NVARCHAR (256)   NULL,
    [TransactionMode]  NVARCHAR (256)   NULL,
    [CREDealID]  NVARCHAR (256)   NULL,
    [DealName]  NVARCHAR (256)   NULL,
    [CRENoteID]         NVARCHAR (256)   NULL,
    [NoteName]       NVARCHAR (256)   NULL,
    [DueDate]        DATETIME         NULL,
    [RemitDate]      DATETIME         NULL,
    [ValueType]      NVARCHAR (256)   NULL,
    [Value]          DECIMAL (28, 15) NULL,
    L_ManualTransaction_AutoID int IDENTITY(1,1)
);

 
go
ALTER TABLE [IO].[L_ManualTransactionLiability]
ADD CONSTRAINT PK_L_ManualTransactionL_L_ManualTransaction_AutoID PRIMARY KEY (L_ManualTransaction_AutoID);



