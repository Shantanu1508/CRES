CREATE PROCEDURE [dbo].[usp_InsertUpdatePrepaymentNoteAllocationSetup]   
	@tbltypePreNoteAllocSetup [tbltype_PrepaymentNoteAllocationSetup] READONLY,
	@UserID uniqueidentifier
AS  
BEGIN    
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  



	UPDATE [CRE].[PrepaymentNoteAllocationSetup]
	SET  CRE.PrepaymentNoteAllocationSetup.NoteID = p.NoteID,
	     CRE.PrepaymentNoteAllocationSetup.GroupID = p.GroupID,
		 CRE.PrepaymentNoteAllocationSetup.GroupPriority = p.GroupPriority,
		 CRE.PrepaymentNoteAllocationSetup.Exclude = p.Exclude,
		 CRE.PrepaymentNoteAllocationSetup.UpdatedBy = @UserID,
		 CRE.PrepaymentNoteAllocationSetup.UpdatedDate = getdate()

	 FROM   (SELECT  NoteID, GroupID, GroupPriority, Exclude, DealID, PrepaymentNoteAllocationSetupID
			 FROM 	@tbltypePreNoteAllocSetup
			 WHERE PrepaymentNoteAllocationSetupID <> 0) p

WHERE CRE.PrepaymentNoteAllocationSetup.DealID = p.DealID and CRE.PrepaymentNoteAllocationSetup.PrepaymentNoteAllocationSetupID = p.PrepaymentNoteAllocationSetupID
	
	INSERT INTO [CRE].[PrepaymentNoteAllocationSetup](
	                DealID,
					NoteID,
					GroupID,
					GroupPriority,
					Exclude,
					CreatedBy,
					CreatedDate,
					UpdatedBy,
					UpdatedDate
				)
	SELECT		t.DealID
	            ,t.NoteID
				,t.GroupID
				,t.GroupPriority
				,t.Exclude
				,@UserID
				,getdate()
				,@UserID
				,getdate()

	FROM @tbltypePreNoteAllocSetup t 
	WHERE t.PrepaymentNoteAllocationSetupID = 0


SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END
