CREATE EXTERNAL DATA SOURCE [RemoteReferenceCRESProduction]
    WITH (
    TYPE = RDBMS,
    LOCATION = N'tcp:b0xesubcki.database.windows.net,1433',
    DATABASE_NAME = N'CRES4_Acore',
    CREDENTIAL = [CredentialCRESProduction]
    );

