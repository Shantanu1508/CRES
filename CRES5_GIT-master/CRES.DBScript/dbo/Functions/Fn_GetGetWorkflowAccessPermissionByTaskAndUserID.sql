

CREATE FUNCTION [dbo].[Fn_GetGetWorkflowAccessPermissionByTaskAndUserID] 
(
    @TaskTypeID int,
	@TaskID nvarchar(256),
	@UserID nvarchar(256),
	@FilterType varchar(100), -- 0: all, 1: respective
	@ReviewCompletedByUser uniqueidentifier=null ,
	@FirstDealFundingID uniqueidentifier=null,
	@IsFirstApprover bit=null,
	@CurrentWFStatusMasterID int=null,
	@IsShowApprover bit=null
)
RETURNS INT
AS
BEGIN
   DECLARE @Result INt,@amount decimal(28,15), @AmountTobeCheck decimal(28,15),@AmountTobeCheckForPrimaryAM decimal(28,15),
   @CompletedByUser uniqueidentifier,@SecondApprovalByUser uniqueidentifier,@SecondApprovalByUserFromReject uniqueidentifier,@IsREODeal bit=0
   
   SET @AmountTobeCheck = 1500000
   SET @AmountTobeCheckForPrimaryAM = 500000
      IF EXISTS(Select TaskID from cre.WFTaskDetail where TaskID = @TaskID and TaskTypeID = @TaskTypeID)
	BEGIN
	     DECLARE @WF_IsFlowStart INT
		 DECLARE @WF_CurrentStatus varchar(5000)
		 DECLARE @WF_IsCompleted INT

		 DECLARE @DealID varchar(5000)
		 DECLARE @DealName varchar(5000)
		 DECLARE @AMSecondUserID varchar(5000)

		 Declare @Max_WFTaskDetailID int
	     Declare @CurrentWFStatusPurposeMappingID int 
	     Declare @CurrentPurposeTypeId int 
		 Declare @NextStatusName  varchar(5000)		 

		 DECLARE @FundingDate DATETIME
		 DECLARE @FundingAmount  Decimal
		 DECLARE @DealLine DATETIME,
		 @WorkFlowType nvarchar(100),
		 @CurrentWFStatus_MasterID int


		 SET @Max_WFTaskDetailID = (Select MAX(WFTaskDetailID) from cre.WFTaskDetail where TaskID = @TaskID and TaskTypeID = @TaskTypeID)
	     SET @CurrentWFStatusPurposeMappingID = (Select WFStatusPurposeMappingID from cre.WFTaskDetail where TaskID = @TaskID and TaskTypeID = @TaskTypeID and WFTaskDetailID = @Max_WFTaskDetailID)
	     SET @CurrentPurposeTypeId = (Select PurposeTypeId from cre.WFStatusPurposeMapping where WFStatusPurposeMappingID = @CurrentWFStatusPurposeMappingID )
		 select  @CurrentWFStatus_MasterID =(Select WFStatusmasterID from cre.WFStatusPurposeMapping where WFStatusPurposeMappingID = @CurrentWFStatusPurposeMappingID)
		 select @WorkFlowType= Value1 from core.Lookup where lookupID=@CurrentPurposeTypeId
		 
		 IF (@TaskTypeID=502)
          BEGIN 
		  select @amount = Amount FROM cre.DealFunding where DealFundingID = @TaskID
		     --whether the second approval is done
		 IF (@CurrentWFStatus_MasterID=4)
		 BEGIN
			--if second approval done normally
			select @SecondApprovalByUser=CreatedBy from  cre.WFTaskDetail where WFTaskDetailID=(Select MAX(WFTaskDetailID) from cre.WFTaskDetail where TaskID = @TaskID and TaskTypeID = @TaskTypeID and SubmitType=498)
			--if second approval done throught reject
			select @SecondApprovalByUserFromReject=CreatedBy from  cre.WFTaskDetail where WFTaskDetailID=(Select MAX(WFTaskDetailID) from cre.WFTaskDetail where TaskID = @TaskID and TaskTypeID = @TaskTypeID and SubmitType=496)
		    
		 END

		 -- set access denay
		  SET @Result = 0;
		  IF (@WorkFlowType ='WF_UNDERREVIEW')
		  BEGIN
				--hide reject option if for  wireconfired record
				IF (@FilterType='Reject' AND EXISTS(select Applied from cre.dealfunding where DealFundingID=@TaskID and Applied=1))
					BEGIN
						 RETURN @Result
					END
				
				SET @Result = 1;
				RETURN @Result
		  END
		  --if no second approval is happned than check for the consicutive user,if same user than do not allow to complete 
		  ELSE IF (@ReviewCompletedByUser IS NOT NULL AND (@ReviewCompletedByUser = @UserID and  @CurrentWFStatusMasterID=4 AND @SecondApprovalByUser IS NULL and @SecondApprovalByUserFromReject IS NULL))
		  BEGIN
			   RETURN @Result
		  END
		  ELSE IF (@ReviewCompletedByUser IS NOT NULL AND (@ReviewCompletedByUser = @UserID and  @CurrentWFStatusMasterID=4 AND @SecondApprovalByUserFromReject IS NOT NULL))
		  BEGIN
			   SET @Result = 1;
			   RETURN @Result
		  END
		  ELSE 
		  IF (@FirstDealFundingID IS NOT NULL AND @CurrentWFStatusMasterID IS NOT NULL AND @IsFirstApprover IS NOT NULL
		  and @FirstDealFundingID = @TaskID and @IsFirstApprover=0 and @CurrentWFStatusMasterID=4
		  )
		  BEGIN
			   --As per jsons request FirstDraw approver should approve only upto 500k,if >500k then tier1,tier2 should approve as per the amount
			   IF EXISTS (SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId
									join Core.Lookup l on e.ModuleId = l.LookupID 
									where l.Name = 'Tier 2 Approval'
									and u.UserID = @UserID)
									BEGIN
									  SET @Result = 1;
									END
		      ELSE IF EXISTS (SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId
									join Core.Lookup l on e.ModuleId = l.LookupID 
									where l.Name = 'Tier 1 Approval'
									and u.UserID = @UserID and @amount<=@AmountTobeCheck)
									BEGIN
									  SET @Result = 1;
									END
			   RETURN @Result
		  END
		  ELSE IF (@IsShowApprover IS NOT NULL and @IsShowApprover=0)
		  BEGIN
				RETURN @Result
		  END

			
			
			
			
			SET @WF_IsCompleted = (SELECT ISNULL
			( (
			SELECT TOP 1 1 FROM [CRE].[WFTaskDetail] td 
			INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
			INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
			WHERE TaskId = @TaskID  and spm.OrderIndex = (
			 SELECT MAX(OrderIndex) FROm [CRE].[WFStatusPurposeMapping] WHERE PurposetypeId = spm.PurposeTypeId 
			) ORDER BY WFTaskDetailID DESC )
			,0 )) --AS WF_IsCompleted


	     SET @WF_IsFlowStart =  (SELECT CASE WHEN (SELECT MIN(OrderIndex) FROm [CRE].[WFStatusPurposeMapping] WHERE PurposetypeId = @CurrentPurposeTypeId) <>
			 (SELECT TOP 1 spm.OrderIndex  FROM [CRE].[WFTaskDetail] td 
			INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
			INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
			WHERE TaskId =  @TaskID
			ORDER BY WFTaskDetailID DESC
			)
			THEN 0 ELSE 1 END
			) --AS WF_IsFlowStart


			IF (@FilterType='Reject')
				BEGIN
					--allow super admin to view reject option
					IF (EXISTS(
								 select u.FirstName from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID 
								 join App.[Role] r on um.RoleID=r.RoleID 
								 where r.RoleName = 'Super Admin'
								 and convert(varchar(MAX),u.UserId) = @UserID
								 )
								 AND EXISTS(select Applied from cre.dealfunding where DealFundingID=@TaskID and ISNULL(Applied,0)=0)
						)
								 BEGIN
								  SET @Result = 1;
								 END
					--
					
					
					--if current status is 2nd approval than need to display reject to any AM

					if (@CurrentWFStatus_MasterID=3)
					BEGIN
					  IF (EXISTS(
								 select u.FirstName from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID 
								 join App.[Role] r on um.RoleID=r.RoleID 
								 where r.RoleName = 'Asset Manager'
								 and convert(varchar(MAX),u.UserId) = @UserID
								 )
								 AND EXISTS(select Applied from cre.dealfunding where DealFundingID=@TaskID and ISNULL(Applied,0)=0)
						)
								 BEGIN
								  SET @Result = 1;
								 END	
					
					END
					
					--check if Tier 2 and not wireconfiremed than allow to show reject button
					IF ((
					  EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID 
									where l.Name = 'Tier 2 Approval'
									and u.UserID = @UserID))
					 AND EXISTS(select Applied from cre.dealfunding where DealFundingID=@TaskID and ISNULL(Applied,0)=0)
						)
					BEGIN
						SET @Result = 1;
					END	
					---check if Tier 1,amount <= 1.5M and not wireconfiremed than allow to show reject button
					ELSE IF ((
					  EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID 
									where l.Name = 'Tier 1 Approval'
									and u.UserID = @UserID and @amount<=@AmountTobeCheck))
					 AND EXISTS(select Applied from cre.dealfunding where DealFundingID=@TaskID and ISNULL(Applied,0)=0)
						)
					BEGIN
						SET @Result = 1;
					END	
					---check if deal specific primary or deal specific Team Lead ,amount <= 500k and not wireconfiremed than allow to show reject button
					ELSE IF ((EXISTS(SELECT u.UserID FROM [CRE].[DealFunding] df
									INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
									INNER JOIN app.[User] u ON u.UserID = d.AMUserID
									 WHERE df.DealFundingID = @TaskID
									 AND  convert(varchar(MAX),u.UserId) = @UserID)
									 or EXISTS(SELECT u.UserID FROM [CRE].[DealFunding] df
									INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
									INNER JOIN app.[User] u ON u.UserID = d.AMTeamLeadUserID
									 WHERE df.DealFundingID = @TaskID
									 AND  convert(varchar(MAX),u.UserId) = @UserID))
					     AND EXISTS(select Applied from cre.dealfunding where DealFundingID=@TaskID and ISNULL(Applied,0)=0)
						 AND @amount<=@AmountTobeCheckForPrimaryAM
						)
					BEGIN
						SET @Result = 1;
					END	

					---check if completed than allow to show reject button to  the person who completed
					ELSE IF(@WF_IsCompleted = 1) 
					BEGIN
					  Select  top 1 @CompletedByUser = t.CreatedBy from cre.WFStatusPurposeMapping sp 
						join [CRE].[WFStatusMaster] s on  sp.WFStatusMasterID=s.WFStatusMasterID 
						join cre.WFTaskDetail t on t.WFStatusPurposeMappingID=sp.WFStatusPurposeMappingID
						where s.WFStatusMasterID=5 and sp.PurposeTypeId=@CurrentPurposeTypeId and t.TaskID=@TaskID 
						and t.SubmitType=498
						order by t.WFTaskDetailID desc
						
						IF (@CompletedByUser=@UserID AND EXISTS(select Applied from cre.dealfunding where DealFundingID=@TaskID and ISNULL(Applied,0)=0))
						BEGIN
							SET @Result = 1;
						END
					END
				
				END
			
			
			ELSE IF(@WF_IsCompleted = 0) --@WF_IsFlowStart = 1 and 
			 BEGIN
			    
				SET @WF_CurrentStatus = (SELECT (SELECT TOP 1 sm.StatusName FROM [CRE].[WFTaskDetail] td 
				INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
				INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
				WHERE TaskId = @TaskID 
				ORDER BY WFTaskDetailID DESC ) ) --as WF_CurrentStatus;

				SET @NextStatusName = ( Select top 1 sm.StatusName as NextStatusName
				    -- ,PurposeTypeId,mapp1.WFStatusPurposeMappingID as NextWFStatusPurposeMappingID,mapp1.WFStatusMasterID as NextWFStatusMasterID,mapp1.OrderIndex as NextOrderIndex 
				from [CRE].[WFTaskDetail] td 
				INNER JOIN cre.WFStatusPurposeMapping mapp1 on mapp1.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID 
				inner join cre.WFStatusMaster sm on sm.WFStatusMasterID = mapp1.WFStatusMasterID
				where td.WFStatusPurposeMappingID > @CurrentWFStatusPurposeMappingID and PurposeTypeId = @CurrentPurposeTypeId
				order by OrderIndex )

				--check if user L2 then @FilterType set 'all'
				--IF EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId
				--					join Core.Lookup l on e.ModuleId = l.LookupID 
				--					where l.Name = 'Approval (L2)'
				--					and u.UserID = @UserID)
				--				  BEGIN
				--					 SET @FilterType = 'all';
				--				  END

				
				
				if(@FilterType = 'all') -- All
				BEGIN

						IF(@WF_CurrentStatus = 'Projected') -- for AMSecondUserID
						 BEGIN
						  --   SET @Result =  (SELECT COUNT (u.UserID) FROM [CRE].[DealFunding] df
								--INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
								--INNER JOIN app.[User] u ON u.UserID = d.AMSecondUserID
								-- WHERE df.DealFundingID = @TaskID
								-- AND  convert(varchar(MAX),u.UserId) = @UserID)
												
								 --IF EXISTS(SELECT d.AMSecondUserID FROM cre.Deal d WHERE convert(varchar(MAX),d.AMSecondUserID) = @UserID)
								 IF EXISTS
								 (
								 select u.FirstName from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID 
								 join App.[Role] r on um.RoleID=r.RoleID 
								 where r.RoleName = 'Asset Manager'
								 and convert(varchar(MAX),u.UserId) = @UserID
								 )
								 BEGIN
								  SET @Result = 1;
								 END	
						 END
						 IF(@WF_CurrentStatus = 'Under Review') -- for AMSecondUserID
						 BEGIN
						  --   SET @Result =  (SELECT COUNT (u.UserID) FROM [CRE].[DealFunding] df
								--INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
								--INNER JOIN app.[User] u ON u.UserID = d.AMSecondUserID
								-- WHERE df.DealFundingID = @TaskID
								-- AND  convert(varchar(MAX),u.UserId) = @UserID)

								 --IF EXISTS(SELECT d.AMSecondUserID FROM cre.Deal d WHERE convert(varchar(MAX),d.AMSecondUserID) = @UserID)
								 IF EXISTS
								 (
								 select u.FirstName from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID 
								 join App.[Role] r on um.RoleID=r.RoleID 
								 where r.RoleName = 'Asset Manager'
								 and convert(varchar(MAX),u.UserId) = @UserID
								 )
								 BEGIN
								  SET @Result = 1;
								 END	
						
						 END
						 ELSE IF(@WF_CurrentStatus ='1st Approval') -- for AMUserID
						   BEGIN
						  --      SET @Result =  (SELECT COUNT (u.UserID) FROM [CRE].[DealFunding] df
								--INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
								--INNER JOIN app.[User] u ON u.UserID = d.AMTeamLeadUserID
								-- WHERE df.DealFundingID = @TaskID
								-- AND  convert(varchar(MAX),u.UserId) = @UserID)
						
								 --IF EXISTS(SELECT u.UserID FROM [CRE].[DealFunding] df
									--INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
									--INNER JOIN app.[User] u ON u.UserID = d.AMUserID
									-- WHERE df.DealFundingID = @TaskID
									-- AND  convert(varchar(MAX),u.UserId) = @UserID)
								 --BEGIN
								 -- SET @Result = 1;
								 --END	
						 						
								--IF (EXISTS (SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId
								--	join Core.Lookup l on e.ModuleId = l.LookupID 
								--	where (l.Name = 'Tier 1 Approval' or l.Name = 'Tier 2 Approval' or l.Name = '1st Approval')
								--	and u.UserID = @UserID)
								--	or EXISTS(SELECT u.UserID FROM [CRE].[DealFunding] df
								--	INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
								--	INNER JOIN app.[User] u ON u.UserID = d.AMUserID
								--	 WHERE df.DealFundingID = @TaskID
								--	 AND  convert(varchar(MAX),u.UserId) = @UserID)
								--	 or EXISTS(SELECT u.UserID FROM [CRE].[DealFunding] df
								--	INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
								--	INNER JOIN app.[User] u ON u.UserID = d.AMTeamLeadUserID
								--	 WHERE df.DealFundingID = @TaskID
								--	 AND  convert(varchar(MAX),u.UserId) = @UserID)
								-- )

								 IF EXISTS
								 (
								 select u.FirstName from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID 
								 join App.[Role] r on um.RoleID=r.RoleID 
								 where r.RoleName = 'Asset Manager'
								 and convert(varchar(MAX),u.UserId) = @UserID
								 )

								 BEGIN
								  SET @Result = 1;
								 END	

						   END
						 ELSE IF(@WF_CurrentStatus ='2nd Approval') -- -- for AMTeamLeadUserID
						   BEGIN
				   				       
								--SET @Result = (SELECT COUNT(u.UserID) FROM [App].[Role] r 
								--INNER JOIN [App].[UserRoleMap] ur ON ur.RoleID = r.RoleID
								--INNER JOIN [App].[User] u ON u.UserID = ur.UserID
								--WHERE r.RoleName = 'Approval (L1)'
								--AND  convert(varchar(MAX),u.UserId) = @UserID)

								IF (EXISTS (SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId
									join Core.Lookup l on e.ModuleId = l.LookupID 
									where (l.Name = 'Tier 1 Approval' or l.Name = 'Tier 2 Approval')
									and u.UserID = @UserID)
								 
								 OR EXISTS(SELECT u.UserID FROM [CRE].[DealFunding] df
									INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
									INNER JOIN app.[User] u ON u.UserID = d.AMUserID
									 WHERE df.DealFundingID = @TaskID
									 AND  convert(varchar(MAX),u.UserId) = @UserID)
								OR EXISTS(SELECT u.UserID FROM [CRE].[DealFunding] df
									INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
									INNER JOIN app.[User] u ON u.UserID = d.AMTeamLeadUserID
									 WHERE df.DealFundingID = @TaskID
									 AND  convert(varchar(MAX),u.UserId) = @UserID)
								OR EXISTS(SELECT u.UserID from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = '1st Approval'
									and u.UserID = @UserID)
									 )
								 BEGIN
								  SET @Result = 1;
								 END	
						   END
						 
                  END
				ELSE if(@FilterType = 'respective') -- Respective
				BEGIN

						IF(@WF_CurrentStatus = 'Projected') -- for AMSecondUserID
						 BEGIN
						  --   SET @Result =  (SELECT COUNT (u.UserID) FROM [CRE].[DealFunding] df
								--INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
								--INNER JOIN app.[User] u ON u.UserID = d.AMSecondUserID
								-- WHERE df.DealFundingID = @TaskID
								-- AND  convert(varchar(MAX),u.UserId) = @UserID)		

								 --- All users with Asset managers role and respective deal
								 IF EXISTS(SELECT df.DealID FROM [CRE].[DealFunding] df
									INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
									--INNER JOIN app.[User] u ON u.UserID = d.AMUserID
									 WHERE df.DealFundingID = @TaskID
									 AND 
										 ( convert(varchar(MAX),d.AMSecondUserID) = @UserID
										 --OR  convert(varchar(MAX),d.AMUserID) = @UserID
										 --OR  convert(varchar(MAX),d.AMTeamLeadUserID) = @UserID
										 )
									 )
								 BEGIN
								  SET @Result = 1;
								 END	

						 END
						 IF(@WF_CurrentStatus = 'Under Review') -- for AMSecondUserID
						 BEGIN
						  --- All users with Asset managers role and respective deal
								IF EXISTS(SELECT df.DealID FROM [CRE].[DealFunding] df
									INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
									 WHERE df.DealFundingID = @TaskID
									 AND ( convert(varchar(MAX),d.AMSecondUserID) = @UserID									 
									   --OR  convert(varchar(MAX),d.AMUserID) = @UserID
									   --OR  convert(varchar(MAX),d.AMTeamLeadUserID) = @UserID
									   )
									 )
								 BEGIN
								  SET @Result = 1;
								 END	
						
						 END
						 ELSE IF(@WF_CurrentStatus ='1st Approval') -- for AMUserID
						   BEGIN
						 
						 						
								 --IF (EXISTS(SELECT u.UserID FROM [CRE].[DealFunding] df
									--INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
									--INNER JOIN app.[User] u ON u.UserID = d.AMUserID
									-- WHERE df.DealFundingID = @TaskID
									-- AND  convert(varchar(MAX),u.UserId) = @UserID)
								 --OR
								 --EXISTS(SELECT d.AMTeamLeadUserID FROM cre.Deal d WHERE convert(varchar(MAX),d.AMTeamLeadUserID) = @UserID))
								 --BEGIN
								 -- SET @Result = 1;
								 --END	

								 --- All users with Asset managers role and respective deal
								IF EXISTS(SELECT df.DealID FROM [CRE].[DealFunding] df
									INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
									 WHERE df.DealFundingID = @TaskID
									 --AND  convert(varchar(MAX),d.AMSecondUserID) = @UserID
									 AND 
									 ( convert(varchar(MAX),d.AMUserID) = @UserID
									  --OR  convert(varchar(MAX),d.AMTeamLeadUserID) = @UserID
									 )
									 )
								 BEGIN
								  SET @Result = 1;
								 END	

						   END
						 ELSE IF(@WF_CurrentStatus ='2nd Approval') -- -- for AMTeamLeadUserID
						   BEGIN
				   				       
								 --- All users with Asset managers role and respective deal
								IF (EXISTS(SELECT df.DealID FROM [CRE].[DealFunding] df
									INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
									 WHERE df.DealFundingID = @TaskID
									 --AND  convert(varchar(MAX),d.AMSecondUserID) = @UserID
									 --AND  convert(varchar(MAX),d.AMUserID) = @UserID
									 AND  convert(varchar(MAX),d.AMTeamLeadUserID) = @UserID
									 )
									 OR EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId
									join Core.Lookup l on e.ModuleId = l.LookupID 
									where l.Name = 'Tier 2 Approval'
									and u.UserID = @UserID))
								 BEGIN
								  SET @Result = 1;
								 END	
						   END
						
                  END
			 END
			 
END
		  
	  ELSE IF (@TaskTypeID = 719)
			BEGIN
			select @DealID = DealID,@amount = ABS(Amount) from cre.DealReserveSchedule where DealReserveScheduleGUID=@TaskID
			select @IsREODeal=IsREODeal from CRE.Deal where DealID=@DealID
		     --whether the second approval is done
		 IF (@CurrentWFStatus_MasterID=4)
		 BEGIN
			--if second approval done normally
			select @SecondApprovalByUser=CreatedBy from  cre.WFTaskDetail where WFTaskDetailID=(Select MAX(WFTaskDetailID) from cre.WFTaskDetail where TaskID = @TaskID and TaskTypeID = @TaskTypeID and SubmitType=498)
			--if second approval done throught reject
			select @SecondApprovalByUserFromReject=CreatedBy from  cre.WFTaskDetail where WFTaskDetailID=(Select MAX(WFTaskDetailID) from cre.WFTaskDetail where TaskID = @TaskID and TaskTypeID = @TaskTypeID and SubmitType=496)
		    
		 END

		 -- set access denay
		  SET @Result = 0;
		  IF (@WorkFlowType ='WF_UNDERREVIEW')
		  BEGIN
				--hide reject option if for  wireconfired record
				IF (@FilterType='Reject' AND EXISTS(select Applied from cre.DealReserveSchedule where DealReserveScheduleGUID=@TaskID and Applied=1))
					BEGIN
						 RETURN @Result
					END
				
				SET @Result = 1;
				RETURN @Result
		  END
		  --if no second approval is happned than check for the consicutive user,if same user than do not allow to complete 
		  ELSE IF (@ReviewCompletedByUser IS NOT NULL AND (@ReviewCompletedByUser = @UserID and  @CurrentWFStatusMasterID=4 AND @SecondApprovalByUser IS NULL and @SecondApprovalByUserFromReject IS NULL))
		  BEGIN
			   RETURN @Result
		  END
		  ELSE IF (@ReviewCompletedByUser IS NOT NULL AND (@ReviewCompletedByUser = @UserID and  @CurrentWFStatusMasterID=4 AND @SecondApprovalByUserFromReject IS NOT NULL))
		  BEGIN
			   SET @Result = 1;
			   RETURN @Result
		  END
		  ELSE 
		  IF (@FirstDealFundingID IS NOT NULL AND @CurrentWFStatusMasterID IS NOT NULL AND @IsFirstApprover IS NOT NULL
		  and @FirstDealFundingID = @TaskID and @IsFirstApprover=0 and @CurrentWFStatusMasterID=4
		  )
		  BEGIN
			   RETURN @Result
		  END
		  ELSE IF (@IsShowApprover IS NOT NULL and @IsShowApprover=0)
		  BEGIN
				RETURN @Result
		  END

			
			
			
			
			SET @WF_IsCompleted = (SELECT ISNULL
			( (
			SELECT TOP 1 1 FROM [CRE].[WFTaskDetail] td 
			INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
			INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
			WHERE TaskId = @TaskID  and spm.OrderIndex = (
			 SELECT MAX(OrderIndex) FROm [CRE].[WFStatusPurposeMapping] WHERE PurposetypeId = spm.PurposeTypeId 
			) ORDER BY WFTaskDetailID DESC )
			,0 )) --AS WF_IsCompleted


	     SET @WF_IsFlowStart =  (SELECT CASE WHEN (SELECT MIN(OrderIndex) FROm [CRE].[WFStatusPurposeMapping] WHERE PurposetypeId = @CurrentPurposeTypeId) <>
			 (SELECT TOP 1 spm.OrderIndex  FROM [CRE].[WFTaskDetail] td 
			INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
			INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
			WHERE TaskId =  @TaskID
			ORDER BY WFTaskDetailID DESC
			)
			THEN 0 ELSE 1 END
			) --AS WF_IsFlowStart


			IF (@FilterType='Reject')
				BEGIN
					--if current status is 2nd approval than need to display reject to any AM

					if (@CurrentWFStatus_MasterID=3)
					BEGIN
					  IF (EXISTS(
								 select u.FirstName from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID 
								 join App.[Role] r on um.RoleID=r.RoleID 
								 where r.RoleName = 'Asset Manager'
								 and convert(varchar(MAX),u.UserId) = @UserID
								 )
								 AND EXISTS(select Applied from cre.DealReserveSchedule where DealReserveScheduleGUID=@TaskID and ISNULL(Applied,0)=0)
						)
								 BEGIN
								  SET @Result = 1;
								 END	
					
					END
					
					--check if Tier 2 and not wireconfiremed than allow to show reject button
					IF ((
					  EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID 
									where l.Name = 'Tier 2 Approval'
									and u.UserID = @UserID))
					 AND EXISTS(select Applied from cre.DealReserveSchedule where DealReserveScheduleGUID=@TaskID and ISNULL(Applied,0)=0)
						)
					BEGIN
						SET @Result = 1;
					END	
					---check if Tier 1,amount <= 1.5M and not wireconfiremed than allow to show reject button
					ELSE IF ((
					  EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID 
									where l.Name = 'Tier 1 Approval'
									and u.UserID = @UserID and @amount<=@AmountTobeCheck))
					 AND EXISTS(select Applied from cre.DealReserveSchedule where DealReserveScheduleGUID=@TaskID and ISNULL(Applied,0)=0)
						)
					BEGIN
						SET @Result = 1;
					END	
					---check if deal specific primary or deal specific Team Lead ,amount <= 500k and not wireconfiremed than allow to show reject button
					ELSE IF ((EXISTS(SELECT u.UserID FROM [CRE].[DealReserveSchedule] df
									INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
									INNER JOIN app.[User] u ON u.UserID = d.AMUserID
									 WHERE df.DealReserveScheduleGUID = @TaskID
									 AND  convert(varchar(MAX),u.UserId) = @UserID)
									 or EXISTS(SELECT u.UserID FROM [CRE].[DealReserveSchedule] df
									INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
									INNER JOIN app.[User] u ON u.UserID = d.AMTeamLeadUserID
									 WHERE df.DealReserveScheduleGUID = @TaskID
									 AND  convert(varchar(MAX),u.UserId) = @UserID))
					     AND EXISTS(select Applied from cre.DealReserveSchedule where DealReserveScheduleGUID=@TaskID and ISNULL(Applied,0)=0)
						 AND @amount<=@AmountTobeCheckForPrimaryAM
						)
					BEGIN
						SET @Result = 1;
					END	

					---check if completed than allow to show reject button to  the person who completed
					ELSE IF(@WF_IsCompleted = 1) 
					BEGIN
					  Select  top 1 @CompletedByUser = t.CreatedBy from cre.WFStatusPurposeMapping sp 
						join [CRE].[WFStatusMaster] s on  sp.WFStatusMasterID=s.WFStatusMasterID 
						join cre.WFTaskDetail t on t.WFStatusPurposeMappingID=sp.WFStatusPurposeMappingID
						where s.WFStatusMasterID=5 and sp.PurposeTypeId=@CurrentPurposeTypeId and t.TaskID=@TaskID 
						and t.SubmitType=498
						order by t.WFTaskDetailID desc
						
						IF (@CompletedByUser=@UserID AND EXISTS(select Applied from cre.DealReserveSchedule where DealReserveScheduleGUID=@TaskID and ISNULL(Applied,0)=0))
						BEGIN
							SET @Result = 1;
						END
					END
				
				END
			
			
			ELSE IF(@WF_IsCompleted = 0) --@WF_IsFlowStart = 1 and 
			 BEGIN
			    
				SET @WF_CurrentStatus = (SELECT (SELECT TOP 1 sm.StatusName FROM [CRE].[WFTaskDetail] td 
				INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
				INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
				WHERE TaskId = @TaskID 
				ORDER BY WFTaskDetailID DESC ) ) --as WF_CurrentStatus;

				SET @NextStatusName = ( Select top 1 sm.StatusName as NextStatusName
				    -- ,PurposeTypeId,mapp1.WFStatusPurposeMappingID as NextWFStatusPurposeMappingID,mapp1.WFStatusMasterID as NextWFStatusMasterID,mapp1.OrderIndex as NextOrderIndex 
				from [CRE].[WFTaskDetail] td 
				INNER JOIN cre.WFStatusPurposeMapping mapp1 on mapp1.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID 
				inner join cre.WFStatusMaster sm on sm.WFStatusMasterID = mapp1.WFStatusMasterID
				where td.WFStatusPurposeMappingID > @CurrentWFStatusPurposeMappingID and PurposeTypeId = @CurrentPurposeTypeId
				order by OrderIndex )

				--check if user L2 then @FilterType set 'all'
				--IF EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId
				--					join Core.Lookup l on e.ModuleId = l.LookupID 
				--					where l.Name = 'Approval (L2)'
				--					and u.UserID = @UserID)
				--				  BEGIN
				--					 SET @FilterType = 'all';
				--				  END

				
				
				if(@FilterType = 'all') -- All
				BEGIN
						IF(@WF_CurrentStatus = 'Projected') -- for AMSecondUserID
						 BEGIN
						  --   SET @Result =  (SELECT COUNT (u.UserID) FROM [CRE].[DealFunding] df
								--INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
								--INNER JOIN app.[User] u ON u.UserID = d.AMSecondUserID
								-- WHERE df.DealFundingID = @TaskID
								-- AND  convert(varchar(MAX),u.UserId) = @UserID)
												
								 --IF EXISTS(SELECT d.AMSecondUserID FROM cre.Deal d WHERE convert(varchar(MAX),d.AMSecondUserID) = @UserID)
								 IF EXISTS
								 (
								 select u.FirstName from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID 
								 join App.[Role] r on um.RoleID=r.RoleID 
								 where r.RoleName = 'Asset Manager'
								 and convert(varchar(MAX),u.UserId) = @UserID
								 )
								 BEGIN
								  SET @Result = 1;
								 END	
						 END
						 IF(@WF_CurrentStatus = 'Under Review') -- for AMSecondUserID
						 BEGIN
								--for REO deal 1st approavl is done by REO group only
								--commented as per requirement changes-now any AM can do the 
								--1st approval for REO deal as well
								--IF(@IsREODeal=1) 
								--BEGIN
								--		if EXISTS(select u.FirstName FROM [App].[EmailNotification] e
								--				inner join  [CORE].[Lookup] l ON l.LookupID = e.ModuleId
								--				inner join [App].[User] u ON  u.Email = e.EmailId
								--				WHERE e.ModuleId ='720' and u.UserID=@UserID)
								--		BEGIN
								--		SET @Result = 1;
								--		END
								--END

								-- ELSE 
								 IF EXISTS
								 (
								 select u.FirstName from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID 
								 join App.[Role] r on um.RoleID=r.RoleID 
								 where r.RoleName = 'Asset Manager'
								 and convert(varchar(MAX),u.UserId) = @UserID
								 )
								 BEGIN
								  SET @Result = 1;
								 END	
						
						 END
						 ELSE IF(@WF_CurrentStatus ='1st Approval') -- for AMUserID
						   BEGIN
						  --      SET @Result =  (SELECT COUNT (u.UserID) FROM [CRE].[DealFunding] df
								--INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
								--INNER JOIN app.[User] u ON u.UserID = d.AMTeamLeadUserID
								-- WHERE df.DealFundingID = @TaskID
								-- AND  convert(varchar(MAX),u.UserId) = @UserID)
						
								 --IF EXISTS(SELECT u.UserID FROM [CRE].[DealFunding] df
									--INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
									--INNER JOIN app.[User] u ON u.UserID = d.AMUserID
									-- WHERE df.DealFundingID = @TaskID
									-- AND  convert(varchar(MAX),u.UserId) = @UserID)
								 --BEGIN
								 -- SET @Result = 1;
								 --END	
						 						
								--IF (EXISTS (SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId
								--	join Core.Lookup l on e.ModuleId = l.LookupID 
								--	where (l.Name = 'Tier 1 Approval' or l.Name = 'Tier 2 Approval' or l.Name = '1st Approval')
								--	and u.UserID = @UserID)
								--	or EXISTS(SELECT u.UserID FROM [CRE].[DealFunding] df
								--	INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
								--	INNER JOIN app.[User] u ON u.UserID = d.AMUserID
								--	 WHERE df.DealFundingID = @TaskID
								--	 AND  convert(varchar(MAX),u.UserId) = @UserID)
								--	 or EXISTS(SELECT u.UserID FROM [CRE].[DealFunding] df
								--	INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
								--	INNER JOIN app.[User] u ON u.UserID = d.AMTeamLeadUserID
								--	 WHERE df.DealFundingID = @TaskID
								--	 AND  convert(varchar(MAX),u.UserId) = @UserID)
								-- )
								IF EXISTS
								 (
								 select u.FirstName from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID 
								 join App.[Role] r on um.RoleID=r.RoleID 
								 where r.RoleName = 'Asset Manager'
								 and convert(varchar(MAX),u.UserId) = @UserID
								 )

								 BEGIN
								  SET @Result = 1;
								 END	

						   END
						 ELSE IF(@WF_CurrentStatus ='2nd Approval') -- -- for AMTeamLeadUserID
						   BEGIN
				   				       
								--SET @Result = (SELECT COUNT(u.UserID) FROM [App].[Role] r 
								--INNER JOIN [App].[UserRoleMap] ur ON ur.RoleID = r.RoleID
								--INNER JOIN [App].[User] u ON u.UserID = ur.UserID
								--WHERE r.RoleName = 'Approval (L1)'
								--AND  convert(varchar(MAX),u.UserId) = @UserID)

								IF (EXISTS (SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId
									join Core.Lookup l on e.ModuleId = l.LookupID 
									where (l.Name = 'Tier 1 Approval' or l.Name = 'Tier 2 Approval')
									and u.UserID = @UserID)
								 
								 OR EXISTS(SELECT u.UserID FROM [CRE].[DealReserveSchedule] df
									INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
									INNER JOIN app.[User] u ON u.UserID = d.AMUserID
									 WHERE df.DealReserveScheduleGUID = @TaskID
									 AND  convert(varchar(MAX),u.UserId) = @UserID)
								OR EXISTS(SELECT u.UserID FROM [CRE].[DealReserveSchedule] df
									INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
									INNER JOIN app.[User] u ON u.UserID = d.AMTeamLeadUserID
									 WHERE df.DealReserveScheduleGUID = @TaskID
									 AND  convert(varchar(MAX),u.UserId) = @UserID)
								OR EXISTS(SELECT u.UserID from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = '1st Approval'
									and u.UserID = @UserID)
									 )
								 BEGIN
								  SET @Result = 1;
								 END	
						   END
						 
                  END
				ELSE if(@FilterType = 'respective') -- Respective
				BEGIN

						IF(@WF_CurrentStatus = 'Projected') -- for AMSecondUserID
						 BEGIN
						  --   SET @Result =  (SELECT COUNT (u.UserID) FROM [CRE].[DealFunding] df
								--INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
								--INNER JOIN app.[User] u ON u.UserID = d.AMSecondUserID
								-- WHERE df.DealFundingID = @TaskID
								-- AND  convert(varchar(MAX),u.UserId) = @UserID)		

								 --- All users with Asset managers role and respective deal
								 IF EXISTS(SELECT df.DealID FROM [CRE].[DealReserveSchedule] df
									INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
									--INNER JOIN app.[User] u ON u.UserID = d.AMUserID
									 WHERE df.DealReserveScheduleGUID = @TaskID
									 AND 
										 ( convert(varchar(MAX),d.AMSecondUserID) = @UserID
										 --OR  convert(varchar(MAX),d.AMUserID) = @UserID
										 --OR  convert(varchar(MAX),d.AMTeamLeadUserID) = @UserID
										 )
									 )
								 BEGIN
								  SET @Result = 1;
								 END	

						 END
						 IF(@WF_CurrentStatus = 'Under Review') -- for AMSecondUserID
						 BEGIN
						  --- All users with Asset managers role and respective deal
								IF EXISTS(SELECT df.DealID FROM [CRE].[DealReserveSchedule] df
									INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
									 WHERE df.DealReserveScheduleGUID = @TaskID
									 AND ( convert(varchar(MAX),d.AMSecondUserID) = @UserID									 
									   --OR  convert(varchar(MAX),d.AMUserID) = @UserID
									   --OR  convert(varchar(MAX),d.AMTeamLeadUserID) = @UserID
									   )
									 )
								 BEGIN
								  SET @Result = 1;
								 END	
						
						 END
						 ELSE IF(@WF_CurrentStatus ='1st Approval') -- for AMUserID
						   BEGIN
						 
						 						
								 --IF (EXISTS(SELECT u.UserID FROM [CRE].[DealFunding] df
									--INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
									--INNER JOIN app.[User] u ON u.UserID = d.AMUserID
									-- WHERE df.DealFundingID = @TaskID
									-- AND  convert(varchar(MAX),u.UserId) = @UserID)
								 --OR
								 --EXISTS(SELECT d.AMTeamLeadUserID FROM cre.Deal d WHERE convert(varchar(MAX),d.AMTeamLeadUserID) = @UserID))
								 --BEGIN
								 -- SET @Result = 1;
								 --END	

								 --- All users with Asset managers role and respective deal
								IF EXISTS(SELECT df.DealID FROM [CRE].[DealReserveSchedule] df
									INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
									 WHERE df.DealReserveScheduleGUID = @TaskID
									 --AND  convert(varchar(MAX),d.AMSecondUserID) = @UserID
									 AND 
									 ( convert(varchar(MAX),d.AMUserID) = @UserID
									  --OR  convert(varchar(MAX),d.AMTeamLeadUserID) = @UserID
									 )
									 )
								 BEGIN
								  SET @Result = 1;
								 END	

						   END
						 ELSE IF(@WF_CurrentStatus ='2nd Approval') -- -- for AMTeamLeadUserID
						   BEGIN
				   				       
								 --- All users with Asset managers role and respective deal
								IF (EXISTS(SELECT df.DealID FROM [CRE].[DealReserveSchedule] df
									INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
									 WHERE df.DealReserveScheduleGUID = @TaskID
									 --AND  convert(varchar(MAX),d.AMSecondUserID) = @UserID
									 --AND  convert(varchar(MAX),d.AMUserID) = @UserID
									 AND  convert(varchar(MAX),d.AMTeamLeadUserID) = @UserID
									 )
									 OR EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId
									join Core.Lookup l on e.ModuleId = l.LookupID 
									where l.Name = 'Tier 2 Approval'
									and u.UserID = @UserID))
								 BEGIN
								  SET @Result = 1;
								 END	
						   END
						
                  END
			 END
			
			
			END
		
	END
    RETURN @Result
END


