-- View
Create View FullAmortizing
as

Select Dealname
,X.Noteid
,HasFunding
,X.name
,X.Crenoteid
, Actualpayoffdate
,fullyExtendedMaturitydate
,Expectedmaturitydate

,y.Amount fees_toBeAmortized
,FEEActualAmortized
, Delta_Fees = ISNULL(y.Amount ,0)  - ISNULL(FEEActualAmortized,0)

,paidoff_vs_Active =Case when Actualpayoffdate is not null and Actualpayoffdate >= '1/1/2019' and ActualPayoffdate <= '12/31/2019'then 'Paid in 2019' 
		when Actualpayoffdate is not null and Actualpayoffdate >= '1/1/2020' and  ActualPayoffdate <= '12/31/2020'then 'Paid in 2020' 
		when Actualpayoffdate is not null and Actualpayoffdate >= '1/1/2021'and ActualPayoffdate <= '12/31/2021' then 'Paid in 2021' 
		when Actualpayoffdate is not null and Actualpayoffdate < '1/1/2019' then 'Paid before 2019' 
		when ActualPayoffdate is null then 'Active'
		end
, z.Amount DiscountPremium_ToBeAmortized
,DiscountPremium_ActualAmortized
,Delta_DiscountPremium = ISNULL(z.Amount,0) - ISNULL(DiscountPremium_ActualAmortized,0)

,w.Amount CapCost_TobeAmortized
,CapitalizedCostAccrual_ActualAmortized
, Delta_Capcost = ISNULL(w.Amount,0) - ISNULL(CapitalizedCostAccrual_ActualAmortized,0)

from
(

select
Dealname
,NC.Noteid
,N1.name
,NC.Crenoteid
,SUM( TotalAmortAccrualForPeriod)FEEActualAmortized
, SUM([DiscountPremiumAccrual])DiscountPremium_ActualAmortized
,SUM([CapitalizedCostAccrual] )CapitalizedCostAccrual_ActualAmortized
,N1.FullyExtendedMaturityDate
, N1.ActualPayoffDate
, N1.ExpectedMaturityDate
,HasFunding
from  [IntegrationGAAP] NC

----left Join [dbo].[DiscountPremium] D on D.[Notekey] = NC.noteid
----left Join [dbo].[Capcost] C on C.Notekey = NC.noteid
left join Note N1 on N1.Notekey = NC.Noteid
left join hasFunding_NoFunding F on F.Noteid = N1.NoteID
where 
 Periodenddate = Eomonth(Periodenddate,0)
Group by NC.CreNoteid, N1.FullyExtendedMaturityDate, N1.ActualPayoffDate, N1.ExpectedMaturityDate, NC.Noteid, Dealname,  N1.name
,HasFunding

)x
outer apply (select N.Notekey, Amount from [IncludedinLevelyield] N where x.Noteid = N.Notekey  )y
outer apply (select d.Notekey, Amount from [dbo].[DiscountPremium] D  where x.Noteid = D.Notekey  )z
outer apply (select c.Notekey, Amount from [dbo].[Capcost] C  where x.Noteid = C.Notekey  )w
--where crenoteid in
--(
--'IC_CSE 1A-1',
--'Phtm Resort B',
--'3097',
--'3428',
--'90 Phtm A',
--'IC_SOP AFS_B',
--'IC_CSE 1A-2',
--'1852',
--'2209',
--'1280',
--'2208',
--'1300',
--'6179',
--'2647',
--'IC_CSE 1B',
--'Core SB PH A Sold',
--'2741',
--'Phtm Npsi B',
--'Phtm Resort A',
--'IC_CSE Mezz 1'
--)