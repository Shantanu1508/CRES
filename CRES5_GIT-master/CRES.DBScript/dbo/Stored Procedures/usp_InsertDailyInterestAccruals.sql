  
CREATE PROCEDURE [dbo].[usp_InsertDailyInterestAccruals]   
@TableTypeDailyInterest [TableTypeDailyInterestAccruals] READONLY,  
@NoteId UNIQUEIDENTIFIER,  
@CreatedBy  nvarchar(256)  
  
AS  
BEGIN  
    SET NOCOUNT ON;  


DECLARE @AnalysisID UNIQUEIDENTIFIER; 
SET @AnalysisID = (Select Top 1 AnalysisID from @TableTypeDailyInterest)


IF (@AnalysisID is not null)
BEGIN
	 
	DELETE FROM [CRE].[DailyInterestAccruals] WHERE [NoteID]=@NoteId  and AnalysisID = @AnalysisID  
	INSERT INTO [CRE].[DailyInterestAccruals]
           (
			[NoteID]
			,[Date]
			,DailyInterestAccrual
			,EndingBalance
			,[AnalysisID]
			,SpreadOrRate
			,IndexRate
			,AllInCouponRate
			,AllInPikRate
			,PikSpreadOrRate
			,PIKIndexRate          
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
		   ) 
	 Select  
		@NoteId  
		,[Date]  
		,DailyInterestAccrual  	 
		,EndingBalance
		,AnalysisID 
		,SpreadOrRate
		,IndexRate
		,AllInCouponRate
		,AllInPikRate
		,PikSpreadOrRate
		,PIKIndexRate          
		,@CreatedBy  
		,GETDATE()  
		,@CreatedBy  
		,GETDATE() 	 
	 FROM @TableTypeDailyInterest 
 
 END  
  
END  


