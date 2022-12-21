CREATE view [dbo].[MultiAmortMethods]
As
Select DealName, Count(distinct Dealname)number, Status
,DealNameStatus =  Dealname + '_' + Status
from
(

Select DealName, AmortMethodused, Status from [dbo].[CurrentAmortAnalysis]
group by DealName, AmortMethodused, Status

)X
Group by Dealname, Status
Having count (*)>1
