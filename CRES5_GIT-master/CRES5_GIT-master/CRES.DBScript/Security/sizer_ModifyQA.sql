CREATE ROLE [sizer_ModifyQA]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [sizer_ModifyQA] ADD MEMBER [sizerUserQA];

