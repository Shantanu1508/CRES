-- [dbo].[usp_GetNoteCommitmentsByNoteID] 'a980c8a4-b5c2-4224-aec6-8ad61fc7ea33','b0e6697b-3534-4c09-be0a-04473401ab93'
--  [dbo].[usp_GetNoteCommitmentsByNoteID] '62E55DE7-791D-4023-949A-D35AEE98CFA7','b0e6697b-3534-4c09-be0a-04473401ab93'
-- [dbo].[usp_GetNoteCommitmentsByNoteID] '5bf977cd-4922-4b8f-aef6-21503c8e9baf','b0e6697b-3534-4c09-be0a-04473401ab93'

Create PROCEDURE [dbo].[usp_GetNoteCommitmentsByNoteID] 
(
@NoteId nvarchar(256),
@UserID nvarchar(256)
)
AS
BEGIN

DECLARE @DealID uniqueidentifier = (SELECT DealID FROM CRE.Note where NoteID = @NoteId);
Declare @BaseCurrencyName nvarchar(max) = ISNULL((SELECT TOP 1  ISNULL(REPLACE(l.Name,'CAD','USD'),'USD') as Name
											FROM cre.note n
											left join  core.account acc on n.Account_AccountID = acc.AccountID
											left join core.lookup l on l.lookupid = acc.BaseCurrencyID
											left join cre.deal d on d.DealID = n.DealID
											WHERE d.DealID = @Dealid
											ORDER BY case when l.Name = 'USD' then 9999 else 1 end desc) ,'USD')


SELECT NoteID,Date,nm.Type,l.name as Typetext,ISNULL(nd.Value,0) as Value,nd.NoteAdjustedTotalCommitment,NoteAggregatedTotalCommitment,NoteTotalCommitment,@BaseCurrencyName as BaseCurrencyName 
	from cre.NoteAdjustedCommitmentMaster nm
	left join cre.NoteAdjustedCommitmentDetail nd on nd.NoteAdjustedCommitmentMasterID = nm.NoteAdjustedCommitmentMasterID
	left join core.lookup l on l.LookupID=nm.Type
	WHERE NoteID = @NoteId
	 order by date,nm.rowno asc--, CASE	WHEN [SortOrder] = 0 THEN '1'
		--			WHEN [SortOrder] = 1 THEN '2'
		--			WHEN [SortOrder] = 2 THEN '3'
		--			ELSE [SortOrder] 
		--	 END asc
	

			
END
	
