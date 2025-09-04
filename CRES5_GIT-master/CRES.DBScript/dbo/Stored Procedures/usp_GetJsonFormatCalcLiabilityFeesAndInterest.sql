CREATE PROCEDURE [dbo].[usp_GetJsonFormatCalcLiabilityFeesAndInterest]	
AS
BEGIN
	Select JsonFormatCalcLiabilityFeesAndInterestID,Position,[Key],KeyFormat,DataType,IsActive,ParentID,FilterBy,DynamicField,DynamicFieldValue,IsOptional
	from [CRE].[JsonFormatCalcLiabilityFeesAndInterest]
	Where IsActive = 1
	order by position,
	(CASE WHEN keyformat = 'variable' THEN 1 
	WHEN keyformat = 'json' THEN 2 WHEN keyformat = 'array' THEN 3 ELSE 9999 END )

END
