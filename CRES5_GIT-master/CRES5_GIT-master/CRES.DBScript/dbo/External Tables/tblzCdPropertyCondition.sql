CREATE EXTERNAL TABLE [dbo].[tblzCdPropertyCondition] (
    [PropertyConditionCd] NVARCHAR (10) NOT NULL,
    [PropertyConditionDesc] NVARCHAR (50) NULL,
    [OrderKey] INT NULL,
    [InactiveSw] BIT NOT NULL,
    [AuditAddDate] DATETIME NOT NULL,
    [AuditAddUserId] NVARCHAR (150) NULL,
    [AuditUpdateDate] DATETIME NOT NULL,
    [AuditUpdateUserId] NVARCHAR (150) NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceData]
    );

