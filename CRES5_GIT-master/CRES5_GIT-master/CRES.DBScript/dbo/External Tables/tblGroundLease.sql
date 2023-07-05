CREATE EXTERNAL TABLE [dbo].[tblGroundLease] (
    [GroundLeaseId] INT NULL,
    [PropertyId_F] INT NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceData]
    );

