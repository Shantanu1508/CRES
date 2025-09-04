Print('Insert in cre.RootV1Calc')
go
TRuncate table [CRE].[RootV1Calc]
GO
SET IDENTITY_INSERT [CRE].[RootV1Calc] ON 

INSERT [CRE].[RootV1Calc] ([RootV1CalcID], [calc_basis], [calc_deffee_basis], [calc_disc_basis], [calc_capcosts_basis], [batch], [engine]) VALUES (1, 0, 1, 1, 1, 0, N'cre')
SET IDENTITY_INSERT [CRE].[RootV1Calc] OFF