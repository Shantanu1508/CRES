      
CREATE PROCEDURE [dbo].[usp_InsertUpdateWFTaskAdditionalDetail]      
(      
  @XMLAdditionalInfo xml,
  @UserID nvarchar(256)
)       
AS      
BEGIN
declare @TaskID NVARCHAR (256)
declare @tWFTaskAdditionalDetail as table
(
    [TaskID]                   NVARCHAR (256) NULL,
    [TaskTypeID]               INT NULL,
    [ExitFee]                  DECIMAL (28, 15) NULL,
    [ExitFeePercentage]        DECIMAL (28, 15) NULL,
    [PrepayPremium]            DECIMAL (28, 15) NULL
)      

INSERT INTO @tWFTaskAdditionalDetail
           ([TaskID],
            [TaskTypeID],
            [ExitFee],
            [ExitFeePercentage],
            [PrepayPremium]
            )

     SELECT Pers.value('(TaskID)[1]', 'nvarchar(256)'),
		 Pers.value('(TaskTypeID)[1]', 'int'),
		 cast(NULLIF(Pers.value('(ExitFee)[1]', 'nvarchar(256)'),'') as decimal(28, 15)),
		 cast(NULLIF(Pers.value('(ExitFeePercentage)[1]', 'nvarchar(256)'),'') as decimal(28, 15)),
		 cast(NULLIF(Pers.value('(PrepayPremium)[1]', 'nvarchar(256)'),'')  as decimal(28, 15))	
	FROM @XMLAdditionalInfo.nodes('/WFTaskAdditionalDetailDataContract') as T(Pers)

select @TaskID=[TaskID] from @tWFTaskAdditionalDetail
if (@TaskID is null)
BEGIN
INSERT INTO [CRE].[WFTaskAdditionalDetail]
           ([TaskID]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
           ,[TaskTypeID]
           ,[ExitFee]
           ,[ExitFeePercentage]
           ,[PrepayPremium])
     select TaskID,@UserID,getdate(),@UserID,getdate(),TaskTypeID,ExitFee,ExitFeePercentage,PrepayPremium
     from @tWFTaskAdditionalDetail
END
ELSE
BEGIN
     update [CRE].[WFTaskAdditionalDetail]
     set [CRE].[WFTaskAdditionalDetail].ExitFee=tbl.ExitFee,
     [CRE].[WFTaskAdditionalDetail].ExitFeePercentage=tbl.ExitFeePercentage,
     [CRE].[WFTaskAdditionalDetail].PrepayPremium=tbl.PrepayPremium,
     [CRE].[WFTaskAdditionalDetail].UpdatedBy=@UserID,
     [CRE].[WFTaskAdditionalDetail].UpdatedDate=getdate()
     from
     (
     select TaskID,TaskTypeID,ExitFee,ExitFeePercentage,PrepayPremium
     from @tWFTaskAdditionalDetail
     ) tbl
     where [CRE].[WFTaskAdditionalDetail].TaskID=tbl.TaskID
END
END  
  