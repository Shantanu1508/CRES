

CREATE PROCEDURE [dbo].[usp_GetAllIndexesMaster] --'80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,20,''
    @UserID UNIQUEIDENTIFIER,
    @PgeIndex INT,
    @PageSize INT,
	@TotalCount INT OUTPUT 
AS
BEGIN
      SET NOCOUNT ON;
	 
	 
     SELECT @TotalCount = COUNT(IndexesMasterID) FROM core.IndexesMaster;
     
		Select 
		im.IndexesMasterID	,
		im.IndexesMasterGuid,	
		im.IndexesName	,
		im.[Description],
		im.CreatedBy,
		im.CreatedDate,
		im.UpdatedBy,
		im.UpdatedDate
		from core.IndexesMaster im		
  ORDER BY im.UpdatedDate DESC
	OFFSET (@PgeIndex - 1)*@PageSize ROWS
	FETCH NEXT @PageSize ROWS ONLY

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    
END      

