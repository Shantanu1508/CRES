CREATE EXTERNAL TABLE [dbo].[tblBorrower] (
    [BorrowerId] INT NULL,
    [BorrowerTypeCd_F] NVARCHAR (3) NULL,
    [LastNameOrOrgName] NVARCHAR (100) NULL,
    [FirstName] NVARCHAR (15) NULL,
    [LastNameOrOrgNameContinued] NVARCHAR (100) NULL,
    [StreetAddress] NVARCHAR (50) NULL,
    [City] NVARCHAR (25) NULL,
    [State] NVARCHAR (2) NULL,
    [Country] NVARCHAR (50) NULL,
    [Zip] NVARCHAR (15) NULL,
    [PhoneNumber] NVARCHAR (20) NULL,
    [TaxId] NVARCHAR (100) NULL,
    [NetWorth] MONEY NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceData]
    );

