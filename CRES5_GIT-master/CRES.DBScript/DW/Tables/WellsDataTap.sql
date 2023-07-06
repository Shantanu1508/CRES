CREATE TABLE [DW].[WellsDataTap] (
    [NoteID]                           NVARCHAR (256)   NULL,
    [TransactionDate]                  DATETIME         NULL,
    [Current_Interest_Paid_To_Date]    DATETIME         NULL,
    [Current_All_In_Interest_Rate]     DECIMAL (28, 15) NULL,
    [Balance_After_Funding_Transacton] DECIMAL (28, 15) NULL,
    [Entry_No]                         INT              NULL,
    [Transaction_Type]                 NVARCHAR (256)   NULL,
    [CreatedBy]                        NVARCHAR (256)   NULL,
    [CreatedDate]                      DATETIME         DEFAULT (getdate()) NULL,
    [UpdatedBy]                        NVARCHAR (256)   NULL,
    [UpdatedDate]                      DATETIME         DEFAULT (getdate()) NULL
);

