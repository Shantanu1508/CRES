

Print('Insert in cre.RootV1Calc')

TRuncate table [CRE].[RootV1Calc]
GO
SET IDENTITY_INSERT [CRE].[RootV1Calc] ON 
INSERT [CRE].[RootV1Calc] ([RootV1CalcID], [calc_basis], [calc_deffee_basis], [calc_disc_basis], [calc_capcosts_basis], [batch], [init_logging], [engine]) VALUES (1, 0, 1, 1, 1, 0, 1, N'cre')
SET IDENTITY_INSERT [CRE].[RootV1Calc] OFF

GO

Print('Insert in cre.JsonFormatCalcV1')
go
Truncate table [CRE].[JsonFormatCalcV1]
go

SET IDENTITY_INSERT [CRE].[JsonFormatCalcV1] ON 

INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (1, N'root', N'calc_basis', N'data', N'bool', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (2, N'root', N'calc_deffee_basis', N'data', N'bool', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (3, N'root', N'calc_disc_basis', N'data', N'bool', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (4, N'root', N'calc_capcosts_basis', N'data', N'bool', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (5, N'root', N'batch', N'data', N'bool', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (6, N'root', N'init_logging', N'data', N'bool', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (7, N'root', N'engine', N'data', N'string', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (8, N'rate', N'startdt', N'data.notes', N'date', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (9, N'rate', N'valtype', N'data.notes', N'string', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (10, N'rate', N'val', N'data.notes', N'decimal', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (11, N'rate', N'intcalcdays', N'data.notes', N'int', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (12, N'dictionary', N'CRENoteID', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (13, N'dictionary', N'NoteID', N'data.notes.setup.dictionary', N'UNIQUEIDENTIFIER', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (14, N'dictionary', N'min_effective_dates', N'data.notes.setup.dictionary', N'date', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (15, N'dictionary', N'initaccenddt', N'data.notes.setup.dictionary', N'date', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (16, N'dictionary', N'matdt', N'data.notes.setup.dictionary', N'date', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (17, N'dictionary', N'initpmtdt', N'data.notes.setup.dictionary', N'date', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (18, N'dictionary', N'ioterm', N'data.notes.setup.dictionary', N'int', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (19, N'dictionary', N'amterm', N'data.notes.setup.dictionary', N'int', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (20, N'dictionary', N'clsdt', N'data.notes.setup.dictionary', N'date', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (21, N'dictionary', N'initbal', N'data.notes.setup.dictionary', N'decimal(28,15)', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (22, N'dictionary', N'totalcmt', N'data.notes.setup.dictionary', N'decimal(28,15)', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (23, N'dictionary', N'leaddays', N'data.notes.setup.dictionary', N'int', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (24, N'dictionary', N'initresetdt', N'data.notes.setup.dictionary', N'date', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (25, N'dictionary', N'initindexovrd', N'data.notes.setup.dictionary', N'decimal(28,15)', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (26, N'dictionary', N'roundmethod', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (27, N'dictionary', N'precision', N'data.notes.setup.dictionary', N'int', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (28, N'dictionary', N'discount', N'data.notes.setup.dictionary', N'decimal(28,15)', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (29, N'dictionary', N'stubintovrd', N'data.notes.setup.dictionary', N'decimal(28,15)', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (30, N'dictionary', N'loanpurchase', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (31, N'dictionary', N'purintovrd', N'data.notes.setup.dictionary', N'decimal(28,15)', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (32, N'dictionary', N'intcalcrulepydn', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (33, N'dictionary', N'capclscost', N'data.notes.setup.dictionary', N'decimal(28,15)', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (34, N'dictionary', N'dd_dom', N'data.notes.setup.dictionary', N'int', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (35, N'dictionary', N'accfreq', N'data.notes.setup.dictionary', N'int', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (36, N'dictionary', N'determidayrefdayofmnth', N'data.notes.setup.dictionary', N'int', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (37, N'dictionary', N'rateindexresetfreq', N'data.notes.setup.dictionary', N'int', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (38, N'dictionary', N'accperpaydaywhennoteomnth', N'data.notes.setup.dictionary', N'int', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (39, N'dictionary', N'payfreq', N'data.notes.setup.dictionary', N'int', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (40, N'dictionary', N'pmtdtbusdaylag', N'data.notes.setup.dictionary', N'int', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (41, N'dictionary', N'stubpaidadv', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (42, N'dictionary', N'finalintaccenddtvrd', N'data.notes.setup.dictionary', N'date', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (43, N'dictionary', N'stubonff', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (44, N'dictionary', N'monamovrd', N'data.notes.setup.dictionary', N'decimal(28,15)', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (45, N'dictionary', N'fixamsch', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (46, N'dictionary', N'amintcalcdaycnt', N'data.notes.setup.dictionary', N'int', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (47, N'dictionary', N'pikinteraddedtoblsbusiadvdate', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (48, N'dictionary', N'piksepcompoundingflg', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)
INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (49, N'dictionary', N'intcalcruleforam', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)
SET IDENTITY_INSERT [CRE].[JsonFormatCalcV1] OFF






------only for dev now
--Truncate table [CRE].[JsonFormatCalcV1]
--go

--SET IDENTITY_INSERT [CRE].[JsonFormatCalcV1] ON 

--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (1, N'root', N'calc_basis', N'data', N'bool', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (2, N'root', N'calc_deffee_basis', N'data', N'bool', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (3, N'root', N'calc_disc_basis', N'data', N'bool', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (4, N'root', N'calc_capcosts_basis', N'data', N'bool', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (5, N'root', N'batch', N'data', N'bool', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (6, N'root', N'init_logging', N'data', N'bool', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (7, N'root', N'engine', N'data', N'string', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (8, N'rate', N'startdt', N'data.notes', N'date', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (9, N'rate', N'valtype', N'data.notes', N'string', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (10, N'rate', N'val', N'data.notes', N'decimal', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (11, N'rate', N'intcalcdays', N'data.notes', N'int', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (12, N'dictionary', N'CRENoteID', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (13, N'dictionary', N'NoteID', N'data.notes.setup.dictionary', N'UNIQUEIDENTIFIER', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (14, N'dictionary', N'min_effective_dates', N'data.notes.setup.dictionary', N'date', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (15, N'dictionary', N'initaccenddt', N'data.notes.setup.dictionary', N'date', 1)

----matdt
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (16, N'dictionary', N'initmatdt', N'data.notes.setup.dictionary', N'date', 1)

--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (17, N'dictionary', N'initpmtdt', N'data.notes.setup.dictionary', N'date', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (18, N'dictionary', N'ioterm', N'data.notes.setup.dictionary', N'int', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (19, N'dictionary', N'amterm', N'data.notes.setup.dictionary', N'int', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (20, N'dictionary', N'clsdt', N'data.notes.setup.dictionary', N'date', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (21, N'dictionary', N'initbal', N'data.notes.setup.dictionary', N'decimal(28,15)', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (22, N'dictionary', N'totalcmt', N'data.notes.setup.dictionary', N'decimal(28,15)', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (23, N'dictionary', N'leaddays', N'data.notes.setup.dictionary', N'int', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (24, N'dictionary', N'initresetdt', N'data.notes.setup.dictionary', N'date', 1)

----initindexovrd
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (25, N'dictionary', N'initindex', N'data.notes.setup.dictionary', N'decimal(28,15)', 1)

--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (26, N'dictionary', N'roundmethod', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (27, N'dictionary', N'precision', N'data.notes.setup.dictionary', N'int', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (28, N'dictionary', N'discount', N'data.notes.setup.dictionary', N'decimal(28,15)', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (29, N'dictionary', N'stubintovrd', N'data.notes.setup.dictionary', N'decimal(28,15)', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (30, N'dictionary', N'loanpurchase', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (31, N'dictionary', N'purintovrd', N'data.notes.setup.dictionary', N'decimal(28,15)', 1)


----intcalcrulepydn
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (32, N'dictionary', N'intecalcrulepydn', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)

--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (33, N'dictionary', N'capclscost', N'data.notes.setup.dictionary', N'decimal(28,15)', 1)


----dd_dom
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (34, N'dictionary', N'dayofmnth', N'data.notes.setup.dictionary', N'int', 1)

--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (35, N'dictionary', N'accfreq', N'data.notes.setup.dictionary', N'int', 1)


--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (36, N'dictionary', N'determidayrefdayofmnth', N'data.notes.setup.dictionary', N'int', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (37, N'dictionary', N'rateindexresetfreq', N'data.notes.setup.dictionary', N'int', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (38, N'dictionary', N'accperpaydaywhennoteomnth', N'data.notes.setup.dictionary', N'int', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (39, N'dictionary', N'payfreq', N'data.notes.setup.dictionary', N'int', 1)

----pmtdtbusdaylag
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (40, N'dictionary', N'paydatebusiessdaylag', N'data.notes.setup.dictionary', N'int', 1)

--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (41, N'dictionary', N'stubpaidadv', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (42, N'dictionary', N'finalintaccenddtvrd', N'data.notes.setup.dictionary', N'date', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (43, N'dictionary', N'stubonff', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (44, N'dictionary', N'monamovrd', N'data.notes.setup.dictionary', N'decimal(28,15)', 1)

----fixamsch
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (45, N'dictionary', N'fixedamortsche', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)

----amintcalcdaycnt
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (46, N'dictionary', N'amortintcalcdaycnt', N'data.notes.setup.dictionary', N'int', 1)

--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (47, N'dictionary', N'pikinteraddedtoblsbusiadvdate', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)

----piksepcompoundingflg
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (48, N'dictionary', N'piksepcomponding', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)

----intcalcruleforam
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (49, N'dictionary', N'intcalcruleforpydwnamort', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)



----Removed column
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (50, N'dictionary', N'insvrpayoverinlvly', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)
----Removed column
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (51, N'dictionary', N'busidayrelapmtdt', N'data.notes.setup.dictionary', N'int', 1)
----Removed column
--INSERT [CRE].[JsonFormatCalcV1] ([JsonFormatCalcV1], [Type], [Key], [Position], [DataType], [IsActive]) VALUES (52, N'dictionary', N'determidtinterestaccper', N'data.notes.setup.dictionary', N'int', 1)

--SET IDENTITY_INSERT [CRE].[JsonFormatCalcV1] OFF