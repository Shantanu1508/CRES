Delete from [CRE].[JsonFormatCalcV1] where [Type] = 'noteperiodiccalc' and [Key]  in ('netpikamountfortheperiod', 'cashinterest','capitalizedinterest','pikballoonsepcomp')

--IF NOT EXISTS(Select * from [CRE].[JsonFormatCalcV1] where [Type] = 'noteperiodiccalc' and [Key] = 'netpikamountfortheperiod')
--BEGIN
--	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'netpikamountfortheperiod', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
--END

--IF NOT EXISTS(Select * from [CRE].[JsonFormatCalcV1] where [Type] = 'noteperiodiccalc' and [Key] = 'cashinterest')
--BEGIN
--	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'cashinterest', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
--END

--IF NOT EXISTS(Select * from [CRE].[JsonFormatCalcV1] where [Type] = 'noteperiodiccalc' and [Key] = 'capitalizedinterest')
--BEGIN
--	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'capitalizedinterest', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
--END

--IF NOT EXISTS(Select * from [CRE].[JsonFormatCalcV1] where [Type] = 'noteperiodiccalc' and [Key] = 'pikballoonsepcomp')
--BEGIN
--	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'pikballoonsepcomp', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
--END

IF NOT EXISTS(Select * from [CRE].[JsonFormatCalcV1] where [Type] = 'noteperiodiccalc' and [Key] = 'pikendbalsepcomp')
BEGIN
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'pikendbalsepcomp', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
END

IF NOT EXISTS(Select * from [CRE].[JsonFormatCalcV1] where [Type] = 'noteperiodiccalc' and [Key] = 'cum_daily_pik_from_interest')
BEGIN
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'cum_daily_pik_from_interest', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
END

IF NOT EXISTS(Select * from [CRE].[JsonFormatCalcV1] where [Type] = 'noteperiodiccalc' and [Key] = 'cum_dailypikcomp')
BEGIN
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'cum_dailypikcomp', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
END

IF NOT EXISTS(Select * from [CRE].[JsonFormatCalcV1] where [Type] = 'noteperiodiccalc' and [Key] = 'cum_dailyintonpik')
BEGIN
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'cum_dailyintonpik', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
END

IF NOT EXISTS(Select * from [CRE].[JsonFormatCalcV1] where [Type] = 'noteperiodiccalc' and [Key] = 'pikinitbalsepcomp')
BEGIN
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'pikinitbalsepcomp', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
END