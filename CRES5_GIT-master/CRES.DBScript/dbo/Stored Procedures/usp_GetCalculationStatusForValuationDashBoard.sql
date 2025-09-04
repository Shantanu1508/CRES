CREATE PROCEDURE [dbo].[usp_GetCalculationStatusForValuationDashBoard]
AS
BEGIN

    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    SET FMTONLY OFF;

    select count(l.StatusID) as [Count],
           l.Name,
           cr.StatusID,
           ''  as IsChart,
		   '' as ErrorMessage_group
    from val.ValuationRequests cr
        inner join Core.Lookup l
            on l.LookupID = cr.StatusID
    group by cr.statusid,
             l.Name,
             l.StatusID
    union all
    Select DATEDIFF(minute, MIN(StartTime), MAX(EndTime)) as [count],
           'Total Calculation time in min' as [Name],
           null as [StatusID],
           '' as IsChart,
		    '' as ErrorMessage_group
    from [val].ValuationRequests cr
    where StatusID in ( 266, 265 )
          and cr.RequestTime >= cast(dateadd(day, -1, getdate()) as date)
    union all

	 Select SUM([count]) [count]
		,STRING_AGG([Name],', ') as [Name]
		,[StatusID]
		,IsChart
		,ErrorMessage_group
		From(
			SELECT COUNT(ErrorMessage) as [count],
			ErrorMessage as [Name],
			(CASE WHEN ErrorMessage like '%No Data to Calculate%' THEN 'No Data to Calculate' ELSE ErrorMessage END) ErrorMessage_group,
			null as [StatusID],
			'calcerror' as IsChart
			from val.ValuationRequests
			WHERE ErrorMessage != ''
			GROUP BY ErrorMessage
			HAVING COUNT(ErrorMessage) > 0
		)a
		Group by [StatusID]
		,IsChart
		,ErrorMessage_group

END