CREATE PROCEDURE [dbo].[usp_GetDiscrepancyForCommitment] 
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


	Select 
	d.[DealID]
	,D.DealName as [Deal Name]
	,N.NoteID
	, N.Name as [Note Name]
	,CONVERT(varchar, n.ActualPayOffDate, 101) ActualPayOffDate
	, L.Name
	,CONVERT(varchar, Date, 101) as Date
	,Cast(ROUND(ND.[Value]  ,2)  as decimal(28,2)) [Value]
	from [CRE].[NoteAdjustedCommitmentMaster] NM
	left join [CRE].[NoteAdjustedCommitmentDetail] ND 
	on ND.[NoteAdjustedCommitmentMasterID] = NM.[NoteAdjustedCommitmentMasterID]
	left join note n on N.Notekey = ND.[NoteID]
	left join deal d on D.Dealkey = n.Dealkey
	left join core.lookup l on l.lookupid = nd.[Type]
	where Nd.value <> 0 
	and l.name = 'Prepayment' and ROUND(ND.Value,2) > 0 and ROUND(ND.Value,2) > 0.20
	AND d.DealName NOT LIKE '%copy%'
	--and d.dealid = '17-0648IC'
	--and n.noteid = 'IC_Upper Rock_B'


 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END     