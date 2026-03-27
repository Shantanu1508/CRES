-- Procedure
CREATE PROCEDURE [dbo].[usp_UpdateXIRRInputFile]
	(
	@XIRRConfigID int,
	@FileNameInput nvarchar(256),
	@UserID nvarchar(256)
)
AS
BEGIN    
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

IF (ISNULL(@FileNameInput,'')<>'')
 BEGIN
	UPDATE CRE.XIRRConfig set FileName_Input=@FileNameInput WHERE XIRRConfigID=@XIRRConfigID
 END

END
