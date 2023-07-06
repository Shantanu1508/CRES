
CREATE PROCEDURE [dbo].[usp_QueueNotesForCalculationIfDWoutofSync]  

AS
BEGIN
	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


declare @TableTypeCalculationRequests TableTypeCalculationRequests

INSERT INTO @TableTypeCalculationRequests(NoteId,StatusText,UserName,PriorityText,AnalysisID,CalcType)
Select Distinct noteid,'Processing' as StatusText,'B0E6697B-3534-4C09-BE0A-04473401AB93' as UserName,'Batch' as PriorityText,analysisID,775 as CalcType
From(
	Select 
	an.analysisID,
	noteid,
	CREnoteid,
	an.[Name] as ScenarioName,
	SourceCnt,
	BICount,
	(SourceCnt - BICount) as Diff
	from (
		Select n.noteid,n.CREnoteid,nc.AnalysisID,count(nc.noteid) as SourceCnt , 
		(Select count(ncBI.noteid) as cnt 
			from dw.noteperiodiccalcBI ncBI 
			where ncbi.NoteID = n.noteid and ncbi.AnalysisID = nc.AnalysisID
		)as BICount
		from cre.note n
		inner join core.Account acc on acc.accountid = n.account_accountid
		left join cre.noteperiodiccalc nc on n.noteid = nc.noteid	
		where acc.isdeleted <> 1 and n.dealid <> '19B51FBD-1F14-41B8-844C-ABD57B772C3A' --sizer test deal
		group by n.noteid,n.CREnoteid,nc.AnalysisID
	)a
	left join core.analysis an on an.AnalysisID = a.AnalysisID
	where SourceCnt <> 0 
	
	and (SourceCnt - BICount) > 0

	UNION


	Select 
	an.analysisID,
	noteid,
	CREnoteid,
	an.[Name] as ScenarioName,
	SourceCnt,
	BICount,
	(SourceCnt - BICount) as Diff
	from (
		Select n.noteid,n.CREnoteid,nc.AnalysisID,count(nc.noteid) as SourceCnt , 
		(Select count(ncBI.noteid) as cnt 
			from dw.TransactionEntryBI ncBI 
			where ncbi.NoteID = n.noteid and ncbi.AnalysisID = nc.AnalysisID
		)as BICount
		from cre.note n
		inner join core.Account acc on acc.accountid = n.account_accountid
		left join cre.TransactionEntry nc on n.noteid = nc.noteid	
		where acc.isdeleted <> 1  and n.dealid <> '19B51FBD-1F14-41B8-844C-ABD57B772C3A' --sizer test deal
		group by n.noteid,n.CREnoteid,nc.AnalysisID
	)a
	left join core.analysis an on an.AnalysisID = a.AnalysisID
	where SourceCnt <> 0 	
	and (SourceCnt - BICount) > 0
)z


exec [dbo].[usp_QueueNotesForCalculation] @TableTypeCalculationRequests,'B0E6697B-3534-4C09-BE0A-04473401AB93','B0E6697B-3534-4C09-BE0A-04473401AB93' 




SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END
GO

