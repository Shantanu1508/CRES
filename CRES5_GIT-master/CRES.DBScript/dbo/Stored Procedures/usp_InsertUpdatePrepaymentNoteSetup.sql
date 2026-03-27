CREATE PROCEDURE [dbo].[usp_InsertUpdatePrepaymentNoteSetup]   
	@tbltypePreNoteSetup [tbltype_PrepaymentNoteSetup] READONLY,
	@UserID uniqueidentifier
AS  
BEGIN    
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  



	UPDATE [CRE].[PrepaymentNoteSetup]
	SET  CRE.PrepaymentNoteSetup.NoteID = p.NoteID,
	     CRE.PrepaymentNoteSetup.AttributeName = p.AttributeName,
		 CRE.PrepaymentNoteSetup.AttributeValue = p.AttributeValue,
		 CRE.PrepaymentNoteSetup.UpdatedBy = @UserID,
		 CRE.PrepaymentNoteSetup.UpdatedDate = getdate(),
		 CRE.PrepaymentNoteSetup.IsDeleted = p.IsDeleted

	 FROM   (SELECT  NoteID, AttributeName, AttributeValue, DealID, PrepaymentNoteSetupID, IsDeleted
			 FROM 	@tbltypePreNoteSetup
			 WHERE PrepaymentNoteSetupID <> 0) p

WHERE CRE.PrepaymentNoteSetup.DealID = p.DealID and CRE.PrepaymentNoteSetup.PrepaymentNoteSetupID = p.PrepaymentNoteSetupID
	
	INSERT INTO [CRE].[PrepaymentNoteSetup](
	                DealID,
					NoteID,
					AttributeName,
					AttributeValue,
					CreatedBy,
					CreatedDate,
					UpdatedBy,
					UpdatedDate,
					IsDeleted
				)
	SELECT		t.DealID
	            ,t.NoteID
				,t.AttributeName
				,t.AttributeValue
				,@UserID
				,getdate()
				,@UserID
				,getdate()
				,t.IsDeleted

	FROM @tbltypePreNoteSetup t 
	WHERE t.PrepaymentNoteSetupID = 0 and ISNULL(t.IsDeleted,0)<>1


SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END
