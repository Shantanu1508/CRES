
GO

Print('Added in ModuleTabMaster')
Go

if not exists(select 1 from [App].[ModuleTabMaster] where ModuleTabName='Deal_Maturity')
begin
	insert into [App].[ModuleTabMaster] Values('Deal_Maturity',42,1,null,null,null,null,2,'Deal_Maturity','Tab')
end


if not exists(select 1 from [App].[ModuleTabMaster] where ModuleTabName='DataManagement')
begin
	insert into [App].[ModuleTabMaster] Values('DataManagement',null,1,null,null,null,null,null,'DataManagement','Menu')
end


if not exists(select 1 from [App].[ModuleTabMaster] where ModuleTabName='DM_SyncQuickbooks')
begin
	Declare @ParentID int =  (select ModuleTabMasterID from [App].[ModuleTabMaster] where ModuleTabName='DataManagement')
	insert into [App].[ModuleTabMaster] Values('DM_SyncQuickbooks',@ParentID,1,null,null,null,null,2,'DM_SyncQuickbooks','Tab')
end

if not exists(select 1 from [App].[ModuleTabMaster] where ModuleTabName='Deal_ReserveFundWorkflow')
begin
	insert into [App].[ModuleTabMaster] Values('Deal_ReserveFundWorkflow',42,1,null,null,null,null,2,'Deal_ReserveFundWorkflow','Tab')
end