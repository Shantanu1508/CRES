CREATE TABLE [HBOT].[IntentColumnMapping] (
    [IntentColumnMappingID] INT            IDENTITY (1, 1) NOT NULL,
    [ObjectType]            NVARCHAR (256) NULL,
    [Intent]                NVARCHAR (256) NULL,
    [DBColumn]              NVARCHAR (256) NULL,
    [TableName]             NVARCHAR (256) NULL,
    [IsLookup]              BIT            NULL,
    [Lookup_TableName]      NVARCHAR (256) NULL,
    [Lookup_KeyColumn]      NVARCHAR (256) NULL,
    [Lookup_ValueColumn]    NVARCHAR (256) NULL
);
go
ALTER TABLE [HBOT].IntentColumnMapping
ADD CONSTRAINT PK_IntentColumnMapping PRIMARY KEY (IntentColumnMappingid);