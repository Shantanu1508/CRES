

CREATE Procedure [dbo].[usp_GetPayRuleDropDownFeeSchedules]
@UserID NVarchar(255)
AS

BEGIN

	SET NOCOUNT ON;

	Select	
	FS.FeeTypeNameText+ ' '+'Strip' as NameText,
	FS.FeeTypeNameID as ID
	from [CRE].[FeeSchedulesConfig] FS	
	order by FS.FeeTypeNameText

END

