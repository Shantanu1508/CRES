
CREATE PROCEDURE [DW].[usp_UpdateAMUserInDeal]
	
AS
BEGIN
	SET NOCOUNT ON;


Declare @dealAM table
(
	CREDealID nvarchar(max),
	AssetManager nvarchar(max),
	AMTeamLeaderName nvarchar(max),
	SecondAssetManagerName nvarchar(max),
	AlternateAssetManager2 nvarchar(max),
	AlternateAssetManager3 nvarchar(max),
	[ShardName] nvarchar(max),
	UserID UNIQUEIDENTIFIER
)
INSERT INTO @dealAM(CREDealID,AssetManager,AMTeamLeaderName,SecondAssetManagerName,AlternateAssetManager2,AlternateAssetManager3,[ShardName])
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'Select ControlId,AssetManagerName,AMTeamLeaderName,SecondAssetManagerName,AlternateAssetManager2,AlternateAssetManager3 from [acore].[vw_AcctDeal] vd'


--Update in cre.deal
Update cre.deal set 
cre.deal.AMUserID = a.AssetManager_UserID,
cre.deal.AMTeamLeadUserID  = a.AMTeamLeaderName_UserID,
cre.deal.AMSecondUserID  = a.AMSecondAssetManagerName_UserID,
cre.deal.AlternateAssetManager2ID  = a.AlternateAssetManager2_UserID,
cre.deal.AlternateAssetManager3ID  = a.AlternateAssetManager3_UserID
From
(
	Select CREDealID,
	(case when AssetManager_UserID is null then null else AssetManager end) as AssetManager,
	AssetManager_UserID,
	(case when AMTeamLeaderName_UserID is null then null else AMTeamLeaderName end) as AMTeamLeaderName,
	AMTeamLeaderName_UserID,
	(case when AMSecondAssetManagerName_UserID is null then null else SecondAssetManagerName end) as SecondAssetManagerName,
	AMSecondAssetManagerName_UserID,
	(case when AlternateAssetManager2_UserID is null then null else AlternateAssetManager2 end) as AlternateAssetManager2,
	AlternateAssetManager2_UserID,
	(case when AlternateAssetManager3_UserID is null then null else AlternateAssetManager3 end) as AlternateAssetManager3,
	AlternateAssetManager3_UserID
	FROM(
		Select 
		CREDealID, 
		AssetManager,
		(SELECT  u.[UserID]
		FROM [App].[User] u join [App].[UserRoleMap] rm on rm.[UserID] = u.[UserID]	join [App].[Role] r on r.[RoleID] = rm.[RoleID]
		join core.Lookup lstatus on lstatus.LookupID = u.StatusID
		where RTRIM(LTRIM(r.RoleName))=RTRIM(LTRIM('Asset manager')) and LTRIM(RTRIM(lastname))+', '+LTRIM(RTRIM(Firstname)) = LTRIM(RTRIM(AssetManager))
		) AssetManager_UserID,

		AMTeamLeaderName,
		(SELECT  u.[UserID]
		FROM [App].[User] u join [App].[UserRoleMap] rm on rm.[UserID] = u.[UserID]	join [App].[Role] r on r.[RoleID] = rm.[RoleID]
		join core.Lookup lstatus on lstatus.LookupID = u.StatusID
		where RTRIM(LTRIM(r.RoleName))=RTRIM(LTRIM('Asset manager')) and LTRIM(RTRIM(lastname))+', '+LTRIM(RTRIM(Firstname)) = LTRIM(RTRIM(AMTeamLeaderName))
		) as AMTeamLeaderName_UserID,

		SecondAssetManagerName,
		(SELECT  u.[UserID]
		FROM [App].[User] u join [App].[UserRoleMap] rm on rm.[UserID] = u.[UserID]	join [App].[Role] r on r.[RoleID] = rm.[RoleID]
		join core.Lookup lstatus on lstatus.LookupID = u.StatusID
		where RTRIM(LTRIM(r.RoleName))=RTRIM(LTRIM('Asset manager')) and LTRIM(RTRIM(lastname))+', '+LTRIM(RTRIM(Firstname)) = LTRIM(RTRIM(SecondAssetManagerName))
		) AMSecondAssetManagerName_UserID,

		AlternateAssetManager2,
		(SELECT  u.[UserID]
		FROM [App].[User] u join [App].[UserRoleMap] rm on rm.[UserID] = u.[UserID]	join [App].[Role] r on r.[RoleID] = rm.[RoleID]
		join core.Lookup lstatus on lstatus.LookupID = u.StatusID
		where  LTRIM(RTRIM(lastname))+', '+LTRIM(RTRIM(Firstname)) = LTRIM(RTRIM(AlternateAssetManager2))   -----RTRIM(LTRIM(r.RoleName))=RTRIM(LTRIM('Asset manager')) and
		) AlternateAssetManager2_UserID,

		AlternateAssetManager3,
		(SELECT  u.[UserID]
		FROM [App].[User] u join [App].[UserRoleMap] rm on rm.[UserID] = u.[UserID]	join [App].[Role] r on r.[RoleID] = rm.[RoleID]
		join core.Lookup lstatus on lstatus.LookupID = u.StatusID
		where  LTRIM(RTRIM(lastname))+', '+LTRIM(RTRIM(Firstname)) = LTRIM(RTRIM(AlternateAssetManager3))   -----RTRIM(LTRIM(r.RoleName))=RTRIM(LTRIM('Asset manager')) and
		) AlternateAssetManager3_UserID

		from @dealAM
	)b
)a
where cre.deal.credealid = a.credealid


--Update in dw.dealBI
Update dw.dealBI set 
dw.dealBI.AMUserID = a.AssetManager_UserID,
dw.dealBI.AMUserBI = a.AssetManager,
dw.dealBI.AMTeamLeadUserID = a.AMTeamLeaderName_UserID,
dw.dealBI.AMTeamLeadUserBI = a.AMTeamLeaderName,
dw.dealBI.AMSecondUserID = a.AMSecondAssetManagerName_UserID,
dw.dealBI.AMSecondUserBI = a.SecondAssetManagerName,
dw.dealBI.AlternateAssetManager2ID = a.AlternateAssetManager2_UserID,
dw.dealBI.AlternateAssetManager2BI = a.AlternateAssetManager2,
dw.dealBI.AlternateAssetManager3ID = a.AlternateAssetManager3_UserID,
dw.dealBI.AlternateAssetManager3BI = a.AlternateAssetManager3
From
(
	Select CREDealID,
	(case when AssetManager_UserID is null then null else AssetManager end) as AssetManager,
	AssetManager_UserID,
	(case when AMTeamLeaderName_UserID is null then null else AMTeamLeaderName end) as AMTeamLeaderName,
	AMTeamLeaderName_UserID,
	(case when AMSecondAssetManagerName_UserID is null then null else SecondAssetManagerName end) as SecondAssetManagerName,
	AMSecondAssetManagerName_UserID,
	(case when AlternateAssetManager2_UserID is null then null else AlternateAssetManager2 end) as AlternateAssetManager2,
	AlternateAssetManager2_UserID,
	(case when AlternateAssetManager3_UserID is null then null else AlternateAssetManager3 end) as AlternateAssetManager3,
	AlternateAssetManager3_UserID
	FROM(
		Select 
		CREDealID, 
		AssetManager,
		(SELECT  u.[UserID]
		FROM [App].[User] u join [App].[UserRoleMap] rm on rm.[UserID] = u.[UserID]	join [App].[Role] r on r.[RoleID] = rm.[RoleID]
		join core.Lookup lstatus on lstatus.LookupID = u.StatusID
		where RTRIM(LTRIM(r.RoleName))=RTRIM(LTRIM('Asset manager')) and LTRIM(RTRIM(lastname))+', '+LTRIM(RTRIM(Firstname)) = LTRIM(RTRIM(AssetManager))
		) AssetManager_UserID,

		AMTeamLeaderName,
		(SELECT  u.[UserID]
		FROM [App].[User] u join [App].[UserRoleMap] rm on rm.[UserID] = u.[UserID]	join [App].[Role] r on r.[RoleID] = rm.[RoleID]
		join core.Lookup lstatus on lstatus.LookupID = u.StatusID
		where RTRIM(LTRIM(r.RoleName))=RTRIM(LTRIM('Asset manager')) and LTRIM(RTRIM(lastname))+', '+LTRIM(RTRIM(Firstname)) = LTRIM(RTRIM(AMTeamLeaderName))
		) as AMTeamLeaderName_UserID,

		SecondAssetManagerName,
		(SELECT  u.[UserID]
		FROM [App].[User] u join [App].[UserRoleMap] rm on rm.[UserID] = u.[UserID]	join [App].[Role] r on r.[RoleID] = rm.[RoleID]
		join core.Lookup lstatus on lstatus.LookupID = u.StatusID
		where RTRIM(LTRIM(r.RoleName))=RTRIM(LTRIM('Asset manager')) and LTRIM(RTRIM(lastname))+', '+LTRIM(RTRIM(Firstname)) = LTRIM(RTRIM(SecondAssetManagerName))
		) AMSecondAssetManagerName_UserID,

		AlternateAssetManager2,
		(SELECT  u.[UserID]
		FROM [App].[User] u join [App].[UserRoleMap] rm on rm.[UserID] = u.[UserID]	join [App].[Role] r on r.[RoleID] = rm.[RoleID]
		join core.Lookup lstatus on lstatus.LookupID = u.StatusID
		where  LTRIM(RTRIM(lastname))+', '+LTRIM(RTRIM(Firstname)) = LTRIM(RTRIM(AlternateAssetManager2))  ---RTRIM(LTRIM(r.RoleName))=RTRIM(LTRIM('Asset manager')) and
		) AlternateAssetManager2_UserID,

		AlternateAssetManager3,
		(SELECT  u.[UserID]
		FROM [App].[User] u join [App].[UserRoleMap] rm on rm.[UserID] = u.[UserID]	join [App].[Role] r on r.[RoleID] = rm.[RoleID]
		join core.Lookup lstatus on lstatus.LookupID = u.StatusID
		where  LTRIM(RTRIM(lastname))+', '+LTRIM(RTRIM(Firstname)) = LTRIM(RTRIM(AlternateAssetManager3))   ----RTRIM(LTRIM(r.RoleName))=RTRIM(LTRIM('Asset manager')) and
		) AlternateAssetManager3_UserID

		from @dealAM
	)b
)a
where dw.dealBI.credealid = a.credealid

Print('Updated asset managers in deal');

END