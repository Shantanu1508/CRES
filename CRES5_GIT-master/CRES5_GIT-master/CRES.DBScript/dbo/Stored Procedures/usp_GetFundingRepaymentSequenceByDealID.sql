


CREATE PROCEDURE [dbo].[usp_GetFundingRepaymentSequenceByDealID]
(
    @DealID UNIQUEIDENTIFIER
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


Select
 fs.NoteID
 ,fs.SequenceNo
,fs.SequenceType
,LSequenceTypeID.Name as SequenceTypeText
,isnull(fs.Value,0)Value
from [CRE].[FundingRepaymentSequence] fs
INNER JOIN [CRE].[Note] n ON fs.NoteID=n.NoteID
INNER JOIN core.Account acc on n.Account_AccountID = acc.AccountID
LEFT JOIN [CORE].[Lookup] LSequenceTypeID ON LSequenceTypeID.LookupID = fs.SequenceType
where n.DealID = @DealID and acc.IsDeleted = 0
order by fs.NoteID,fs.SequenceNo


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END

