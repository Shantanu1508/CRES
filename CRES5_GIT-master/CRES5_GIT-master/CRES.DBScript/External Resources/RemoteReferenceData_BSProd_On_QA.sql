CREATE EXTERNAL DATA SOURCE [RemoteReferenceData_BSProd_On_QA]
    WITH (
    TYPE = RDBMS,
    LOCATION = N'tcp:z70t9nlx1v.database.secure.windows.net',
    DATABASE_NAME = N'BackshopProduction',
    CREDENTIAL = [CredentialAcore_BSProd_On_QA]
    );

