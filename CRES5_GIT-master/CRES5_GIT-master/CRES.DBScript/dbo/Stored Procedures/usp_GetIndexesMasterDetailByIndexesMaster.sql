
CREATE PROCEDURE [dbo].[usp_GetIndexesMasterDetailByIndexesMaster]  --'538910c2-7f90-42e1-b2b6-aba5c2481aea'
    @IndexesMasterGuid UNIQUEIDENTIFIER,
	@UserID VARCHAR(5000)
AS

 BEGIN
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT IndexesMasterID,
IndexesMasterGuid,	
IndexesName	,
[Description],
CreatedBy,
CreatedDate,
UpdatedBy,
UpdatedDate
FROM core.IndexesMaster im 
WHERE im.IndexesMasterGuid = @IndexesMasterGuid;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
 
END
