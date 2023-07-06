

CREATE PROCEDURE [dbo].[usp_GetPermissionByRoleId]	--'17E54888-1BE1-482E-938B-127E181DB71B'
@RoleID UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 
Select mtm.ModuleTabMasterID,mtm.ModuleTabName ,mtm.ParentID,mtm.StatusID,mtm.SortOrder,mtm.DisplayName,mtm.ModuleType,
(Select Count(mtrrm.ModuleTabRoleRightsMapID) from [App].[Role] r 
INNER JOIN [App].[RoleRightsMap] rrm ON rrm.RoleID = r.RoleID
INNER JOIN [App].[Rights] rights ON rrm.RightsID = rights.RightsID
Right JOIN [App].[ModuleTabRoleRightsMap] mtrrm ON mtrrm.RoleRightsMapID = rrm.RoleRightsMapID
where r.RoleID = @RoleID and rights.rightsname ='Edit' and mtrrm.ModuleTabMasterId = mtm.ModuleTabMasterId ) as IsEdit,
(Select Count(mtrrm.ModuleTabRoleRightsMapID) from [App].[Role] r 
INNER JOIN [App].[RoleRightsMap] rrm ON rrm.RoleID = r.RoleID
INNER JOIN [App].[Rights] rights ON rrm.RightsID = rights.RightsID
Right JOIN [App].[ModuleTabRoleRightsMap] mtrrm ON mtrrm.RoleRightsMapID = rrm.RoleRightsMapID
where r.RoleID = @RoleID and rights.rightsname ='View' and mtrrm.ModuleTabMasterId = mtm.ModuleTabMasterId ) as IsView,
(Select Count(mtrrm.ModuleTabRoleRightsMapID) from [App].[Role] r 
INNER JOIN [App].[RoleRightsMap] rrm ON rrm.RoleID = r.RoleID
INNER JOIN [App].[Rights] rights ON rrm.RightsID = rights.RightsID
Right JOIN [App].[ModuleTabRoleRightsMap] mtrrm ON mtrrm.RoleRightsMapID = rrm.RoleRightsMapID
where r.RoleID = @RoleID and rights.rightsname ='Delete' and mtrrm.ModuleTabMasterId = mtm.ModuleTabMasterId ) as IsDelete
from [App].[ModuleTabMaster] mtm
Order by mtm.ModuleType desc



	SET TRANSACTION ISOLATION LEVEL READ COMMITTED


 
END
