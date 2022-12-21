ALTER ROLE [db_owner] ADD MEMBER [CRES4];


GO
ALTER ROLE [db_owner] ADD MEMBER [Acore_BIViewer];


GO
ALTER ROLE [db_owner] ADD MEMBER [Cres4_qa_role];


GO
ALTER ROLE [db_datareader] ADD MEMBER [Acore_DataExtract];


GO
ALTER ROLE [db_datareader] ADD MEMBER [Acore_BIViewer];


GO
ALTER ROLE [db_datareader] ADD MEMBER [CresReader_role];


GO
ALTER ROLE [db_datareader] ADD MEMBER [CresReader_Acore_role];


GO
ALTER ROLE [db_datareader] ADD MEMBER [ReadScriptUser];

