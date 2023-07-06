CREATE View [dbo].[WFTaskDetail]  
AS  
	SELECT	
		  WFTaskDetailID
		 ,WFStatusPurposeMappingID
		 ,TaskID	
		 ,TaskTypeID
		 ,TaskTypeBI	
		 ,Comment	
		 ,SubmitType
		 ,SubmitTypeBI	
		 ,CreatedBy	
		 ,CreatedDate	
		 ,UpdatedBy	
		 ,UpdatedDate	
		 ,IsDeleted	
		 ,DelegatedUserID
		 ,SpecialInstruction
		 ,AdditionalComment
		 ,WFGroupText
		 ,StatusName
		 ,StatusDisplayName
		 ,DealFundingDisplayName
		 ,WFUnderReviewDisplayName
		 ,WFFinalStatus as WFCurrentStatus
	FROM [DW].[WFTaskDetailBI]

