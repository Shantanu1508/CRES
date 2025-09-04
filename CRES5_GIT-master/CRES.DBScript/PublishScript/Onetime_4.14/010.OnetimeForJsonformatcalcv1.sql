


IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [Type] = 'dictionary' and [key] = 'matadjmonth')
BEGIN
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'dictionary', N'matadjmonth', N'data.notes.setup.dictionary', N'int', 1)	
END