-- Procedure

CREATE PROCEDURE [dbo].[usp_InsertUpdateWFTaskAdditionalDetail]      
(      
  @XMLAdditionalInfo xml,
  @UserID nvarchar(256)
)       
AS      
BEGIN


declare @TaskID NVARCHAR (256),@AdditionalEmail NVARCHAR (500),@OrgAdditionalEmail NVARCHAR (500),@TaskTypeID INT,@PurposeID INT
declare @tWFTaskAdditionalDetail as table
(
    [TaskID]                   NVARCHAR (256) NULL,
    [TaskTypeID]               INT NULL,
    [ExitFee]                  DECIMAL (28, 15) NULL,
    [ExitFeePercentage]        DECIMAL (28, 15) NULL,
    [PrepayPremium]            DECIMAL (28, 15) NULL,
    [AdditionalEmail]          NVARCHAR (500) NULL
)      

INSERT INTO @tWFTaskAdditionalDetail
           ([TaskID],
            [TaskTypeID],
            [ExitFee],
            [ExitFeePercentage],
            [PrepayPremium],
            [AdditionalEmail]
            )

     SELECT Pers.value('(TaskID)[1]', 'nvarchar(256)'),
		 Pers.value('(TaskTypeID)[1]', 'int'),
		 cast(NULLIF(Pers.value('(ExitFee)[1]', 'nvarchar(256)'),'') as decimal(28, 15)),
		 cast(NULLIF(Pers.value('(ExitFeePercentage)[1]', 'nvarchar(256)'),'') as decimal(28, 15)),
		 cast(NULLIF(Pers.value('(PrepayPremium)[1]', 'nvarchar(256)'),'')  as decimal(28, 15)),
		 Pers.value('(AdditionalEmail)[1]', 'nvarchar(256)')
	FROM @XMLAdditionalInfo.nodes('/WFTaskAdditionalDetailDataContract') as T(Pers)

select @TaskID=[TaskID],@TaskTypeID =TaskTypeID,@AdditionalEmail=AdditionalEmail from @tWFTaskAdditionalDetail
IF (@TaskTypeID=502)
BEGIN
 select @PurposeID=PurposeID from cre.DealFunding where DealFundingID=@TaskID
if (@TaskID is null)
BEGIN

IF (@PurposeID=630)
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
           ,[PrepayPremium]
           ,[AdditionalEmail])
     select TaskID,@UserID,getdate(),@UserID,getdate(),TaskTypeID,ExitFee,ExitFeePercentage,PrepayPremium,AdditionalEmail
     from @tWFTaskAdditionalDetail
     --update AdditionalEmaildate if emailid entered from ui
    
     END
     ELSE
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
           ,[PrepayPremium]
           ,[AdditionalEmail])
     select TaskID,@UserID,getdate(),@UserID,getdate(),TaskTypeID,null,null,null,AdditionalEmail from @tWFTaskAdditionalDetail
     
     END

      if (@AdditionalEmail is not null and @AdditionalEmail<>'')
     BEGIN
        update [CRE].[WFTaskAdditionalDetail] set AdditionalEmailUpdatedDate=GETDATE() where TaskID=@TaskID and TaskTypeID=@TaskTypeID
     END
END
ELSE
BEGIN
     select @OrgAdditionalEmail=AdditionalEmail from [CRE].[WFTaskAdditionalDetail] where TaskID= @TaskID and TaskTypeID=@TaskTypeID
     
     IF (@PurposeID=630)
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

     IF (isnull(@OrgAdditionalEmail,'')<>@AdditionalEmail)
     BEGIN
         update [CRE].[WFTaskAdditionalDetail] set  AdditionalEmail = @AdditionalEmail,AdditionalEmailUpdatedDate=GETDATE() where TaskID=@TaskID and TaskTypeID=@TaskTypeID
     END
END
END

ELSE IF (@TaskTypeID=719)
BEGIN

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
           ,[PrepayPremium]
           ,[AdditionalEmail])
     select TaskID,@UserID,getdate(),@UserID,getdate(),TaskTypeID,null,null,null,AdditionalEmail from @tWFTaskAdditionalDetail

      if (@AdditionalEmail is not null and @AdditionalEmail<>'')
     BEGIN
        update [CRE].[WFTaskAdditionalDetail] set AdditionalEmailUpdatedDate=GETDATE() where TaskID=@TaskID and TaskTypeID=@TaskTypeID
     END
END
ELSE
BEGIN
     select @OrgAdditionalEmail=AdditionalEmail from [CRE].[WFTaskAdditionalDetail] where TaskID= @TaskID and TaskTypeID=@TaskTypeID

     IF (isnull(@OrgAdditionalEmail,'')<>@AdditionalEmail)
     BEGIN
         update [CRE].[WFTaskAdditionalDetail] set  AdditionalEmail = @AdditionalEmail,AdditionalEmailUpdatedDate=GETDATE() where TaskID=@TaskID and TaskTypeID=@TaskTypeID
     END
END
END
END
GO

