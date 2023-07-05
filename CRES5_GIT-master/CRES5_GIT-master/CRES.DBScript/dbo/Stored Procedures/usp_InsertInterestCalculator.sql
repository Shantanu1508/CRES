  
CREATE PROCEDURE [dbo].[usp_InsertInterestCalculator]  
  
@TableTypeTransactionEntry [TableTypeInterestCalculator] READONLY,  
@NoteId UNIQUEIDENTIFIER,  
@CreatedBy  nvarchar(256)  
  
AS  
BEGIN  
    SET NOCOUNT ON;  


DECLARE @AnalysisID UNIQUEIDENTIFIER; 
SET @AnalysisID = (Select Top 1 AnalysisID from @TableTypeTransactionEntry)


IF (@AnalysisID is not null)
BEGIN
  
	Declare @ID uniqueidentifier;  
  
	DELETE FROM [CRE].[InterestCalculator] WHERE [NoteID]=@NoteId  and AnalysisID = @AnalysisID
  
	INSERT INTO [CRE].[InterestCalculator]
           ([NoteID]
           ,[AccrualStartDate]
           ,[AccrualEndDate]
           ,[PaymentDate]
           ,[BeginningBalance]
           ,[AnalysisID]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]) 
	 Select  
	  @NoteId  
	 ,AccrualStartDate  
	 ,AccrualEndDate  
	 ,PaymentDate  
	 ,BeginningBalance
	 ,AnalysisID 
	 ,@CreatedBy  
	 ,GETDATE()  
	 ,@CreatedBy  
	 ,GETDATE() 	 
	 FROM @TableTypeTransactionEntry  
 
 END
 
  
  
END  
