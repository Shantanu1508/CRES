Declare @TaskID nvarchar(max)
Declare @WFStatusPurposeMappingID int
Declare @TaskTypeID int
Declare @Comment  nvarchar(max)
Declare @SubmitType int
Declare @CreatedBy nvarchar(256)


IF CURSOR_STATUS('global','CursorWorkFlow')>=-1
BEGIN
	DEALLOCATE CursorWorkFlow
END

DECLARE CursorWorkFlow CURSOR 
for
(
	Select 
	DealFundingID as TaskID,
	(Select WFStatusPurposeMappingID from cre.WFStatusPurposeMapping where OrderIndex = 10 and PurposeTypeId = df.PurposeID) as WFStatusPurposeMappingID,
	502 as TaskTypeID,
	null as Comment,
	498 as SubmitType,
	'B0E6697B-3534-4C09-BE0A-04473401AB93' as CreatedBy
	from cre.dealfunding df
	where PurposeID in (Select lookupID from core.lookup where [name] in ('Additional Collateral Purchase') and ParentID = 50) --,,'Note Transfer'
	--and dealid <> 'FDD8EC03-9D63-4512-9990-89C508983EDC'
	and Applied = 0
	and df.dealfundingid not in (Select taskid from cre.wftaskdetail)
	--order by DealID,[date]
)
OPEN CursorWorkFlow 

FETCH NEXT FROM CursorWorkFlow
INTO @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,@Comment,@SubmitType,@CreatedBy
WHILE @@FETCH_STATUS = 0
BEGIN


	Print(@TaskID)
	DECLARE  @CheckListDetail tblType_CheckListDetail
	exec [dbo].[usp_InsertWorkflowDetailForTaskId] @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,@Comment,@SubmitType,@CreatedBy,null,null,null,@CheckListDetail
		
					 
FETCH NEXT FROM CursorWorkFlow
INTO @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,@Comment,@SubmitType,@CreatedBy
END
CLOSE CursorWorkFlow   
DEALLOCATE CursorWorkFlow