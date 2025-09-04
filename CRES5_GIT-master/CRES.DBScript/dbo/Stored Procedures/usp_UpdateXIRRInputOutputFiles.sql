CREATE PROCEDURE [dbo].[usp_UpdateXIRRInputOutputFiles]
	(
	@XIRRReturnGroupID int,
	@FileNameInput nvarchar(256),
	@UserID nvarchar(256)
)
AS
BEGIN    
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

IF (ISNULL(@FileNameInput,'')<>'')
 BEGIN
	UPDATE CRE.XIRRReturnGroup set FileName_Input=@FileNameInput WHERE XIRRReturnGroupID=@XIRRReturnGroupID
 END

END