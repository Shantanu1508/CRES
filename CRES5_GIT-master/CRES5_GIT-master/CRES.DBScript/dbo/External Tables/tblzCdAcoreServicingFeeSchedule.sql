CREATE EXTERNAL TABLE [dbo].[tblzCdAcoreServicingFeeSchedule] (
    [AcoreServicingFeeScheduleId] INT NULL,
    [InvestorId] INT NULL,
    [MinimumBalance] MONEY NOT NULL,
    [MaximumBalance] MONEY NOT NULL,
    [FeePct] FLOAT (53) NOT NULL,
    [AuditAddDate] DATETIME NOT NULL,
    [AuditAddUserid] NVARCHAR (150) NOT NULL,
    [AuditUpdateDate] DATETIME NULL,
    [AuditUpdateUserid] NVARCHAR (150) NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceData],
    SCHEMA_NAME = N'ACORE',
    OBJECT_NAME = N'tblzCdAcoreServicingFeeSchedule'
    );

