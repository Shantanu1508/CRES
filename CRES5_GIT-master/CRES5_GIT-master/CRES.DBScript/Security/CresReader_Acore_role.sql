CREATE ROLE [CresReader_Acore_role]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [CresReader_Acore_role] ADD MEMBER [CresReader_Acore_user];

