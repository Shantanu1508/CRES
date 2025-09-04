CREATE TABLE [CRE].[TransactionAuditLogLiability] (
    [TransactionAuditLogID] UNIQUEIDENTIFIER CONSTRAINT [DF__Transacti__Trans_L__6E565CE8] DEFAULT (newid()) NOT NULL,
    [BatchLogID]            INT              NOT NULL,
    [LiabilityAccountID]    UNIQUEIDENTIFIER NULL,
    [TransactionMode]       NVARCHAR (256)   NULL,
    [DealAccountID]         UNIQUEIDENTIFIER NULL,
    [NoteAccountID]         UNIQUEIDENTIFIER NULL,
    [TransactionType]       NVARCHAR (250)   NULL,
    [DueDate]               DATETIME         NULL,
    [RemitDate]             DATETIME         NULL,
    [ServicingAmount]       DECIMAL (28, 15) NULL,
    [Comment]               NVARCHAR (MAX)   NULL,
    [TotalRemit]            DECIMAL (28, 15) NULL,
    [Status]                NVARCHAR (250)   NULL,
    [ServicerMasterID]      INT              NULL,
    [TransactionDate]       DATETIME         NULL,
    [IsDeleted]             BIT              CONSTRAINT [DF__Transacti___L_IsDel__57BDDBAA] DEFAULT ((0)) NULL,
    [ReconFlag]               nvarchar(50)      NULL,
    [CreatedBy]             NVARCHAR (256)   NULL,
    [CreatedDate]           DATETIME         NULL,
    [UpdatedBy]             NVARCHAR (256)   NULL,
    [UpdatedDate]           DATETIME ,	
    TransactionAuditLog_AutoID int IDENTITY(1,1)
    
);

go
ALTER TABLE [CRE].[TransactionAuditLogLiability]
ADD CONSTRAINT PK_TransactionAuditLog_L_TransactionAuditLogID PRIMARY KEY (TransactionAuditLog_AutoID);
