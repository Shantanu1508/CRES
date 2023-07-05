CREATE view [dbo].[FFClosingDateCompare]
As
Select  
Distinct
D.dealName

 ,NF.CRENoteID 
,isFundingdateequalclosingdate= 
Case when ISNULL(N.ClosingDate,'') = ISNULL(NF.Date,'') then 'yes' 
else 'no'
 end
 , Discount
 , CapitalizedClosingCosts
 , OriginationFee
 ,ClosingDate

																	
from Dw.NoteFundingScheduleBI NF
Inner join Dw.NoteBI  N on NF.CRENoteID =  N.CreNoteid
Inner join Dw.DealBI D on D.Dealid =  N.DealID
--where ISNULL(ClosingDate,'') = ISNULL(Date,'')
--where  
--NF.CRENoteID in( Select Case WHen Not exists (Select N.CRENoteID from Dw.NoteBI N
--																	Inner join Dw.NoteFundingScheduleBI NF on N.CRENoteID = NF.CRENoteID
--																	and ISNULL(ClosingDate, '') = ISNull(NF.Date,'')) then N.CRENoteID else NF.Crenoteid End
--																	from Note)
																	
													
			 --NF.CRENoteID = '12409'										

