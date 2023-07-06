CREATE TABLE [CRE].[DealReserve] (
    [EscrowId]               INT              NULL,
    [InterestEarnedCredited] NVARCHAR (256)   NULL,
    [LoanNumber]             NVARCHAR (256)   NULL,
    [DealName]               NVARCHAR (256)   NULL,
    [SortOrder]              INT              NULL,
    [EscrowType]             NVARCHAR (256)   NULL,
    [EscrowTypeDesc]         NVARCHAR (256)   NULL,
    [MonthlyBalance]         DECIMAL (28, 15) NULL,
    [BalanceAsOfDate]        DATE             NULL,
    [ReserveType]            NVARCHAR (256)   NULL,
    [EscrowStatusDesc]       NVARCHAR (256)   NULL,
    [EscrowStatus]           NVARCHAR (256)   NULL,
    [IORPLANCODE]            NVARCHAR (256)   NULL,
    DealReserve_AutoID int IDENTITY(1,1)
);
go


ALTER TABLE [CRE].[DealReserve]
ADD CONSTRAINT PK_DealReserve_DealReserveID PRIMARY KEY (DealReserve_AutoID);

