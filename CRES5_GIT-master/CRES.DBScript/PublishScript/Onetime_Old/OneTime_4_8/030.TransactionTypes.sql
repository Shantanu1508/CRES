Delete from cre.TransactionTypes where [TransactionName] = 'ChangeInNetAssetValue'
go

IF NOT EXISTS(Select [TransactionName] from cre.TransactionTypes where [TransactionName] = 'NetPropertyIncomeOrLoss')
BEGIN
	INSERT [CRE].[TransactionTypes] ([TransactionName], [TransactionCategory], [Calculated], [IncludeCashflowDownload], [IncludeServicingReconciliation], [IncludeGAAPCalculations], [AllowCalculationOverride], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [TransactionGroup], [Cash_NonCash], [AccountName], [DecodeNo], [DecodeName], [RP_Mics_Comment], [Decode_Definition]) 
	VALUES (N'NetPropertyIncomeOrLoss', N'Default', 3, 3, 3, 3, 4, N'B0E6697B-3534-4C09-BE0A-04473401AB93', GetDate(), N'B0E6697B-3534-4C09-BE0A-04473401AB93', GetDate(), N'', N'Non Cash', N'NetPropertyIncomeOrLoss', NULL, NULL, NULL, NULL)
END

go

Delete from cre.TransactionTypes where [TransactionName] = 'EquityDistribution'
go


IF NOT EXISTS(Select [TransactionName] from cre.TransactionTypes where [TransactionName] = 'EquityDistribution')
BEGIN
	INSERT [CRE].[TransactionTypes] ([TransactionName], [TransactionCategory], [Calculated], [IncludeCashflowDownload], [IncludeServicingReconciliation], [IncludeGAAPCalculations], [AllowCalculationOverride], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [TransactionGroup], [Cash_NonCash], [AccountName], [DecodeNo], [DecodeName], [RP_Mics_Comment], [Decode_Definition]) 
	VALUES (N'EquityDistribution', N'Default', 3, 3, 3, 3, 4, N'B0E6697B-3534-4C09-BE0A-04473401AB93', GetDate(), N'B0E6697B-3534-4C09-BE0A-04473401AB93', GetDate(), N'', N'Cash', N'EquityDistribution', NULL, NULL, NULL, NULL)
END
