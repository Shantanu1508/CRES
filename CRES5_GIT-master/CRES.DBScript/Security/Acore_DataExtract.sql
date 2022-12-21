CREATE ROLE [Acore_DataExtract]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [Acore_DataExtract] ADD MEMBER [dataExtractUser];

