CREATE Procedure [dbo].[usp_SaveWFDashboard]
@UserID NVarchar(255),
@XMLWFList XML

AS

BEGIN

	SET NOCOUNT ON;

  declare @tWFTaskAdditionalDetail table
  (
	[TaskID] nvarchar(256),
	[TaskTypeID] int,
	[FCApprover] nvarchar(256)
  )
	
	--insert in to temp table from xml
	INSERT INTO @tWFTaskAdditionalDetail 
		SELECT 
		 Pers.value('(TaskID)[1]', 'nvarchar(256)')
		 ,Pers.value('(TaskTypeID)[1]', 'int')
		 ,Pers.value('(UserID)[1]', 'nvarchar(256)')
	FROM @XMLWFList.nodes('/ArrayOfWFDashboardDataContract/WFDashboardDataContract') as t(Pers)



 --update existing record

		UPDATE [CRE].WFTaskAdditionalDetail
		   
		   SET [CRE].WFTaskAdditionalDetail.[FCApprover] = tf.FCApprover
			  ,[UpdatedBy] = @UserID
			  ,[UpdatedDate] = getdate()
			  FROM
			(
			 SELECT [TaskID],[TaskTypeID],[FCApprover] from @tWFTaskAdditionalDetail 
			) tf 
			where cre.WFTaskAdditionalDetail.TaskID = tf.TaskID 
			and cre.WFTaskAdditionalDetail.TaskTypeID=tf.TaskTypeID
			and isnull(tf.FCApprover,'')!=''

END
