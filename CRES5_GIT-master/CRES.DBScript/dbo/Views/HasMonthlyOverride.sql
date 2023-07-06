CREATE View [dbo].[HasMonthlyOverride]
as

Select DealName, count (Distinct DealName)number, status 

,DealNameStatus =  Dealname + '_' + Status from
(

Select DealName,Date, Status from [dbo].[CurrentAmortAnalysis]
Where AmortMethodused = 'Has Monthly Override'
group by DealName , Date, Status
Having count (dealname)>1
)x
group by Dealname, status
Having count (*)>1


