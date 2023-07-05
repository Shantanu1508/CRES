-- Procedure
-- [dbo].[usp_GetInterestPaidTransactionEntry] 'b0e6697b-3534-4c09-be0a-04473401ab93','c7a300a5-33ff-42c9-9806-7d94d58f8010','11168,11169','12/09/2022 12:00:00 AM','10/10/2023 12:00:00 AM'
CREATE PROCEDURE [dbo].[usp_GetInterestPaidTransactionEntry]
@UserId nvarchar(256),
@DealID UNIQUEIDENTIFIER,
@MultipleNoteids nvarchar(max),
@StartDate Date,
@EndDate Date 

 
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
IF OBJECT_ID('tempdb..[#tblListNotes]') IS NOT NULL                                         
	DROP TABLE [#tblListNotes]

CREATE TABLE #tblListNotes(
	CRENoteID VARCHAR(256)
)
INSERT INTO #tblListNotes(CRENoteID)
select Value from fn_Split(@MultipleNoteids);
--=================
	SELECT  NoteID,convert(varchar,Date,101) as Date,Amount
	FROM CRE.TransactionEntry
	WHERE [Type]='InterestPaid' 
	and [Date] >= @StartDate 
	and [Date]<= @EndDate
	and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	and  NoteID IN (SELECT NoteID FROM CRE.Note WHERE CRENoteID in (Select CRENoteID from #tblListNotes))
	GROUP BY NoteID,Date,Amount
END
