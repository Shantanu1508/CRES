CREATE Procedure [dbo].[usp_GetLookupForMaster]	
	
AS
BEGIN
	SET NOCOUNT ON;
	
	Select LookupId,[Name],[Description],SortOrder,ddlType
	FROM(
		Select ServicerID as LookupId,ServicerName as [Name],'' as [description],0 as SortOrder,'ddlServicer' as ddlType from cre.Servicer
	)a

END
