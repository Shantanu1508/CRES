
Print('Insert JsonTemplateMaster')
go
Truncate table [CRE].[JsonTemplateMaster] 


go
SET IDENTITY_INSERT [CRE].[JsonTemplateMaster] ON 
INSERT [CRE].[JsonTemplateMaster] ([JsonTemplateMasterID], [TemplateName], [Comment], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (1, N'Default Template', NULL, NULL, NULL, NULL, NULL)
INSERT [CRE].[JsonTemplateMaster] ([JsonTemplateMasterID], [TemplateName], [Comment], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (2, N'Basis Template', NULL, N'B0E6697B-3534-4C09-BE0A-04473401AB93', CAST(N'2021-12-17T12:51:19.630' AS DateTime), N'B0E6697B-3534-4C09-BE0A-04473401AB93', CAST(N'2021-12-17T12:51:19.630' AS DateTime))
SET IDENTITY_INSERT [CRE].[JsonTemplateMaster] OFF


go

Update core.AnalysisParameter set JsonTemplateMasterID = 1
Update core.AnalysisParameter set JsonTemplateMasterID = 2 where analysisid in ('E50C2A12-5D4B-4540-A9C0-DB06D73F919D','02D20D3E-291A-42F8-AFCD-BDDFBB9DA16B')
go