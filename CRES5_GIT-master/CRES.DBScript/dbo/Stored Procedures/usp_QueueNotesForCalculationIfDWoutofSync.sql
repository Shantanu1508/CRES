  
CREATE PROCEDURE [dbo].[usp_QueueNotesForCalculationIfDWoutofSync]     
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
 
  
Declare @tbltran as TABLE(	
	
	NoteId	UNIQUEIDENTIFIER,
	StatusText	nvarchar(256),
	UserName	nvarchar(256),
	PriorityText	nvarchar(256),
	AnalysisID		UNIQUEIDENTIFIER,
	CalcEngineTypeName nvarchar(256),  
	CalcType int
)
  
INSERT INTO @tbltran(NoteId,StatusText,UserName,PriorityText,AnalysisID,CalcType)  
Select Distinct noteid,'Processing' as StatusText,'3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50' as UserName,'Batch' as PriorityText,analysisID,775 as CalcType  
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
  Select n.noteid,n.CREnoteid,nc.AnalysisID,count(nc.AccountID) as SourceCnt ,   
  (Select count(ncBI.noteid) as cnt   
   from dw.noteperiodiccalcBI ncBI   
   where ncbi.NoteID = n.noteid and ncbi.AnalysisID = nc.AnalysisID  
  )as BICount  
  from cre.note n  
  inner join core.Account acc on acc.accountid = n.account_accountid  
  left join cre.noteperiodiccalc nc on nc.AccountID = acc.AccountID
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
  Select n.noteid,n.CREnoteid,nc.AnalysisID,count(n.noteid) as SourceCnt ,   
  (Select count(ncBI.noteid) as cnt   
   from dw.TransactionEntryBI ncBI   
   where ncbi.AccountID = n.Account_AccountID and ncbi.AnalysisID = nc.AnalysisID  
  )as BICount  
  from cre.note n  
  inner join core.Account acc on acc.accountid = n.account_accountid  
  left join cre.TransactionEntry nc on n.Account_AccountID = nc.AccountID   
  where acc.isdeleted <> 1  and n.dealid <> '19B51FBD-1F14-41B8-844C-ABD57B772C3A' --sizer test deal  
  group by n.noteid,n.CREnoteid,nc.AnalysisID  ,n.Account_AccountID
 )a  
 left join core.analysis an on an.AnalysisID = a.AnalysisID  
 where SourceCnt <> 0    
 and (SourceCnt - BICount) > 0  
)z  
  


---========================
Declare @Analysisid UNIQUEIDENTIFIER
 
IF CURSOR_STATUS('global','CursorAnalysis')>=-1
BEGIN
	DEALLOCATE CursorAnalysis
END

DECLARE CursorAnalysis CURSOR 
for
(
	Select distinct Analysisid from @tbltran where Analysisid is not null
)
OPEN CursorAnalysis 

FETCH NEXT FROM CursorAnalysis
INTO @Analysisid

WHILE @@FETCH_STATUS = 0
BEGIN

	---Queue note for calculation
	declare @TableTypeCR TableTypeCalculationRequests  
 
	delete From @TableTypeCR

	INSERT INTO @TableTypeCR(NoteId,StatusText,UserName,PriorityText,AnalysisID,CalcType)  
	Select Distinct NoteId,StatusText,UserName,PriorityText,AnalysisID,CalcType
	from @tbltran t
	where t.Analysisid = @Analysisid

	
	exec [dbo].[usp_QueueNotesForCalculation] @TableTypeCR,'3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50','3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50', NULL, NULL, 'DWOutofSync'
  
FETCH NEXT FROM CursorAnalysis
INTO @Analysisid
END
CLOSE CursorAnalysis   
DEALLOCATE CursorAnalysis
  
  
  
  

  
  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
  
END  