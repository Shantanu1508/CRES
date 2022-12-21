CREATE EXTERNAL TABLE [dbo].[tblControlMaster] (
    [ControlId] NVARCHAR (10) NOT NULL,
    [DealName] NVARCHAR (75) NOT NULL,
    [DealBorrowerContact1_ContactId_F] INT NULL,
    [Sponsor_OrgId_F] INT NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceData]
    );

