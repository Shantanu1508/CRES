CREATE EXTERNAL TABLE [dbo].[tblzCdEscrowStatus] (
    [EscrowStatusCD] NVARCHAR (3) NULL,
    [EscrowStatusDesc] NVARCHAR (50) NULL,
    [OrderKey] INT NULL,
    [InactiveSw] BIT NOT NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceData]
    );

