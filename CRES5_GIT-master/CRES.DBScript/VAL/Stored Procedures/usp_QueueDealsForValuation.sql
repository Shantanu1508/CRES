-- Procedure

CREATE PROCEDURE [VAL].[usp_QueueDealsForValuation]
(
	@tbltype_QueueDealsForValuation [val].[tbltype_QueueDealsForValuation] Readonly
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
 
	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = (Select top 1 MarkedDate from @tbltype_QueueDealsForValuation where MarkedDate is not null))




	Delete from [VAL].[ValuationRequests] where MarkedDateMasterID = @MarkedDateMasterID 
	and Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	and dealid in (	
		select Distinct d.DealID 
		from @tbltype_QueueDealsForValuation q
		Inner join cre.deal d on d.credealid = q.dealid  
		Where d.isdeleted <> 1
	)



	--Delete v From [VAL].[ValuationRequests]  v	
	--Inner Join cre.deal d on d.dealid = v.dealid
	--Inner Join Core.Analysis a on a.Analysisid = v.AnalysisID
	--Inner Join @tbltype_QueueDealsForValuation q on q.dealid = d.credealid and a.name = ISNULL(q.Scenario,'Default')
	--Where v.MarkedDateMasterID = @MarkedDateMasterID



	INSERT INTO [VAL].[ValuationRequests](MarkedDateMasterID,[DealID],[RequestTime],[StatusID],AnalysisID,[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],NumberOfRetries)
	Select Distinct  @MarkedDateMasterID
	,d.dealid
	,getdate() as [RequestTime]
	,292 as [StatusID]
	,a.AnalysisID
	,UserID
	,getdate()
	,UserID
	,getdate()
	,1 as NumberOfRetries
	from @tbltype_QueueDealsForValuation q
	Inner Join cre.deal d on d.credealid = q.dealid
	Inner Join Core.Analysis a on a.name = q.Scenario


	 

 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END


