CREATE ROLE [CresReader_role]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [CresReader_role] ADD MEMBER [CresReader_user];

