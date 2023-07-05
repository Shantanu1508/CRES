CREATE EXTERNAL TABLE [dbo].[tblPrepayment] (
    [PrepaymentId_NoteId_F] INT NULL,
    [GracePeriod] INT NULL,
    [LateFee] FLOAT (53) NULL,
    [MonetaryDefaultDays] INT NULL,
    [DefaultRate] FLOAT (53) NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceData]
    );

