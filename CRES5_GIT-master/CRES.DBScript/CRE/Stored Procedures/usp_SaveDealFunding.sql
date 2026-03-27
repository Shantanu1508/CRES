-- Procedure

--[CRE].[usp_SaveDealFunding] 'dc7139ab-d18f-47c4-a711-420b4bde4f38',
--'fdd8ec03-9d63-4512-9990-89c508983edc','2016-08-23','370984.28','Draw 1',318,1,'',1,'b0e6697b-3534-4c09-be0a-04473401ab93','2019-01-23','b0e6697b-3534-4c09-be0a-04473401ab93','2019-01-23'

CREATE PROCEDURE [CRE].[usp_SaveDealFunding]
(
	@XMLDealFunding XML,
	@DelegatedUserID nvarchar(256) = null
	--@DealFundingID  uniqueidentifier,
	--@DealID varchar(256),    
	--@Date datetime,
	--@Amount decimal(28, 15) ,	 
	--@Comment nvarchar(max),
	--@PurposeID int,
	--@Applied bit,
	--@DrawFundingId nvarchar(256) ,
	--@DealFundingRowno int,
	--@CreatedBy nvarchar(256) ,
	--@CreatedDate datetime ,
	--@UpdatedBy nvarchar(256) ,
	--@UpdatedDate datetime  
)
  
AS
BEGIN
  SET NOCOUNT ON;  


	
	declare @currcount int =1

	declare @DealFundingID  uniqueidentifier,
	@DealID varchar(256),    
	@Date datetime,
	@Amount decimal(28, 15) ,	 
	@SavedAmountWith5Percentage decimal(28, 15) ,
	@Comment nvarchar(max),
	@PurposeID int,
	@Applied bit,
	@NonCommitmentAdj bit,
	@DrawFundingId nvarchar(256) ,
	@DealFundingRowno int,
	@EquityAmount decimal(28, 15) ,		
	@CreatedBy nvarchar(256) ,
	@CreatedDate datetime ,
	@UpdatedBy nvarchar(256) ,
	@UpdatedDate datetime  ,

	@RequiredEquity decimal(28, 15) ,
	@AdditionalEquity decimal(28, 15) ,
	@GeneratedBy  int ,
	@GeneratedByUserID  nvarchar(256) ,
	@AdjustmentType int
		
	declare @TempDealFunding table
	(
	ID int identity,
	DealFundingID  uniqueidentifier,
	DealID varchar(256),    
	[Date] datetime,
	Amount decimal(28, 15) ,	 
	Comment nvarchar(max),
	PurposeID int,
	Applied bit,
	NonCommitmentAdj bit,
	DrawFundingId nvarchar(256) ,
	DealFundingRowno int,
	EquityAmount decimal(28, 15) ,	
	CreatedBy nvarchar(256),
	RequiredEquity decimal(28, 15) ,	
	AdditionalEquity  decimal(28, 15) ,
	GeneratedBy  int,
    GeneratedByUserID nvarchar(256) ,
	AdjustmentType int
	)

	INSERT INTO @TempDealFunding

	select 
	ISNULL(nullif(Pers.value('(DealFundingID)[1]', 'varchar(256)'), ''),'00000000-0000-0000-0000-000000000000'),  
	nullif(Pers.value('(DealID)[1]', 'varchar(256)'), ''),
	Pers.value('(Date)[1]', 'datetime'),
	Pers.value('(Value)[1]', 'decimal(28, 15)'),
	nullif(Pers.value('(Comment)[1]', 'nvarchar(max)'), ''),
	Pers.value('(PurposeID)[1]', 'INT'),
	Pers.value('(Applied)[1]', 'bit'),
	Pers.value('(NonCommitmentAdj)[1]', 'bit'),
	nullif(Pers.value('(DrawFundingId)[1]', 'nvarchar(256)'), ''),
	Pers.value('(DealFundingRowno)[1]', 'int'),	
	Pers.value('(EquityAmount)[1]', 'decimal(28, 15)'),	
	nullif(Pers.value('(CreatedBy)[1]', 'nvarchar(256)'), ''),
	Pers.value('(RequiredEquity)[1]', 'decimal(28, 15)'),
	Pers.value('(AdditionalEquity)[1]', 'decimal(28, 15)'),
	Pers.value('(GeneratedBy)[1]', 'INT')	,
	Pers.value('(GeneratedByUserID)[1]', 'nvarchar(256)')	,
	Pers.value('(AdjustmentType)[1]', 'INT')	
	FROM @XMLDealFunding.nodes('/ArrayOfPayruleDealFundingDataContract/PayruleDealFundingDataContract') as t(Pers)
	WHERE Pers.value('(Value)[1]', 'varchar(256)') != ''
	and Pers.value('(PurposeID)[1]', 'INT') <> 840

	SET @DealID = (select top 1 DealID from @TempDealFunding)

	------Principal writeoff temp table-----------
	declare @TempDealFunding_PrincipalWriteOff table
	(
	ID int identity,
	DealFundingID  uniqueidentifier,
	DealID varchar(256),    
	[Date] datetime,
	Amount decimal(28, 15) ,	 
	Comment nvarchar(max),
	PurposeID int,
	Applied bit,
	NonCommitmentAdj bit,
	DrawFundingId nvarchar(256) ,
	DealFundingRowno int,
	EquityAmount decimal(28, 15) ,	
	CreatedBy nvarchar(256),
	RequiredEquity decimal(28, 15) ,	
	AdditionalEquity  decimal(28, 15) ,
	GeneratedBy  int,
    GeneratedByUserID nvarchar(256) ,
	AdjustmentType int
	)

	INSERT INTO @TempDealFunding_PrincipalWriteOff
	select 
	ISNULL(nullif(Pers.value('(DealFundingID)[1]', 'varchar(256)'), ''),'00000000-0000-0000-0000-000000000000'),  
	nullif(Pers.value('(DealID)[1]', 'varchar(256)'), ''),
	Pers.value('(Date)[1]', 'datetime'),
	Pers.value('(Value)[1]', 'decimal(28, 15)'),
	nullif(Pers.value('(Comment)[1]', 'nvarchar(max)'), ''),
	Pers.value('(PurposeID)[1]', 'INT'),
	Pers.value('(Applied)[1]', 'bit'),
	Pers.value('(NonCommitmentAdj)[1]', 'bit'),
	nullif(Pers.value('(DrawFundingId)[1]', 'nvarchar(256)'), ''),
	Pers.value('(DealFundingRowno)[1]', 'int'),	
	Pers.value('(EquityAmount)[1]', 'decimal(28, 15)'),	
	nullif(Pers.value('(CreatedBy)[1]', 'nvarchar(256)'), ''),
	Pers.value('(RequiredEquity)[1]', 'decimal(28, 15)'),
	Pers.value('(AdditionalEquity)[1]', 'decimal(28, 15)'),
	Pers.value('(GeneratedBy)[1]', 'INT')	,
	Pers.value('(GeneratedByUserID)[1]', 'nvarchar(256)')	,
	Pers.value('(AdjustmentType)[1]', 'INT')	
	FROM @XMLDealFunding.nodes('/ArrayOfPayruleDealFundingDataContract/PayruleDealFundingDataContract') as t(Pers)
	WHERE Pers.value('(Value)[1]', 'varchar(256)') != ''
	and Pers.value('(PurposeID)[1]', 'INT') = 840
	---===============================

	

	declare @IsLegalDeal bit = 0;
	

	IF EXISTS(Select  1 from cre.deal where DealID=@DealID and [status]=323)
	BEGIN
		Set @IsLegalDeal = 1
	END


	----capture current status
	Declare @WFCurrentStatus as table (TaskId UNIQUEIDENTIFIER,WFStatusMasterID int,WFStatusPurposeMappingID int)

	INSERT INTO @WFCurrentStatus(TaskId,WFStatusMasterID,WFStatusPurposeMappingID)
	Select TaskId,WFStatusMasterID,WFStatusPurposeMappingID
	from(
		SELECT TaskId,sm.WFStatusMasterID,td.WFStatusPurposeMappingID
		,ROW_NUMBER() OVER (Partition by TaskId order by TaskId,WFTaskDetailID DESC) rno
		FROM [CRE].[WFTaskDetail] td 
		inner join cre.dealfunding df on df.dealfundingid = td.TaskId
		INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
		INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
		WHERE df.dealid = @DealID
		and td.TaskTypeID=502
	)a where rno = 1



	Declare @tblWorkflowDetail as table(
		TaskID nvarchar(256),
		WFStatusPurposeMappingID int,
		TaskTypeID int,
		Comment  nvarchar(max),
		SubmitType int,
		CreatedBy nvarchar(256),
		AdditionalComments nvarchar(max) ,
		SpecialInstructions nvarchar(max) ,
		DelegatedUserID nvarchar(256) 
	)
	

	---=======================================================
	while exists(select 1 from @TempDealFunding where ID = @currcount)
	BEGIN
	    select		
		@DealFundingID = DealFundingID,
		@DealID = DealID,    
		@Date  = [Date],
		@Amount = Amount,	 
		@Comment  = Comment,
		@PurposeID =PurposeID,
		@Applied = Applied,
		@NonCommitmentAdj=NonCommitmentAdj,
		@DrawFundingId = DrawFundingId,
		@DealFundingRowno = DealFundingRowno,
		@EquityAmount=EquityAmount,
		@CreatedBy = CreatedBy,
		@UpdatedBy = CreatedBy,
		@RequiredEquity = RequiredEquity ,
		@AdditionalEquity  =AdditionalEquity,
		@GeneratedBy = GeneratedBy,
		@GeneratedByUserID=GeneratedByUserID,
		@AdjustmentType= AdjustmentType
		from @TempDealFunding where ID = @currcount

		Declare @wfDeleteFlag int = 0;
		Declare @wfFundingUpdateFlag int = 0;
		Declare @wfFundingDecreaseFlag int = 0;
		Declare @wfFundDateUpdateFlag int = 0;

		Declare @SavedPurpose int ;
		Declare @SavedAmount decimal(28, 15)
		Declare @SavedDate date,@SavedApplied bit

		Select @SavedPurpose = PurposeID,
		@SavedAmount=Amount ,
		@SavedDate = [Date],
		@SavedApplied =Applied
		from cre.DealFunding where DealID = @DealID and  DealFundingID = @DealFundingID



		--or @SavedAmount <> @Amount
		if((@SavedPurpose <> @PurposeID) and @DealFundingID <> '00000000-0000-0000-0000-000000000000')
		BEGIN
			SET @wfDeleteFlag = 1
		END
		--================================================

		--@SavedAmount: Previous amount
		--@Amount: New Amount

		--Reset the Work Flow to Requested only if the increase in FF amount is greater than 5%
		SET @SavedAmountWith5Percentage = @SavedAmount * .05;
		SET @SavedAmountWith5Percentage = @SavedAmount + round(@SavedAmountWith5Percentage,2);
	
		--commented as it workd only for positive amount
		--if((round(@SavedAmountWith5Percentage,2) < round(@Amount,2)) and @DealFundingID <> '00000000-0000-0000-0000-000000000000')
		--taking absolute value so that it will work for negative amount as well
		if((abs(round(@SavedAmountWith5Percentage,2)) < abs(round(@Amount,2))) and @DealFundingID <> '00000000-0000-0000-0000-000000000000')
		BEGIN
			SET @wfFundingUpdateFlag = 1
		END
		-- when amount change less then 5%
		ELSE if((abs(round(@SavedAmount,2)) <> abs(round(@Amount,2))) and @DealFundingID <> '00000000-0000-0000-0000-000000000000') 
		BEGIN
			SET @wfFundingDecreaseFlag = 1
		END
		--if((round(@SavedAmount,2) > round(@Amount,2)) and @DealFundingID <> '00000000-0000-0000-0000-000000000000')
	
		if(CAST(@Date as Date) <> Cast(@SavedDate as Date) and @DealFundingID <> '00000000-0000-0000-0000-000000000000')
		BEGIN
			SET @wfFundDateUpdateFlag = 1
		END


		----INsert Activity------------
		IF NOT EXISTS(
		select DealFundingID from CRE.DealFunding where 
		DealFundingID = ISNULL(@DealFundingID,'00000000-0000-0000-0000-000000000000') and
		ISNULL(CONVERT(varchar, [Date], 101),'')=ISNULL(CONVERT(varchar, @Date, 101),'') and 
		ISNULL(Amount,0)= ISNULL(@Amount,0) and 
		ISNULL(Comment,0)= ISNULL(@Comment,0) and 
		ISNULL(PurposeID,0)= ISNULL(@PurposeID,0) and 
		DealID=@DealID and
		ISNULL(Applied,0)= ISNULL(@Applied,0) and 
		ISNULL(DrawFundingId,'')=ISNULL(@DrawFundingId,'')
		)
		BEGIN		   

			delete from app.activitylog where ActivityLogAutoID in (
			Select ActivityLogAutoID from app.activitylog where ParentModuleID = @DealID and ModuleID = @DealID and ParentModuleTypeID=283 and ActivityType=416 and CreatedBy = @CreatedBy
			and Cast(CreatedDate as date) = Cast(getdate() as Date)
			and DATEDIFF(SECOND, CreatedDate,  getdate()) < 10
			)		   

			exec dbo.usp_InsertActivityLog @DealID,283,@DealID,416,'Updated',@CreatedBy		
			--if doing wireconfirm and making debt amount as zero than change workflow status back to Projected
			IF(@Applied = 1 and @SavedApplied=0 and @Amount=0 ) 
			BEGIN
					DECLARE @tWFStatusPurposeMappingID INT
					SET @tWFStatusPurposeMappingID = (SELECT WFStatusPurposeMappingID FROM [CRE].[WFStatusPurposeMapping] WHERE PurposeTypeID= @PurposeID AND OrderIndex =10)
					Declare @fundingMsgZero NVARCHAR(256)
								SET @fundingMsgZero = 'Rejected to Projected because of debt amount as zero';

					INSERT INTO @tblWorkflowDetail(TaskID,WFStatusPurposeMappingID,TaskTypeID,Comment,SubmitType,CreatedBy,AdditionalComments,SpecialInstructions,DelegatedUserID)
					VALUES(@DealFundingID,@tWFStatusPurposeMappingID,502,@fundingMsgZero,496,@CreatedBy,null,null,@DelegatedUserID)
			END

		END
		---------------------------------
		   
		---Deal Funding Insert Update

		if(@AdjustmentType=0) 
		BEGIN
		set @AdjustmentType=null
		END 
		Declare @VDealFundingID uniqueidentifier;
		SET @VDealFundingID = @DealFundingID;
		

		Update CRE.DealFunding 
		set 
		[Date]=@Date,
		Amount= @Amount,	
		Comment =@Comment,	
		PurposeID=@PurposeID,		 
		UpdatedBy=@UpdatedBy,
		UpdatedDate =GETDATE() ,				
		DealID=@DealID,
		Applied=@Applied,
		NonCommitmentAdj=@NonCommitmentAdj,
		Issaved=@Applied,
		DrawFundingId=@DrawFundingId,
		DealFundingRowno=@DealFundingRowno,
		EquityAmount=@EquityAmount,
		DeadLineDate = dbo.Fn_GetnextWorkingDays(@Date,-2,'PMT Date'),
		RequiredEquity = @RequiredEquity ,
		AdditionalEquity = @AdditionalEquity,
		GeneratedBy = @GeneratedBy,
		GeneratedByUserID=@GeneratedByUserID,
		AdjustmentType=@AdjustmentType
		where DealFundingID =@DealFundingID;	

		IF @@ROWCOUNT = 0 
		BEGIN
			DECLARE @tDealFunding TABLE (tDealFundingId UNIQUEIDENTIFIER)

			INSERT INTO CRE.DealFunding	(DealID,[Date],Amount,Comment,PurposeID,Applied,NonCommitmentAdj,Issaved,DrawFundingId,DealFundingRowno,EquityAmount,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,DeadLineDate,RequiredEquity,AdditionalEquity,GeneratedBy,GeneratedByUserID,AdjustmentType)		 
			OUTPUT inserted.DealFundingID INTO @tDealFunding(tDealFundingId)
			VALUES(@DealID,@Date,@Amount,@Comment,@PurposeID,@Applied,@NonCommitmentAdj,@Applied,@DrawFundingId,@DealFundingRowno,@EquityAmount,@CreatedBy,GETDATE(),@UpdatedBy,GETDATE(),dbo.Fn_GetnextWorkingDays(@Date,-2,'PMT Date'),@RequiredEquity ,@AdditionalEquity,@GeneratedBy,@GeneratedByUserID,@AdjustmentType)
	

			SELECT @VDealFundingID = tDealFundingId FROM @tDealFunding;			
		END 
		-----------------------------------------

		--delete workflow if purposeid changed
		IF (@wfDeleteFlag = 1)
		BEGIN
			--Delete workflow for that dealfunding
			--Delete from cre.WFTaskDetail where TaskID = @DealFundingID
			--Delete from cre.WFTaskDetailArchive  where TaskID = @DealFundingID
			--Delete from cre.WFCheckListDetail where TaskID = @DealFundingID

			Delete from cre.WFTaskDetail where WFTaskDetailID in (Select WFTaskDetailID from cre.WFTaskDetail where TaskID = @DealFundingID) and TaskTypeID=502
			Delete from cre.WFTaskDetailArchive  where WFTaskDetailArchiveID in (Select WFTaskDetailArchiveID from cre.WFTaskDetailArchive  where TaskID = @DealFundingID) and TaskTypeID=502
			Delete from cre.WFCheckListDetail where WFCheckListDetailID in (Select WFCheckListDetailID from cre.WFCheckListDetail where TaskID = @DealFundingID) and TaskTypeID=502
			--------------------------
		END
	

		declare @IsWF_Enable bit = 0;
		IF EXISTS(SELECT 1 FROM [CRE].[WFStatusPurposeMapping] WHERE PurposeTypeID= @PurposeID AND OrderIndex =10 and IsEnable=1)
		BEGIN
			Set @IsWF_Enable = 1
		END


	--Insert into WFTaskDetail
	--if not a phantom legal deal and workflow is allowed
	---IF (NOT EXISTS(select 1 from cre.deal where DealID=@DealID and [status]=325 and isnull(linkeddealid,'') ='') and EXISTS(SELECT WFStatusPurposeMappingID FROM [CRE].[WFStatusPurposeMapping] WHERE PurposeTypeID= @PurposeID AND OrderIndex =10 and IsEnable=1))
	IF(@IsLegalDeal = 1 and @IsWF_Enable = 1)
	BEGIN

	-- For Wire confirmed funding not perform action
	IF(@Applied <> 1)
	BEGIN
		--update invoice status from invoice quiued to generate on unwireconfirmed		

		IF EXISTS(Select 1 from Cre.InvoiceDetail where ObjectID= @VDealFundingID and ObjectTypeID=698 and InvoiceTypeID=558 and DrawFeeStatus=696)
		begin
			update Cre.InvoiceDetail set DrawFeeStatus=692 ,FileName=null,InvoiceNo=null, UpdatedDate = getdate() where ObjectID= @VDealFundingID and ObjectTypeID=698 and InvoiceTypeID=558 and DrawFeeStatus=696
			if (@@ROWCOUNT>0)
			Begin
				exec [usp_InsertDrawFeeActivityLog] @VDealFundingID,'Invoice Removed from Queue','',''
			End		 

		end
		-----------------------------
		
		Declare @WFNotificationMasterID int
		Declare @MessageHTML nvarchar(max)
		Declare @AdditionalText   nvarchar(256)
		Declare @ScheduledDateTime Datetime
		Declare @ActionType int

		IF NOT EXISTS(Select TaskID from cre.WFTaskDetail where TaskID = @VDealFundingID and TaskTypeID=502)
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
					--@CreatedBy nvarchar(256),
					--@CheckListDetail tblType_CheckListDetail readonly
				--==================================

				
				--DECLARE  @CheckListDetail tblType_CheckListDetail
				--exec [dbo].[usp_InsertWorkflowDetailForTaskId] @VDealFundingID,@WFStatusPurposeMappingID,502,'',498,@CreatedBy,null,null,@DelegatedUserID,@CheckListDetail

				--optimize
				INSERT INTO @tblWorkflowDetail(TaskID,WFStatusPurposeMappingID,TaskTypeID,Comment,SubmitType,CreatedBy,AdditionalComments,SpecialInstructions,DelegatedUserID)
				VALUES(@VDealFundingID,@WFStatusPurposeMappingID,502,'',498,@CreatedBy,null,null,@DelegatedUserID)
			END
		END
		ELSE
		BEGIN
			IF(@wfFundingUpdateFlag = 1)
			BEGIN		
				DECLARE @WF_CurrentStatusID INT
				DECLARE @WF_ReviewStatusID INT

				---old
				--SET @WF_CurrentStatusID = (SELECT (SELECT TOP 1 sm.WFStatusMasterID FROM [CRE].[WFTaskDetail] td 
				--INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
				--INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
				--WHERE TaskId = @DealFundingID and td.TaskTypeID=502
				--ORDER BY WFTaskDetailID DESC ) ) ;	
				
				--new Optimize
				SET @WF_CurrentStatusID =  (Select WFStatusMasterID from @WFCurrentStatus WHERE TaskId = @DealFundingID)				


				SELECT @WF_ReviewStatusID = WFStatusMasterID FROM [CRE].[WFStatusMaster] WHERE StatusName = 'Under Review'

				IF(@WF_CurrentStatusID > @WF_ReviewStatusID)
				BEGIN
					SET @WFStatusPurposeMappingID = (SELECT WFStatusPurposeMappingID FROM [CRE].[WFStatusPurposeMapping] WHERE PurposeTypeID= @PurposeID AND OrderIndex =20)
				END
				ELSE
				BEGIN
					SET @WFStatusPurposeMappingID =  (Select WFStatusPurposeMappingID from @WFCurrentStatus WHERE TaskId = @DealFundingID)
				END
				
				
				--IF(@WF_CurrentStatusID > @WF_ReviewStatusID)
				--BEGIN
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

						--DECLARE  @CheckListDetail tblType_CheckListDetail
						--Submit type - 497 (Save and Draft)
						--exec [dbo].[usp_InsertWorkflowDetailForTaskId] @VDealFundingID,@WFStatusPurposeMappingID,502,@fundingMsg,497,@CreatedBy,null,null,@DelegatedUserID,@CheckListDetail
						
						--optimize
						INSERT INTO @tblWorkflowDetail(TaskID,WFStatusPurposeMappingID,TaskTypeID,Comment,SubmitType,CreatedBy,AdditionalComments,SpecialInstructions,DelegatedUserID)
						VALUES(@VDealFundingID,@WFStatusPurposeMappingID,502,@fundingMsg,497,@CreatedBy,null,null,@DelegatedUserID)
					
					END
				--END



				----START--Insert WF Revised notification----		
				--IF EXISTS(Select WFNotificationMasterID from cre.WFNotificationMaster where name = 'Preliminary Notification' and IsEnable = 1)
				--BEGIN					
		
				--	SET @WFNotificationMasterID = (Select WFNotificationMasterID from cre.WFNotificationMaster where name = 'Preliminary Notification')
				--	SET @MessageHTML = null
				--	SET @AdditionalText = CONVERT(varchar, CAST(@SavedAmount AS money), 1) + '||' + CONVERT(varchar, CAST(@Amount AS money), 1)
				--	SET @ScheduledDateTime = null
				--	SET @ActionType = (Select LookupID from core.lookup where ParentID = 96 and name = 'None')

				--	EXEC [CRE].[usp_InsertUpdateWFNotification] @WFNotificationMasterID,@VDealFundingID,@MessageHTML,@AdditionalText,@ScheduledDateTime,@ActionType,@CreatedBy,null,null
				--END				
				----END--Insert WF Revised notification----
			END



			--Amount decrease 
			ELSE IF(@wfFundingDecreaseFlag = 1)
			BEGIN		
				--DECLARE @WF_CurrentStatusID INT
				--DECLARE @WF_ReviewStatusID INT
				
				-----oLD
				--SET @WF_CurrentStatusID = (SELECT (SELECT TOP 1 sm.WFStatusMasterID FROM [CRE].[WFTaskDetail] td 
				--INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
				--INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
				--WHERE TaskId = @DealFundingID and td.TaskTypeID=502
				--ORDER BY WFTaskDetailID DESC ) ) --as WF_CurrentStatus;			
			
				--new Optimize
				SET @WF_CurrentStatusID =  (Select WFStatusMasterID from @WFCurrentStatus WHERE TaskId = @DealFundingID)	
			
				--old
				---SET @WFStatusPurposeMappingID = (SELECT top 1 td.WFStatusPurposeMappingID FROM [CRE].[WFTaskDetail] td WHERE TaskId = @DealFundingID and td.TaskTypeID=502 ORDER BY WFTaskDetailID DESC ) --as WF_CurrentStatus;			
				
				--New Optimize
				SET @WFStatusPurposeMappingID =  (Select WFStatusPurposeMappingID from @WFCurrentStatus WHERE TaskId = @DealFundingID)
			
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
						--exec [dbo].[usp_InsertWorkflowDetailForTaskId] @VDealFundingID,@WFStatusPurposeMappingID,502,@fundingMsg,497,@CreatedBy,null,null,@DelegatedUserID,@CheckListDetail

						--optimize
						INSERT INTO @tblWorkflowDetail(TaskID,WFStatusPurposeMappingID,TaskTypeID,Comment,SubmitType,CreatedBy,AdditionalComments,SpecialInstructions,DelegatedUserID)
						VALUES(@VDealFundingID,@WFStatusPurposeMappingID,502,@fundingMsg,497,@CreatedBy,null,null,@DelegatedUserID)

					END
				END
				

				----START--Insert WF Revised notification----		
				--IF EXISTS(Select WFNotificationMasterID from cre.WFNotificationMaster where name = 'Preliminary Notification' and IsEnable = 1)
				--BEGIN

				--	SET @WFNotificationMasterID = (Select WFNotificationMasterID from cre.WFNotificationMaster where name = 'Preliminary Notification')
				--	SET @MessageHTML = null
				--	SET @AdditionalText = CONVERT(varchar, CAST(@SavedAmount AS money), 1) + '||' + CONVERT(varchar, CAST(@Amount AS money), 1)
				--	SET @ScheduledDateTime = null
				--	SET @ActionType = (Select LookupID from core.lookup where ParentID = 96 and name = 'None')

				--	EXEC [CRE].[usp_InsertUpdateWFNotification] @WFNotificationMasterID,@VDealFundingID,@MessageHTML,@AdditionalText,@ScheduledDateTime,@ActionType,@CreatedBy,null,null
				--END				
				----END--Insert WF Revised notification----

			END
			--============IF date changed=========================
			ELSE IF(@wfFundDateUpdateFlag = 1)
			BEGIN
				--oLD
				--SET @WF_CurrentStatusID = (SELECT (SELECT TOP 1 sm.WFStatusMasterID FROM [CRE].[WFTaskDetail] td 
				--INNER JOIN [CRE].[WFStatusPurposeMapping] spm ON spm.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID
				--INNER JOIN [CRE].[WFStatusMaster] sm ON sm.WFStatusMasterID = spm.WFStatusMasterID
				--WHERE TaskId = @DealFundingID and td.TaskTypeID=502
				--ORDER BY WFTaskDetailID DESC ) ) 
			
				--SET @WFStatusPurposeMappingID = (SELECT top 1 td.WFStatusPurposeMappingID FROM [CRE].[WFTaskDetail] td WHERE TaskId = @DealFundingID and td.TaskTypeID=502 ORDER BY WFTaskDetailID DESC ) --as WF_CurrentStatus;			
				
				---New Optimize
				SET @WF_CurrentStatusID =  (Select WFStatusMasterID from @WFCurrentStatus WHERE TaskId = @DealFundingID)
				SET @WFStatusPurposeMappingID =  (Select WFStatusPurposeMappingID from @WFCurrentStatus WHERE TaskId = @DealFundingID)


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
						--exec [dbo].[usp_InsertWorkflowDetailForTaskId] @VDealFundingID,@WFStatusPurposeMappingID,502,@fundingMsg,497,@CreatedBy,null,null,@DelegatedUserID,@CheckListDetail

						--optimize
						INSERT INTO @tblWorkflowDetail(TaskID,WFStatusPurposeMappingID,TaskTypeID,Comment,SubmitType,CreatedBy,AdditionalComments,SpecialInstructions,DelegatedUserID)
						VALUES(@VDealFundingID,@WFStatusPurposeMappingID,502,@fundingMsg,497,@CreatedBy,null,null,@DelegatedUserID)

					END
				END
				

				----START--Insert WF Revised notification----		
				--IF EXISTS(Select WFNotificationMasterID from cre.WFNotificationMaster where name = 'Preliminary Notification' and IsEnable = 1)
				--BEGIN

				--	SET @WFNotificationMasterID = (Select WFNotificationMasterID from cre.WFNotificationMaster where name = 'Preliminary Notification')
				--	SET @MessageHTML = null
				--	SET @AdditionalText = Cast(LEFT(DATENAME(WEEKDAY,Cast(@SavedDate as date)),3) +', '+ Format(Cast(@SavedDate as date),'MMM dd, yyyy') as nvarchar(256)) + '||' + Cast(LEFT(DATENAME(WEEKDAY,Cast(@Date as date)),3) +', '+ Format(Cast(@Date as date),'MMM dd, yyyy') as nvarchar(256))
				--	SET @ScheduledDateTime = null
				--	SET @ActionType = (Select LookupID from core.lookup where ParentID = 96 and name = 'None')

				--	EXEC [CRE].[usp_InsertUpdateWFNotification] @WFNotificationMasterID,@VDealFundingID,@MessageHTML,@AdditionalText,@ScheduledDateTime,@ActionType,@CreatedBy,null,null
				--END				
				----END--Insert WF Revised notification----

			END
			--===========================================


		 END
	END

	
	END

	SET @currcount+=1
END
	
	

	--------------------------------
	DECLARE  @tbltype_WorkflowDetail [tbltype_WorkflowDetail] 

	INSERT INTO @tbltype_WorkflowDetail(TaskID,WFStatusPurposeMappingID,TaskTypeID,Comment,SubmitType,CreatedBy,AdditionalComments,SpecialInstructions,DelegatedUserID)
	Select TaskID,WFStatusPurposeMappingID,TaskTypeID,Comment,SubmitType,CreatedBy,AdditionalComments,SpecialInstructions,DelegatedUserID
	from @tblWorkflowDetail
	
	
	exec [dbo].[usp_InsertWorkflowDetailForTaskId_ForDealFunding]  @tbltype_WorkflowDetail
	--------------------------------



	--update checklist item of all the fundings which are in projected status,with the latest wirefram funding
	-- Condition
	--	Check List  item status to be NOT copied (from most recent Wire Confirm record) to succeeding funding’s  except for status type “N/A”.
	--  a. If the Check list item is N/A it should be copied to the succeeding Funding’s  with the comment associated with it.
	--	b. All other Status (other than N/A) should be rolled back to Pending.

	--CheckListStatus = 
	--501: for N/A
	--550: for Pending
	--if 

	  IF (NOT EXISTS(select 1 from cre.deal where DealID=@DealID and [status]=325 and isnull(linkeddealid,'') ='')  
		AND EXISTS(SELECT WFStatusPurposeMappingID FROM [CRE].[WFStatusPurposeMapping] WHERE PurposeTypeID= @PurposeID AND OrderIndex =10 and IsEnable=1)	  )
	  BEGIN
		   IF (@DealID IS NOT NULL and @DealID<>'')
		   BEGIN
				UPDATE [CRE].[WFCheckListDetail]	SET [CRE].[WFCheckListDetail].[CheckListStatus] = tblInCLD.CheckListStatus, 
				[CRE].[WFCheckListDetail].[Comment] = tblInCLD.Comment
				from(
					select wc.TaskID,wc.WFCheckListMasterID,
					(CASE WHEN wc.CheckListStatus = 501 THEN 501 ELSE 550 END ) AS CheckListStatus,
					(CASE WHEN  wc.CheckListStatus = 501 THEN wc.Comment ELSE '' END) Comment  
					from [CRE].[WFCheckListDetail] wc 
					join  cre.WFCheckListMaster wm on wc.WFCheckListMasterID=wm.WFCheckListMasterID
					where taskid in (select top 1 DealFundingID  from CRE.DealFunding where DealID = @DealID and Applied=1 order by [date] desc,DealFundingRowno desc)

					AND wc.WFCheckListMasterID IS NOT NULL 
					--dont copy the checlist status from latest draw for Draw approval checklist
					AND wc.WFCheckListMasterID not in (9,21,6) 
				) as tblInCLD
				--where [CRE].[WFCheckListDetail].TaskId = tblInCLD.TaskId
				--and 
				WHERE [CRE].[WFCheckListDetail].WFCheckListMasterID = tblInCLD.WFCheckListMasterID
				AND [CRE].[WFCheckListDetail].TaskId in 
				(
					SELECT TaskID from [CRE].[WFTaskDetail] t join CRE.DealFunding d on  d.dealfundingID=t.TaskID WHERE WFStatusPurposeMappingID=1
					and DealID=@DealID and Applied<>1 and t.TaskTypeID=502
				)
			END		
	  END

	  --========Inserintologtable======------	
	  --EXEC [dbo].[usp_InsertIntoLogTables] 'DealFunding', @DealID


	  --===================================---


	---Principal write off-----------
	Delete From CRE.DealFunding where DealID = @DealID and PurposeID = 840
	INSERT INTO CRE.DealFunding	(DealID,[Date],Amount,Comment,PurposeID,Applied,NonCommitmentAdj,Issaved,DrawFundingId,DealFundingRowno,EquityAmount,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,DeadLineDate,RequiredEquity,AdditionalEquity,GeneratedBy,GeneratedByUserID,AdjustmentType)		 
	Select @DealID,Date,Amount,Comment,PurposeID,Applied,NonCommitmentAdj,Applied,DrawFundingId,DealFundingRowno,EquityAmount,CreatedBy,GETDATE(),CreatedBy,GETDATE(),dbo.Fn_GetnextWorkingDays(Date,-2,'PMT Date'),RequiredEquity ,AdditionalEquity,GeneratedBy,GeneratedByUserID,AdjustmentType
	From @TempDealFunding_PrincipalWriteOff
	---------------------------------

	---update workflow checklist item 'Outstanding Draw Fees'---
	 exec [usp_UpdateWFCheckListForOutstandingDrawFees] 502,@DealID,''
	--------------------------------
END
GO

