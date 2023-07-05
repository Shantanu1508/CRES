------------------------------------------------------------
-- Author:		<NewCon Infosystem>
-- Create date: <11/05/2012>
------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_GetSizerDocumentsRecordSet]	 
 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    select
     ObjectTypeID 
	,ObjectID 
	,DocLink 
	,DocTypeID 
	,CreatedBy 
	,CreatedDate 
	,UpdatedBy 
	,UpdatedDate 
	from  cre.SizerDocuments
	where 1<>1
 

 
END


