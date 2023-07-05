CREATE EXTERNAL TABLE [dbo].[tblEscrow] (
    [EscrowId] INT NULL,
    [ControlMasterId_F] NVARCHAR (10) NULL,
    [NoteId_F] INT NULL,
    [PropertyId_F] INT NULL,
    [EscrowTypeCode] NVARCHAR (25) NULL,
    [EscrowTypeDesc] NVARCHAR (50) NULL,
    [InitialBalance] MONEY NULL,
    [CurrentBalance] MONEY NULL,
    [MonthlyBalance] MONEY NULL,
    [PledgedToLender] NVARCHAR (3) NULL,
    [BalanceAsOfDate] DATETIME NULL,
    [ReserveType] NVARCHAR (40) NULL,
    [SortOrder] INT NULL,
    [AuditAddDate] DATETIME NULL,
    [AuditAddUserId] NVARCHAR (150) NULL,
    [AuditUpdateDate] DATETIME NULL,
    [AuditUpdateUserId] NVARCHAR (150) NULL,
    [EscrowStatus] NVARCHAR (20) NULL,
    [EscrowCap] MONEY NULL,
    [InterestEarnedCredited] NVARCHAR (40) NULL,
    [EscrowLock] BIT NULL,
    [ReserveBalanceAtContribution] MONEY NULL,
    [EscrowDisbursement] MONEY NULL,
    [LOCExpirationDate] DATETIME NULL,
    [EscrowAccountNumber] NVARCHAR (50) NULL,
    [EscrowDueDate] DATETIME NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceData]
    );

