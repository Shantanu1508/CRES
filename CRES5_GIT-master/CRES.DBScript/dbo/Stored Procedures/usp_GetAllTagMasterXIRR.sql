CREATE PROCEDURE [dbo].[usp_GetAllTagMasterXIRR] 
  @UserID UNIQUEIDENTIFIER
AS  
BEGIN  
  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
   

	SELECT  t.TagMasterXIRRID
		   ,t.Name 
		   ,t.CreatedBy      
		   ,t.CreatedDate     
		   ,t.UpdatedBy      
		   ,t.UpdatedDate
		   ,(CASE WHEN z.TagMasterXIRRID is not null THEN 1 ELSE 0 END)as  IsTagAssociate
	FROM CRE.TagMasterXIRR t
	left join(
		Select distinct TagMasterXIRRID from  [CRE].[TagAccountMappingXIRR] 
	)z on z.TagMasterXIRRID = t.TagMasterXIRRID
	order by t.Name asc




 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
  
  
  