CREATE EXTERNAL TABLE [dbo].[Ex_Prod_FundingSchedule] (
    [FundingScheduleID] UNIQUEIDENTIFIER NULL,
    [EventId] UNIQUEIDENTIFIER NULL,
    [Date] DATE NULL,
    [Value] DECIMAL (28, 15) NULL,
    [PurposeID] INT NULL,
    [Applied] BIT NULL,
    [CreatedBy] NVARCHAR (256) NULL,
    [CreatedDate] DATETIME NULL,
    [UpdatedBy] NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME NULL,
    [DrawFundingId] NVARCHAR (256) NULL,
    [Comments] NVARCHAR (MAX) NULL,
    [Issaved] BIT NULL,
    [DealFundingRowno] INT NULL,
    [DealFundingID] UNIQUEIDENTIFIER NULL,
    [WF_CurrentStatus] NVARCHAR (256) NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceCRESProduction],
    SCHEMA_NAME = N'CORE',
    OBJECT_NAME = N'FundingSchedule'
    );

