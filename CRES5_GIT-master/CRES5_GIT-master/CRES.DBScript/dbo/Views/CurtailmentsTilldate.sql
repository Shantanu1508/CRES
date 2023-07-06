

Create view [dbo].[CurtailmentsTilldate]
as

Select 
CRENoteID 

,SUM(Amortization)Amortization
,SUM(Prepayments)Prepayments
, SUM(NegativeNoteTransfer)NegativeNoteTransfer
, SUM(FullPayoff)FullPayoff
,LoanstatusCD_F
from
(


Select CRENoteID
,  Amortization = Case when purpose = 'Amortization' then SUM (Amount) end 
, PurposePaydownFullpayoff = Case When purpose in ( 'Paydown', 'Full Payoff', 'Property Release', 'Paydown', 'Other') then  'Paydown' end
, PurposeNegativeNoteTransfer = Case When purpose = 'Note Transfer' Then 'negative note tranfer' End

, PurposeAmortization =  Case when purpose = 'Amortization' then 'Amortization' end 
, PurposeFullpayoff = Case when purpose = 'Full Payoff' then 'Amortization' end 
, Prepayments = Case When purpose in ( 'Paydown', 'Property Release', 'Paydown', 'Other')
							Then SUM (Amount)  end
, NegativeNoteTransfer = Case when purpose = 'Note Transfer' then SUM (Amount) end 
, FullPayoff = Case When purpose = 'Full Payoff' Then SUM (Amount)  end

,LoanstatusCD_F

from NoteFundingSchedule M
Left join UwDeal D on D.DealName = M.Dealname

Where Purpose  in ('Amortization', 'Paydown', 'Full Payoff', 'Property Release', 'Paydown', 'Other', 'Note Transfer' ) 
and isnull(Amount,0) < 0  

and Date <= Dateadd(d,-1,Convert(date,Getdate()))
group By CRENoteID, LoanstatusCD_F, Purpose
)x
group by CRENoteID

,LoanstatusCD_F
