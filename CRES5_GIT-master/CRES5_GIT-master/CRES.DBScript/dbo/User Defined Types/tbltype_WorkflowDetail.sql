CREATE TYPE [dbo].[tbltype_WorkflowDetail] AS TABLE
(
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
