CREATE PROCEDURE [dbo].[usp_GetJsonFormatCalcLiability]	
AS
BEGIN
	Select JsonFormatCalcLiabilityID,Position,[Key],KeyFormat,DataType,IsActive,ParentID,FilterBy 
	from [CRE].[JsonFormatCalcLiability]
	Where IsActive = 1
	order by position,
	(CASE WHEN keyformat = 'variable' THEN 1 
	WHEN keyformat = 'json' THEN 2 WHEN keyformat = 'array' THEN 3 ELSE 9999 END )

END