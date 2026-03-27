CREATE PROCEDURE [dbo].[usp_InsertUpdateLiabilityNoteFromExcel]        
(        
		@LiabilityNoteAutoID    INT , 	
		@PaymentFrequency                        INT             ,
		@AccrualEndDateBusinessDayLag			 INT             ,
		@AccrualFrequency                        INT             ,
		@Roundingmethod                          INT             ,
		@IndexRoundingRule                       INT             ,	 
		@UseNoteLevelOverride bit,
		@UserID nvarchar(256) 
)         
AS        
BEGIN        
  
		UPDATE CRE.LiabilityNote SET 	 
	 
			PaymentFrequency = @PaymentFrequency                      
			,AccrualEndDateBusinessDayLag	= @AccrualEndDateBusinessDayLag		  
			,AccrualFrequency = @AccrualFrequency                       
			,Roundingmethod = @Roundingmethod                         
			,IndexRoundingRule = @IndexRoundingRule                      
	        ,UseNoteLevelOverride=@UseNoteLevelOverride
			  ,[UpdatedBy] = @UserID        
            ,[UpdatedDate] = GETDATE()        
		
		WHERE LiabilityNoteAutoID = @LiabilityNoteAutoID   
   
  
END  