CREATE PROCEDURE [dbo].[usp_InsertNoteExtentionCalcField]  
  
	@CRENoteId Nvarchar(256),  
	@AnalysisID UNIQUEIDENTIFIER,  
	@MaturityUsedInCalc Date,
	@CreatedBy  NVARCHAR(256)
  
AS  
BEGIN  
    SET NOCOUNT ON;

	DECLARE @AccountID UNIQUEIDENTIFIER;  
	SET @AccountID = (Select Account_AccountID from CRE.note n inner join Core.Account ac on n.Account_AccountID=ac.AccountID  where n.CRENoteID = @CRENoteId and ac.IsDeleted=0)  

	--=====================Managing Note and Analysis wise calculator fields
	Delete From [CRE].[NoteExtentionCalcField] Where AccountID = @AccountID AND AnalysisID = @AnalysisID;

	INSERT INTO [CRE].[NoteExtentionCalcField] (AccountID, AnalysisID, SelectedMaturityDate, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate) 
	Values (@AccountID, @AnalysisID, @MaturityUsedInCalc, @CreatedBy, GETDATE(), @CreatedBy, GETDATE());
END