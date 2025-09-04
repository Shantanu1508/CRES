CREATE View [dbo].[Transactiontype_NonGAAP]

As
Select Distinct Type 


from dw.transactionEntryBI
Where Type not in ('SpreadPercentage', 'LIBORPercentage', 'EndingPVGAAPBookValue', 'EndingGAAPBookValue')
and AccountTypeID = 1

