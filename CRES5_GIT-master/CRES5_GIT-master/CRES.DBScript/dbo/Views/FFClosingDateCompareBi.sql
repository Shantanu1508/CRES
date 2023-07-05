CREATE View [dbo].[FFClosingDateCompareBi]
as

Select Distinct *
, Comment= Case when CRENoteID 
in (Select CRENoteID from [FFClosingDateCompare] Where isFundingdateequalclosingdate = 'yes'  )  AND CRENoteID in  (Select CreNoteid from [FFClosingDateCompare] Where isFundingdateequalclosingdate = 'no' ) 
	then 'FundingsOnandAfterClosing'else 'FundlingsonlyonClosing' end 
				
from [FFClosingDateCompare]
