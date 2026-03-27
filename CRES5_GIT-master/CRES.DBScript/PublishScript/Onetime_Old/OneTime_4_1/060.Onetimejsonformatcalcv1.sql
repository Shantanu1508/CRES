
GO

Print('Insert into jsonformatcalcv1')


IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [key] = 'accountingclosedate')
BEGIN
	INSERT INTO cre.jsonformatcalcv1 ([Type],[Key],Position,DataType,IsActive)
	VALUES('dictionary','accountingclosedate','data.notes.setup.dictionary','date',1)
END


Delete  from cre.jsonformatcalcv1 where [key] = 'isaccountingclose'
IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [key] = 'accountingclose')
BEGIN
	INSERT INTO cre.jsonformatcalcv1 ([Type],[Key],Position,DataType,IsActive)
	VALUES('root','accountingclose','data','bool',1)
END


IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [key] = 'effectivedate' and [type] = 'noteperiodiccalc')
BEGIN
	INSERT INTO cre.jsonformatcalcv1 ([Type],[Key],Position,DataType,IsActive)
	VALUES('noteperiodiccalc','effectivedate','data.notes.noteperiodiccalc','date',1)
END


Delete from cre.jsonformatcalcv1 where [type] = 'noteperiodiccalc'

IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [Type] = 'noteperiodiccalc')
BEGIN	
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'crenoteid', N'data.notes.noteperiodiccalc', N'nvarchar(256)', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'effectivedate', N'data.notes.noteperiodiccalc', N'date', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'date', N'data.notes.noteperiodiccalc', N'date', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'levyld', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'gaapbv', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'cum_am_disc', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'feeamort', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'cum_am_fee', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'cum_dailypikint', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'cum_baladdon_am', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'cum_baladdon_nonam', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'cum_dailyint', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'cum_ddbaladdon', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'cum_ddintdelta', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'cum_am_capcosts', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'endbal', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'initbal', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'cum_fee_levyld', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'period_ddintdelta_shifted', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'intdeltabal', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'cum_exit_fee_excl_lv_yield', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'periodend', N'data.notes.noteperiodiccalc', N'date', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'periodstart', N'data.notes.noteperiodiccalc', N'date', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'pmtdtnotadj', N'data.notes.noteperiodiccalc', N'date', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'pmtdt', N'data.notes.noteperiodiccalc', N'date', 1)
	INSERT [CRE].[JsonFormatCalcV1] ( [Type], [Key], [Position], [DataType], [IsActive]) VALUES (N'noteperiodiccalc', N'periodpikint', N'data.notes.noteperiodiccalc', N'decimal(28,15)', 1)
END
