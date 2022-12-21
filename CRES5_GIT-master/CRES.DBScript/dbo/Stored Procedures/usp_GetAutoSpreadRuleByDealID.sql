


CREATE PROCEDURE [dbo].[usp_GetAutoSpreadRuleByDealID]
@UserID UNIQUEIDENTIFIER,
@DealID UNIQUEIDENTIFIER

AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	SELECT  a.AutoSpreadRuleID
	,a.PurposeType
	-- ,a.PurposeSubType
	,a.DebtAmount
	,a.EquityAmount
	,a.StartDate
	,a.EndDate
	,a.DistributionMethod
	,a.FrequencyFactor
	,a.Comment
	,a.CreatedBy
	,a.CreatedDate
	,a.UpdatedBy
	,a.UpdatedDate 
	,l.Name as PurposeTypeText
	,l1.Name as DistributionMethodText		   
	,a.RequiredEquity
	,a.AdditionalEquity
	FROM [CRE].[AutoSpreadRule] a 
	left join [Core].[Lookup] l  ON  l.LookupID = a.PurposeType
	left join [core].[Lookup] l1 ON  l1.LookupID = a.DistributionMethod
	WHERE a.DealID = @DealID
	ORDER BY a.StartDate DESC,a.EndDate DESC,a.AutoSpreadRuleID DESC

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
  


