CREATE PROCEDURE [dbo].[usp_GetCalculationSummaryForValuationDashBoard]
AS
BEGIN

    SET NOCOUNT ON;
	Select * from 
	(

	select 
		VM.VMName, 
		count(l.StatusID) as [Count],
		l.Name,
		'ServerName' as 'GridType'
	 from val.ValuationRequests cr
	INNER JOIN  App.VMMaster VM ON VM.VMMasterID=cr.VMMasterID
	inner join Core.Lookup l on l.LookupID = cr.StatusID
	group by cr.statusid,l.Name,l.StatusID,VM.VMName

	UNION

	select 
		CAST(MD.MarkedDate as NVARCHAR), 
		count(l.StatusID) as [Count],
		l.Name,
		'MarkedDate' as 'GridType'
	 from val.ValuationRequests cr
	INNER JOIN [VAL].[MarkedDateMaster] MD ON MD.MarkedDateMasterID=cr.MarkedDateMasterID
	inner join Core.Lookup l on l.LookupID = cr.StatusID
	group by cr.statusid,l.Name,l.StatusID,MD.MarkedDate

	) as Result
	PIVOT  
		(
			MIN([Count])  
			FOR [Name] IN ([Processing],[Running],[Completed],[Failed])  
		) AS PivotTable
END