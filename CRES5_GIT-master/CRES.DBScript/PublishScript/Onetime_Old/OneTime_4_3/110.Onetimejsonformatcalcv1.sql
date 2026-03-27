Delete from cre.jsonformatcalcv1 where [type] = 'svrwatchlist'

IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [Type] = 'svrwatchlist')
BEGIN	
	
	INSERT [CRE].[JsonFormatCalcV1] ([Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'svrwatchlist', N'crenoteid', N'data.notes.svrwatchlist', N'nvarchar(256)', 1)
	INSERT [CRE].[JsonFormatCalcV1] ([Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'svrwatchlist', N'date', N'data.notes.svrwatchlist', N'Date', 1)
	INSERT [CRE].[JsonFormatCalcV1] ([Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'svrwatchlist', N'amount', N'data.notes.svrwatchlist', N'decimal(28,15)', 1)

END


IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [Type] = 'noteactuals' and [Key] = 'writeoffamount')
BEGIN	
	INSERT [CRE].[JsonFormatCalcV1] ([Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteactuals', N'writeoffamount', N'data.notes.noteactuals', N'decimal(28,15)', 1)
END


