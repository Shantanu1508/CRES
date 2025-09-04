  
CREATE PROCEDURE [dbo].[usp_InsertPeriodicInterestRateUsed]   
@TableTypeDailyInterest [TableTypePeriodicInterestRateUsed] READONLY,  
@NoteId UNIQUEIDENTIFIER,  
@CreatedBy  nvarchar(256)  
  
AS  
BEGIN  
    SET NOCOUNT ON;  


DECLARE @AnalysisID UNIQUEIDENTIFIER; 
SET @AnalysisID = (Select Top 1 AnalysisID from @TableTypeDailyInterest)


IF (@AnalysisID is not null)
BEGIN
	 
	DELETE FROM [CRE].[PeriodicInterestRateUsed] WHERE [NoteID]=@NoteId  and AnalysisID = @AnalysisID  
	INSERT INTO [CRE].[PeriodicInterestRateUsed]
           (
			[NoteID]
			,[Date]
			,CouponSpread
			,AllInCouponRate
			,AllInPikRate
			,LiborRate
			,IndexFloor
			,CouponRate
			,AdditionalPIKinterestRatefromPIKTable
			,AdditionalPIKSpreadfromPIKTable
			,PIKIndexFloorfromPIKTable 
           ,[AnalysisID]		  
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
		    ,IsPaymentDate) 
	 Select  
		@NoteId  
		,[Date]  
		,CouponSpread
		,AllInCouponRate
		,AllInPikRate
		,LiborRate
		,IndexFloor
		,CouponRate
		,AdditionalPIKinterestRatefromPIKTable
		,AdditionalPIKSpreadfromPIKTable
		,PIKIndexFloorfromPIKTable
		,AnalysisID		
		,@CreatedBy  
		,GETDATE()  
		,@CreatedBy  
		,GETDATE() 	 
		,IsPaymentDate
		FROM @TableTypeDailyInterest 
 
 END  
  
END  


