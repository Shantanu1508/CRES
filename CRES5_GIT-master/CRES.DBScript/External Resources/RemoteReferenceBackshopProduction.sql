CREATE EXTERNAL DATA SOURCE [RemoteReferenceBackshopProduction]
    WITH (
    TYPE = RDBMS,
    LOCATION = N'tcp:z70t9nlx1v.database.secure.windows.net,1433',
    DATABASE_NAME = N'BackshopProduction',
    CREDENTIAL = [CredentialBackshopProduction]
    );

