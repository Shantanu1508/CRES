CREATE PROCEDURE [dbo].[usp_GetCollectCalculatorLogsValue] 
  
AS
 BEGIN

  SELECT [Value] from [App].[AppConfig] WHERE [key]='CollectCalculatorLogs'

 END