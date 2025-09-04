
IF NOT EXISTS(Select * from [CRE].[JsonFormatCalcV1] where [Type] = 'noteperiodiccalc' and [Key] = 'cum_unusedfee')
BEGIN
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'cum_unusedfee', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
END


--IF NOT EXISTS(Select * from [CRE].[JsonFormatCalcV1] where [Type] = 'noteperiodiccalc' and [Key] = 'initfunding')
--BEGIN
--	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'initfunding', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
--END