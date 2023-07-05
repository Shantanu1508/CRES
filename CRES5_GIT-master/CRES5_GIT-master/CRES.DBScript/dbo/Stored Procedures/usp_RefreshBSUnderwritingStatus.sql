    
    
CREATE PROCEDURE [dbo].[usp_RefreshBSUnderwritingStatus]     
 @BatchName nvarchar(256),    
 @UserID UNIQUEIDENTIFIER    
AS    
BEGIN    
 SET NOCOUNT ON;      
      
  

  ----=========Kill Process If running more than 2 hour's
	IF ((Select top 1 Status2 from dw.batchlog where BatchName = @BatchName order by batchlogid desc) = 'Process Running')  
	BEGIN  
		--Print('Process is Running.');  
		Declare @BSDate Datetime
		Declare @BLID Int
		Select top 1 @BSDate = BatchStartTime ,@BLID = batchlogid
		from dw.batchlog where BatchName = @BatchName and Status2 = 'Process Running' order by batchlogid desc	
	
		IF(ABS(DateDiff(hour,getdate(),@BSDate)) >= 1)
		BEGIN
			--Print('Process is Running too long.');  
			--Delete from dw.BatchDetail where batchlogid = @BLID
			--Delete from dw.BatchLog where batchlogid = @BLID
			Delete from dw.batchDetail where batchlogid in (Select batchlogID from dw.batchlog where BatchName = @BatchName and Status2 = 'Process Running')
			Delete from dw.batchlog where BatchName = @BatchName and Status2 = 'Process Running'
		END

	END
	----================================

	IF EXISTS(SELECT top 1 Status2  FROM DW.BatchLog WHERE BatchName= @BatchName  order by BatchLogId desc)
	BEGIN
		SELECT top 1 Status2  FROM DW.BatchLog WHERE BatchName= @BatchName  order by BatchLogId desc    
	END
	ELSE
	BEGIN
		SELECT top 1 'Completed' Status2  
	END
  

    
     
END 



