
CREATE PROCEDURE [dbo].[usp_GetNamedRangeUsedInBatchUpload]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

     select distinct NamedRange from [App].[DataDictionary]
where UsedInBatchUpload ='Y'

 
END


  
 
