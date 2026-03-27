
Print('Insert in Analysis')
IF NOT EXISTS(Select [Name] from [Core].[Analysis] where [Name] = 'Sizer Only')
BEGIN
	INSERT [Core].[Analysis] ([AnalysisID], [Name], [StatusID], [Description], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [ScenarioColor]) VALUES (N'02d20d3e-291a-42f8-afcd-bddfbb9da16b', N'Sizer Only', 4, N'this will be used only add-in  ', N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2021-01-22T04:16:53.203' AS DateTime), N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2021-01-22T04:21:42.693' AS DateTime), N'turquoise3')

	INSERT [Core].[AnalysisParameter] ([AnalysisParameterID], [AnalysisID], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [MaturityScenarioOverrideID], [MaturityAdjustment], [FunctionName], [IndexScenarioOverride], [CalculationMode], [ExcludedForcastedPrePayment], [AutoCalculationFrequency], [NextExecuteTime], [UseActuals], [UseBusinessDayAdjustment]) VALUES (N'9c888bb1-48b0-4a06-ab08-ff1aaa7cee19', N'02d20d3e-291a-42f8-afcd-bddfbb9da16b', N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2021-01-22T04:16:53.230' AS DateTime), N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2021-01-22T04:21:42.720' AS DateTime), 343, NULL, N'', 1, 503, 4, NULL, NULL, 4, 3)
END