
Truncate TABLE [VAL].[Configuration]

GO 
INSERT [val].[Configuration] ([Env], [Key], [value]) VALUES (N'QA', N'Version', N'0.0.0')
GO
INSERT [val].[Configuration] ([Env], [Key], [value]) VALUES (N'QA', N'EnvironmentName', N'CRES4_QA')
GO 
 
INSERT [val].[Configuration] ([Env], [Key], [value]) VALUES (N'QA', N'Service_URL', N'https://qacrescalculator.azurewebsites.net/')
 

GO 
INSERT [val].[Configuration] ([Env], [Key], [value]) VALUES (N'Dev', N'Version', N'0.0.0')
GO
INSERT [val].[Configuration] ([Env], [Key], [value]) VALUES (N'Dev', N'EnvironmentName', N'CRES4_QA')
GO 
 
INSERT [val].[Configuration] ([Env], [Key], [value]) VALUES (N'Dev', N'Service_URL', N'https://localhost:44364/')
GO

GO 
INSERT [val].[Configuration] ([Env], [Key], [value]) VALUES (N'Integration', N'Version', N'0.0.0')
GO
INSERT [val].[Configuration] ([Env], [Key], [value]) VALUES (N'Integration', N'EnvironmentName', N'Cres4_Integration')
GO  
INSERT [val].[Configuration] ([Env], [Key], [value]) VALUES (N'Integration', N'Service_URL', N'https://integrationcres4calculator.azurewebsites.net/')
GO


GO 
INSERT [val].[Configuration] ([Env], [Key], [value]) VALUES (N'Acore', N'Version', N'0.0.0')
GO
INSERT [val].[Configuration] ([Env], [Key], [value]) VALUES (N'Acore', N'EnvironmentName', N'Cres4_Acore')
GO  
INSERT [val].[Configuration] ([Env], [Key], [value]) VALUES (N'Acore', N'Service_URL', N'https://acorecalculator.azurewebsites.net/')
GO