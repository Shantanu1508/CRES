CREATE PROCEDURE [dbo].[usp_InsertUpdateDebtOneTimeUpdate]      
(   
	@DebtID int,
	@AccountID UNIQUEIDENTIFIER, 
	@OriginationDate	Date	,
	@UserID nvarchar(256)
	
 )
AS      
BEGIN    
 
	UPDATE CRE.Debt SET   
		OriginationDate = @OriginationDate 
		,[UpdatedBy] = @UserID      
		,[UpdatedDate] = GETDATE()  
		WHERE DebtID = @DebtID 

 
      
END
GO

