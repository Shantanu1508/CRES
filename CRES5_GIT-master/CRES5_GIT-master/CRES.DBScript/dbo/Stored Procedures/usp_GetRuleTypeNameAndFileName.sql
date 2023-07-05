
CREATE PROCEDURE [dbo].[usp_GetRuleTypeNameAndFileName] 

AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

  
	Select rtm.RuleTypeMasterID,rtm.RuleTypeName,rtd.RuleTypeDetailID,rtd.FileName,rtd.[Type],rtd.DBFileName
	from [CRE].[RuleTypeMaster] rtm
	left join [CRE].[RuleTypeDetail] rtd on rtm.RuleTypeMasterID = rtd.RuleTypeMasterID
	where IsActive = 1
	order by RuleTypeName,FileName

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END




