CREATE PROCEDURE [dbo].[usp_ResetReserveWorkflow]    
 @SavedPurpose int,
 @SavedAmount decimal(28, 15),
 @SavedDate date,
 @PurposeID int,
 @Amount decimal(28, 15),
 @Date date,
 @TaskID UNIQUEIDENTIFIER,  
 @TaskTypeID int,
 @Applied bit,
 @UserID UNIQUEIDENTIFIER  
AS    
BEGIN    
    SET NOCOUNT ON;  
    declare @SavedAmountWith5Percentage decimal(28, 15),@DealID UNIQUEIDENTIFIER 
	Declare @wfDeleteFlag int = 0
	Declare @wfFundingUpdateFlag int = 0;
	Declare @wfFundingDecreaseFlag int = 0;
	Declare @wfFundDateUpdateFlag int = 0;
	
   select @DealID = DealID from cre.DealReserveSchedule where DealReserveScheduleGUID=@TaskID
    

    if((@SavedPurpose <> @PurposeID) and @TaskID <> '00000000-0000-0000-0000-000000000000')
		SET @wfDeleteFlag = 1
	--================================================
	--@SavedAmount: Previous amount
	--@Amount: New Amount

	--validations
	--Reset the Work Flow to Requested only if the increase in FF amount is greater than 5%
	SET @SavedAmountWith5Percentage = @SavedAmount * .05;
	SET @SavedAmountWith5Percentage = @SavedAmount + round(@SavedAmountWith5Percentage,2);
	
	if((round(@SavedAmountWith5Percentage,2) < round(@Amount,2)) and @TaskID <> '00000000-0000-0000-0000-000000000000')
	BEGIN
	   SET @wfFundingUpdateFlag = 1
	END
	-- when amount change less then 5%
	ELSE if((round(@SavedAmount,2) <> round(@Amount,2)) and @TaskID <> '00000000-0000-0000-0000-000000000000') 
	BEGIN
	   SET @wfFundingDecreaseFlag = 1
	END
	 --if((round(@SavedAmount,2) > round(@Amount,2)) and @TaskID <> '00000000-0000-0000-0000-000000000000')
	
	if(CAST(@Date as Date) <> Cast(@SavedDate as Date) and @TaskID <> '00000000-0000-0000-0000-000000000000')
	BEGIN
	   SET @wfFundDateUpdateFlag = 1
	END
  

  IF (@wfDeleteFlag = 1)
	BEGIN
		--Delete workflow for that dealfunding
		--Delete from cre.WFTaskDetail where TaskID = @TaskID
		--Delete from cre.WFTaskDetailArchive  where TaskID = @TaskID
		--Delete from cre.WFCheckListDetail where TaskID = @TaskID

		Delete from cre.WFTaskDetail where WFTaskDetailID in (Select WFTaskDetailID from cre.WFTaskDetail where TaskID = @TaskID) and TaskTypeID=@TaskTypeID
		Delete from cre.WFTaskDetailArchive  where WFTaskDetailArchiveID in (Select WFTaskDetailArchiveID from cre.WFTaskDetailArchive  where TaskID = @TaskID) and TaskTypeID=@TaskTypeID
		Delete from cre.WFCheckListDetail where WFCheckListDetailID in (Select WFCheckListDetailID from cre.WFCheckListDetail where TaskID = @TaskID) and TaskTypeID=@TaskTypeID
		--------------------------
	END
	
	
	--Insert into WFTaskDetail
	--if not a phantom legal deal and workflow is allowed
	IF (NOT EXISTS(select 1 from cre.deal where DealID=@DealID and [status]=325 and isnull(linkeddealid,'') ='')
	and 
	EXISTS(SELECT WFStatusPurposeMappingID FROM [CRE].[WFStatusPurposeMapping] WHERE PurposeTypeID= @PurposeID AND OrderIndex =10 and IsEnable=1)
	)
	BEGIN

	-- For Wire confirmed funding not perform action
	IF(@Applied <> 1)
	BEGIN
	   
		Declare @WFNotificationMasterID int
		Declare @MessageHTML nvarchar(max)
		Declare @AdditionalText   nvarchar(256)
		Declare @ScheduledDateTime Datetime
		Declare @ActionType int

		IF NOT EXISTS(Select TaskID from cre.WFTaskDetail where TaskID = @TaskID and TaskTypeID=@TaskTypeID)
		BEGIN
			DECLARE @WFStatusPurposeMappingID INT
			SET @WFStatusPurposeMappingID = (SELECT WFStatusPurposeMappingID FROM [CRE].[WFStatusPurposeMapping] WHERE PurposeTypeID= @PurposeID AND OrderIndex =10)
		  
			IF (@WFStatusPurposeMappingID is not NULL)
			BEGIN
				-- ====Parameter==============================
					--@TaskID nvarchar(max),
					--@WFStatusPurposeMappingID int,
					--@TaskTypeID int,
					--@Comment  nvarchar(max),
					--@SubmitType int,
					--@UserID nvarchar(256),
					--@CheckListDetail tblType_CheckListDetail readonly
				--==================================

				DECLARE  @CheckListDetail tblType_CheckListDetail
				exec [dbo].[usp_InsertWorkflowDetailForTaskId] @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,'',498,@UserID,null,null,null,@CheckListDetail
			END
		END
		ELSE
		 BEGIN
		   IF(@wfFundingUpdateFlag = 1)
			BEGIN		
			DECLARE @WF_CurrentStatusID INT
			DECLARE @WF_ReviewStatusID INT
			SET @WF_CurrentStatusID = (SELECT (SELECT TOP 1 sm.WFStatusMasterID FROM [CRE].[WFTaskDetail] td 
				INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
				INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
				WHERE TaskId = @TaskID and td.TaskTypeID=@TaskTypeID
				ORDER BY WFTaskDetailID DESC ) ) --as WF_CurrentStatus;			
			
			
				SELECT @WF_ReviewStatusID = WFStatusMasterID FROM [CRE].[WFStatusMaster] WHERE StatusName = 'Under Review'

				IF(@WF_CurrentStatusID > @WF_ReviewStatusID)
				BEGIN
					--	DECLARE @WFStatusPurposeMappingID INT
				SET @WFStatusPurposeMappingID = (SELECT WFStatusPurposeMappingID FROM [CRE].[WFStatusPurposeMapping] WHERE PurposeTypeID= @PurposeID AND OrderIndex =20)
				IF (@WFStatusPurposeMappingID is not NULL)
					BEGIN
						-- ====Parameter==============================
							--@TaskID nvarchar(max),
							--@WFStatusPurposeMappingID int,
							--@TaskTypeID int,
							--@Comment  nvarchar(max),
							--@SubmitType int,
							--@CreatedBy nvarchar(256),
							--@CheckListDetail tblType_CheckListDetail readonly
						--==================================
						--@SavedAmount: Previous amount
						--@Amount: New Amount
						
						
                 
						Declare @fundingMsg NVARCHAR(256)
						SET @fundingMsg = 'Changed the funding amount from $' + CONVERT(varchar, CAST(@SavedAmount AS money), 1) + ' to $' + CONVERT(varchar, CAST(@Amount AS money), 1);
					    SET @fundingMsg = REPLACE(@fundingMsg,'$-','-$');



						IF(@wfFundDateUpdateFlag = 1)
						BEGIN
							Declare @OldFormattedDate nvarchar(256)
							Declare @NewFormattedDate nvarchar(256)
							SET @OldFormattedDate = Cast(LEFT(DATENAME(WEEKDAY,Cast(@SavedDate as date)),3) +', '+FORMAT(@SavedDate,'MMM d' + IIF(DAY(@SavedDate) IN (1,21,31),'''st ''',IIF(DAY(@SavedDate) IN (2,22),'''nd''',IIF(DAY(@SavedDate) IN (3,23),'''rd''','''th''')))+', yyyy') as nvarchar(256))
							SET @NewFormattedDate =  Cast( LEFT(DATENAME(WEEKDAY,Cast(@Date as date)),3) +', '+FORMAT(@Date,'MMM d' + IIF(DAY(@Date) IN (1,21,31),'''st ''',IIF(DAY(@Date) IN (2,22),'''nd''',IIF(DAY(@Date) IN (3,23),'''rd''','''th''')))+', yyyy') as nvarchar(256))

							--SET @fundingMsg = @fundingMsg + '<br>' + 'Changed the funding date from ' + Cast(LEFT(DATENAME(WEEKDAY,Cast(@SavedDate as date)),3) +', '+ Format(Cast(@SavedDate as date),'MMM dd, yyyy') as nvarchar(256)) + ' to ' + Cast(LEFT(DATENAME(WEEKDAY,Cast(@Date as date)),3) +', '+ Format(Cast(@Date as date),'MMM dd, yyyy') as nvarchar(256))
							SET @fundingMsg = @fundingMsg + '<br>' + 'Changed the funding date from ' + @OldFormattedDate + ' to ' + @NewFormattedDate
						END

					   --	DECLARE  @CheckListDetail tblType_CheckListDetail
					   --Submit type - 497 (Save and Draft)
						exec [dbo].[usp_InsertWorkflowDetailForTaskId] @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,@fundingMsg,497,@UserID,null,null,null,@CheckListDetail
					END
				END

			END
			--Amount decrease 
			ELSE IF(@wfFundingDecreaseFlag = 1)
			BEGIN		
			--DECLARE @WF_CurrentStatusID INT
			--DECLARE @WF_ReviewStatusID INT
				SET @WF_CurrentStatusID = (SELECT (SELECT TOP 1 sm.WFStatusMasterID FROM [CRE].[WFTaskDetail] td 
				INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
				INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
				WHERE TaskId = @TaskID and td.TaskTypeID=@TaskTypeID
				ORDER BY WFTaskDetailID DESC ) ) --as WF_CurrentStatus;			
			
			
				SET @WFStatusPurposeMappingID = (SELECT top 1 td.WFStatusPurposeMappingID FROM [CRE].[WFTaskDetail] td WHERE TaskId = @TaskID and td.TaskTypeID=@TaskTypeID ORDER BY WFTaskDetailID DESC ) --as WF_CurrentStatus;			
			

				--SELECT @WF_ReviewStatusID = WFStatusMasterID FROM [CRE].[WFStatusMaster] WHERE StatusName = 'Requested'

				--IF(@WF_CurrentStatusID > @WF_ReviewStatusID)
				BEGIN
					--	DECLARE @WFStatusPurposeMappingID INT
				--SET @WFStatusPurposeMappingID = (SELECT WFStatusPurposeMappingID FROM [CRE].[WFStatusPurposeMapping] WHERE PurposeTypeID= @PurposeID AND OrderIndex =20)
				IF (@WFStatusPurposeMappingID is not NULL)
					BEGIN
						-- ====Parameter==============================
							--@TaskID nvarchar(max),
							--@WFStatusPurposeMappingID int,
							--@TaskTypeID int,
							--@Comment  nvarchar(max),
							--@SubmitType int,
							--@CreatedBy nvarchar(256),
							--@CheckListDetail tblType_CheckListDetail readonly
						--==================================
						--@SavedAmount: Previous amount
						--@Amount: New Amount
						
						
                 
						--Declare @fundingMsg NVARCHAR(256)
						SET @fundingMsg = ''
						SET @fundingMsg = 'Changed the funding amount from $' + CONVERT(varchar, CAST(@SavedAmount AS money), 1) + ' to $' + CONVERT(varchar, CAST(@Amount AS money), 1);
						
						IF(@wfFundDateUpdateFlag = 1)
						BEGIN
							--Declare @OldFormattedDate nvarchar(256)
							--Declare @NewFormattedDate nvarchar(256)
							SET @OldFormattedDate = Cast(LEFT(DATENAME(WEEKDAY,Cast(@SavedDate as date)),3) +', '+FORMAT(@SavedDate,'MMM d' + IIF(DAY(@SavedDate) IN (1,21,31),'''st ''',IIF(DAY(@SavedDate) IN (2,22),'''nd''',IIF(DAY(@SavedDate) IN (3,23),'''rd''','''th''')))+', yyyy') as nvarchar(256))
							SET @NewFormattedDate = Cast(LEFT(DATENAME(WEEKDAY,Cast(@Date as date)),3) +', '+FORMAT(@Date,'MMM d' + IIF(DAY(@Date) IN (1,21,31),'''st ''',IIF(DAY(@Date) IN (2,22),'''nd''',IIF(DAY(@Date) IN (3,23),'''rd''','''th''')))+', yyyy') as nvarchar(256))

							--SET @fundingMsg = @fundingMsg + '<br>' + 'Changed the funding date from ' + Cast(LEFT(DATENAME(WEEKDAY,Cast(@SavedDate as date)),3) +', '+ Format(Cast(@SavedDate as date),'MMM dd, yyyy') as nvarchar(256)) + ' to ' + Cast(LEFT(DATENAME(WEEKDAY,Cast(@Date as date)),3) +', '+ Format(Cast(@Date as date),'MMM dd, yyyy') as nvarchar(256))
							SET @fundingMsg = @fundingMsg + '<br>' + 'Changed the funding date from ' + @OldFormattedDate + ' to ' + @NewFormattedDate
						END
					   
						--DECLARE  @CheckListDetail tblType_CheckListDetail					  
						--SELECT * FROm [CRE].[WFTaskDetail] where TaskId = '7D81FB1C-5A64-4A12-99EB-00A94ED05699'
						--Submit type - 497 (Save and Draft)
						exec [dbo].[usp_InsertWorkflowDetailForTaskId] @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,@fundingMsg,497,@UserID,null,null,null,@CheckListDetail
					END
				END

			END
			--============IF date changed=========================
			ELSE IF(@wfFundDateUpdateFlag = 1)
			BEGIN
				
				SET @WF_CurrentStatusID = (SELECT (SELECT TOP 1 sm.WFStatusMasterID FROM [CRE].[WFTaskDetail] td 
				INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
				INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
				WHERE TaskId = @TaskID and td.TaskTypeID=@TaskTypeID
				ORDER BY WFTaskDetailID DESC ) ) --as WF_CurrentStatus;			
			
			
				SET @WFStatusPurposeMappingID = (SELECT top 1 td.WFStatusPurposeMappingID FROM [CRE].[WFTaskDetail] td WHERE TaskId = @TaskID and td.TaskTypeID=@TaskTypeID ORDER BY WFTaskDetailID DESC ) --as WF_CurrentStatus;			
			

				--SELECT @WF_ReviewStatusID = WFStatusMasterID FROM [CRE].[WFStatusMaster] WHERE StatusName = 'Requested'

				--IF(@WF_CurrentStatusID > @WF_ReviewStatusID)
				BEGIN
					--	DECLARE @WFStatusPurposeMappingID INT
				--SET @WFStatusPurposeMappingID = (SELECT WFStatusPurposeMappingID FROM [CRE].[WFStatusPurposeMapping] WHERE PurposeTypeID= @PurposeID AND OrderIndex =20)
				IF (@WFStatusPurposeMappingID is not NULL)
					BEGIN
						-- ====Parameter==============================
							--@TaskID nvarchar(max),
							--@WFStatusPurposeMappingID int,
							--@TaskTypeID int,
							--@Comment  nvarchar(max),
							--@SubmitType int,
							--@CreatedBy nvarchar(256),
							--@CheckListDetail tblType_CheckListDetail readonly
						--==================================
						--@SavedAmount: Previous amount
						--@Amount: New Amount
						
						
                 
						--Declare @fundingMsg NVARCHAR(256)
						SET @fundingMsg = ''
						
						SET @OldFormattedDate = Cast(LEFT(DATENAME(WEEKDAY,Cast(@SavedDate as date)),3) +', '+FORMAT(@SavedDate,'MMM d' + IIF(DAY(@SavedDate) IN (1,21,31),'''st ''',IIF(DAY(@SavedDate) IN (2,22),'''nd''',IIF(DAY(@SavedDate) IN (3,23),'''rd''','''th''')))+', yyyy') as nvarchar(256))
						SET @NewFormattedDate =  Cast( LEFT(DATENAME(WEEKDAY,Cast(@Date as date)),3) +', '+FORMAT(@Date,'MMM d' + IIF(DAY(@Date) IN (1,21,31),'''st ''',IIF(DAY(@Date) IN (2,22),'''nd''',IIF(DAY(@Date) IN (3,23),'''rd''','''th''')))+', yyyy') as nvarchar(256))

						--SET @fundingMsg = 'Changed the funding date from ' + Cast(LEFT(DATENAME(WEEKDAY,Cast(@SavedDate as date)),3) +', '+ Format(Cast(@SavedDate as date),'MMM dd, yyyy') as nvarchar(256)) + ' to ' + Cast(LEFT(DATENAME(WEEKDAY,Cast(@Date as date)),3) +', '+ Format(Cast(@Date as date),'MMM dd, yyyy') as nvarchar(256));
						SET @fundingMsg = @fundingMsg + '<br>' + 'Changed the funding date from ' + @OldFormattedDate + ' to ' + @NewFormattedDate
						
					   --	DECLARE  @CheckListDetail tblType_CheckListDetail
					  
					  --SELECT * FROm [CRE].[WFTaskDetail] where TaskId = '7D81FB1C-5A64-4A12-99EB-00A94ED05699'
					   --Submit type - 497 (Save and Draft)
						exec [dbo].[usp_InsertWorkflowDetailForTaskId] @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,@fundingMsg,497,@UserID,null,null,null,@CheckListDetail
					END
				END
				
			END
			--===========================================


		 END
	END
	END
  
END