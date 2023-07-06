CREATE TABLE [DW].[L_UwNoteFundingBI] (
    [FundingID]          INT              NULL,
    [Noteid_F]           INT              NULL,
    [Applied]            BIT              NULL,
    [FundingDate]        DATETIME         NULL,
    [FundingAmount]      DECIMAL (28, 15) NULL,
    [Comments]           NVARCHAR (MAX)   NULL,
    [AuditAddDate]       DATETIME         NULL,
    [AuditAddUserId]     NVARCHAR (150)   NULL,
    [AuditUpdateDate]    DATETIME         NULL,
    [AuditUpdateUserId]  NVARCHAR (150)   NULL,
    [FundingCSPrincipal] DECIMAL (28, 15) NULL,
    [FundingLBInterest]  FLOAT (53)       NULL,
    [FundingLBLock]      BIT              NULL,
    [FundingPurposeCD_F] NVARCHAR (256)   NULL,
    [FundingDrawId]      NVARCHAR (256)   NULL,
    [FundingExpense]     DECIMAL (28, 15) NULL,
    [ExpenseComments]    NVARCHAR (MAX)   NULL,
    [WireConfirm]        BIT              NULL
);

