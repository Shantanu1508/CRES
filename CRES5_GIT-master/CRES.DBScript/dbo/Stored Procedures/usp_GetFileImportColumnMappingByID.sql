--usp_GetFileImportColumnMappingByID 1
CREATE PROCEDURE [dbo].usp_GetFileImportColumnMappingByID
(
	@FileImportMasterID int
)
AS
BEGIN
	Select 
		[FileImportColumnMappingID],
		[FileImportMasterID],
		[FileColumnName],
		[LandingColumnName]
	FROM CRE.[FileImportColumnMapping] 
	WHERE FileImportMasterID = @FileImportMasterID
END

