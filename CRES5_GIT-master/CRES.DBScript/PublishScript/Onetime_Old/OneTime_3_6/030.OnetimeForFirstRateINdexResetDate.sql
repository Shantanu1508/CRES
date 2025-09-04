

Update cre.note set FirstIndexDeterminationDateOverride = Firstrateindexresetdate

Update DW.NoteBI set FirstIndexDeterminationDateOverride = Firstrateindexresetdate

IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [key] = 'fstIndexDeterDtOverride')
BEGIN
INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'dictionary', N'fstIndexDeterDtOverride', N'data.notes.setup.dictionary', N'date', 1)
	
END



IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [key] = 'initialinterestaccrualenddate')
BEGIN
INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteactuals', N'initialinterestaccrualenddate', N'data.notes.actuals', N'date', 1)
	
END

-----Demo
IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [key] = 'accrualperiodtype')
BEGIN
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'dictionary', N'accrualperiodtype', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)	
END
IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [key] = 'accrualperiodbusinessdayadj')
BEGIN
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'dictionary', N'accrualperiodbusinessdayadj', N'data.notes.setup.dictionary', N'nvarchar(256)', 1)	
END



Update cre.note set AccrualPeriodType = 811,AccrualPeriodBusinessDayAdj = 813

