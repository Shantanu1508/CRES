CREATE EXTERNAL DATA SOURCE [RemoteReferenceCRESProductionBK_Temp]
    WITH (
    TYPE = RDBMS,
    LOCATION = N'tcp:b0xesubcki.database.windows.net,1433',
    DATABASE_NAME = N'CRES4_Acore_2.13.2_PreRelease',
    CREDENTIAL = [CredentialCRESProductionBK_Temp]
    );

