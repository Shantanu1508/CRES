
Delete from cre.TransactionTypes where TransactionCategory = 'Liability' and TransactionName in ('Equity','Subline')

--Select * from cre.TransactionTypes where TransactionCategory = 'Liability' and TransactionName in ('EquityCapitalDistribution')

Update cre.TransactionTypes SET TransactionName = 'EquityCapitalAllocation',AccountName = 'EquityCapitalAllocation',TransactionGroup = 'EquityCapitalAllocation' where TransactionCategory = 'Liability' and TransactionName in ('EquityCapitalDistribution')
Update cre.TransactionTypes SET TransactionName = 'SublineCall',AccountName = 'SublineCall',TransactionGroup = 'SublineCall' where TransactionCategory = 'Liability' and TransactionName in ('SublineAdvance')
Update cre.TransactionTypes SET TransactionName = 'SublineAllocation',AccountName = 'SublineAllocation',TransactionGroup = 'SublineAllocation' where TransactionCategory = 'Liability' and TransactionName in ('SublinePaydown')