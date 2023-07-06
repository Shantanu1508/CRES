
-- usp_GetScheduledPrincipalByDealID '7fe5cb7d-a7d4-4d4b-bef3-228774d85545','7fe5cb7d-a7d4-4d4b-bef3-228774d85545'
-- usp_GetScheduledPrincipalByDealID '17-1036','7fe5cb7d-a7d4-4d4b-bef3-228774d85545'
CREATE PROCEDURE [dbo].[usp_GetScheduledPrincipalByDealID]  
@DealID nvarchar(256),
@UserID uniqueidentifier

AS  
BEGIN  
    SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @Analysisid uniqueidentifier = (SELECT AnalysisID from CORE.Analysis WHERE Name='Default');

	SELECT n.NoteID,SUM(Amount) as Amount
	FROM cre.note n 
	inner join cre.deal d on d.dealid = n.DealID
	left join cre.TransactionEntry t on t.NoteID = n.NoteID
	where IIF(@DealID LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'),CAST(d.DealID as nvarchar(256)),d.CREDealID) = @DealID
	and AnalysisID=@Analysisid 
	and t.type='ScheduledPrincipalPaid' 
	and t.Date <= cast(getdate() as date)
	group by n.NoteID

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
