CREATE View [dbo].[WFCheckListDetail]  
AS  
	SELECT	
	     WFCheckListDetailID	
		,TaskId	
		,WFCheckListMasterID	
		,CheckListName	
		,CheckListStatus
		,CheckListStatusText	
		,Comment	
		,IsMandatory	
		,SortOrder	
		,WorkFlowType
		,CreatedBy	
		,CreatedDate	
		,UpdatedBy	
		,UpdatedDate
from  [DW].[WFCheckListDetailBI]

