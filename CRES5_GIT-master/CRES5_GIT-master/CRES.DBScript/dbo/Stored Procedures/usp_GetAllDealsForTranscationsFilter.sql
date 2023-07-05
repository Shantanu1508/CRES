
CREATE PROCEDURE dbo.[usp_GetAllDealsForTranscationsFilter] 
@IsReconciled bit=0
AS
BEGIN
SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	if (@IsReconciled=0)
	Begin
	SELECT distinct d.DealID			  
			  , d.CREDealId,d.DealName from cre.Deal d 
			inner join cre.TranscationReconciliation tr on tr.DealId =d.DealID
			where tr.Deleted=0 and PostedDate is null
			order by d.DealName
	END
	ELSE
	BEGIN
	SELECT distinct d.DealID			  
			  , d.CREDealId,d.DealName from cre.Deal d 
			inner join cre.TranscationReconciliation tr on tr.DealId =d.DealID
			where tr.Deleted=0 and PostedDate is not null
			order by d.DealName
	END

			  

END

