
CREATE PROCEDURE [dbo].[usp_GetCalculationStatusForDashBoard] --'c10f3372-0fc2-4861-a9f5-148f1f80804f'
	@AnalysisID UNIQUEIDENTIFIER
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF;
   
 DECLARE @startdate VARCHAR(50);
DECLARE @enddate VARCHAR(50);
set @startdate = (select min(endtime) from Core.CalculationRequests cr where StatusID=266 and  AnalysisID =@AnalysisID and cr.RequestTime>=cast(dateadd(day, -1, getdate()) as date) and CalcType = 775) 
set @enddate = (select max(endtime) from Core.CalculationRequests cr where StatusID=266  and   AnalysisID =@AnalysisID  and cr.RequestTime>=cast(dateadd(day, -1, getdate()) as date) and CalcType = 775)


   select count(l.StatusID) as [Count],l.Name,null as [Date] , '' as IsChart from Core.CalculationRequests  cr
	inner join  Core.Lookup l on l.LookupID = cr.StatusID
	where AnalysisID =@AnalysisID
	 and cr.RequestTime>=cast(dateadd(day, -1, getdate()) as date)
	 and CalcType = 775
	group by cr.statusid,l.Name,l.StatusID

union all

select 0 as [count] ,
'Max Calculated time' as [Name], 
 @enddate  as [Date],
  '' as IsChart

union all
select 0 as [count] ,
'Min Calculated time' as [Name], 
 @startdate  as [Date],
  '' as IsChart

	
union all
select 0 as [count] ,
'Calculation Request time' as [Name], 
 min(RequestTime)  as [Date],
  '' as IsChart
from Core.CalculationRequests where AnalysisID =@AnalysisID
 and RequestTime>=cast(dateadd(day, -1, getdate()) as date)
 and CalcType = 775

union all

 select datediff(mi, @startdate, @enddate) as [count],
'Total Calculation time in min' as [Name],
 null as [Date],
 '' as IsChart
 
 union all

 SELECT  COUNT(ErrorMessage)  as [count] ,ErrorMessage  as [Name] , null as [Date],'calcerror' as IsChart from Core.CalculationRequests
WHERE ErrorMessage != '' and AnalysisID =@AnalysisID and CalcType = 775
GROUP BY ErrorMessage
HAVING COUNT(ErrorMessage) > 0


END


