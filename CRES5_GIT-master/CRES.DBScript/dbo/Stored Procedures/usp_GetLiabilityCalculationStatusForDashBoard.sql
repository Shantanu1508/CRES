CREATE PROCEDURE [dbo].[usp_GetLiabilityCalculationStatusForDashBoard]   --'c10f3372-0fc2-4861-a9f5-148f1f80804f'  
	@AnalysisID UNIQUEIDENTIFIER = null
AS  
BEGIN  
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
	SET FMTONLY OFF;  
     
	--Declare @AnalysisID UNIQUEIDENTIFIER  ='c10f3372-0fc2-4861-a9f5-148f1f80804f' ;

	IF @AnalysisID IS NULL
	BEGIN
		SET @AnalysisID = (Select AnalysisID from [Core].[Analysis] where [Name]='Default') 
	END

	DECLARE @startdate VARCHAR(50);  
	DECLARE @enddate VARCHAR(50);  
	
	set @startdate = (select min(endtime) from Core.CalculationRequestsLiability cr where StatusID=266 and  AnalysisID =@AnalysisID and cr.RequestTime>=cast(dateadd(day, -1, getdate()) as date) and CalcType IN (910))   
	set @enddate = (select max(endtime) from Core.CalculationRequestsLiability cr where StatusID=266  and   AnalysisID =@AnalysisID  and cr.RequestTime>=cast(dateadd(day, -1, getdate()) as date) and CalcType IN (910))  

	select count(l.StatusID) as [Count],l.Name,null as [Date] , '' as IsChart from Core.CalculationRequestsLiability  cr  
	inner join  Core.Lookup l on l.LookupID = cr.StatusID  
	where AnalysisID = @AnalysisID  
	and CalcType IN (910)  
	group by cr.statusid,l.Name,l.StatusID  
  
	union all  
	
	select 0 as [count] ,  
	'Calculation Request time' as [Name],   
	min(RequestTime)  as [Date],  
	'' as IsChart  
	from Core.CalculationRequestsLiability where AnalysisID =@AnalysisID  
	and RequestTime>=cast(dateadd(day, -1, getdate()) as date)  
	and CalcType IN (910)  
  
	union all  
  
	select datediff(mi, @startdate, @enddate) as [count],  
	'Total Calculation time in min' as [Name],  
	null as [Date],  
	'' as IsChart  
   
	union all  
  
	SELECT  COUNT(ErrorMessage)  as [count] ,ErrorMessage  as [Name] , null as [Date],'calcerror' as IsChart from Core.CalculationRequestsLiability  
	WHERE ErrorMessage != '' and AnalysisID =@AnalysisID and CalcType IN (910)  
	GROUP BY ErrorMessage  
	HAVING COUNT(ErrorMessage) > 0  
  
	union all

	Select  COUNT(cq.RequestID) as [Count],'Data Saved in DB',null as [Date] ,CAST(cr.CalcEngineType as varchar(10))  as IsChart
	from [Core].[CalculationQueueRequest] cq
	inner join [Core].[CalculationRequestsLiability] cr on cq.requestid = cr.requestid
	where cr.analysisid =@AnalysisID
	and ([TransactionOutput] = 266 and [NotePeriodicOutput] = 266 and [StrippingOutput] = 266) 
	 and CalcType IN (910)  
	group by  cr.CalcEngineType

END