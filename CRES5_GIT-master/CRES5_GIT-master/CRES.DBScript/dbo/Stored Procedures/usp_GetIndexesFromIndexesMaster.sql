
CREATE PROCEDURE [dbo].[usp_GetIndexesFromIndexesMaster]  --'538910c2-7f90-42e1-b2b6-aba5c2481aea'
AS
 BEGIN
SET NOCOUNT ON;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


Select 
IndexesMasterID	,
IndexesMasterGuid,	
IndexesName	,
[Description],
CreatedBy,
CreatedDate,
UpdatedBy,
UpdatedDate
from core.IndexesMaster


SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
 
END
