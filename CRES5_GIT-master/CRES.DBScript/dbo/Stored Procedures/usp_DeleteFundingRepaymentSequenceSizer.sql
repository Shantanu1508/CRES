-- Procedure

CREATE PROCEDURE [dbo].[usp_DeleteFundingRepaymentSequenceSizer] 
@credealid nvarchar(256)

AS
BEGIN

  
Delete from CRE.FundingRepaymentSequence where NoteID in (
select NoteID FROM CRE.Note n WHERE n.dealid = (select DealID from  cre.deal where CREDealID=@credealid and isdeleted <> 1)  )

END


