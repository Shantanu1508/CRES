  
-- View  
CREATE View  [dbo].[NotePIKBalance] as 
Select n.noteid,isnull(ABS(SUM(tr.Amount)),0) as SumPikAmount  
from transactionEntry Tr  
Inner join note n on n.Notekey = tr.notekey  
where tr.analysisID =  'C10F3372-0FC2-4861-A9F5-148F1F80804F' and tr.[Type] in ('PikPrincipalPaid','PIKPrincipalFunding')  
and tr.date <= CAST(getdate() as date)  
and tr.AccounttypeID = 1  
group by n.noteid  