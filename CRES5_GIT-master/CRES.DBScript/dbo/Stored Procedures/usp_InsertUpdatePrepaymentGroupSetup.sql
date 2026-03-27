CREATE PROCEDURE [dbo].[usp_InsertUpdatePrepaymentGroupSetup]   
	@tbltypePreGroupSetup [tbltype_PrepaymentGroupSetup] READONLY,
	@UserID uniqueidentifier
AS  
BEGIN    
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  



	UPDATE [CRE].[PrepaymentGroupSetup]
	SET  CRE.PrepaymentGroupSetup.GroupId = p.GroupId,
	     CRE.PrepaymentGroupSetup.AttributeName = p.AttributeName,
		 CRE.PrepaymentGroupSetup.AttributeValue = p.AttributeValue,
		 CRE.PrepaymentGroupSetup.UpdatedBy = @UserID,
		 CRE.PrepaymentGroupSetup.UpdatedDate = getdate(),
		 CRE.PrepaymentGroupSetup.IsDeleted = p.IsDeleted

	 FROM   (SELECT  GroupId, AttributeName, AttributeValue, DealID, PrepaymentGroupSetupID, IsDeleted
			 FROM 	@tbltypePreGroupSetup
			 WHERE PrepaymentGroupSetupID <> 0 ) p

WHERE CRE.PrepaymentGroupSetup.DealID = p.DealID and CRE.PrepaymentGroupSetup.PrepaymentGroupSetupID = p.PrepaymentGroupSetupID
	
	INSERT INTO [CRE].[PrepaymentGroupSetup](
	                DealID,
					GroupId,
					AttributeName,
					AttributeValue,
					CreatedBy,
					CreatedDate,
					UpdatedBy,
					UpdatedDate,
					IsDeleted
				)
	SELECT		t.DealID
	            ,t.GroupId
				,t.AttributeName
				,t.AttributeValue
				,@UserID
				,getdate()
				,@UserID
				,getdate()
				,t.IsDeleted

	FROM @tbltypePreGroupSetup t 
	WHERE t.PrepaymentGroupSetupID = 0 and ISNULL(t.IsDeleted,0)<>1


SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END
