
Create View [dbo].[NegativeNoteTransfersTillDate]
As

Select CRENoteID,  SUM (Amount)Amount, LoanstatusCD_F
--, SUM(EndingBalance) EndingBalance
from NoteFundingSchedule M
Left join UwDeal D on D.DealName = M.Dealname
--Left Join ( select Noteid, SUM(EndingBalance)EndingBalance from cre.[NotePeriodicCalc] nc
--			where analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' and convert(date,periodendDate) = Dateadd(d,-1,Convert(date,Getdate()))
--			Group by Nc.noteid
--			)x

--on x.noteid = Noteid 
Where Purpose  in ('Note Transfer' ) and isnull(Amount,0) < 0  

and Date <= Dateadd(d,-1,Convert(date,Getdate()))
group By CRENoteID, LoanstatusCD_F
