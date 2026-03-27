
GO

Print('Insert into jsonformatcalcv1')

IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [key] = 'detdt_hlday_ls')
BEGIN
INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'dictionary', N'detdt_hlday_ls', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)
	
END



IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [key] = 'detdt_hlday_ls' and [type] = 'rate')
BEGIN
INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'rate', N'detdt_hlday_ls', N'data.notes', N'string', 1)
	
END

go
IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [key] = 'accountingclosedate')
BEGIN
INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'dictionary', N'accountingclosedate', N'data.notes.setup.dictionary', N'date', 1)
	
END

go

IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [Type] = 'noteperiodiccalc')
BEGIN	
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'CRENoteID', N'data.notes.noteperiodiccalc', N'nvarchar(256)', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'PeriodEndDate', N'data.notes.noteperiodiccalc', N'date', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'EndingGAAPBV', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'DiscountPremiumAmort', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'AmortofDeferredFees', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'AccumulatedAmortofDeferredFees', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
END

go

IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [key] = 'indexnametext' and [type] = 'rate')
BEGIN
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'rate', N'indexnametext', N'data.notes', N'string', 1)
END