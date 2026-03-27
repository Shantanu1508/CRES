CREATE PROCEDURE [dbo].[usp_GetXIRRFileToBeDeleteFromBlob] 
AS  
BEGIN  
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  


Select Distinct XIRRDeleteBlobFilesID,[FileName],[Path] from [CRE].[XIRRDeleteBlobFiles]
Where ISNULL(IsDelete,0) <> 1
and [FileName] not in(
	Select Distinct [FileName] From(
		Select FileName_Input  as [FileName] From [CRE].[XIRRConfig]
		union all			 
		Select FileName_Input  as [FileName] From [CRE].[XIRRReturngroup]
		UNION ALL			  
		Select FileName_Input  as [FileName] from cre.XIRRConfigArchive
		UNION ALL			 
		Select FileName_Output as [FileName] from cre.XIRRConfigArchive
	)a
	WHere a.[FileName] is not null
)




END  


