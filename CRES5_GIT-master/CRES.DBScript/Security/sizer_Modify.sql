CREATE ROLE [sizer_Modify]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [sizer_Modify] ADD MEMBER [sizerUser];

