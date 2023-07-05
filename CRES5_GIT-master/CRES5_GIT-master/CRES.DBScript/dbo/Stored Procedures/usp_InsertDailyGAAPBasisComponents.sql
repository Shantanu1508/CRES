  
CREATE PROCEDURE [dbo].[usp_InsertDailyGAAPBasisComponents]   
@TableTypeDailyGAAPBasisComponents [TableTypeDailyGAAPBasisComponents] READONLY,  
@NoteId UNIQUEIDENTIFIER,  
@CreatedBy  nvarchar(256)  
  
AS  
BEGIN  
    SET NOCOUNT ON;  


DECLARE @AnalysisID UNIQUEIDENTIFIER; 
SET @AnalysisID = (Select Top 1 AnalysisID from @TableTypeDailyGAAPBasisComponents)


IF (@AnalysisID is not null)
BEGIN
	 
	DELETE FROM [CRE].DailyGAAPBasisComponents WHERE [NoteID]=@NoteId  and AnalysisID = @AnalysisID  
	INSERT INTO [CRE].DailyGAAPBasisComponents
           (
				 NoteID                     
				,[Date]                      
				,AccumAmortofDeferredFees       
				,AccumulatedAmortofDiscountPremium      
				,AccumulatedAmortofCapitalizedCost 				
				,EndingBalance  
				,GrossDeferredFees   
				,CleanCost  
				,CurrentPeriodInterestAccrualPeriodEnddate  
				,CurrentPeriodPIKInterestAccrualPeriodEnddate  
				,InterestSuspenseAccountBalance   
				,AnalysisID 
				,CreatedBy 
				,CreatedDate   
				,UpdatedBy   
				,UpdatedDate  
				) 
	 Select  
			@NoteID                     
			,[Date]                      
			,AccumAmortofDeferredFees       
			,AccumulatedAmortofDiscountPremium      
			,AccumulatedAmortofCapitalizedCost 
			,EndingBalance  
			,GrossDeferredFees   
			,CleanCost  
			,CurrentPeriodInterestAccrualPeriodEnddate  
			,CurrentPeriodPIKInterestAccrualPeriodEnddate  
			,InterestSuspenseAccountBalance   
			,AnalysisID 
			,@CreatedBy  
			,GETDATE()  
			,@CreatedBy  
			,GETDATE() 	 
	 FROM @TableTypeDailyGAAPBasisComponents 
 
 END  
  
END