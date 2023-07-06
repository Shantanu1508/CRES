

CREATE PROCEDURE [dbo].[usp_InsertDrawFeeActivityLog] 
 @TaskID nvarchar(max),
 @Comment  nvarchar(max) = null,
 @CreatedBy nvarchar(256),
 @DelegatedUserID nvarchar(256)
 
AS
BEGIN
 
 declare @WFStatusPurposeMappingID int ,@TaskTypeID int

 select top 1 @WFStatusPurposeMappingID=WFStatusPurposeMappingID,@TaskTypeID=TaskTypeID  from CRE.WFTaskDetail 
 where taskid=@TaskID order by WFTaskDetailID desc
   if (@CreatedBy is null or @CreatedBy='')
      begin
       set @CreatedBy='00000000-0000-0000-0000-000000000000'
	  end

 INSERT INTO [CRE].[WFTaskDetail]
           ([WFStatusPurposeMappingID]
           ,[TaskID]
           ,[TaskTypeID]
           ,[Comment]
           ,[SubmitType]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
		   ,[DelegatedUserID])
		 VALUES
			(
			@WFStatusPurposeMappingID,
			@TaskID,
			@TaskTypeID,
			(case when (@Comment IS NULL or @Comment='') then 'Checklist updated' else @Comment end),
			497,
			@CreatedBy,
			getdate(),
			@CreatedBy,
			getdate(),
			@DelegatedUserID
			)

END
          