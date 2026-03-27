update cre.ReserveAccount set ReserveAccountName='Tenant Improvements / 3A Durango' where ReserveAccountName ='3A Durango'
update cre.ReserveAccount set ReserveAccountName='TI and LC / 3C Kansas City' where ReserveAccountName ='3C Kansas City'
update cre.ReserveAccount set ReserveAccountName='TI and LC / 2B Dallas' where ReserveAccountName ='2B Dallas'
update cre.ReserveAccount set ReserveAccountName='Net Proceeds' where ReserveAccountName ='Net Proceeds'
update cre.ReserveAccount set ReserveAccountName='Excess Cash Flow' where ReserveAccountName ='Excess Cash Flow'
update cre.ReserveAccount set ReserveAccountName='Debt Service / Debt Service and Operating Shortfall Reserve' where ReserveAccountName ='Debt Service Reserve'
update cre.ReserveAccount set ReserveAccountName='Retention Reserve / Oregon Construction Retainage Escrow Account' where ReserveAccountName ='Oregon Retainage Reserve'
update cre.ReserveAccount set ReserveAccountName='Project Reserve / Project Expenditure Reserve Account' where ReserveAccountName ='Project Expenditure'

Update RA Set RA.ReserveAccountMasterID = RAM.ReserveAccountMasterID
from cre.ReserveAccount RA INNER JOIN cre.ReserveAccountMaster RAM ON RA.ReserveAccountName = RAM.ReserveAccountName