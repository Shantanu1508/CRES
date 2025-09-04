

Print('Insert into appconfig')


delete from [App].[AppConfig]  where [Key] = 'GetChathamFinancialDailyRateURL' 
INSERT [App].[AppConfig] ([Key], [Value], [Comments], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (N'GetChathamFinancialDailyRateURL', N'https://www.chathamfinancial.com/getrates/297760', N'api to import daily data', NULL, NULL, NULL, NULL)
 


 
delete from [App].[AppConfig]  where [Key] = 'ChathamFinancialForwardRateQuarterly' 
INSERT [App].[AppConfig] ([Key], [Value], [Comments], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (N'ChathamFinancialForwardRateQuarterly', N'https://www.chathamfinancial.com/getrates/285116', N'api to import Rate Quarterly', NULL, NULL, NULL, NULL)
 



  

