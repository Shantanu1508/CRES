CREATE PROCEDURE [dbo].[usp_CheckWorkflowConcurrency]
	@UserID nvarchar(256),
	@xmlWorkflow xml
AS
	BEGIN
		declare @Status int=0,
		--@CheckListCnt int =6,
		--@SpecialInstruction nvarchar(500),
		--@AdditionalComment nvarchar(500),
		--@AdditionalEmail nvarchar(500),

		@TaskTypeID int,
		@TaskID nvarchar(500),
		@WFStatusPurposeMappingID int

		declare @WFDetail as table
		(
		  TaskTypeID int,
		  TaskID nvarchar(500),
		  WFStatusPurposeMappingID int
		)

		INSERT INTO @WFDetail
		select 
		Pers.value('(TaskTypeID)[1]', 'INT'),
		ISNULL(nullif(Pers.value('(TaskID)[1]', 'varchar(256)'), ''),'00000000-0000-0000-0000-000000000000'),  
		Pers.value('(WFStatusPurposeMappingID)[1]', 'INT')
		FROM @xmlWorkflow.nodes('/WFConcurrencyParams') as t(Pers)
		
		select @TaskTypeID=TaskTypeID,@TaskID=TaskID,@WFStatusPurposeMappingID=WFStatusPurposeMappingID from @WFDetail
		
		if Not exists (
		select 1 from cre.WFTaskDetail where TaskID=@TaskID
		and TaskTypeID=@TaskTypeID
		and WFStatusPurposeMappingID=@WFStatusPurposeMappingID
		)
		BEGIN
			SET @Status=1
		END
		--ELSE if (select count(1) from CRE.WFCheckListDetail where TaskID='16e28975-e68b-41cc-9cd7-df66879f1f33' 
		--and TaskTypeID=502)<>@CheckListCnt
		--BEGIN
		--	SET @Status=1
		--END
		--ELSE if not exists (select 1 from cre.WFTaskAdditionalDetail where TaskID='16e28975-e68b-41cc-9cd7-df66879f1f33'
		--and TaskTypeID=502
		--and isnull(SpecialInstruction,'')=isnull(@SpecialInstruction,'')
		--and isnull(AdditionalComment,'')=isnull(@AdditionalComment,'')
		--and isnull(AdditionalEmail,'')=isnull(@AdditionalComment,'')
		--)
		--BEGIN
		--	SET @Status=1
		--END

		select @Status as [Status]
END