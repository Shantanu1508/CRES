IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [Type] = 'fee_stripping' and [key] = 'feescheduleid')
BEGIN
	INSERT [CRE].[JsonFormatCalcV1] ([Type], [Key], [Position], [DataType], [IsActive]) VALUES ( N'fee_stripping', N'feescheduleid', N'data.notes.fee_stripping', N'nvarchar(256)', 1)
END
