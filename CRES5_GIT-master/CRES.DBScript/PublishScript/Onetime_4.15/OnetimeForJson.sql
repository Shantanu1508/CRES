IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [key] = 'contractmat')
BEGIN
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES ( N'tbl_notematurity', N'contractmat', N'data.notes.maturity', N'date', 1)
END