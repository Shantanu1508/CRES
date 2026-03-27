CREATE PROCEDURE [dbo].[usp_InsertUpdateTagMasterXIRR]   
	@TabletypXIRR [TableTypeTagMasterXIRR] READONLY,
	@UserID uniqueidentifier
AS  
BEGIN    
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  



	UPDATE [CRE].[TagMasterXIRR]
	SET  CRE.TagMasterXIRR.Name = a.Name,
		 CRE.TagMasterXIRR.UpdatedBy = @UserID,
		 CRE.TagMasterXIRR.UpdatedDate = getdate()

	 FROM   (SELECT  Name, TagMasterXIRRID 
			 FROM 	@TabletypXIRR
			 WHERE TagMasterXIRRID <> 0) a

WHERE CRE.TagMasterXIRR.TagMasterXIRRID = a.TagMasterXIRRID
	
	INSERT INTO CRE.TagMasterXIRR(
					Name,
					CreatedBy,
					CreatedDate,
					UpdatedBy,
					UpdatedDate
				)
	SELECT		t.Name
				,@UserID
				,getdate()
				,@UserID
				,getdate()

	FROM @TabletypXIRR t 
	WHERE t.TagMasterXIRRID = 0


SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END
