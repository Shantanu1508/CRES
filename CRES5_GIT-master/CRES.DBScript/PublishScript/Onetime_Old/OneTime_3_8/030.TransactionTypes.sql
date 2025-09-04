Print('Truncate table TransactionTypes')



IF NOT EXISTS(Select [TransactionName] from cre.TransactionTypes where [TransactionName] = 'RawIndexPercentage')
BEGIN
	INSERT [CRE].[TransactionTypes] ([TransactionName], [TransactionCategory], [Calculated], [IncludeCashflowDownload], [IncludeServicingReconciliation], [IncludeGAAPCalculations], [AllowCalculationOverride], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [TransactionGroup], [Cash_NonCash], [AccountName], [DecodeNo], [DecodeName], [RP_Mics_Comment], [Decode_Definition]) 
	VALUES (N'RawIndexPercentage', N'Default', 3, 3, 3, 3, 4, N'B0E6697B-3534-4C09-BE0A-04473401AB93', CAST(N'2023-05-17T05:08:49.003' AS DateTime), N'B0E6697B-3534-4C09-BE0A-04473401AB93', CAST(N'2023-05-17T05:08:49.003' AS DateTime), N'', N'', N'RawIndexPercentage', NULL, NULL, NULL, NULL)
END