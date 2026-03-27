-- Procedure
CREATE PROCEDURE [dbo].[usp_GetLiabilityFeeScheduleByAccountID] --'8BFA1EAD-8765-4A2C-99E3-F49D6D3F1675','DA4DAB4F-BCB3-4D3D-8F40-19897215FD72'
	@DebtAccountID UNIQUEIDENTIFIER,
	@AdditionalAccountID UNIQUEIDENTIFIER = NULL
AS
BEGIN

Select
e.AccountID,
e.AdditionalAccountID,
fs.FeeName,
fs.StartDate,
fs.EndDate,
fs.ValueTypeID,
LValueTypeID.FeeTypeNameText as FeeTypeText,
isnull(fs.Value,0) as Fee,
fs.FeeAmountOverride,
fs.BaseAmountOverride,
fs.ApplyTrueUpFeature as ApplyTrueUpFeatureID
,LApplyTrueUpFeature.[Name] as ApplyTrueUpFeatureText,
isnull(fs.IncludedLevelYield,0) as IncludedLevelYield,
fs.FeetobeStripped as PercentageOfFeeToBeStripped,
e.EffectiveStartDate as EffectiveDate,
fs.CreatedBy,   
fs.CreatedDate, 
fs.UpdatedBy,
fs.UpdatedDate
from
core.PrepayAndAdditionalFeeScheduleLiability fs
Inner Join core.Event e on e.EventID = fs.EventID
LEFT JOIN cre.FeeSchedulesConfigLiability LValueTypeID ON LValueTypeID.FeeTypeNameID = fs.ValueTypeID
LEFT JOIN [CORE].[Lookup] LApplyTrueUpFeature ON LApplyTrueUpFeature.LookupID = fs.ApplyTrueUpFeature
Where e.StatusID=1 and AccountID = @DebtAccountID AND EffectiveStartDate=(select Max(EffectiveStartDate) from [Core].[Event] e Where AccountID = @DebtAccountID and (@AdditionalAccountID IS NULL OR e.AdditionalAccountID = @AdditionalAccountID) and EventTypeID =  908 and StatusID = 1)
and (@AdditionalAccountID IS NULL OR e.AdditionalAccountID = @AdditionalAccountID)

END