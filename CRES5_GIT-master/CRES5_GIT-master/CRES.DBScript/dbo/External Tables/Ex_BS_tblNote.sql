CREATE EXTERNAL TABLE [dbo].[Ex_BS_tblNote] (
    [NoteId] INT NOT NULL,
    [ControlId_F] NVARCHAR (10) NOT NULL,
    [NoteName] NVARCHAR (60) NOT NULL,
    [FirstPIPaymentDate] DATETIME NULL,
    [StubAmortBalanceAmt] FLOAT (53) NULL,
    [OrigLoanAmount] MONEY NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceData],
    SCHEMA_NAME = N'dbo',
    OBJECT_NAME = N'tblnote'
    );

