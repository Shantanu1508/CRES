CREATE EXTERNAL TABLE [dbo].[Ex_Prod_Note] (
    [NoteID] UNIQUEIDENTIFIER NOT NULL,
    [Account_AccountID] UNIQUEIDENTIFIER NOT NULL,
    [DealID] UNIQUEIDENTIFIER NOT NULL,
    [CRENoteID] NVARCHAR (256) NULL,
    [ClientNoteID] NVARCHAR (256) NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceCRESProduction],
    SCHEMA_NAME = N'CRE',
    OBJECT_NAME = N'Note'
    );

