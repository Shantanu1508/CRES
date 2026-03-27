


IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [Type] = 'noteactuals' and [key] = 'capitalizedInt')
BEGIN
	INSERT [CRE].[JsonFormatCalcV1] ([Type], [Key], [Position], [DataType], [IsActive]) VALUES ( N'noteactuals', N'capitalizedInt', N'data.notes.actuals', N'decimal(28,15)', 1)
END

IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [Type] = 'noteactuals' and [key] = 'cashInt')
BEGIN
	INSERT [CRE].[JsonFormatCalcV1] ([Type], [Key], [Position], [DataType], [IsActive]) VALUES ( N'noteactuals', N'cashInt', N'data.notes.actuals', N'decimal(28,15)', 1)
END


IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [Type] = 'dictionary' and [key] = 'fulliotermflag')
BEGIN
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'dictionary', N'fulliotermflag', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)	
END



---update cre.JsonFormatCalcV1  set [key] = 'initfund' where [key] = 'initbal' and [Type] = 'dictionary'