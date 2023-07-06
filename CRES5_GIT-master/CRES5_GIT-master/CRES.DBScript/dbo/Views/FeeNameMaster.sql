CREATE View [dbo].[FeeNameMaster]
As
Select distinct ISNULL(Feename,'None')FeeName from Transactionentry


