


CREATE PROCEDURE [dbo].[usp_GetContentByRuleTypeDetailID]
	@RuleTypeDetailID int
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

  
	Select Content from [CRE].[RuleTypeDetail] where RuleTypeDetailID = @RuleTypeDetailID

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END




