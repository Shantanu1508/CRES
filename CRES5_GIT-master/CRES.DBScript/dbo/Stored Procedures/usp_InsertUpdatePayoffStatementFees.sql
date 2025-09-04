CREATE PROCEDURE [dbo].[usp_InsertUpdatePayoffStatementFees]   
	@tblPayoffStatementFees [tbltype_PayoffStatementFees] READONLY,
	@UserID uniqueidentifier
AS  
BEGIN    
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  



	UPDATE [CRE].[PayoffStatementFees]
	SET   CRE.PayoffStatementFees.FeeName = p.FeeName,
	     CRE.PayoffStatementFees.FeeType = p.FeeType,
		 CRE.PayoffStatementFees.[Value] = p.[Value],
		 CRE.PayoffStatementFees.UpdatedBy = @UserID,
		 CRE.PayoffStatementFees.UpdatedDate = getdate(),
		 CRE.PayoffStatementFees.Comment = p.Comment
		 
	 FROM   (SELECT  FeeName, FeeType, Value, DealID, PayoffStatementFeesID, Comment
			 FROM 	@tblPayoffStatementFees
			 WHERE PayoffStatementFeesID <> 0 ) p

WHERE CRE.PayoffStatementFees.DealID = p.DealID and CRE.PayoffStatementFees.PayoffStatementFeesID = p.PayoffStatementFeesID	
	INSERT INTO [CRE].[PayoffStatementFees](
	                DealID,
					FeeName,
					FeeType,
					[Value],
					CreatedBy,
					CreatedDate,
					UpdatedBy,
					UpdatedDate,
					Comment
				 
				)
	SELECT		t.DealID
	            ,t.FeeName
				,t.FeeType
				,t.[Value]
				,@UserID
				,getdate()
				,@UserID
				,getdate()	
				,Comment

	FROM @tblPayoffStatementFees t 
	WHERE t.PayoffStatementFeesID = 0 


SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END
