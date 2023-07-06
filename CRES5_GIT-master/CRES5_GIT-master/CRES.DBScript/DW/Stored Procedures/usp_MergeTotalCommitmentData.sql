

CREATE PROCEDURE [DW].[usp_MergeTotalCommitmentData]

@BatchLogId int

AS
BEGIN

SET NOCOUNT ON


UPDATE [DW].BatchDetail
SET
BITableName = 'TotalCommitmentDataBI',
BIStartTime = GETDATE()
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_TotalCommitmentDataBI'


DECLARE @RowCount int

IF EXISTS(Select DealID from [dw].[L_DealBI])
BEGIN

--truncate table [DW].[TotalCommitmentDataBI]
Delete from [DW].[TotalCommitmentDataBI] where dealid in (Select DealID from [dw].[L_DealBI])

INSERT INTO [DW].[TotalCommitmentDataBI](
NoteID
,CRENoteID
,Date
,Type
,TypeBI
,value
,NoteAdjustedTotalCommitment
,NoteTotalCommitment
,Rowno
,CREDealID
,dealid
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
)

		
SELECT 
nd.NoteID
,n.CRENoteID
,Date as Date
,nd.Type as Type
,l.name as [TypeBI]
,nd.value
,NoteAdjustedTotalCommitment
,NoteTotalCommitment	
,nd.Rowno
,d.CREDealID
,d.dealid

,nm.CreatedBy
,nm.createddate
,nm.UpdatedBy
,nm.UpdatedDate
from cre.NoteAdjustedCommitmentMaster nm
left join cre.NoteAdjustedCommitmentDetail nd on nd.NoteAdjustedCommitmentMasterID = nm.NoteAdjustedCommitmentMasterID
right join cre.deal d on d.DealID=nm.DealID
Right join cre.note n on n.NoteID = nd.NoteID
inner join core.account acc on acc.AccountID = n.Account_AccountID
left join core.Lookup l on l.Lookupid = nd.type
where d.IsDeleted<>1 and acc.IsDeleted<>1
--and n.crenoteid in ( '10049')	
and nm.DealID in (Select DealID from [dw].[L_DealBI])
order by nd.NoteID,Rowno

END

SET @RowCount = @@ROWCOUNT

UPDATE [DW].BatchDetail
SET
BIEndTime = GETDATE(),
BIRecordCount = @RowCount
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_TotalCommitmentDataBI'

Print(char(9) +'usp_MergeTotalCommitmentData - ROWCOUNT = '+cast(@RowCount  as varchar(100)));


END

