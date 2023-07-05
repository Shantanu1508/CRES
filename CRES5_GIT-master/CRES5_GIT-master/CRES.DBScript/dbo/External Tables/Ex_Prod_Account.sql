CREATE EXTERNAL TABLE [dbo].[Ex_Prod_Account] (
    [AccountID] UNIQUEIDENTIFIER NOT NULL,
    [AccountTypeID] INT NULL,
    [StatusID] INT NULL,
    [Name] VARCHAR (256) NULL,
    [BaseCurrencyID] INT NULL,
    [PayFrequency] INT NULL,
    [ClientNoteID] NVARCHAR (256) NULL,
    [IsDeleted] BIT NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceCRESProduction],
    SCHEMA_NAME = N'CORE',
    OBJECT_NAME = N'Account'
    );

