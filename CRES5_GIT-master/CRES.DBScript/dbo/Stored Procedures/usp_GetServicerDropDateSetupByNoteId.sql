


CREATE PROCEDURE [dbo].[usp_GetServicerDropDateSetupByNoteId] --'62D692B2-3073-4A21-A723-B1ED48011E05', '80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,1,null
(
    @NoteId UNIQUEIDENTIFIER,
	@UserID UNIQUEIDENTIFIER
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
   
     SELECT [ServicerDropDateSetupID]
      ,[NoteID]
      ,[ModeledPMTDropDate]
      ,[PMTDropDateOverride]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
  FROM [CRE].[ServicerDropDateSetup]
  where NoteID = @NoteId


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END

