-- Procedure
--select * from app.[user] where login='tier2'
--[usp_GetWorkflowDetailByTaskId] 719,'22efd9c4-b0c8-4d54-a779-a78d5673ca4c','C24C8297-3B99-4BF1-8CE0-85DA85A86223'
create PROCEDURE [dbo].[usp_GetWorkflowDetailByTaskId] 
(
    @TaskTypeID int,
	@TaskID nvarchar(500),
	@UserID nvarchar(500)
)
	
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @amount decimal(28,15),@isShowCompleted bit = 0,@OrderIndexCount int =0,@AmountTobeCheck decimal(28,15),@AmountTobeCheckForPrimaryAM decimal(28,15)
	Declare @Max_WFTaskDetailID int = (Select MAX(WFTaskDetailID) from cre.WFTaskDetail where TaskID = @TaskID and TaskTypeID=@TaskTypeID)
	Declare @CurrentWFStatusPurposeMappingID int = (Select WFStatusPurposeMappingID from cre.WFTaskDetail where TaskID = @TaskID and TaskTypeID=@TaskTypeID and WFTaskDetailID = @Max_WFTaskDetailID)
	Declare @CurrentWFStatusMasterID int,
	@ReviewCompletedByUser uniqueidentifier,
	@IsReviewCompletedByPrimaryAM bit=0
	Declare @CurrentPurposeTypeId int,
	@DealID uniqueidentifier,
	@FirstDealFundingID uniqueidentifier,
	@PurposeID int,
	@IsApprovalL3 bit=0,
	@IsShowApprover bit =1,
	@SecondApprovalByUser uniqueidentifier,
	@PurposeTypeValue nvarchar(100),
	@IsDisableFundingTeamApproval int=0,
	@IsOnlyPrimaryUser int=0,
	@DealStatusID int,
	@IsREODeal bit=0,
	@CheckListStatus int

	--502-Deal Funding,716-Reserve Account

	if (@TaskTypeID = 502)
	BEGIN

	select @amount = Amount FROM cre.DealFunding where DealFundingID = @TaskID
	select @CheckListStatus=CheckListStatus from cre.wfchecklistdetail where taskid=@TaskID and WFCheckListMasterID=6 and TaskTypeID=502
	SET @AmountTobeCheck = 1500000
	SET @AmountTobeCheckForPrimaryAM = 500000 

	select  @CurrentWFStatusMasterID =(Select WFStatusmasterID from cre.WFStatusPurposeMapping where WFStatusPurposeMappingID = @CurrentWFStatusPurposeMappingID)
	select @DealID = DealID,@PurposeID = PurposeID from cre.DealFunding where DealFundingID=@TaskID
	select @PurposeTypeValue = Value FROM Core.Lookup where LookupID=@PurposeID
	select @DealStatusID=[Status] from cre.Deal where DealID=@DealID
	
	--Select  top 1 @FirstDealFundingID=DealFundingID from cre.DealFunding where dealid = @DealID and @PurposeTypeValue = 'Positive'
 --   order by Date,DealFundingRowno
     
	--First draw = First positive draw,funding amount>0 and work flow is enabled
	Select  top 1 @FirstDealFundingID=df.DealFundingID from cre.DealFunding df left join core.lookup l  on df.PurposeID =l.LookupID 
    join 
	(
	    Select distinct taskid  from [CRE].WFTaskDetail t  
		join cre.dealfunding df on t.taskid=df.dealfundingid
		join cre.deal d on d.dealid=df.dealid
		where df.dealid=@DealID
		and d.[Status]<>325
	) wfallow on wfallow.taskid =df.DealFundingID
	where dealid = @DealID and (@PurposeTypeValue = 'Positive' or @PurposeTypeValue = 'Both') 
	and ((l.Value ='Positive' and l.Value <>'Both') or (l.Value ='Both' and df.Amount>0))
	and df.Amount>0
	order by Date,DealFundingRowno	
	
	
	if (@FirstDealFundingID = @TaskID OR @amount>@AmountTobeCheckForPrimaryAM)
	BEGIN
	   set @IsDisableFundingTeamApproval=1
	END
	
	--if current status is 'submiteed to review'
	IF (@CurrentWFStatusMasterID >=3) 
	BEGIN
		--get the user who complited the 'submitted to review' step
		IF (@CurrentWFStatusMasterID=3)
		BEGIN
			select @ReviewCompletedByUser=CreatedBy from  cre.WFTaskDetail where WFTaskDetailID=(Select MAX(WFTaskDetailID) from cre.WFTaskDetail where TaskID = @TaskID and TaskTypeID=@TaskTypeID and SubmitType=498)
	    END
		ELSE 
		BEGIN
			select @CurrentPurposeTypeId = (Select PurposeTypeId from cre.WFStatusPurposeMapping where WFStatusPurposeMappingID = @CurrentWFStatusPurposeMappingID )
			Select  top 1 @ReviewCompletedByUser = t.CreatedBy from cre.WFStatusPurposeMapping sp 
			join [CRE].[WFStatusMaster] s on  sp.WFStatusMasterID=s.WFStatusMasterID 
			join cre.WFTaskDetailArchive t on t.WFStatusPurposeMappingID=sp.WFStatusPurposeMappingID
			where s.WFStatusMasterID=3 and sp.PurposeTypeId=@CurrentPurposeTypeId and t.TaskID=@TaskID and t.TaskTypeID=@TaskTypeID 
			and t.SubmitType=498
			order by t.WFTaskDetailID desc
	    END
		

		IF (@CurrentWFStatusMasterID=4)
		BEGIN
			select @SecondApprovalByUser=CreatedBy from  cre.WFTaskDetail where WFTaskDetailID=(Select MAX(WFTaskDetailID) from cre.WFTaskDetail where TaskID = @TaskID and SubmitType=498)
	    END
		--ELSE 
		--BEGIN
		--	select @CurrentPurposeTypeId = (Select PurposeTypeId from cre.WFStatusPurposeMapping where WFStatusPurposeMappingID = @CurrentWFStatusPurposeMappingID )
		--	Select  top 1 @SecondApprovalByUser = t.CreatedBy from cre.WFStatusPurposeMapping sp 
		--	join [CRE].[WFStatusMaster] s on  sp.WFStatusMasterID=s.WFStatusMasterID 
		--	join cre.WFTaskDetailArchive t on t.WFStatusPurposeMappingID=sp.WFStatusPurposeMappingID
		--	where s.WFStatusMasterID=4 and sp.PurposeTypeId=@CurrentPurposeTypeId and t.TaskID=@TaskID 
		--	and t.SubmitType=498
		--	order by t.WFTaskDetailID desc
	 --   END

		
		--check if L3 and first funding of that perticular status than dicrectly show the completed button
		--IF(@CurrentWFStatusMasterID=3 and @FirstDealFundingID = @TaskID)
		--As per jsons request FirstDraw approver should approve only upto 500 k
		IF(@CurrentWFStatusMasterID=3 and @FirstDealFundingID = @TaskID and @amount<=@AmountTobeCheckForPrimaryAM)

		BEGIN
		   
		   IF EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = '1st Approval'
									and u.UserID = @UserID)
								  BEGIN
									 SET @IsApprovalL3=1
									 SET @CurrentWFStatusPurposeMappingID+=1
									SET @isShowCompleted = 1
									SET @OrderIndexCount = 10
								  END
								  --if first funding but not '1st Approval' user than allow to do second approval
								  --allow only if 1st approval and user doing 2nd approval is different
								  ELSE IF (@ReviewCompletedByUser<>@UserID) 
								  BEGIN
								   SET @IsShowApprover = 1
								  END
								  ELSE
								  BEGIN
								     SET @IsShowApprover = 0
								  END
		END
		--ELSE IF(@CurrentWFStatusMasterID=4 and @FirstDealFundingID = @TaskID) --first funding and someone did the second approval
		ELSE IF(@CurrentWFStatusMasterID=4 and @FirstDealFundingID = @TaskID and @amount<=@AmountTobeCheckForPrimaryAM)

		BEGIN
		   
		   IF EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = '1st Approval'
									and u.UserID = @UserID)
								  BEGIN
									 SET @IsApprovalL3=1
									SET @isShowCompleted = 1
								  END
								  ELSE
								  BEGIN
								     SET @IsShowApprover = 0
								  END
		END
		ELSE
		BEGIN
		
		
		--check whether the review is completed by deal specific primary AM,deal specific team lead(am overside) or non primary AM
		IF (EXISTS(SELECT u.UserID FROM [CRE].[DealFunding] df
										INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
										INNER JOIN app.[User] u ON u.UserID = d.AMUserID
										 WHERE df.DealFundingID = @TaskID
										 AND  convert(varchar(MAX),u.UserId) = @ReviewCompletedByUser)
										 )
			BEGIN
			  SET @IsReviewCompletedByPrimaryAM=1
			END

			
		--if review complated by deal specific primary AM
		IF ( @IsReviewCompletedByPrimaryAM=1)
		BEGIN
			 
			IF (@ReviewCompletedByUser=@UserID )
			BEGIN
			         --allow only if 1st approval and 2nd approval is done by different user
					 IF (@SecondApprovalByUser is null)
						   SET @IsShowApprover=1
					  ELSE IF(@ReviewCompletedByUser<>@SecondApprovalByUser and @UserID<>@SecondApprovalByUser and @CurrentWFStatusMasterID=4 and @amount<=@AmountTobeCheckForPrimaryAM)
						SET @IsShowApprover=1
					ELSE
			           SET @IsShowApprover=0
			END
			
			IF (@IsShowApprover=1)
			BEGIN
					 IF NOT EXISTS(
					  SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID 
					  where (l.Name = 'Tier 2 Approval' or l.Name = 'Tier 1 Approval')
											and u.UserID = @UserID)
						BEGIN
						      SET @IsOnlyPrimaryUser=1
						END
					--if L2
					IF EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 2 Approval'
											and u.UserID = @UserID AND  @CurrentWFStatusMasterID=3)
										  BEGIN
											 SET @CurrentWFStatusPurposeMappingID+=1
											SET @isShowCompleted = 1
											SET @OrderIndexCount = 10
										  END
			
			
					ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 2 Approval'
						and u.UserID = @UserID  AND @CurrentWFStatusMasterID=4))
						BEGIN
							set @IsShowApprover=1
					
						END

					ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 1 Approval'
											and u.UserID = @UserID AND (@amount<=@AmountTobeCheck) AND @CurrentWFStatusMasterID=3))
						BEGIN
							set @CurrentWFStatusPurposeMappingID+=1
							SET @isShowCompleted = 1
							SET @OrderIndexCount = 10
						END
					ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 1 Approval'
										and u.UserID = @UserID AND (@amount<=@AmountTobeCheck) AND @CurrentWFStatusMasterID=4))
					BEGIN
						set @IsShowApprover=1
					END
					ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 1 Approval'
						and u.UserID = @UserID AND (@amount>@AmountTobeCheck) AND @CurrentWFStatusMasterID=4))
						BEGIN
							set @IsShowApprover=0
					
						END
					ELSE IF (EXISTS( select 1 from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID join App.[Role] r on um.RoleID=r.RoleID where r.RoleName = 'Asset Manager'
										 and u.UserId = @UserID AND @CurrentWFStatusMasterID=3 and @UserID=@ReviewCompletedByUser))
						BEGIN
							set @IsShowApprover=0
					
						END

					ELSE IF (EXISTS( select 1 from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID join App.[Role] r on um.RoleID=r.RoleID where r.RoleName = 'Asset Manager'
										 and u.UserId = @UserID AND @CurrentWFStatusMasterID=4 and @UserID=@SecondApprovalByUser))
						BEGIN
							set @IsShowApprover=0
					
						END
					ELSE IF EXISTS(SELECT u.UserID FROM [CRE].[DealFunding] df
							INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
							INNER JOIN app.[User] u ON u.UserID = d.AMTeamLeadUserID
							WHERE df.DealFundingID = @TaskID
							AND  convert(varchar(MAX),u.UserId) = @UserID
							AND @CurrentWFStatusMasterID=3 and @amount<=@AmountTobeCheckForPrimaryAM and @IsOnlyPrimaryUser=1)
							BEGIN
									
							-- if funding teams approval required = No than only display final approval otherwise deiplay second approval
							if (@CheckListStatus<>499)
							BEGIN
								SET @CurrentWFStatusPurposeMappingID+=1
								SET @isShowCompleted = 1
								SET @OrderIndexCount = 10
							END
							ELSE
							BEGIN
								SET @IsShowApprover=1
							END
							END
					ELSE IF EXISTS(SELECT u.UserID FROM [CRE].[DealFunding] df
							INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
							INNER JOIN app.[User] u ON u.UserID = d.AMTeamLeadUserID
							WHERE df.DealFundingID = @TaskID
							AND  convert(varchar(MAX),u.UserId) = @UserID
							AND @CurrentWFStatusMasterID=4 and @amount<=@AmountTobeCheckForPrimaryAM)
							BEGIN
									set @IsShowApprover=1
							END
			
					ELSE
						BEGIN
						set @IsShowApprover=1
					END
			END
		
		END

		ELSE --if review complated by non primary AM
		BEGIN
	         
			IF (@ReviewCompletedByUser=@UserID OR EXISTS(SELECT u.UserID FROM [CRE].[DealFunding] df
							INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
							INNER JOIN app.[User] u ON u.UserID = d.AMTeamLeadUserID
							WHERE df.DealFundingID = @TaskID
							AND  convert(varchar(MAX),u.UserId) = @UserID))
			BEGIN
						print @SecondApprovalByUser
						--allow only if 1st approval and 2nd approval is done by different user
						IF (@SecondApprovalByUser is null)
						   SET @IsShowApprover=1
						ELSE IF(@ReviewCompletedByUser<>@SecondApprovalByUser and @UserID<>@SecondApprovalByUser and @CurrentWFStatusMasterID=4)
							SET @IsShowApprover=1
						ELSE
							SET @IsShowApprover=0
			END
			
			 
			

			IF (@IsShowApprover=1)
			BEGIN  
					  --if log in user in deal specific primary AM or deal specific team lead
					  IF (EXISTS(SELECT u.UserID FROM [CRE].[DealFunding] df
												INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
												INNER JOIN app.[User] u ON u.UserID = d.AMUserID
												 WHERE df.DealFundingID = @TaskID
												 AND  convert(varchar(MAX),u.UserId) = @UserID)
						OR EXISTS(SELECT u.UserID FROM [CRE].[DealFunding] df
							INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
							INNER JOIN app.[User] u ON u.UserID = d.AMTeamLeadUserID
							WHERE df.DealFundingID = @TaskID
							AND  convert(varchar(MAX),u.UserId) = @UserID)
					 )
					BEGIN
					  --check if user is only primary or teamlead and not t1 and t2 
					  IF NOT EXISTS(
					  SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID 
					  where (l.Name = 'Tier 2 Approval' or l.Name = 'Tier 1 Approval')
											and u.UserID = @UserID)
						BEGIN
						      SET @IsOnlyPrimaryUser=1
						END 								
												 
					  
					 
					  IF (@amount<=@AmountTobeCheckForPrimaryAM and @CurrentWFStatusMasterID=3 and @IsOnlyPrimaryUser=1)
						BEGIN
					
							-- if funding teams approval required = No than only display final approval otherwise deiplay second approval
							if (@CheckListStatus<>499)
							BEGIN
								SET @CurrentWFStatusPurposeMappingID+=1
								SET @isShowCompleted = 1
								SET @OrderIndexCount = 10
							END
							ELSE
							BEGIN
								SET @IsShowApprover=1
							END
						END
						ELSE IF (@amount<=@AmountTobeCheckForPrimaryAM and @CurrentWFStatusMasterID=4)
						BEGIN
							SET @IsShowApprover=1
						END
						--if tier 2 he can approval any amount
						--if L2
						ELSE IF EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 2 Approval'
											and u.UserID = @UserID AND @CurrentWFStatusMasterID=3)
										  BEGIN
									 
											 SET @CurrentWFStatusPurposeMappingID+=1
											SET @isShowCompleted = 1
											SET @OrderIndexCount = 10
										  END
				
						ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 2 Approval'
						and u.UserID = @UserID  AND @CurrentWFStatusMasterID=4))
						BEGIN
							set @IsShowApprover=1
					
						END
						--if funding amount < 5 milion and tier 1, he can approve
						ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 1 Approval'
											and u.UserID = @UserID AND (@amount<=@AmountTobeCheck) AND @CurrentWFStatusMasterID=3))
						BEGIN
							set @CurrentWFStatusPurposeMappingID+=1
							SET @isShowCompleted = 1
							SET @OrderIndexCount = 10
						END
						ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 1 Approval'
											and u.UserID = @UserID AND (@amount<=@AmountTobeCheck) AND @CurrentWFStatusMasterID=4))
						BEGIN
							set @IsShowApprover=1
						END

						--if funding amount > 5 milion,status-1st approval and tier 1, he can do 2nd approval
						ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 1 Approval'
											and u.UserID = @UserID AND (@amount>@AmountTobeCheck) AND @CurrentWFStatusMasterID=3))
						BEGIN
							set @IsShowApprover=1
						END
						--if funding amount > 5 milion and tier 1 he can not approve
						ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 1 Approval'
						and u.UserID = @UserID AND (@amount>@AmountTobeCheck) AND @CurrentWFStatusMasterID=4))
						BEGIN
							set @IsShowApprover=0
					
						END
						ELSE IF (EXISTS( select 1 from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID join App.[Role] r on um.RoleID=r.RoleID where r.RoleName = 'Asset Manager'
										 and u.UserId = @UserID AND @CurrentWFStatusMasterID=3 and @UserID=@ReviewCompletedByUser))
						BEGIN
							set @IsShowApprover=0
					
						END

						ELSE IF (EXISTS( select 1 from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID join App.[Role] r on um.RoleID=r.RoleID where r.RoleName = 'Asset Manager'
										 and u.UserId = @UserID AND @CurrentWFStatusMasterID=4 and @UserID=@SecondApprovalByUser))
						BEGIN
							set @IsShowApprover=0
					
						END
				
						ELSE IF (EXISTS( select 1 from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID join App.[Role] r on um.RoleID=r.RoleID where r.RoleName = 'Asset Manager'
										 and u.UserId = @UserID AND @CurrentWFStatusMasterID=3))
						BEGIN
							set @IsShowApprover=1
					
						END
						ELSE
						 BEGIN
							set @IsShowApprover=0
						END
					END
					ELSE
					BEGIN
					--if tier 2 he can approval any amount
				
						IF EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 2 Approval'
											and u.UserID = @UserID AND @CurrentWFStatusMasterID=3)
										  BEGIN
									 
											 SET @CurrentWFStatusPurposeMappingID+=1
											SET @isShowCompleted = 1
											SET @OrderIndexCount = 10
										  END
				
				
						ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 2 Approval'
						and u.UserID = @UserID  AND @CurrentWFStatusMasterID=4))
						BEGIN
							set @IsShowApprover=1
					
						END
						--if funding amount < 5 milion and tier 1, he can approve
						ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 1 Approval'
											and u.UserID = @UserID AND (@amount<=@AmountTobeCheck) AND @CurrentWFStatusMasterID=3))
						BEGIN
							set @CurrentWFStatusPurposeMappingID+=1
							SET @isShowCompleted = 1
							SET @OrderIndexCount = 10
						END
						ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 1 Approval'
											and u.UserID = @UserID AND (@amount<=@AmountTobeCheck) AND @CurrentWFStatusMasterID=4))
						BEGIN
							set @IsShowApprover=1
						END
						--if funding amount > 5 milion,status-1st approval and tier 1, he can do 2nd approval
						ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 1 Approval'
											and u.UserID = @UserID AND (@amount>@AmountTobeCheck) AND @CurrentWFStatusMasterID=3))
						BEGIN
							set @IsShowApprover=1
						END
						ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 1 Approval'
						and u.UserID = @UserID AND (@amount>@AmountTobeCheck) AND @CurrentWFStatusMasterID=4))
						BEGIN
							set @IsShowApprover=0
					
						END
						ELSE IF (EXISTS( select 1 from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID join App.[Role] r on um.RoleID=r.RoleID where r.RoleName = 'Asset Manager'
										 and u.UserId = @UserID AND @CurrentWFStatusMasterID=3 and @UserID=@ReviewCompletedByUser))
						BEGIN
							set @IsShowApprover=0
					
						END

						ELSE IF (EXISTS( select 1 from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID join App.[Role] r on um.RoleID=r.RoleID where r.RoleName = 'Asset Manager'
										 and u.UserId = @UserID AND @CurrentWFStatusMasterID=4 and @UserID=@SecondApprovalByUser))
						BEGIN
							set @IsShowApprover=0
					
						END
						ELSE IF (EXISTS( select 1 from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID join App.[Role] r on um.RoleID=r.RoleID where r.RoleName = 'Asset Manager'
										 and u.UserId = @UserID AND @CurrentWFStatusMasterID=3))
						BEGIN
							set @IsShowApprover=1
					
						END
						ELSE
						 BEGIN
							set @IsShowApprover=0
						END

					END
			END
		END
		END
	END
	
	select  @CurrentWFStatusMasterID =(Select WFStatusmasterID from cre.WFStatusPurposeMapping where WFStatusPurposeMappingID = @CurrentWFStatusPurposeMappingID)
	
	select  @CurrentPurposeTypeId = (Select PurposeTypeId from cre.WFStatusPurposeMapping where WFStatusPurposeMappingID = @CurrentWFStatusPurposeMappingID )
	select @amount = Amount FROM cre.DealFunding where DealFundingID = @TaskID

	Select 
	td.WFTaskDetailID,
	td.TaskID,
	td.TaskTypeID,
	td.SubmitType,
	'' as Comment,
	--td.Comment,
	(case when @isShowCompleted = 1 then @CurrentWFStatusPurposeMappingID else td.WFStatusPurposeMappingID end) as WFStatusPurposeMappingID,
	
	mapp.PurposeTypeId,
	mapp.OrderIndex,
	(case when @isShowCompleted = 1 then @CurrentWFStatusMasterID else mapp.WFStatusMasterID end) as WFStatusMasterID
	,

	--(Case
	--When (Select count(WFCheckListDetailID) from cre.WFCheckListDetail where TaskId = @TaskID and (CheckListStatus = (Select Lookupid from core.lookup where parentid = 78 and [name] = 'No') or CheckListStatus is null)) > 0 
	--then sm.StatusName + ' (Partial)' 
	--Else sm.StatusName END
	--)StatusName,
	sm.StatusName,
	StatusDisplayName =(CASE WHEN lPurposeType.Value1 = 'WF_UNDERREVIEW' THEN sm.WFUnderReviewDisplayName else sm.StatusDisplayName end),
	--(Case
	--When (Select count(WFCheckListDetailID) from cre.WFCheckListDetail where TaskId = @TaskID and (CheckListStatus = (Select Lookupid from core.lookup where parentid = 78 and [name] = 'No') or CheckListStatus is null)) > 0 
	--then sm.StatusDisplayName + ' (Partial)' 
	--Else sm.StatusDisplayName END
	--)StatusDisplayName,

	lTaskTypeID.name as TaskTypeIDText,
	lSubmitType.name as SubmitTypeText,

	tblnextstastus.NextWFStatusPurposeMappingID,
	tblnextstastus.NextWFStatusMasterID,
	tblnextstastus.NextStatusName,
	tblnextstastus.NextOrderIndex,
	--(case 
	--	when (Select COUNT(OrderIndex) from cre.WFStatusPurposeMapping where PurposeTypeId = mapp.PurposeTypeId and OrderIndex > (case when @amount<=1000000 then mapp.OrderIndex+10 else mapp.OrderIndex end) ) = 1 then 'FinalState' 
	--	when (Select COUNT(OrderIndex) from cre.WFStatusPurposeMapping where PurposeTypeId = mapp.PurposeTypeId and OrderIndex >(case when @amount<=1000000 then mapp.OrderIndex+10 else mapp.OrderIndex end) ) = 0 then 'Complete' 
	--	else 'InProcess' end
	--) as wfFlag,
	(case 
		when (Select COUNT(OrderIndex) from cre.WFStatusPurposeMapping where PurposeTypeId = mapp.PurposeTypeId and OrderIndex > (case when @isShowCompleted = 1 then mapp.OrderIndex+@OrderIndexCount else mapp.OrderIndex end)) = 1 then 'FinalState' 
		when (Select COUNT(OrderIndex) from cre.WFStatusPurposeMapping where PurposeTypeId = mapp.PurposeTypeId and OrderIndex >(case when @isShowCompleted = 1 then mapp.OrderIndex+@OrderIndexCount else mapp.OrderIndex end)) = 0 then 'Complete' 
		else 'InProcess' end
	) as wfFlag,
	--wf_isAllow =(case when @ReviewCompletedByUser = @UserID then 0 when (@FirstDealFundingID = @TaskID and @IsApprovalL3=0 and @CurrentWFStatusMasterID=3) then 0 when @IsShowApprover=0 then 0 else
	--[dbo].[Fn_GetGetWorkflowAccessPermissionByTaskAndUserID](td.TaskID,@UserID,'all') end)
	[dbo].[Fn_GetGetWorkflowAccessPermissionByTaskAndUserID](@TaskTypeID,td.TaskID,@UserID,'all',@ReviewCompletedByUser,@FirstDealFundingID,@IsApprovalL3,@CurrentWFStatusMasterID,@IsShowApprover) as wf_isAllow
	,tblnextstastus.NextStatusDisplayName,
	wf_isAllowReject = [dbo].[Fn_GetGetWorkflowAccessPermissionByTaskAndUserID](@TaskTypeID,td.TaskID,@UserID,'Reject',null,null,null,null,null),
	lPurposeType.Value1 as WorkFlowType,
	@IsDisableFundingTeamApproval as IsDisableFundingTeamApproval,
	@IsOnlyPrimaryUser as IsOnlyPrimaryUser
	from cre.WFTaskDetail td
	left join cre.WFStatusPurposeMapping mapp on mapp.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
	left join cre.WFStatusMaster sm on sm.WFStatusMasterID = mapp.WFStatusMasterID
	left join core.Lookup lTaskTypeID on lTaskTypeID.LookupID = td.TaskTypeID and lTaskTypeID.ParentID = 27
	left join core.Lookup lSubmitType on lSubmitType.LookupID = td.SubmitType and lSubmitType.ParentID = 77
	
	left join
	(
		Select top 1 PurposeTypeId,mapp1.WFStatusPurposeMappingID as NextWFStatusPurposeMappingID,mapp1.WFStatusMasterID as NextWFStatusMasterID,sm.StatusName as NextStatusName,mapp1.OrderIndex as NextOrderIndex,
		NextStatusDisplayName =(case when (select Value1 FROM Core.Lookup where LookUpID=@CurrentPurposeTypeId)='WF_UNDERREVIEW' THEN sm.WFUnderReviewDisplayName else sm.StatusDisplayName end)
		from cre.WFStatusPurposeMapping mapp1
		inner join cre.WFStatusMaster sm on sm.WFStatusMasterID = mapp1.WFStatusMasterID
		where WFStatusPurposeMappingID > @CurrentWFStatusPurposeMappingID and PurposeTypeId = @CurrentPurposeTypeId
		order by OrderIndex

	)tblnextstastus on tblnextstastus.PurposeTypeId = mapp.PurposeTypeId
	join cre.dealfunding df on df.DealFundingID =td.TaskID
	left join core.Lookup lPurposeType on lPurposeType.LookupID = df.PurposeID and lPurposeType.ParentID = 50
	join cre.Deal d on d.DealID = df.DealID
	Where td.WFTaskDetailID = @Max_WFTaskDetailID
	and td.IsDeleted=0

	END
	ELSE IF (@TaskTypeID = 719)
	BEGIN
	select @CheckListStatus=CheckListStatus from cre.wfchecklistdetail where taskid=@TaskID and WFCheckListMasterID=15 and TaskTypeID=719
	select @amount = Abs(Amount) FROM CRE.DealReserveSchedule where DealReserveScheduleGUID = @TaskID

	SET @AmountTobeCheck = 1500000
	SET @AmountTobeCheckForPrimaryAM = 500000 
	select  @CurrentWFStatusMasterID =(Select WFStatusmasterID from cre.WFStatusPurposeMapping where WFStatusPurposeMappingID = @CurrentWFStatusPurposeMappingID)
	select @DealID = DealID,@PurposeID = PurposeID from cre.DealReserveSchedule where DealReserveScheduleGUID=@TaskID
	select @IsREODeal=isnull(IsREODeal,0) from CRE.Deal where DealID=@DealID
	select @PurposeTypeValue = Value FROM Core.Lookup where LookupID=@PurposeID
	select @DealStatusID=[Status] from cre.Deal where DealID=@DealID
	
	--Select  top 1 @FirstDealFundingID=DealFundingID from cre.DealFunding where dealid = @DealID and @PurposeTypeValue = 'Positive'
 --   order by Date,DealFundingRowno
	
	if (@amount>@AmountTobeCheckForPrimaryAM or @IsREODeal=1)
	BEGIN
	   set @IsDisableFundingTeamApproval=1
	END
	
	--if current status is 'submiteed to review'
	IF (@CurrentWFStatusMasterID >=3) 
	BEGIN
		
		--get the user who complited the 'submitted to review' step
		IF (@CurrentWFStatusMasterID=3)
		BEGIN
			select @ReviewCompletedByUser=CreatedBy from  cre.WFTaskDetail where WFTaskDetailID=(Select MAX(WFTaskDetailID) from cre.WFTaskDetail where TaskID = @TaskID and TaskTypeID=@TaskTypeID and SubmitType=498)
	    END
		ELSE 
		BEGIN
			select @CurrentPurposeTypeId = (Select PurposeTypeId from cre.WFStatusPurposeMapping where WFStatusPurposeMappingID = @CurrentWFStatusPurposeMappingID )
			Select  top 1 @ReviewCompletedByUser = t.CreatedBy from cre.WFStatusPurposeMapping sp 
			join [CRE].[WFStatusMaster] s on  sp.WFStatusMasterID=s.WFStatusMasterID 
			join cre.WFTaskDetailArchive t on t.WFStatusPurposeMappingID=sp.WFStatusPurposeMappingID
			where s.WFStatusMasterID=3 and sp.PurposeTypeId=@CurrentPurposeTypeId and t.TaskID=@TaskID and t.TaskTypeID=@TaskTypeID 
			and t.SubmitType=498
			order by t.WFTaskDetailID desc
	    END


		IF (@CurrentWFStatusMasterID=4)
		BEGIN
			select @SecondApprovalByUser=CreatedBy from  cre.WFTaskDetail where WFTaskDetailID=(Select MAX(WFTaskDetailID) from cre.WFTaskDetail where TaskID = @TaskID and SubmitType=498 and TaskTypeID=@TaskTypeID)
			
	    END
		
		--check whether the review is completed by deal specific primary AM,deal specific team lead(am overside) or non primary AM
		IF (EXISTS(SELECT u.UserID FROM [CRE].DealReserveSchedule df
										INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
										INNER JOIN app.[User] u ON u.UserID = d.AMUserID
										 WHERE df.DealReserveScheduleGUID = @TaskID
										 AND  convert(varchar(MAX),u.UserId) = @ReviewCompletedByUser)
										 )
			BEGIN
			  SET @IsReviewCompletedByPrimaryAM=1
			END


		--if review complated by deal specific primary AM
		IF ( @IsReviewCompletedByPrimaryAM=1)
		BEGIN
			
			IF (@ReviewCompletedByUser=@UserID )
			BEGIN
			         --allow only if 1st approval and 2nd approval is done by different user
					 IF (@SecondApprovalByUser is null)
						   SET @IsShowApprover=1
					 ELSE IF(@ReviewCompletedByUser<>@SecondApprovalByUser and @UserID<>@SecondApprovalByUser and @CurrentWFStatusMasterID=4 and @amount<=@AmountTobeCheckForPrimaryAM)
						SET @IsShowApprover=1
					ELSE
			           SET @IsShowApprover=0
			END
			
			IF (@IsShowApprover=1)
			BEGIN
					 IF NOT EXISTS(
					  SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID 
					  where (l.Name = 'Tier 2 Approval' or l.Name = 'Tier 1 Approval')
											and u.UserID = @UserID)
						BEGIN
						      SET @IsOnlyPrimaryUser=1
						END
					--if L2
					IF EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 2 Approval'
											and u.UserID = @UserID AND  @CurrentWFStatusMasterID=3 and @IsREODeal=0)
										  BEGIN
											 SET @CurrentWFStatusPurposeMappingID+=1
											SET @isShowCompleted = 1
											SET @OrderIndexCount = 10
										  END
			
			
					ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 2 Approval'
						and u.UserID = @UserID  AND @CurrentWFStatusMasterID=4) and @UserID<>@SecondApprovalByUser)
						BEGIN
							set @IsShowApprover=1
					
						END

					ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 1 Approval'
											and u.UserID = @UserID AND (@amount<=@AmountTobeCheck) AND @CurrentWFStatusMasterID=3 ) and @IsREODeal=0)
						BEGIN
							set @CurrentWFStatusPurposeMappingID+=1
							SET @isShowCompleted = 1
							SET @OrderIndexCount = 10
						END
					ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 1 Approval'
										and u.UserID = @UserID AND (@amount<=@AmountTobeCheck) AND @CurrentWFStatusMasterID=4) and @UserID<>@SecondApprovalByUser)
					BEGIN
						set @IsShowApprover=1
					END
					ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 1 Approval'
						and u.UserID = @UserID AND (@amount>@AmountTobeCheck) AND @CurrentWFStatusMasterID=4))
						BEGIN
							set @IsShowApprover=0
					
						END
					ELSE IF (EXISTS( select 1 from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID join App.[Role] r on um.RoleID=r.RoleID where r.RoleName = 'Asset Manager'
										 and u.UserId = @UserID AND @CurrentWFStatusMasterID=3 and @UserID=@ReviewCompletedByUser))
						BEGIN
							set @IsShowApprover=0
					
						END

					ELSE IF (EXISTS( select 1 from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID join App.[Role] r on um.RoleID=r.RoleID where r.RoleName = 'Asset Manager'
										 and u.UserId = @UserID AND @CurrentWFStatusMasterID=4 and @UserID=@SecondApprovalByUser))
						BEGIN
							set @IsShowApprover=0
					
						END
					ELSE IF EXISTS(SELECT u.UserID FROM [CRE].DealReserveSchedule df
							INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
							INNER JOIN app.[User] u ON u.UserID = d.AMTeamLeadUserID
							WHERE df.DealReserveScheduleGUID = @TaskID
							AND  convert(varchar(MAX),u.UserId) = @UserID
							AND @CurrentWFStatusMasterID=3 and @amount<=@AmountTobeCheckForPrimaryAM and @IsOnlyPrimaryUser=1)
							BEGIN
								-- if funding teams approval required = No than only display final approval otherwise deiplay second approval
								if (@CheckListStatus<>499)
								BEGIN
									SET @CurrentWFStatusPurposeMappingID+=1
									SET @isShowCompleted = 1
									SET @OrderIndexCount = 10
								END
								ELSE
								BEGIN
									SET @IsShowApprover=1
								END
							END
					ELSE IF EXISTS(SELECT u.UserID FROM [CRE].DealReserveSchedule df
							INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
							INNER JOIN app.[User] u ON u.UserID = d.AMTeamLeadUserID
							WHERE df.DealReserveScheduleGUID = @TaskID
							AND  convert(varchar(MAX),u.UserId) = @UserID
							AND @CurrentWFStatusMasterID=4 and @amount<=@AmountTobeCheckForPrimaryAM)
							BEGIN
									set @IsShowApprover=1
							END
			
					ELSE
						BEGIN
						set @IsShowApprover=1
					END
			END
		
		END

		ELSE --if review complated by non primary AM
		BEGIN
	        
			IF (@ReviewCompletedByUser=@UserID OR EXISTS(SELECT u.UserID FROM [CRE].DealReserveSchedule df
							INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
							INNER JOIN app.[User] u ON u.UserID = d.AMTeamLeadUserID
							WHERE df.DealReserveScheduleGUID = @TaskID
							AND  convert(varchar(MAX),u.UserId) = @UserID))
			BEGIN
						--allow only if 1st approval and 2nd approval is done by different user
						IF (@SecondApprovalByUser is null)
						   SET @IsShowApprover=1
						ELSE IF(@ReviewCompletedByUser<>@SecondApprovalByUser and @UserID<>@SecondApprovalByUser and @CurrentWFStatusMasterID=4)
							SET @IsShowApprover=1
						ELSE
							SET @IsShowApprover=0
			END
			
			IF (@IsShowApprover=1)
			BEGIN  
					  --if log in user in deal specific primary AM or deal specific team lead
					  IF (EXISTS(SELECT u.UserID FROM [CRE].DealReserveSchedule df
												INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
												INNER JOIN app.[User] u ON u.UserID = d.AMUserID
												 WHERE df.DealReserveScheduleGUID = @TaskID
												 AND  convert(varchar(MAX),u.UserId) = @UserID)
						OR EXISTS(SELECT u.UserID FROM [CRE].DealReserveSchedule df
							INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
							INNER JOIN app.[User] u ON u.UserID = d.AMTeamLeadUserID
							WHERE df.DealReserveScheduleGUID = @TaskID
							AND  convert(varchar(MAX),u.UserId) = @UserID)
					 )
					BEGIN
					
					  --check if user is only primary or teamlead and not t1 and t2 
					  IF NOT EXISTS(
					  SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID 
					  where (l.Name = 'Tier 2 Approval' or l.Name = 'Tier 1 Approval')
											and u.UserID = @UserID)
						BEGIN
						      SET @IsOnlyPrimaryUser=1
						END 								
														 
					  
					  
					  IF (@amount<=@AmountTobeCheckForPrimaryAM and @CurrentWFStatusMasterID=3 and @IsREODeal=0 and @IsOnlyPrimaryUser=1)
						BEGIN
					
							-- if funding teams approval required = No than only display final approval otherwise deiplay second approval
								if (@CheckListStatus<>499)
								BEGIN
									SET @CurrentWFStatusPurposeMappingID+=1
									SET @isShowCompleted = 1
									SET @OrderIndexCount = 10
								END
								ELSE
								BEGIN
									SET @IsShowApprover=1
								END
						END
						ELSE IF (@amount<=@AmountTobeCheckForPrimaryAM and @CurrentWFStatusMasterID=4)
						BEGIN
							set @IsShowApprover=1
						END
						--if tier 2 he can approval any amount
						--if L2
						ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 2 Approval'
											and u.UserID = @UserID AND @CurrentWFStatusMasterID=3) and @IsREODeal=0)
										  BEGIN
									 
											 SET @CurrentWFStatusPurposeMappingID+=1
											SET @isShowCompleted = 1
											SET @OrderIndexCount = 10
										  END
				
						ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 2 Approval'
						and u.UserID = @UserID  AND @CurrentWFStatusMasterID=4) and @UserID<>@SecondApprovalByUser)
						BEGIN
							set @IsShowApprover=1
					
						END
						--if funding amount < 5 milion and tier 1, he can approve
						ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 1 Approval'
											and u.UserID = @UserID AND (@amount<=@AmountTobeCheck) AND @CurrentWFStatusMasterID=3) and @IsREODeal=0)
						BEGIN
							set @CurrentWFStatusPurposeMappingID+=1
							SET @isShowCompleted = 1
							SET @OrderIndexCount = 10
						END
						ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 1 Approval'
											and u.UserID = @UserID AND (@amount<=@AmountTobeCheck) AND @CurrentWFStatusMasterID=4) and @UserID<>@SecondApprovalByUser)
						BEGIN
							set @IsShowApprover=1
						END

						--if funding amount > 5 milion,status-1st approval and tier 1, he can do 2nd approval
						ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 1 Approval'
											and u.UserID = @UserID AND (@amount>@AmountTobeCheck) AND @CurrentWFStatusMasterID=3))
						BEGIN
							set @IsShowApprover=1
						END
						--if funding amount > 5 milion and tier 1 he can not approve
						ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 1 Approval'
						and u.UserID = @UserID AND (@amount>@AmountTobeCheck) AND @CurrentWFStatusMasterID=4))
						BEGIN
							set @IsShowApprover=0
					
						END
						ELSE IF (EXISTS( select 1 from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID join App.[Role] r on um.RoleID=r.RoleID where r.RoleName = 'Asset Manager'
										 and u.UserId = @UserID AND @CurrentWFStatusMasterID=3 and @UserID=@ReviewCompletedByUser))
						BEGIN
							set @IsShowApprover=0
					
						END

						ELSE IF (EXISTS( select 1 from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID join App.[Role] r on um.RoleID=r.RoleID where r.RoleName = 'Asset Manager'
										 and u.UserId = @UserID AND @CurrentWFStatusMasterID=4 and @UserID=@SecondApprovalByUser))
						BEGIN
							set @IsShowApprover=0
					
						END
				
						ELSE IF (EXISTS( select 1 from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID join App.[Role] r on um.RoleID=r.RoleID where r.RoleName = 'Asset Manager'
										 and u.UserId = @UserID AND @CurrentWFStatusMasterID=3))
						BEGIN
							set @IsShowApprover=1
					
						END
						ELSE
						 BEGIN
							set @IsShowApprover=0
						END
					END
					ELSE
					BEGIN
					--if tier 2 he can approval any amount
				
						IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 2 Approval'
											and u.UserID = @UserID AND @CurrentWFStatusMasterID=3) and @IsREODeal=0)
										  BEGIN
									 
											 SET @CurrentWFStatusPurposeMappingID+=1
											SET @isShowCompleted = 1
											SET @OrderIndexCount = 10
										  END
				
				
						ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 2 Approval'
						and u.UserID = @UserID  AND @CurrentWFStatusMasterID=4) and @UserID<>@SecondApprovalByUser)
						BEGIN
							set @IsShowApprover=1
				
						END
						--if funding amount < 5 milion and tier 1, he can approve
						ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 1 Approval'
											and u.UserID = @UserID AND (@amount<=@AmountTobeCheck) AND @CurrentWFStatusMasterID=3) and @IsREODeal=0)
						BEGIN
							set @CurrentWFStatusPurposeMappingID+=1
							SET @isShowCompleted = 1
							SET @OrderIndexCount = 10
						END
						ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 1 Approval'
											and u.UserID = @UserID AND (@amount<=@AmountTobeCheck) AND @CurrentWFStatusMasterID=4) and @UserID<>@SecondApprovalByUser) 
						BEGIN
							set @IsShowApprover=1
							
						END
						--if funding amount > 5 milion,status-1st approval and tier 1, he can do 2nd approval
						ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 1 Approval'
											and u.UserID = @UserID AND (@amount>@AmountTobeCheck) AND @CurrentWFStatusMasterID=3))
						BEGIN
							set @IsShowApprover=1
						END
						ELSE IF (EXISTS(SELECT 1 from App.[User] u join App.EmailNotification e on u.Email = e.EmailId join Core.Lookup l on e.ModuleId = l.LookupID where l.Name = 'Tier 1 Approval'
						and u.UserID = @UserID AND (@amount>@AmountTobeCheck) AND @CurrentWFStatusMasterID=4))
						BEGIN
							set @IsShowApprover=0
					
						END
						ELSE IF (EXISTS( select 1 from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID join App.[Role] r on um.RoleID=r.RoleID where r.RoleName = 'Asset Manager'
										 and u.UserId = @UserID AND @CurrentWFStatusMasterID=3 and @UserID=@ReviewCompletedByUser))
						BEGIN
							set @IsShowApprover=0
					
						END

						ELSE IF (EXISTS( select 1 from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID join App.[Role] r on um.RoleID=r.RoleID where r.RoleName = 'Asset Manager'
										 and u.UserId = @UserID AND @CurrentWFStatusMasterID=4 and @UserID=@SecondApprovalByUser))
						BEGIN
							set @IsShowApprover=0
					
						END
						ELSE IF (EXISTS( select 1 from App.[User] u join App.[UserRoleMap] um on u.UserID=um.UserID join App.[Role] r on um.RoleID=r.RoleID where r.RoleName = 'Asset Manager'
										 and u.UserId = @UserID AND @CurrentWFStatusMasterID=3))
						BEGIN
							set @IsShowApprover=1
					
						END
						ELSE
						 BEGIN
							set @IsShowApprover=0
						END

					END
			END
		END
	END
	 
	
	select  @CurrentWFStatusMasterID =(Select WFStatusmasterID from cre.WFStatusPurposeMapping where WFStatusPurposeMappingID = @CurrentWFStatusPurposeMappingID)
	
	select  @CurrentPurposeTypeId = (Select PurposeTypeId from cre.WFStatusPurposeMapping where WFStatusPurposeMappingID = @CurrentWFStatusPurposeMappingID )
	Select 
	td.WFTaskDetailID,
	td.TaskID,
	td.TaskTypeID,
	td.SubmitType,
	'' as Comment,
	--td.Comment,
	(case when @isShowCompleted = 1 then @CurrentWFStatusPurposeMappingID else td.WFStatusPurposeMappingID end) as WFStatusPurposeMappingID,
	
	mapp.PurposeTypeId,
	mapp.OrderIndex,
	(case when @isShowCompleted = 1 then @CurrentWFStatusMasterID else mapp.WFStatusMasterID end) as WFStatusMasterID
	,

	--(Case
	--When (Select count(WFCheckListDetailID) from cre.WFCheckListDetail where TaskId = @TaskID and (CheckListStatus = (Select Lookupid from core.lookup where parentid = 78 and [name] = 'No') or CheckListStatus is null)) > 0 
	--then sm.StatusName + ' (Partial)' 
	--Else sm.StatusName END
	--)StatusName,
	sm.StatusName,
	StatusDisplayName =(CASE WHEN lPurposeType.Value1 = 'WF_UNDERREVIEW' THEN sm.WFUnderReviewDisplayName else sm.StatusDisplayName end),
	--(Case
	--When (Select count(WFCheckListDetailID) from cre.WFCheckListDetail where TaskId = @TaskID and (CheckListStatus = (Select Lookupid from core.lookup where parentid = 78 and [name] = 'No') or CheckListStatus is null)) > 0 
	--then sm.StatusDisplayName + ' (Partial)' 
	--Else sm.StatusDisplayName END
	--)StatusDisplayName,

	lTaskTypeID.name as TaskTypeIDText,
	lSubmitType.name as SubmitTypeText,

	tblnextstastus.NextWFStatusPurposeMappingID,
	tblnextstastus.NextWFStatusMasterID,
	tblnextstastus.NextStatusName,
	tblnextstastus.NextOrderIndex,
	--(case 
	--	when (Select COUNT(OrderIndex) from cre.WFStatusPurposeMapping where PurposeTypeId = mapp.PurposeTypeId and OrderIndex > (case when @amount<=1000000 then mapp.OrderIndex+10 else mapp.OrderIndex end) ) = 1 then 'FinalState' 
	--	when (Select COUNT(OrderIndex) from cre.WFStatusPurposeMapping where PurposeTypeId = mapp.PurposeTypeId and OrderIndex >(case when @amount<=1000000 then mapp.OrderIndex+10 else mapp.OrderIndex end) ) = 0 then 'Complete' 
	--	else 'InProcess' end
	--) as wfFlag,
	(case 
		when (Select COUNT(OrderIndex) from cre.WFStatusPurposeMapping where PurposeTypeId = mapp.PurposeTypeId and OrderIndex > (case when @isShowCompleted = 1 then mapp.OrderIndex+@OrderIndexCount else mapp.OrderIndex end)) = 1 then 'FinalState' 
		when (Select COUNT(OrderIndex) from cre.WFStatusPurposeMapping where PurposeTypeId = mapp.PurposeTypeId and OrderIndex >(case when @isShowCompleted = 1 then mapp.OrderIndex+@OrderIndexCount else mapp.OrderIndex end)) = 0 then 'Complete' 
		else 'InProcess' end
	) as wfFlag,
	--wf_isAllow =(case when @ReviewCompletedByUser = @UserID then 0 when (@FirstDealFundingID = @TaskID and @IsApprovalL3=0 and @CurrentWFStatusMasterID=3) then 0 when @IsShowApprover=0 then 0 else
	--[dbo].[Fn_GetGetWorkflowAccessPermissionByTaskAndUserID](td.TaskID,@UserID,'all') end)
	[dbo].[Fn_GetGetWorkflowAccessPermissionByTaskAndUserID](@TaskTypeID,td.TaskID,@UserID,'all',@ReviewCompletedByUser,@FirstDealFundingID,@IsApprovalL3,@CurrentWFStatusMasterID,@IsShowApprover) as wf_isAllow
	,tblnextstastus.NextStatusDisplayName,
	wf_isAllowReject = [dbo].[Fn_GetGetWorkflowAccessPermissionByTaskAndUserID](@TaskTypeID,td.TaskID,@UserID,'Reject',null,null,null,null,null),
	lPurposeType.Value1 as WorkFlowType,
	@IsDisableFundingTeamApproval as IsDisableFundingTeamApproval,
	@IsOnlyPrimaryUser as IsOnlyPrimaryUser
	from cre.WFTaskDetail td
	left join cre.WFStatusPurposeMapping mapp on mapp.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
	left join cre.WFStatusMaster sm on sm.WFStatusMasterID = mapp.WFStatusMasterID
	left join core.Lookup lTaskTypeID on lTaskTypeID.LookupID = td.TaskTypeID and lTaskTypeID.ParentID = 27
	left join core.Lookup lSubmitType on lSubmitType.LookupID = td.SubmitType and lSubmitType.ParentID = 77
	
	left join
	(
		Select top 1 PurposeTypeId,mapp1.WFStatusPurposeMappingID as NextWFStatusPurposeMappingID,mapp1.WFStatusMasterID as NextWFStatusMasterID,sm.StatusName as NextStatusName,mapp1.OrderIndex as NextOrderIndex,
		NextStatusDisplayName =(case when (select Value1 FROM Core.Lookup where LookUpID=@CurrentPurposeTypeId)='WF_UNDERREVIEW' THEN sm.WFUnderReviewDisplayName else sm.StatusDisplayName end)
		from cre.WFStatusPurposeMapping mapp1
		inner join cre.WFStatusMaster sm on sm.WFStatusMasterID = mapp1.WFStatusMasterID
		where WFStatusPurposeMappingID > @CurrentWFStatusPurposeMappingID and PurposeTypeId = @CurrentPurposeTypeId
		order by OrderIndex

	)tblnextstastus on tblnextstastus.PurposeTypeId = mapp.PurposeTypeId
	join cre.DealReserveSchedule df on df.DealReserveScheduleGUID =td.TaskID
	left join core.Lookup lPurposeType on lPurposeType.LookupID = df.PurposeID and lPurposeType.ParentID = 119
	join cre.Deal d on d.DealID = df.DealID
	Where td.WFTaskDetailID = @Max_WFTaskDetailID
	and td.IsDeleted=0

	END
	
END





