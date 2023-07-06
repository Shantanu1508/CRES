CREATE PROCEDURE [dbo].[usp_GetDataDictionary]

AS
BEGIN
	SET NOCOUNT ON;

	Select
	NamedRange,
	NamedCell,
	DBField,
	IsDropDown,
	DataType,
	[Required],
	UsedInSizer,
	UsedInBatchUpload
	from [App].[DataDictionary]

ORDER BY CASE WHEN [NamedRange] ='M61.Tables.Deal' THEN '1'
WHEN [NamedRange] = 'M61.Tables.DealFunding' THEN '2'
WHEN [NamedRange] = 'M61.Tables.Scenario' THEN '3'
WHEN [NamedRange] = 'M61.Tables.Note' THEN '4'

ELSE '999' END ASC

END