
CREATE PROCEDURE [dbo].[usp_GetUserPermission] --'bf8cc838-d983-4975-ae6b-8f6af74d0d80' ,'NoteDetail','bf8cc838-d983-4975-ae6b-8f6af74d0d80',182

@UserId UNIQUEIDENTIFIER,
@ParentModuleName  nvarchar(256),
@ObjectID nvarchar(500) ,
@ObjectTypeID INT = 0

AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @newRole VARCHAR(50) ;
	DECLARE @userRole VARCHAR(50) ;
	SET @newRole = '';
   --Status:
   --Inactive: 324
   --Phantom: 325
   --Deal: 283
 
 IF(@ParentModuleName ='DealDetail' OR @ParentModuleName ='NoteDetail')
 BEGIN
    Select @userRole = r.RoleName
			from [App].[User] u
			INNER JOIN [App].[UserRoleMap] urm ON urm.UserID = u.UserID
			INNER JOIN [App].[Role] r ON urm.RoleID = r.RoleID
			where u.UserID = @UserId and u.StatusID = (Select LookupID from COre.Lookup where Name ='Active' and ParentID = 1)

	if(@userRole = 'Asset Manager' )
	BEGIN
		SET @newRole = 'Asset Manager'

		--check Deal is Inactive or Phantom
		--IF(@ObjectID != '' and @ObjectTypeID = 283)
		--BEGIN
		--   IF EXISTS (SELECT d.DealID FROM CRE.Deal d WHERE (CAST(DealID AS VARCHAR(500)) = @ObjectID OR CREDealID = @ObjectID) and isdeleted=0 and d.Status IN (324, 325))
		--	   BEGIN
		--		--SET @newRole = 'Viewer'
		--		SET @newRole = 'Asset Manager'
		--	   END
		--END		 
  --      ELSE 
		--BEGIN
		--	--check Note and related Deal is Inactive or Phantom
		--	IF(@ObjectID != '' and @ObjectTypeID = 182)
		--	BEGIN
		--	  IF EXISTS(SELECT n.NoteID FROM CRE.note n inner join core.Account acc on acc.AccountID = n.Account_AccountID where CAST(n.NoteID AS VARCHAR(500)) = @ObjectID and acc.IsDeleted=0 and acc.StatusID =2 )
		--	  BEGIN
		--		 --SET @newRole = 'Viewer'
		--		 SET @newRole = 'Asset Manager'
		--	  END

		--	  DECLARE @DealID nvarchar(500);
		--	  SELECT @DealID = n.DealID FROM CRE.note n inner join core.Account acc on acc.AccountID = n.Account_AccountID where CAST(n.NoteID AS VARCHAR(500)) = @ObjectID and acc.IsDeleted=0;  
		 		  
		--		--check Deal is Inactive or Phantom
		--		IF EXISTS (SELECT d.DealID FROM CRE.Deal d WHERE (CAST(DealID AS VARCHAR(500)) = @DealID) and isdeleted=0 and d.Status IN (324, 325))
		--		BEGIN
		--			--SET @newRole = 'Viewer'
		--			SET @newRole = 'Asset Manager'
		--		END
		--	 END
		-- END

			----***** Payoff date check **----
			--PRINT @newRole
			---- For All users: check Deal Payoff date and payoff date is less then today(= 0) then assign Viewer role 
			-- IF(@ObjectID != '' and @ObjectTypeID = 283)
			-- BEGIN
			--		IF((Select (case when ISNULL(MAX(a.Maturity) ,getdate() + 1) > CAST(getdate() as Date) then 1 else 0 end) as Allow

			--			from
			--			(
			--					SELECT NoteID			  
			--					,CRENoteID
			--					,a.Name	Name	
			--					,n.closingdate
			--					,( 
			--					case when n.ActualPayoffDate is not null then n.ActualPayoffDate
			--					when (select SelectedMaturityDate from core.Maturity where EventID=(select max(EventID) from core.Event where eventtypeid=11 and AccountID=(select Account_AccountID from cre.note where noteid=n.noteid))) >getdate() or (n.ExtendedMaturityScenario1 is  null and n.ExtendedMaturityScenario2 is  null and n.ExtendedMaturityScenario3 is  null and n.FullyExtendedMaturityDate is null)
			--					then  (select SelectedMaturityDate from core.Maturity where EventID=(select max(EventID) from core.Event where eventtypeid=11 and AccountID=(select Account_AccountID from cre.note where noteid=n.noteid)))  
			--					else
			--					case when  n.ExtendedMaturityScenario1>GETDATE() or (n.ExtendedMaturityScenario2 is  null and n.ExtendedMaturityScenario3 is  null and n.FullyExtendedMaturityDate is null) then n.ExtendedMaturityScenario1 else
			--					case when n.ExtendedMaturityScenario2 >GETDATE() or (n.ExtendedMaturityScenario3 is  null and n.FullyExtendedMaturityDate is null) then n.ExtendedMaturityScenario2 else
			--					case when  n.ExtendedMaturityScenario3 >GETDATE() or (n.FullyExtendedMaturityDate is null) then  n.ExtendedMaturityScenario3 else

			--					n.FullyExtendedMaturityDate end  --end
			--					end end end)as Maturity 

			--					FROM CRE.Note n inner join Core.Account a on Account_AccountID=a.AccountID	
			--					left join Core.Lookup l ON n.RateType=l.LookupID				
			--					left join Core.Lookup lNoteFundingRule ON n.NoteFundingRule=lNoteFundingRule.LookupID 
			--					left join Core.Lookup llienposition ON n.lienposition=llienposition.LookupID 
			--					where a.isdeleted=0 
			--					and CAST(n.DealId AS VARCHAR(500)) = @ObjectID
			--			)a
			--			)= 0)
			--			BEGIN 
			--			  --SET @newRole = 'Viewer'
			--			  SET @newRole = 'Asset Manager'
			--			END
			--END


			--PRINT @newRole
			---- For All users: check Note Payoff date and payoff date is less then today(= 0) then assign Viewer role 
			-- IF(@ObjectID != '' and @ObjectTypeID = 182)
			-- BEGIN
			--		IF((Select (case when ISNULL(MAX(a.Maturity) ,getdate() + 1) > CAST(getdate() as Date) then 1 else 0 end) as Allow

			--			from
			--			(
			--					SELECT NoteID			  
			--					,CRENoteID
			--					,a.Name	Name	
			--					,n.closingdate
			--					,( 
			--					case when n.ActualPayoffDate is not null then n.ActualPayoffDate
			--					when (select SelectedMaturityDate from core.Maturity where EventID=(select max(EventID) from core.Event where eventtypeid=11 and AccountID=(select Account_AccountID from cre.note where noteid=n.noteid))) >getdate() or (n.ExtendedMaturityScenario1 is  null and n.ExtendedMaturityScenario2 is  null and n.ExtendedMaturityScenario3 is  null and n.FullyExtendedMaturityDate is null)
			--					then  (select SelectedMaturityDate from core.Maturity where EventID=(select max(EventID) from core.Event where eventtypeid=11 and AccountID=(select Account_AccountID from cre.note where noteid=n.noteid)))  
			--					else
			--					case when  n.ExtendedMaturityScenario1>GETDATE() or (n.ExtendedMaturityScenario2 is  null and n.ExtendedMaturityScenario3 is  null and n.FullyExtendedMaturityDate is null) then n.ExtendedMaturityScenario1 else
			--					case when n.ExtendedMaturityScenario2 >GETDATE() or (n.ExtendedMaturityScenario3 is  null and n.FullyExtendedMaturityDate is null) then n.ExtendedMaturityScenario2 else
			--					case when  n.ExtendedMaturityScenario3 >GETDATE() or (n.FullyExtendedMaturityDate is null) then  n.ExtendedMaturityScenario3 else

			--					n.FullyExtendedMaturityDate end  --end
			--					end end end)as Maturity 

			--					FROM CRE.Note n inner join Core.Account a on Account_AccountID=a.AccountID	
			--					left join Core.Lookup l ON n.RateType=l.LookupID				
			--					left join Core.Lookup lNoteFundingRule ON n.NoteFundingRule=lNoteFundingRule.LookupID 
			--					left join Core.Lookup llienposition ON n.lienposition=llienposition.LookupID 
			--					where a.isdeleted=0 
			--					and CAST(n.DealId AS VARCHAR(500)) = @ObjectID
			--			)a
			--			)= 0)
			--			BEGIN 
			--			  --SET @newRole = 'Viewer'
			--			  SET @newRole = 'Asset Manager'
			--			END
			--END

         --end payoff date check
	END 
	


END


if(@newRole = 'Viewer')
 BEGIN
  
     DECLARE @UserName VARCHAR(500)
     SELECT @UserName = (u.FirstName +' '+u.LastName) FROM [App].[User] u 
	  where u.UserID = @UserId and u.StatusID = (Select LookupID from COre.Lookup where Name ='Active' and ParentID = 1);

	  IF(@UserName != '')
	   BEGIN
			Select UserName, RoleName,RightsName,ModuleTabName,ParentModuleName,ModuleType,DisplayName
			FROM(
				Select @UserName as UserName,
				r.RoleName,
				rights.RightsName,
				mtm.ModuleTabName,
				(Select ModuleTabName from [App].[ModuleTabMaster] where ModuleTabMasterID = mtm.parentid) as ParentModuleName,
				SortOrder,
				ModuleType,
				DisplayName
				from [App].[Role] r
				INNER JOIN [App].[RoleRightsMap] rrm ON rrm.RoleID = r.RoleID
				INNER JOIN [App].[Rights] rights ON rrm.RightsID = rights.RightsID
				INNER JOIN [App].[ModuleTabRoleRightsMap] mtrrm ON mtrrm.RoleRightsMapID = rrm.RoleRightsMapID
				INNER JOIN [App].[ModuleTabMaster] mtm ON mtrrm.ModuleTabMasterID = mtm.ModuleTabMasterID
				where r.RoleName = 'Viewer'
				)a	
			Where ISNULL(a.ParentModuleName,'master') = @ParentModuleName
			Order By
			a.SortOrder
       END

 END
ELSE
 BEGIN
    Select UserName,RoleName,RightsName,ModuleTabName,ParentModuleName,ModuleType,DisplayName
		FROM(
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
			where u.UserID = @UserId and u.StatusID = (Select LookupID from COre.Lookup where Name ='Active' and ParentID = 1)
		)a	
		Where ISNULL(a.ParentModuleName,'master') = @ParentModuleName 
		Order By
		a.SortOrder

 END
END


