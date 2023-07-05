CREATE EXTERNAL TABLE [dbo].[tblPropertyExp] (
    [PropertyExpId] INT NULL,
    [PropertyId_F] INT NOT NULL,
    [PropertyConditionCd_F] NVARCHAR (10) NULL,
    [NumOfTenants] INT NULL,
    [PropertyRollUpSW] BIT NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceData]
    );

