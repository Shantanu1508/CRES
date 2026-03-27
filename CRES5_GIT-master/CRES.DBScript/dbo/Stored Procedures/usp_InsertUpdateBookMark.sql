-- Procedure
-- Procedure
CREATE PROCEDURE [dbo].[usp_InsertUpdateBookMark]
@UserId  NVARCHAR (256),
@AccountId UNIQUEIDENTIFIER,
@IsBookMark NVARCHAR (10)
AS
BEGIN
    SET NOCOUNT ON;

	IF(@IsBookMark = 'Unpin')
	BEGIN
		Delete From [CRE].[BookMark] where [UserID] = @UserId and AccountID = @AccountId
	END

	ELSE IF(@IsBookMark = 'Pin')
	BEGIN
		Delete From [CRE].[BookMark] where [UserID] = @UserId and AccountID = @AccountId

		INSERT INTO [CRE].[BookMark]
		(                             
		 [AccountID]
		,[UserID]
		,[CreatedBy]                        
		,[CreatedDate]                      
		,[UpdatedBy]                        
		,[UpdatedDate]                     
	     )
		VALUES
		(
		 @AccountId 
		,@UserId
		,@UserId
		,GETDATE()	
		,@UserId
		,GETDATE()
		)
	END
END
GO

