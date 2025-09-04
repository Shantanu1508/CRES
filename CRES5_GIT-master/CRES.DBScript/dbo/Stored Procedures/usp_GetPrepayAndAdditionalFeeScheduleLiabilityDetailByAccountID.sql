
--	[dbo].[usp_GetPrepayAndAdditionalFeeScheduleLiabilityDetailByAccountID] 'f7a7d049-0b99-469d-8945-154d961c7dfb','05a96b38-8b22-47b2-aa06-6c84f63c9c67'

CREATE PROCEDURE [dbo].[usp_GetPrepayAndAdditionalFeeScheduleLiabilityDetailByAccountID]
	@DebtAccountID UNIQUEIDENTIFIER,
	@AdditionalAccountID UNIQUEIDENTIFIER = NULL
AS
BEGIN

	Select
		e.AccountID,
		e.AdditionalAccountID,
		e.EventID,
		e.EffectiveStartDate As EffectiveDate,
		fs.ValueTypeID,
		fs.StartDate,
		fsD.[From],
		fsD.[To],
		isnull(fsD.[Value],0) as Value
	from
	core.PrepayAndAdditionalFeeScheduleLiabilityDetail fsD
	INNER JOIN core.PrepayAndAdditionalFeeScheduleLiability fs ON fs.PrepayAndAdditionalFeeScheduleLiabilityID = fsD.PrepayAndAdditionalFeeScheduleLiabilityID
	Inner Join core.Event e on e.EventID = fs.EventID
	Where e.StatusID=1 and e.AccountID = @DebtAccountID 
	AND e.EffectiveStartDate=(select Max(ev.EffectiveStartDate) from [Core].[Event] ev Where ev.AccountID = @DebtAccountID 
								and (@AdditionalAccountID IS NULL OR ev.AdditionalAccountID = @AdditionalAccountID) 
								and ev.EventTypeID =  908 and ev.StatusID = 1
							 )
	and (@AdditionalAccountID IS NULL OR e.AdditionalAccountID = @AdditionalAccountID)

END