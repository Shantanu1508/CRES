INSERT [CRE].[JsonFormatCalcLiability] ( [Position], [Key], [KeyFormat], [DataType], [IsActive], [ParentID], [FilterBy]) VALUES (N'root', N'ManualEntry', N'array', N'', 1, NULL, NULL)

Declare @ID int = (Select JsonFormatCalcLiabilityID from cre.jsonformatcalcliability where [Position] = 'root' and [key] = 'ManualEntry')

INSERT [CRE].[JsonFormatCalcLiability] ( [Position], [Key], [KeyFormat], [DataType], [IsActive], [ParentID], [FilterBy]) VALUES ( N'root.ManualEntry', N'ManualEntryID', N'variable', N'int', 1, @ID, NULL)
INSERT [CRE].[JsonFormatCalcLiability] ( [Position], [Key], [KeyFormat], [DataType], [IsActive], [ParentID], [FilterBy]) VALUES ( N'root.ManualEntry', N'AccountId', N'variable', N'nvarchar(256)', 1, @ID, NULL)
INSERT [CRE].[JsonFormatCalcLiability] ( [Position], [Key], [KeyFormat], [DataType], [IsActive], [ParentID], [FilterBy]) VALUES ( N'root.ManualEntry', N'AccountName', N'variable', N'nvarchar(256)', 1, @ID, NULL)
INSERT [CRE].[JsonFormatCalcLiability] ( [Position], [Key], [KeyFormat], [DataType], [IsActive], [ParentID], [FilterBy]) VALUES ( N'root.ManualEntry', N'TransactionDate', N'variable', N'date', 1, @ID, NULL)
INSERT [CRE].[JsonFormatCalcLiability] ( [Position], [Key], [KeyFormat], [DataType], [IsActive], [ParentID], [FilterBy]) VALUES ( N'root.ManualEntry', N'TransactionType', N'variable', N'nvarchar(256)', 1, @ID, NULL)
INSERT [CRE].[JsonFormatCalcLiability] ( [Position], [Key], [KeyFormat], [DataType], [IsActive], [ParentID], [FilterBy]) VALUES ( N'root.ManualEntry', N'TransactionAmount', N'variable', N'decimal(28,15)', 1, @ID, NULL)
INSERT [CRE].[JsonFormatCalcLiability] ( [Position], [Key], [KeyFormat], [DataType], [IsActive], [ParentID], [FilterBy]) VALUES ( N'root.ManualEntry', N'Comments', N'variable', N'nvarchar(256)', 1, @ID, NULL)
						