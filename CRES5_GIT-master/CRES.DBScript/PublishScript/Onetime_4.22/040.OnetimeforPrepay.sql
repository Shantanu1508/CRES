IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [Type] = 'dictionary' and [key] = 'prepaydate')
BEGIN
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'dictionary', N'prepaydate', N'data.notes.setup.dictionary', N'date', 1)	
END