

 
CREATE PROCEDURE [dbo].[usp_InsertUpdateDealArchieveList] 

@TmpDealArch TableTypeDealArchieve READONLY
 

AS
BEGIN
--Insert Deal Fundinge data
	INSERT INTO CRE.DealArchieveTable
	(
		 DealFundingID
		,DealID
		,[Date]
		,Amount
		,Comment
		,PurposeID
		,CreatedBy
		,CreatedDate
		,UpdatedBy
		,UpdatedDate
		,ArchieveBy
		,ArchieveDate
	)
	select  DealFundingID ,
			DealID ,
			[Date] ,
			[Value],
			Comment,
			PurposeID ,
			CreatedBy,
			GETDATE(),
			UpdatedBy,
			GETDATE(),
			UpdatedBy,
			GETDATE() from  @TmpDealArch							
		


--Delete this record from main table
--Delete from CRE.DealFunding where DealFundingID=@DealFundingID and DealID=@DealID
Delete from CRE.DealFunding where DealFundingAutoID in (Select DealFundingAutoID from CRE.DealFunding where DealFundingID in (select DealFundingID from  @TmpDealArch))

IF EXISTS(Select TaskID from cre.WFTaskDetail wf where wf.TaskID in ( select DealFundingID from  @TmpDealArch ))
BEGIN
	Update cre.WFTaskDetail SET IsDeleted=1 where WFTaskDetailID in (Select WFTaskDetailID from cre.WFTaskDetail wf where wf.TaskID in ( select DealFundingID from  @TmpDealArch  ))
	Update cre.WFTaskDetailArchive SET IsDeleted=1 where WFTaskDetailID in (Select WFTaskDetailID from cre.WFTaskDetail wf where wf.TaskID in ( select DealFundingID from  @TmpDealArch)  )
	Update cre.WFCheckListDetail SET IsDeleted=1 where TaskId in ( select DealFundingID from  @TmpDealArch) 
END
------------------------------
----log activity

--delete from app.activitylog where ParentModuleID = @DealID and ParentModuleTypeID=283 and ModuleID = @DealID  and ActivityType=416 and CreatedBy = @CreatedBy
--		   and Cast(CreatedDate as date) = Cast(getdate() as Date)
--		   and DATEDIFF(SECOND, CreatedDate,  getdate()) <10
-- exec dbo.usp_InsertActivityLog @DealID,283,@DealID,416,'Deleted',@CreatedBy



END



