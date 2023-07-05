CREATE TABLE [dbo].[ServicingData] (
    [effective_date]    DATETIME2 (7) NOT NULL,
    [old_loan_number]   NVARCHAR (50) NOT NULL,
    [principal_balance] FLOAT (53)    NOT NULL,
    CONSTRAINT [PK_ServicingData] PRIMARY KEY CLUSTERED ([effective_date] ASC, [old_loan_number] ASC)
);

