
--[usp_SearchNoteByCRENoteId] '3336'

CREATE PROCEDURE [dbo].[usp_SearchNoteByCRENoteId]   --'2173'
(
    @CRENoteId nvarchar(500)
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
   
     		SELECT n.NoteID
				  ,n.CRENoteID
				  ,n.DealID
				  ,d.DealName
				  ,ac.StatusID
				  ,n.RateType
				  ,l.Name 'RateTypeText' 
				  ,n.ClosingDate
				  ,ac.Name
			  FROM CRE.Note n
			  INNER JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
			  left join Core.Lookup l ON n.RateType=l.LookupID
		      left join CRE.Deal d on d.DealID = n.DealID
			  WHERE CRENoteID = @CRENoteId
			  AND ac.IsDeleted=0

			SET TRANSACTION ISOLATION LEVEL READ COMMITTED	  

END

