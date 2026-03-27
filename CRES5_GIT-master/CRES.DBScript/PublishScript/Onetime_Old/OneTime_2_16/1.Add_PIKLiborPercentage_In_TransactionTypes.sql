SET IDENTITY_INSERT [CRE].[TransactionTypes] ON
IF NOT EXISTS(Select [TransactionName] from [CRE].[TransactionTypes] where [TransactionName] = 'PIKLiborPercentage')
BEGIN
	INSERT [CRE].[TransactionTypes] ([TransactionTypesID], [TransactionTypesGUID], [TransactionName], [TransactionCategory], [Calculated], [IncludeCashflowDownload], [IncludeServicingReconciliation], [IncludeGAAPCalculations], [AllowCalculationOverride], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [TransactionGroup]) VALUES (57, N'db046879-a909-456a-a488-5cdf023b2561', N'PIKLiborPercentage', N'Default', 3, 3, 3, 3, 4, N'B0E6697B-3534-4C09-BE0A-04473401AB93', CAST(N'2021-01-06T12:08:39.380' AS DateTime), N'B0E6697B-3534-4C09-BE0A-04473401AB93', CAST(N'2021-01-06T12:08:39.380' AS DateTime), N'')
END
SET IDENTITY_INSERT [CRE].[TransactionTypes] OFF