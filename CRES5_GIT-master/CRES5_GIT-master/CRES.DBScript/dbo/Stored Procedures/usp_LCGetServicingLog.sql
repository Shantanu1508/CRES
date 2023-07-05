
CREATE PROCEDURE [dbo].[usp_LCGetServicingLog]  --2307

@CRENoteID nvarchar(256)
 

AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

 select 
 --Cast(ntd.TransactionDate as datetime) TransactionDate,
--Cast((Case
--WHEN TransactionDate is null THEN RelatedtoModeledPMTDate
--WHEN TransactionDate = RelatedtoModeledPMTDate THEN RelatedtoModeledPMTDate
--WHEN TransactionDate < RelatedtoModeledPMTDate THEN RelatedtoModeledPMTDate
--WHEN TransactionDate > RelatedtoModeledPMTDate THEN TransactionDate
--ELSE RelatedtoModeledPMTDate
--END) as datetime) as TransactionDate,

Cast(ntd.RelatedtoModeledPMTDate as datetime) TransactionDate,

--l1.Name,
TransactionTypeText as [Name],

(Case 
	When (isnull(ntd.OverrideValue,0) <> 0 ) Then ntd.OverrideValue
	When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount
	When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount
	When (isnull(ntd.Ignore,0) <>0 ) Then ntd.OverrideValue
END) as Amount,


 Cast(ntd.RelatedtoModeledPMTDate as datetime) RelatedtoModeledPMTDate 
from

cre.NoteTransactionDetail ntd
inner join CRE.Note note on note.NoteID = ntd.NoteID 
inner join Core.Account ac on note.Account_AccountID=ac.AccountID
left join Core.Lookup l1 on l1.LookupID =ntd.TransactionType 
where note.CRENoteID  = @CRENoteID
and ac.IsDeleted=0
order by ntd.RelatedtoModeledPMTDate asc


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END
