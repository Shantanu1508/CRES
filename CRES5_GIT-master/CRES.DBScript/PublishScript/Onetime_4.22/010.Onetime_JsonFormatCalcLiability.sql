INSERT [CRE].[JsonFormatCalcLiability] ( [Position], [Key], [KeyFormat], [DataType], [IsActive], [ParentID], [FilterBy]) VALUES (N'root', N'LiabilityNoteTransactionOverride', N'array', N'', 1, NULL, NULL)

Declare @ID int = (Select JsonFormatCalcLiabilityID from cre.jsonformatcalcliability where [Position] = 'root' and [key] = 'LiabilityNoteTransactionOverride')

INSERT [CRE].[JsonFormatCalcLiability] ( [Position], [Key], [KeyFormat], [DataType], [IsActive], [ParentID], [FilterBy]) VALUES ( N'root.LiabilityNoteTransactionOverride', N'LiabilityNoteAccountID', N'variable', N'nvarchar(256)', 1, @ID, NULL)
INSERT [CRE].[JsonFormatCalcLiability] ( [Position], [Key], [KeyFormat], [DataType], [IsActive], [ParentID], [FilterBy]) VALUES ( N'root.LiabilityNoteTransactionOverride', N'LiabilityNoteID', N'variable', N'nvarchar(256)', 1, @ID, NULL)
INSERT [CRE].[JsonFormatCalcLiability] ( [Position], [Key], [KeyFormat], [DataType], [IsActive], [ParentID], [FilterBy]) VALUES ( N'root.LiabilityNoteTransactionOverride', N'AssetAccountID', N'variable', N'nvarchar(256)', 1, @ID, NULL)
INSERT [CRE].[JsonFormatCalcLiability] ( [Position], [Key], [KeyFormat], [DataType], [IsActive], [ParentID], [FilterBy]) VALUES ( N'root.LiabilityNoteTransactionOverride', N'TransactionDate', N'variable', N'date', 1, @ID, NULL)
INSERT [CRE].[JsonFormatCalcLiability] ( [Position], [Key], [KeyFormat], [DataType], [IsActive], [ParentID], [FilterBy]) VALUES ( N'root.LiabilityNoteTransactionOverride', N'TransactionTypes', N'variable', N'nvarchar(256)', 1, @ID, NULL)
INSERT [CRE].[JsonFormatCalcLiability] ( [Position], [Key], [KeyFormat], [DataType], [IsActive], [ParentID], [FilterBy]) VALUES ( N'root.LiabilityNoteTransactionOverride', N'TransactionAmount', N'variable', N'decimal(28,15)', 1, @ID, NULL)
INSERT [CRE].[JsonFormatCalcLiability] ( [Position], [Key], [KeyFormat], [DataType], [IsActive], [ParentID], [FilterBy]) VALUES ( N'root.LiabilityNoteTransactionOverride', N'OriginalAmount', N'variable', N'decimal(28,15)', 1, @ID, NULL)
INSERT [CRE].[JsonFormatCalcLiability] ( [Position], [Key], [KeyFormat], [DataType], [IsActive], [ParentID], [FilterBy]) VALUES ( N'root.LiabilityNoteTransactionOverride', N'Delta', N'variable', N'decimal(28,15)', 1, @ID, NULL)
INSERT [CRE].[JsonFormatCalcLiability] ( [Position], [Key], [KeyFormat], [DataType], [IsActive], [ParentID], [FilterBy]) VALUES ( N'root.LiabilityNoteTransactionOverride', N'AssetID', N'variable', N'nvarchar(256)', 1, @ID, NULL)
INSERT [CRE].[JsonFormatCalcLiability] ( [Position], [Key], [KeyFormat], [DataType], [IsActive], [ParentID], [FilterBy]) VALUES ( N'root.LiabilityNoteTransactionOverride', N'Type', N'variable', N'nvarchar(256)', 1, @ID, NULL)
						
go

INSERT [CRE].[JsonFormatCalcLiability] ( [Position], [Key], [KeyFormat], [DataType], [IsActive], [ParentID], [FilterBy]) VALUES ( N'root.CashflowConfig', N'RebalanceMethod', N'variable', N'int', 1, 84, NULL)
	
						