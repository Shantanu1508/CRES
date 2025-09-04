-- Function
-- Function

CREATE Function ufn_UnderwrittingCheckPermissionFunction(@LoginId nvarchar(256)= null,@Password nvarchar(256)= null,@DealID nvarchar(256)= null)
returns int
with returns null on null input as
Begin
    declare @Count int,@Permission int,@AllowSizerUploadText nvarchar(256)
	set @Permission=0	
	set @Count= (Select count(*)FROM (
					Select (u.FirstName +' '+u.LastName) as UserName,
					r.RoleName,
					rights.RightsName,
					mtm.ModuleTabName,
					(Select ModuleTabName from [App].[ModuleTabMaster] where ModuleTabMasterID = mtm.parentid) as ParentModuleName,
					SortOrder,
					ModuleType,
					DisplayName
					from [App].[User] u
					INNER JOIN [App].[UserRoleMap] urm ON urm.UserID = u.UserID
					INNER JOIN [App].[Role] r ON urm.RoleID = r.RoleID
					INNER JOIN [App].[RoleRightsMap] rrm ON rrm.RoleID = r.RoleID
					INNER JOIN [App].[Rights] rights ON rrm.RightsID = rights.RightsID
					INNER JOIN [App].[ModuleTabRoleRightsMap] mtrrm ON mtrrm.RoleRightsMapID = rrm.RoleRightsMapID
					INNER JOIN [App].[ModuleTabMaster] mtm ON mtrrm.ModuleTabMasterID = mtm.ModuleTabMasterID
					where 
					u.StatusID = (Select LookupID from COre.Lookup where Name ='Active' and ParentID = 1)
					and u.[Login]=@LoginID and mtm.ModuleTabName='SizerUpload'
					)a	
				where RightsName='Edit'	)


	if @Count>0
	Begin
		set @Permission=2;

		set @AllowSizerUploadText=(
			
			select isnull(l.Name,'None')  from cre.deal d
			left join core.lookup l on l.LookupID=d.AllowSizerUpload
			where CREDealID= @DealID and   isnull(isdeleted,0)=0

		)

		if (@AllowSizerUploadText='None' AND @AllowSizerUploadText='Settlement')
		begin
			set @Permission=1
		end
	End

	return @Permission;

end;


--Select DBO.UnderwrittingCheckPermissionFunction('admin_dev','f225999720b317e32fa0ffac27b84269','17-1708.22222');
GO

