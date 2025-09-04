
CREATE View [dbo].[ExitFeeMaturityCheck]
as
Select 
d.CREDealID
,DealName
, F.Crenoteid
,N.Name NoteName
,EffectiveDate,StartDate
, FeeName
, FullyExtendedMaturityDate
, ActualPayoffDate
, PaidOffVsActive = Case when ActualPayoffDate is NULL then 'Active' else 'Paid Off' End
, IsMaxExitFeeDate  = Case when F.EndDate = MaxExitFeeEnddate Then 'Yes' Else 'No'  end 
, F.EndDate
,[Value]
--,Case when Datediff(DAY, FullyExtendedMaturityDate, f.Enddate)<= 2 then Replace( f.Enddate
,Abs_Delta= ABS( Datediff(DAY, FullyExtendedMaturityDate, Case when Datediff(DAY, FullyExtendedMaturityDate, f.Enddate)between 0 and 2 Then FullyExtendedMaturityDate else f.Enddate end))
,Delta= ( Datediff(DAY, FullyExtendedMaturityDate, Case when Datediff(DAY, FullyExtendedMaturityDate, f.Enddate)between 0 and 2 Then FullyExtendedMaturityDate else f.Enddate end))
from Dw.[FeeScheduleBI] F
Inner join Dw.NoteBI N on N.Noteid = F.Noteid
inner join Dw.DealBI D on D.Dealid = N.Dealid


outer apply (select Noteid, Max(Enddate)MaxExitFeeEnddate from dbo.feeschedule F1
			where F1.FeeType like '%exit%' 
			--and ISNULL(f1.Feetobestripped,0) <> 1
			Group by F1.Noteid)x
			Where F.Crenoteid = X.Noteid 
			--and F.StartDate = X.MaxExitFeestartdate
and F.FeeType like '%exit%' 
--and ISNULL(f.Feetobestripped,0) <> 1
GO