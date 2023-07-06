
CREATE PROCEDURE [dbo].[usp_InitiateWorkFlowForDeal]  
(
	@dealid Uniqueidentifier,
	@CreatedBy nvarchar(256),
	@DelegatedUserID nvarchar(256) = null
)
AS  
BEGIN  
 
 SET NOCOUNT ON;



Declare @TaskID nvarchar(max)
Declare @WFStatusPurposeMappingID int
Declare @TaskTypeID int
Declare @Comment  nvarchar(max)
Declare @SubmitType int


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
	@CreatedBy as CreatedBy
	from cre.dealfunding df
	inner join cre.deal d on d.dealid = df.dealid
	where PurposeID in (Select Distinct PurposeTypeId from CRE.WFStatusPurposeMapping) --(Select lookupID from core.lookup where [name] = 'Capital Expenditure' and ParentID = 50)	
	and Applied = 0
	and df.dealfundingid not in (Select taskid from cre.wftaskdetail)
	and d.[Status] <> 325 and nullif(d.linkeddealid,'') is null --Only for legal deals
	and d.dealid = @dealid
	
)
OPEN CursorWorkFlow 

FETCH NEXT FROM CursorWorkFlow
INTO @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,@Comment,@SubmitType,@CreatedBy
WHILE @@FETCH_STATUS = 0
BEGIN
	
	DECLARE  @CheckListDetail tblType_CheckListDetail
	exec [dbo].[usp_InsertWorkflowDetailForTaskId] @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,@Comment,@SubmitType,@CreatedBy,null,null,@DelegatedUserID,@CheckListDetail
		
					 
FETCH NEXT FROM CursorWorkFlow
INTO @TaskID,@WFStatusPurposeMappingID,@TaskTypeID,@Comment,@SubmitType,@CreatedBy
END
CLOSE CursorWorkFlow   
DEALLOCATE CursorWorkFlow


END
