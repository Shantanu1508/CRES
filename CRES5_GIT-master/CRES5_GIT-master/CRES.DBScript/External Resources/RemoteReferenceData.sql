CREATE EXTERNAL DATA SOURCE [RemoteReferenceData]
    WITH (
    TYPE = RDBMS,
    LOCATION = N'tcp:z70t9nlx1v.database.secure.windows.net',
    DATABASE_NAME = N'BackshopStaging',
    CREDENTIAL = [CredentialAcore]
    );

