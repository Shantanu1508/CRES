CREATE EXTERNAL DATA SOURCE [RemoteReferenceDataFF]
    WITH (
    TYPE = RDBMS,
    LOCATION = N'tcp:z70t9nlx1v.database.windows.net,1433',
    DATABASE_NAME = N'BackshopStaging',
    CREDENTIAL = [CredentialAcoreFF]
    );

