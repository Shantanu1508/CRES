
CREATE PROCEDURE [dbo].[usp_GetFastestAndSlowest]  --'AED67736-F2A1-483C-8015-6BC14E4A50AC'	
	@AnalysisID UNIQUEIDENTIFIER
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF;  
 


Select * from (
select top 1 'Max Time' as [type],n.crenoteid, MAx(datediff(SECOND,StartTime,EndTime)) as [time] 
from Core.CalculationRequests cr
left join cre.note n on n.noteid = cr.noteid
where StartTime is not null and EndTime is not null and cr.AnalysisID=@AnalysisID
and CalcType = 775
group by n.crenoteid
order by MAx(datediff(SECOND,StartTime,EndTime)) desc
)a

UNION 

Select * from (
select top 1 'Min Time' as [type],n.crenoteid, MIN(datediff(SECOND,StartTime,EndTime)) as [time] 
from Core.CalculationRequests cr
left join cre.note n on n.noteid = cr.noteid
where StartTime is not null and EndTime is not null and cr.AnalysisID=@AnalysisID
and CalcType = 775
group by n.crenoteid
order by MIN(datediff(SECOND,StartTime,EndTime))
)b 

--union

--select  
--'timetaken' as [type],
--  n.crenoteid
-- ,datediff(SECOND,StartTime,EndTime) as timetaken  
-- from Core.CalculationRequests cr
--left join cre.note n on n.noteid = cr.noteid
--where StartTime is not null and EndTime is not null and cr.AnalysisID=@AnalysisID
--and cr.RequestTime>=cast(dateadd(day, -1, getdate()) as date)

END


