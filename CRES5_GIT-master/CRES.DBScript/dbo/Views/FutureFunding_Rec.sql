-- View
-- View
CREATE view FutureFunding_Rec
AS

Select 
S.NoteID
, S.transactionDate,
S.PurposeBI
, S.WireConfirmBI
, userenteredorAutospread= Case when purposebi = 'Paydown' and ISNULL(s.wireconfirm,0) =1 
or (s.comments is not null and s.comments <> 'None') or (s.Amount>0 and s.Wireconfirm = 1) 
or (s.Amount>0 and s.comments is not null and s.comments <> 'None') Then 'Auto Spread'
else 'User Entered' end
, N.Amount Int_FF_Amt, 
S.amount Stg_FF_Amount
, ISNULL(N.Amount,0) - ISNULL(S.Amount,0) As Delta
, HasDelta= Case when ISNULL(N.Amount,0) - ISNULL(S.Amount,0) <>0 then 'Yes'  else 'No' end
from [dbo].[Staging_NoteFunding] s
left join NoteFundingSchedule N on s.noteid = n.CRENoteID and n.date=s.transactionDate 
and isnull(s.PurposeBI,'') =isnull(n.Purpose,'') 
and ISNULL(S.Comments, 'None') =ISNULL(n.CommentsBI, 'None') 
and ISNULL(s.wireconfirm,0) = isnull(N.wireconfirm,0)