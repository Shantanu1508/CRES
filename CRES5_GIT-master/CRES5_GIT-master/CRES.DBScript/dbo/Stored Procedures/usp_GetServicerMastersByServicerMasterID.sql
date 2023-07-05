
CREATE PROCEDURE [dbo].[usp_GetServicerMastersByServicerMasterID] 
(
	@ServicerMasterID int
)
AS
BEGIN
 SET NOCOUNT ON;

	Select   ServicerName
	FROM [Cre].[ServicerMaster] WHERE ServicerMasterId = @ServicerMasterID

END


