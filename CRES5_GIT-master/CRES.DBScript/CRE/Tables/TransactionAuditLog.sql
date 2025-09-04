CREATE TABLE [CRE].[TransactionAuditLog] (
    [TransactionAuditLogID] UNIQUEIDENTIFIER CONSTRAINT [DF__Transacti__Trans__6E565CE8] DEFAULT (newid()) NOT NULL,
    [BatchLogID]            INT              NOT NULL,
    [NoteID]                UNIQUEIDENTIFIER NOT NULL,
    [TransactionType]       NVARCHAR (250)   NULL,
    [DueDate]               DATETIME         NULL,
    [RemitDate]             DATETIME         NULL,
    [ServicingAmount]       DECIMAL (28, 15) NULL,
    [Comment]               NVARCHAR (MAX)   NULL,
    [TotalRemit]            DECIMAL (28, 15) NULL,
    [Status]                NVARCHAR (250)   NULL,
    [ServicerMasterID]      INT              NULL,
    [TransactionDate]       DATETIME         NULL,
    [IsDeleted]             BIT              CONSTRAINT [DF__Transacti__IsDel__57BDDBAA] DEFAULT ((0)) NULL,
    ReconFlag               nvarchar(50)      NULL,
     [CreatedBy]             NVARCHAR (256)   NULL,
    [CreatedDate]           DATETIME         NULL,
    [UpdatedBy]             NVARCHAR (256)   NULL,
    [UpdatedDate]           DATETIME ,	
    TransactionAuditLog_AutoID int IDENTITY(1,1),
    CRENoteID 				NVARCHAR (256)   NULL,
);

go
ALTER TABLE [CRE].[TransactionAuditLog]
ADD CONSTRAINT PK_TransactionAuditLog_TransactionAuditLogID PRIMARY KEY (TransactionAuditLog_AutoID);