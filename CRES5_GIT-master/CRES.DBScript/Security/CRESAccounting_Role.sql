CREATE ROLE [CRESAccounting_Role]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [CRESAccounting_Role] ADD MEMBER [CRESAccountingUser];

