CREATE PROCEDURE [dbo].[usp_GetWFStatusPurposeMapping]  --'b0e6697b-3534-4c09-be0a-04473401ab93'
    @UserID UNIQUEIDENTIFIER
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	SELECT
			WFStatusPurposeMappingID,	
			WFStatusMasterID,	
			PurposeTypeId,	
			OrderIndex,
			IsEnable,	
			wfspm.CreatedBy,	
			wfspm.CreatedDate,	
			wfspm.UpdatedBy,	
			wfspm.UpdatedDate,
			l.Name as PurposeTypeText,
			l1.[Value] as AutospreadValueText,
			l2.Value1 as WFValueText 
	FROM [CRE].[WFStatusPurposeMapping]  wfspm
	left join core.lookup l on l.lookupid = wfspm.PurposeTypeId
	left join core.lookup l1 on l1.lookupid = wfspm.PurposeTypeId
	left join core.lookup l2 on l2.lookupid = wfspm.PurposeTypeId
	WHERE IsEnable=1

 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END    

select * from core.lookup where parentid=50

