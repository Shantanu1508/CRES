CREATE View [dbo].[FeeFunctionsDefinition]
as 
SELECT [FunctionName]
      ,[FunctionType]
      ,[PaymentFrequency]
      ,[AccrualBasis]
      ,[AccrualStartDate]
      ,[AccrualPeriod]
  FROM [DW].[FeeFunctionsDefinitionBI]



