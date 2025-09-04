CREATE PROCEDURE [VAL].[usp_GetValuationRequests] 
(	
	@TimeZoneName nvarchar(250)
)
     
AS        
BEGIN        
 SET NOCOUNT ON;        
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        



	select CAST(md.MarkedDate as Datetime) as MarkedDate
	,d.DealName
	,d.CREDealID	
	,lstatus.Name as [Status]
	,isnull( [dbo].[ufn_GetTimeByTimeZoneName] (v.RequestTime,@TimeZoneName ),v.RequestTime)	 
	,v.CreatedBy
	,isnull( [dbo].[ufn_GetTimeByTimeZoneName] (v.StartTime,@TimeZoneName ),v.StartTime)	
	,isnull( [dbo].[ufn_GetTimeByTimeZoneName] (v.EndTime,@TimeZoneName ),v.EndTime)
	,v.ErrorMessage	
	,v.NumberOfRetries
	from  val.valuationrequests v
	Left Join cre.deal d on d.dealid = v.dealid 
	left Join core.lookup lstatus on lstatus.lookupid = v.StatusID	
	left Join core.analysis a on a.analysisid = v.AnalysisID
	Inner Join [VAL].[MarkedDateMaster] md on md.MarkedDateMasterID = v.MarkedDateMasterID
	Where v.CreatedDate>=DateAdd(hour,-24,getdate())
	Order by md.MarkedDate,v.RequestTime desc


        
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED        
END
GO

