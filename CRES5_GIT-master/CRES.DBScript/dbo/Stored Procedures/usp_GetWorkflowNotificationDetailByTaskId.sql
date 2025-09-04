-- Procedure



--EXEC [dbo].[usp_GetWorkflowNotificationDetailByTaskId]  '76505995-2448-4E87-B1A2-08D4BD223463',  502 ,'3bbeac70-f8a0-49ee-906d-1e4d40cd16e7'


CREATE PROCEDURE [dbo].[usp_GetWorkflowNotificationDetailByTaskId] 
(
    @ObjectID varchar(5000),
	@ObjectTypeId INT,	
	@UserID nvarchar(256)
)
	
AS
BEGIN
	SET NOCOUNT ON;

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
		 DECLARE @TaskID varchar(5000) 

		 DECLARE @FundingDate DATETIME
		 DECLARE @FundingAmount  Decimal
		 DECLARE @DealLine DATETIME

		 DECLARE @EmailNotification Table(
		 UserID UNIQUEIDENTIFIER,
		 Email varchar(5000),
		 UserName varchar(256),
		 DealID UNIQUEIDENTIFIER,
		 DealName varchar(5000), 
		 NextStatusName varchar(256),
		 TaskID varchar(256),
		 FundingDate DATE, 
		 FundingAmount decimal(28,15), 
		 DealLine DATE
		 )
		 DECLARE 
		 @tDealID UNIQUEIDENTIFIER,
		 @tDealName varchar(5000), 
		 @tNextStatusName varchar(256),
		 @tFundingDate DATE, 
		 @tFundingAmount decimal(28,15), 
		 @tDealLine DATE,
		 @IsREODeal bit=0,
		 @AllowWFInternalNotification nvarchar(10)=(select [Value] from app.AppConfig WHERE [key]='AllowWFInternalNotification')

	IF(@ObjectTypeId = 283) -- Deal
	BEGIN
	  

	  SET @TaskID =  (SELECT TOP 1 TaskID FROM [CRE].[WFTaskDetail] wtd
	  INNER JOIN CRE.DealFunding df ON df.DealFundingID = wtd.TaskID AND df.DealFundingID IN 
	  (
	      SELECT df.DealFundingID FROM CRE.DealFunding df
	     WHERE df.DealID = @ObjectID
	  )
	  GROUP BY TaskID 
	  HAVING COUNT(TaskID) = 1)

	   SET @Max_WFTaskDetailID = (Select MAX(WFTaskDetailID) from cre.WFTaskDetail where TaskID = @TaskID)
	   SET @CurrentWFStatusPurposeMappingID = (Select WFStatusPurposeMappingID from cre.WFTaskDetail where TaskID = @TaskID and WFTaskDetailID = @Max_WFTaskDetailID)
	   SET @CurrentPurposeTypeId = (Select PurposeTypeId from cre.WFStatusPurposeMapping where WFStatusPurposeMappingID = @CurrentWFStatusPurposeMappingID )
		 
      	SET @WF_CurrentStatus = (SELECT (SELECT TOP 1 sm.StatusName FROM [CRE].[WFTaskDetail] td 
				INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
				INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
				WHERE TaskId = @TaskID 
				ORDER BY WFTaskDetailID DESC ) ) --as WF_CurrentStatus;

		SET @NextStatusName = ( Select top 1 sm.StatusDisplayName as NextStatusName
				    -- ,PurposeTypeId,mapp1.WFStatusPurposeMappingID as NextWFStatusPurposeMappingID,mapp1.WFStatusMasterID as NextWFStatusMasterID,mapp1.OrderIndex as NextOrderIndex 
				from [CRE].[WFTaskDetail] td 
				INNER JOIN cre.WFStatusPurposeMapping mapp1 on mapp1.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID 
				inner join cre.WFStatusMaster sm on sm.WFStatusMasterID = mapp1.WFStatusMasterID
				where td.WFStatusPurposeMappingID > @CurrentWFStatusPurposeMappingID and PurposeTypeId = @CurrentPurposeTypeId
				order by OrderIndex )

		SELECT @DealID = d.DealID, @DealName = d.DealName  FROM CRE.Deal d
		WHERE d.DealID = @ObjectID

		
/*
        IF(@WF_CurrentStatus = 'Projected')
				 BEGIN
				       
					   SELECT u.UserID, u.Email, u.FirstName +'  '+ u.LastName as UserName, d.DealID, d.DealName, @NextStatusName as NextStatusName, TaskID, df.Date AS FundingDate, df.Amount AS FundingAmount , df.DeadLineDate AS DealLine FROM [CRE].[WFTaskDetail] wtd
						  INNER JOIN CRE.DealFunding df ON df.DealFundingID = wtd.TaskID AND df.DealFundingID IN 
						  (
							  SELECT df.DealFundingID FROM CRE.DealFunding df
							 WHERE df.DealID = @ObjectID
						  )
						  LEFT JOIN CRE.Deal d ON d.DealID = df.DealID
						  LEFT JOIN app.[User] u ON u.UserID = d.AMSecondUserID 						 
						  WHERE wtd.UpdatedDate = wtd.CreatedDate
						  GROUP BY TaskID, u.UserID, u.Email, u.FirstName , u.LastName , df.Date , df.Amount, d.DealID, d.DealName,df.DeadLineDate
						  HAVING COUNT(TaskID) = 1	;				     
									
												
					-- update updatedDate field	for check Notification send related task
					UPDATE [CRE].[WFTaskDetail] SET UpdatedDate = GETDATE() 
					WHERE
					 TaskID IN 
					 (SELECT TaskID FROM [CRE].[WFTaskDetail] wtd
					  INNER JOIN CRE.DealFunding df ON df.DealFundingID = wtd.TaskID AND df.DealFundingID IN 
					  (
						  SELECT df.DealFundingID FROM CRE.DealFunding df
						 WHERE df.DealID = @ObjectID
					  )					 
					  GROUP BY TaskID 
					  HAVING COUNT(TaskID) = 1)
					 


		END 
		 */
	END
	
--SELECT * FROm core.Lookup WHERE ParentID =27 Name = 'Deal'
 ELSE IF(@ObjectTypeId = 502) -- Deal Funding
	BEGIN
	   --Enable/Disbale wf notification based on app.AppConfig flage
	   if (@AllowWFInternalNotification='1') 
	   BEGIN
		   SET @TaskID = @ObjectID

		   IF EXISTS(Select TaskID from cre.WFTaskDetail where TaskID = @TaskID and TaskTypeID=@ObjectTypeId)
	BEGIN
	    


		 SET @Max_WFTaskDetailID = (Select MAX(WFTaskDetailID) from cre.WFTaskDetail where TaskID = @TaskID and TaskTypeID=@ObjectTypeId)
	     SET @CurrentWFStatusPurposeMappingID = (Select WFStatusPurposeMappingID from cre.WFTaskDetail where TaskID = @TaskID and TaskTypeID=@ObjectTypeId and WFTaskDetailID = @Max_WFTaskDetailID)
	     SET @CurrentPurposeTypeId = (Select PurposeTypeId from cre.WFStatusPurposeMapping where WFStatusPurposeMappingID = @CurrentWFStatusPurposeMappingID )
		 

			SET @WF_IsCompleted = (SELECT ISNULL
			( (
			SELECT TOP 1 1 FROM [CRE].[WFTaskDetail] td 
			INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
			INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
			WHERE TaskId = @TaskID  and TaskTypeID=@ObjectTypeId and spm.OrderIndex = (
			 SELECT MAX(OrderIndex) FROm [CRE].[WFStatusPurposeMapping] WHERE PurposetypeId = spm.PurposeTypeId 
			) ORDER BY WFTaskDetailID DESC )
			,0 )) --AS WF_IsCompleted


	     SET @WF_IsFlowStart =  (SELECT CASE WHEN (SELECT MIN(OrderIndex) FROm [CRE].[WFStatusPurposeMapping] WHERE PurposetypeId = @CurrentPurposeTypeId) !=
			 (SELECT TOP 1 spm.OrderIndex  FROM [CRE].[WFTaskDetail] td 
			INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
			INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
			WHERE TaskId =  @TaskID and TaskTypeID=@ObjectTypeId
			ORDER BY WFTaskDetailID DESC
			)
			THEN 1 ELSE 0 END
			) --AS WF_IsFlowStart


			IF(@WF_IsFlowStart = 1 and @WF_IsCompleted = 0)
			 BEGIN
			      PRINT 1
				SET @WF_CurrentStatus = (SELECT (SELECT TOP 1 sm.StatusName FROM [CRE].[WFTaskDetail] td 
				INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
				INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
				WHERE TaskId = @TaskID and TaskTypeID=@ObjectTypeId
				ORDER BY WFTaskDetailID DESC ) ) --as WF_CurrentStatus;

				SET @NextStatusName = ( Select top 1 sm.StatusDisplayName as NextStatusName
				    -- ,PurposeTypeId,mapp1.WFStatusPurposeMappingID as NextWFStatusPurposeMappingID,mapp1.WFStatusMasterID as NextWFStatusMasterID,mapp1.OrderIndex as NextOrderIndex 
				from [CRE].[WFTaskDetail] td 
				INNER JOIN cre.WFStatusPurposeMapping mapp1 on mapp1.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID 
				inner join cre.WFStatusMaster sm on sm.WFStatusMasterID = mapp1.WFStatusMasterID
				where td.WFStatusPurposeMappingID > @CurrentWFStatusPurposeMappingID and PurposeTypeId = @CurrentPurposeTypeId
				order by OrderIndex )

				
				--no need to send email on create new deal funding 
				--IF(@WF_CurrentStatus = 'Projected')
				-- BEGIN
				--       SELECT u.UserID, u.Email, u.FirstName +'  '+ u.LastName as UserName, d.DealID, d.DealName, @NextStatusName as NextStatusName, @TaskID as TaskID, df.Date AS FundingDate, df.Amount AS FundingAmount , df.DeadLineDate AS DealLine FROM [CRE].[DealFunding] df
				--		INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
				--		INNER JOIN app.[User] u ON u.UserID = d.AMSecondUserID
				--		 WHERE df.DealFundingID = @TaskID
						
				-- END 
				-- ELSE 

				 /*
				 IF(@WF_CurrentStatus = 'Requested')
				 BEGIN
				       SELECT DISTINCT u.UserID, u.Email, u.FirstName +'  '+ u.LastName as UserName, d.DealID, d.DealName, @NextStatusName as NextStatusName, @TaskID as TaskID, df.Date AS FundingDate, df.Amount AS FundingAmount , df.DeadLineDate AS DealLine FROM [CRE].[DealFunding] df
						JOIN  CRE.Deal d ON d.DealID = df.DealID
						join
						( 
						SELECT AMUserID UserID,df.DealFundingID FROM [CRE].[Deal] d
						JOIN  CRE.DealFunding df ON df.DealID = d.DealID
						WHERE df.DealFundingID = @TaskID
						UNION
						SELECT AMSecondUserID UserID,df.DealFundingID FROM [CRE].[Deal] d
						JOIN  CRE.DealFunding df ON df.DealID = d.DealID
						WHERE df.DealFundingID = @TaskID
						UNION
						SELECT AMTeamLeadUserID UserID,df.DealFundingID FROM [CRE].[Deal] d
						JOIN  CRE.DealFunding df ON df.DealID = d.DealID
						WHERE df.DealFundingID = @TaskID
						UNION
						select us.UserID,@TaskID DealFundingID from App.EmailNotification e join App.[User] us on us.Email =e.Emailid where ModuleId=552
						) tbluser on tbluser.DealFundingID =df.DealFundingID
						join App.[User] u on u.UserID=tbluser.UserID
						WHERE df.DealFundingID = @TaskID
						AND u.UserID<>@UserID
						
				 END 
				 ELSE */
				 IF(@WF_CurrentStatus ='1st Approval')
				   BEGIN
				        INSERT INTO @EmailNotification
						SELECT DISTINCT u.UserID, u.Email, u.FirstName +'  '+ u.LastName as UserName, d.DealID, d.DealName, @NextStatusName as NextStatusName, @TaskID as TaskID, df.Date AS FundingDate, df.Amount AS FundingAmount , df.DeadLineDate AS DealLine FROM [CRE].[DealFunding] df
						JOIN  CRE.Deal d ON d.DealID = df.DealID
						join
						( 
						SELECT AMUserID UserID,df.DealFundingID FROM [CRE].[Deal] d
						JOIN  CRE.DealFunding df ON df.DealID = d.DealID
						WHERE df.DealFundingID = @TaskID
						UNION
						SELECT AMSecondUserID UserID,df.DealFundingID FROM [CRE].[Deal] d
						JOIN  CRE.DealFunding df ON df.DealID = d.DealID
						WHERE df.DealFundingID = @TaskID
						UNION
						SELECT AMTeamLeadUserID UserID,df.DealFundingID FROM [CRE].[Deal] d
						JOIN  CRE.DealFunding df ON df.DealID = d.DealID
						WHERE df.DealFundingID = @TaskID
						UNION
						SELECT AlternateAssetManager2ID UserID,df.DealFundingID FROM [CRE].[Deal] d
						JOIN  CRE.DealFunding df ON df.DealID = d.DealID
						WHERE df.DealFundingID = @TaskID
						UNION
						SELECT AlternateAssetManager3ID UserID,df.DealFundingID FROM [CRE].[Deal] d
						JOIN  CRE.DealFunding df ON df.DealID = d.DealID
						WHERE df.DealFundingID = @TaskID
						--UNION
						--select us.UserID,@TaskID DealFundingID from App.EmailNotification e join App.[User] us on us.Email =e.Emailid where ModuleId=552
						) tbluser on tbluser.DealFundingID =df.DealFundingID
						join App.[User] u on u.UserID=tbluser.UserID
						WHERE df.DealFundingID = @TaskID
						AND u.UserID<>@UserID
						
						--select top 1 @tDealID=DealID,@tDealName = DealName,@tNextStatusName =NextStatusName,
						--@tFundingDate = FundingDate,@tFundingAmount=FundingAmount,@tDealLine=DealLine from @EmailNotification


						select top 1 @tDealID=d1.DealID,@tDealName = d1.DealName,@tNextStatusName =@NextStatusName,
						@tFundingDate = df1.Date,@tFundingAmount=df1.Amount,@tDealLine=df1.DeadLineDate  FROM [CRE].[DealFunding] df1
						JOIN  CRE.Deal d1 ON d1.DealID = df1.DealID
						WHERE df1.dealfundingID=@TaskID
						
						select UserID,Email,UserName,DealID,DealName,NextStatusName,TaskID,FundingDate,FundingAmount,DealLine,0 as WorkflowUserTypeID
						from @EmailNotification
						union
						(
						select us.UserID,us.Email,us.FirstName +'  '+ us.LastName as UserName,@tDealID,@tDealName,@tNextStatusName,@TaskID,@tFundingDate,
						@tFundingAmount,@tDealLine,564 as WorkflowUserTypeID from App.EmailNotification e join App.[User] us on us.Email =e.Emailid where ModuleId=564
						and us.UserID NOT IN(select UserID from @EmailNotification) and us.UserID<>@UserID
						)
						union
						select '00000000-0000-0000-0000-000000000000' as UserID ,EmailId,'' as UserName ,@tDealID,@tDealName,@tNextStatusName,@TaskID,@tFundingDate,
						@tFundingAmount,@tDealLine,0 as WorkflowUserTypeID from App.EmailNotification where ModuleId=614
						union
						select UserID ,us.Email,us.FirstName +'  '+ us.LastName as UserName ,@tDealID,@tDealName,@tNextStatusName,@TaskID,@tFundingDate,
						@tFundingAmount,@tDealLine,0 as WorkflowUserTypeID from App.[User] us where [UserID]=@UserID

						 
				   END
				 ELSE IF(@WF_CurrentStatus ='2nd Approval')
				   BEGIN

				       INSERT INTO @EmailNotification
						SELECT DISTINCT u.UserID, u.Email, u.FirstName +'  '+ u.LastName as UserName, d.DealID, d.DealName, @NextStatusName as NextStatusName, @TaskID as TaskID, df.Date AS FundingDate, df.Amount AS FundingAmount , df.DeadLineDate AS DealLine FROM [CRE].[DealFunding] df
						JOIN  CRE.Deal d ON d.DealID = df.DealID
						join
						( 
						SELECT AMUserID UserID,df.DealFundingID FROM [CRE].[Deal] d
						JOIN  CRE.DealFunding df ON df.DealID = d.DealID
						WHERE df.DealFundingID = @TaskID
						UNION
						SELECT AMSecondUserID UserID,df.DealFundingID FROM [CRE].[Deal] d
						JOIN  CRE.DealFunding df ON df.DealID = d.DealID
						WHERE df.DealFundingID = @TaskID
						UNION
						SELECT AMTeamLeadUserID UserID,df.DealFundingID FROM [CRE].[Deal] d
						JOIN  CRE.DealFunding df ON df.DealID = d.DealID
						WHERE df.DealFundingID = @TaskID
						UNION
						SELECT AlternateAssetManager2ID UserID,df.DealFundingID FROM [CRE].[Deal] d
						JOIN  CRE.DealFunding df ON df.DealID = d.DealID
						WHERE df.DealFundingID = @TaskID
						UNION
						SELECT AlternateAssetManager3ID UserID,df.DealFundingID FROM [CRE].[Deal] d
						JOIN  CRE.DealFunding df ON df.DealID = d.DealID
						WHERE df.DealFundingID = @TaskID
						--UNION
						--select us.UserID,@TaskID DealFundingID from App.EmailNotification e join App.[User] us on us.Email =e.Emailid where ModuleId=552
						) tbluser on tbluser.DealFundingID =df.DealFundingID
						join App.[User] u on u.UserID=tbluser.UserID
						WHERE df.DealFundingID = @TaskID
						AND u.UserID<>@UserID
						
						--select top 1 @tDealID=DealID,@tDealName = DealName,@tNextStatusName =NextStatusName,
						--@tFundingDate = FundingDate,@tFundingAmount=FundingAmount,@tDealLine=DealLine from @EmailNotification

						select top 1 @tDealID=d1.DealID,@tDealName = d1.DealName,@tNextStatusName =@NextStatusName,
						@tFundingDate = df1.Date,@tFundingAmount=df1.Amount,@tDealLine=df1.DeadLineDate  FROM [CRE].[DealFunding] df1
						JOIN  CRE.Deal d1 ON d1.DealID = df1.DealID
						WHERE df1.dealfundingID=@TaskID
						
						select UserID,Email,UserName,DealID,DealName,NextStatusName,TaskID,FundingDate,FundingAmount,DealLine,0 as WorkflowUserTypeID
						from @EmailNotification
						union
						(
						select us.UserID,us.Email,us.FirstName +'  '+ us.LastName as UserName,@tDealID,@tDealName,@tNextStatusName,@TaskID,@tFundingDate,
						@tFundingAmount,@tDealLine,564 as WorkflowUserTypeID from App.EmailNotification e join App.[User] us on us.Email =e.Emailid where ModuleId=564
						and us.UserID NOT IN(select UserID from @EmailNotification) and us.UserID<>@UserID
						)
						--Email to AM fundting team
						union
						select '00000000-0000-0000-0000-000000000000' as UserID ,EmailId,'' as UserName ,@tDealID,@tDealName,@tNextStatusName,@TaskID,@tFundingDate,
						@tFundingAmount,@tDealLine,0 as WorkflowUserTypeID from App.EmailNotification where ModuleId=614
						union
						select UserID ,us.Email,us.FirstName +'  '+ us.LastName as UserName ,@tDealID,@tDealName,@tNextStatusName,@TaskID,@tFundingDate,
						@tFundingAmount,@tDealLine,0 as WorkflowUserTypeID from App.[User] us where [UserID]=@UserID


				   END
			 END
						
END
	   END
    END
ELSE IF(@ObjectTypeId = 719) -- Reserve Account
BEGIN
	   --Enable/Disbale wf notification based on app.AppConfig flage
	   if (@AllowWFInternalNotification='1') 
	   BEGIN
		   SET @TaskID = @ObjectID

		   IF EXISTS(Select TaskID from cre.WFTaskDetail where TaskID = @TaskID and TaskTypeID=@ObjectTypeId)
	BEGIN
	    


		 SET @Max_WFTaskDetailID = (Select MAX(WFTaskDetailID) from cre.WFTaskDetail where TaskID = @TaskID and TaskTypeID=@ObjectTypeId)
	     SET @CurrentWFStatusPurposeMappingID = (Select WFStatusPurposeMappingID from cre.WFTaskDetail where TaskID = @TaskID and TaskTypeID=@ObjectTypeId and WFTaskDetailID = @Max_WFTaskDetailID)
	     SET @CurrentPurposeTypeId = (Select PurposeTypeId from cre.WFStatusPurposeMapping where WFStatusPurposeMappingID = @CurrentWFStatusPurposeMappingID )
		 

			SET @WF_IsCompleted = (SELECT ISNULL
			( (
			SELECT TOP 1 1 FROM [CRE].[WFTaskDetail] td 
			INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
			INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
			WHERE TaskId = @TaskID  and TaskTypeID=@ObjectTypeId and spm.OrderIndex = (
			 SELECT MAX(OrderIndex) FROm [CRE].[WFStatusPurposeMapping] WHERE PurposetypeId = spm.PurposeTypeId 
			) ORDER BY WFTaskDetailID DESC )
			,0 )) --AS WF_IsCompleted


	     SET @WF_IsFlowStart =  (SELECT CASE WHEN (SELECT MIN(OrderIndex) FROm [CRE].[WFStatusPurposeMapping] WHERE PurposetypeId = @CurrentPurposeTypeId) !=
			 (SELECT TOP 1 spm.OrderIndex  FROM [CRE].[WFTaskDetail] td 
			INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
			INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
			WHERE TaskId =  @TaskID and TaskTypeID=@ObjectTypeId
			ORDER BY WFTaskDetailID DESC
			)
			THEN 1 ELSE 0 END
			) --AS WF_IsFlowStart


			IF(@WF_IsFlowStart = 1 and @WF_IsCompleted = 0)
			 BEGIN
			      PRINT 1
				SET @WF_CurrentStatus = (SELECT (SELECT TOP 1 sm.StatusName FROM [CRE].[WFTaskDetail] td 
				INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
				INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
				WHERE TaskId = @TaskID and TaskTypeID=@ObjectTypeId
				ORDER BY WFTaskDetailID DESC ) ) --as WF_CurrentStatus;

				SET @NextStatusName = ( Select top 1 sm.StatusDisplayName as NextStatusName
				    -- ,PurposeTypeId,mapp1.WFStatusPurposeMappingID as NextWFStatusPurposeMappingID,mapp1.WFStatusMasterID as NextWFStatusMasterID,mapp1.OrderIndex as NextOrderIndex 
				from [CRE].[WFTaskDetail] td 
				INNER JOIN cre.WFStatusPurposeMapping mapp1 on mapp1.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID 
				inner join cre.WFStatusMaster sm on sm.WFStatusMasterID = mapp1.WFStatusMasterID
				where td.WFStatusPurposeMappingID > @CurrentWFStatusPurposeMappingID and PurposeTypeId = @CurrentPurposeTypeId
				order by OrderIndex )

				
				--no need to send email on create new deal funding 
				--IF(@WF_CurrentStatus = 'Projected')
				-- BEGIN
				--       SELECT u.UserID, u.Email, u.FirstName +'  '+ u.LastName as UserName, d.DealID, d.DealName, @NextStatusName as NextStatusName, @TaskID as TaskID, df.Date AS FundingDate, df.Amount AS FundingAmount , df.DeadLineDate AS DealLine FROM [CRE].[DealFunding] df
				--		INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
				--		INNER JOIN app.[User] u ON u.UserID = d.AMSecondUserID
				--		 WHERE df.DealFundingID = @TaskID
						
				-- END 
				-- ELSE 

				 /*
				 IF(@WF_CurrentStatus = 'Requested')
				 BEGIN
				       SELECT DISTINCT u.UserID, u.Email, u.FirstName +'  '+ u.LastName as UserName, d.DealID, d.DealName, @NextStatusName as NextStatusName, @TaskID as TaskID, df.Date AS FundingDate, df.Amount AS FundingAmount , df.DeadLineDate AS DealLine FROM [CRE].[DealFunding] df
						JOIN  CRE.Deal d ON d.DealID = df.DealID
						join
						( 
						SELECT AMUserID UserID,df.DealFundingID FROM [CRE].[Deal] d
						JOIN  CRE.DealFunding df ON df.DealID = d.DealID
						WHERE df.DealFundingID = @TaskID
						UNION
						SELECT AMSecondUserID UserID,df.DealFundingID FROM [CRE].[Deal] d
						JOIN  CRE.DealFunding df ON df.DealID = d.DealID
						WHERE df.DealFundingID = @TaskID
						UNION
						SELECT AMTeamLeadUserID UserID,df.DealFundingID FROM [CRE].[Deal] d
						JOIN  CRE.DealFunding df ON df.DealID = d.DealID
						WHERE df.DealFundingID = @TaskID
						UNION
						select us.UserID,@TaskID DealFundingID from App.EmailNotification e join App.[User] us on us.Email =e.Emailid where ModuleId=552
						) tbluser on tbluser.DealFundingID =df.DealFundingID
						join App.[User] u on u.UserID=tbluser.UserID
						WHERE df.DealFundingID = @TaskID
						AND u.UserID<>@UserID
						
				 END 
				 ELSE */

				 select @IsREODeal=isnull(IsREODeal,0) FROM [CRE].[Deal] d
						JOIN  CRE.DealReserveSchedule df ON df.DealID = d.DealID
						WHERE df.DealReserveScheduleGUID = @TaskID
				 IF(@WF_CurrentStatus ='1st Approval')
				   BEGIN
				        INSERT INTO @EmailNotification
						SELECT DISTINCT u.UserID, u.Email, u.FirstName +'  '+ u.LastName as UserName, d.DealID, d.DealName, @NextStatusName as NextStatusName, @TaskID as TaskID, df.Date AS FundingDate, ABS(df.Amount) AS FundingAmount , null AS DealLine FROM CRE.DealReserveSchedule df
						JOIN  CRE.Deal d ON d.DealID = df.DealID
						join
						( 
						SELECT AMUserID UserID,df.DealReserveScheduleGUID FROM [CRE].[Deal] d
						JOIN  CRE.DealReserveSchedule df ON df.DealID = d.DealID
						WHERE df.DealReserveScheduleGUID = @TaskID
						UNION
						SELECT AMSecondUserID UserID,df.DealReserveScheduleGUID FROM [CRE].[Deal] d
						JOIN  CRE.DealReserveSchedule df ON df.DealID = d.DealID
						WHERE df.DealReserveScheduleGUID = @TaskID
						UNION
						SELECT AMTeamLeadUserID UserID,df.DealReserveScheduleGUID FROM [CRE].[Deal] d
						JOIN  CRE.DealReserveSchedule df ON df.DealID = d.DealID
						WHERE df.DealReserveScheduleGUID = @TaskID
						UNION
						SELECT AlternateAssetManager2ID UserID,df.DealReserveScheduleGUID FROM [CRE].[Deal] d
						JOIN  CRE.DealReserveSchedule df ON df.DealID = d.DealID
						WHERE df.DealReserveScheduleGUID = @TaskID
						UNION
						SELECT AlternateAssetManager3ID UserID,df.DealReserveScheduleGUID FROM [CRE].[Deal] d
						JOIN  CRE.DealReserveSchedule df ON df.DealID = d.DealID
						WHERE df.DealReserveScheduleGUID = @TaskID
						--UNION
						--select us.UserID,@TaskID DealFundingID from App.EmailNotification e join App.[User] us on us.Email =e.Emailid where ModuleId=552
						) tbluser on tbluser.DealReserveScheduleGUID =df.DealReserveScheduleGUID
						join App.[User] u on u.UserID=tbluser.UserID
						WHERE df.DealReserveScheduleGUID = @TaskID
						AND u.UserID<>@UserID
						
						--select top 1 @tDealID=DealID,@tDealName = DealName,@tNextStatusName =NextStatusName,
						--@tFundingDate = FundingDate,@tFundingAmount=FundingAmount,@tDealLine=DealLine from @EmailNotification


						select top 1 @tDealID=d1.DealID,@tDealName = d1.DealName,@tNextStatusName =@NextStatusName,
						@tFundingDate = df1.Date,@tFundingAmount=ABS(df1.Amount) FROM CRE.DealReserveSchedule df1
						JOIN  CRE.Deal d1 ON d1.DealID = df1.DealID
						WHERE df1.DealReserveScheduleGUID=@TaskID
						
						select UserID,Email,UserName,DealID,DealName,NextStatusName,TaskID,FundingDate,FundingAmount,DealLine,0 as WorkflowUserTypeID
						from @EmailNotification
						union
						(
						select us.UserID,us.Email,us.FirstName +'  '+ us.LastName as UserName,@tDealID,@tDealName,@tNextStatusName,@TaskID,@tFundingDate,
						@tFundingAmount,@tDealLine,564 as WorkflowUserTypeID from App.EmailNotification e join App.[User] us on us.Email =e.Emailid where ModuleId=564
						and us.UserID NOT IN(select UserID from @EmailNotification) and us.UserID<>@UserID
						)
						union
						select '00000000-0000-0000-0000-000000000000' as UserID ,EmailId,'' as UserName ,@tDealID,@tDealName,@tNextStatusName,@TaskID,@tFundingDate,
						@tFundingAmount,@tDealLine,0 as WorkflowUserTypeID from App.EmailNotification where ModuleId=614
						union
						select '00000000-0000-0000-0000-000000000000' as UserID ,EmailId,'' as UserName ,@tDealID,@tDealName,@tNextStatusName,@TaskID,@tFundingDate,
						@tFundingAmount,@tDealLine,0 as WorkflowUserTypeID from App.EmailNotification where ModuleId=720 and [Status]=1 and @IsREODeal=1
						union
						select UserID ,us.Email,us.FirstName +'  '+ us.LastName as UserName ,@tDealID,@tDealName,@tNextStatusName,@TaskID,@tFundingDate,
						@tFundingAmount,@tDealLine,0 as WorkflowUserTypeID from App.[User] us where [UserID]=@UserID
						 
				   END
				 ELSE IF(@WF_CurrentStatus ='2nd Approval')
				   BEGIN

				       INSERT INTO @EmailNotification
						SELECT DISTINCT u.UserID, u.Email, u.FirstName +'  '+ u.LastName as UserName, d.DealID, d.DealName, @NextStatusName as NextStatusName, @TaskID as TaskID, df.Date AS FundingDate, ABS(df.Amount) AS FundingAmount , null AS DealLine FROM CRE.DealReserveSchedule df
						JOIN  CRE.Deal d ON d.DealID = df.DealID
						join
						( 
						SELECT AMUserID UserID,df.DealReserveScheduleGUID FROM [CRE].[Deal] d
						JOIN  CRE.DealReserveSchedule df ON df.DealID = d.DealID
						WHERE df.DealReserveScheduleGUID = @TaskID
						UNION
						SELECT AMSecondUserID UserID,df.DealReserveScheduleGUID FROM [CRE].[Deal] d
						JOIN  CRE.DealReserveSchedule df ON df.DealID = d.DealID
						WHERE df.DealReserveScheduleGUID = @TaskID
						UNION
						SELECT AMTeamLeadUserID UserID,df.DealReserveScheduleGUID FROM [CRE].[Deal] d
						JOIN  CRE.DealReserveSchedule df ON df.DealID = d.DealID
						WHERE df.DealReserveScheduleGUID = @TaskID
						UNION
						SELECT AlternateAssetManager2ID UserID,df.DealReserveScheduleGUID FROM [CRE].[Deal] d
						JOIN  CRE.DealReserveSchedule df ON df.DealID = d.DealID
						WHERE df.DealReserveScheduleGUID = @TaskID
						UNION
						SELECT AlternateAssetManager3ID UserID,df.DealReserveScheduleGUID FROM [CRE].[Deal] d
						JOIN  CRE.DealReserveSchedule df ON df.DealID = d.DealID
						WHERE df.DealReserveScheduleGUID = @TaskID
						--UNION
						--select us.UserID,@TaskID DealFundingID from App.EmailNotification e join App.[User] us on us.Email =e.Emailid where ModuleId=552
						) tbluser on tbluser.DealReserveScheduleGUID =df.DealReserveScheduleGUID
						join App.[User] u on u.UserID=tbluser.UserID
						WHERE df.DealReserveScheduleGUID = @TaskID
						AND u.UserID<>@UserID
						
						--select top 1 @tDealID=DealID,@tDealName = DealName,@tNextStatusName =NextStatusName,
						--@tFundingDate = FundingDate,@tFundingAmount=FundingAmount,@tDealLine=DealLine from @EmailNotification

						select top 1 @tDealID=d1.DealID,@tDealName = d1.DealName,@tNextStatusName =@NextStatusName,
						@tFundingDate = df1.Date,@tFundingAmount=ABS(df1.Amount)  FROM CRE.DealReserveSchedule df1
						JOIN  CRE.Deal d1 ON d1.DealID = df1.DealID
						WHERE df1.DealReserveScheduleGUID=@TaskID
						
						select UserID,Email,UserName,DealID,DealName,NextStatusName,TaskID,FundingDate,FundingAmount,DealLine,0 as WorkflowUserTypeID
						from @EmailNotification
						union
						(
						select us.UserID,us.Email,us.FirstName +'  '+ us.LastName as UserName,@tDealID,@tDealName,@tNextStatusName,@TaskID,@tFundingDate,
						@tFundingAmount,@tDealLine,564 as WorkflowUserTypeID from App.EmailNotification e join App.[User] us on us.Email =e.Emailid where ModuleId=564
						and us.UserID NOT IN(select UserID from @EmailNotification) and us.UserID<>@UserID
						)
						--Email to AM fundting team
						union
						select '00000000-0000-0000-0000-000000000000' as UserID ,EmailId,'' as UserName ,@tDealID,@tDealName,@tNextStatusName,@TaskID,@tFundingDate,
						@tFundingAmount,@tDealLine,0 as WorkflowUserTypeID from App.EmailNotification where ModuleId=614
						union
						select '00000000-0000-0000-0000-000000000000' as UserID ,EmailId,'' as UserName ,@tDealID,@tDealName,@tNextStatusName,@TaskID,@tFundingDate,
						@tFundingAmount,@tDealLine,0 as WorkflowUserTypeID from App.EmailNotification where ModuleId=720 and [Status]=1 and @IsREODeal=1
						union
						select UserID ,us.Email,us.FirstName +'  '+ us.LastName as UserName ,@tDealID,@tDealName,@tNextStatusName,@TaskID,@tFundingDate,
						@tFundingAmount,@tDealLine,0 as WorkflowUserTypeID from App.[User] us where [UserID]=@UserID


				   END
			 END
						
END
	   END
    END
END




