-- Procedure
CREATE PROCEDURE [DBO].[usp_GetDealRelationshipByDealID] --'251839ED-C974-49EA-900D-769CED25C95E'
	@DealID UNIQUEIDENTIFIER
AS          
BEGIN
	SET NOCOUNT ON;

	SELECT 
	@DealID as DealID,
	LR.LookupID as RelationshipID,
	LR.[Name] as RelationshipText,
	D.CREDealID as LinkedDealID
	From [CRE].[DealRelationship] DR
	INNER JOIN [Core].[Lookup] LR ON LR.LookupID = DR.RelationshipID
	INNER JOIN [CRE].[Deal] D ON D.DealID = DR.LinkedDealID
	Where DR.DealID = @DealID;

END