-- Procedure
CREATE Procedure [dbo].[usp_GetCalculationResults]

@crenoteid nvarchar(MAX),
@AnalysisID  nvarchar(MAX)
AS
BEGIN
	SET NOCOUNT ON;

if(@crenoteid<>'')
BEGIN
	
	CREATE TABLE #tblListNotes(
	  CRENoteID VARCHAR(256)
	)
	INSERT INTO #tblListNotes(CRENoteID)
	select Value from fn_Split(@crenoteid);
END;

 
Select creNoteId,Username,Analysisid,RequestTime,  EndTime, l.Name StatusName
From [Core].[CalculationRequests] c
inner join cre.note n on n.Account_AccountID = c.AccountId
Inner join core.lookup l on l.lookupid = c.statusid
where crenoteid in (select CRENoteID from #tblListNotes) and [AnalysisID] = @AnalysisID
and c.CalcType = 775


 
	 
End