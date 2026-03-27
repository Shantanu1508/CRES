--Drop PROCEDURE [dbo].[usp_InsertUpdateAdjustedTotalCommitment]      
CREATE PROCEDURE [dbo].[usp_InsertUpdateAdjustedTotalCommitment]      
      
@TableAdjustedTotalCommitment [TableAdjustedTotalCommitment] READONLY,      
@UserID uniqueidentifier      
      
      
AS       
BEGIN        
SET NOCOUNT ON;       
  
DECLARE  @rownumberOuter int;      
Declare @DealID uniqueidentifier = (SELECT Top 1 DealID FROM @TableAdjustedTotalCommitment)      
      
--------============Delete table NoteAdjustedCommitmentMaster==============------      
 DELETE FROM CRE.NoteAdjustedCommitmentDetail WHERE DealID = @DealID  --and type<>690       
 DELETE FROM CRE.NoteAdjustedCommitmentMaster WHERE DealID = @DealID  --and type<>690 
      
-----==== Declaring cursor to insert row by row ==========----------      
IF CURSOR_STATUS('global','row_cursor')>= -1          
BEGIN            
DEALLOCATE row_cursor          
END    
DECLARE row_cursor CURSOR     
FOR      
(        
 SELECT  distinct ttc.Rownumber FROM @TableAdjustedTotalCommitment ttc      
)       
OPEN row_cursor         
        
FETCH NEXT FROM row_cursor           
INTO  @rownumberOuter      
        
WHILE @@FETCH_STATUS = 0              
BEGIN         
    
DECLARE  @tAdjustementtotalcommitment TABLE (tMasterID int);     
DECLARE  @insertedMasterID int;       
Delete from @tAdjustementtotalcommitment;    
      
INSERT INTO CRE.NoteAdjustedCommitmentMaster       
  (      
    DealID      
   ,[Date]      
   ,[Type]      
   ,Comments       
   ,DealAdjustmentHistory       
   ,AdjustedCommitment       
   ,TotalCommitment       
   ,AggregatedCommitment       
   ,CreatedBy       
   ,CreatedDate       
   ,UpdatedBy       
   ,UpdatedDate      
   ,TotalRequiredEquity      
   ,TotalAdditionalEquity      
   ,Rowno    
   ,TotalEquityatClosing
  )      
      
 OUTPUT inserted.NoteAdjustedCommitmentMasterID INTO @tAdjustementtotalcommitment(tMasterID)      
 SELECT top 1      
    DealID      
   ,[Date]      
   ,[Type]      
   ,Comments       
   ,DealAdjustmentHistory       
   ,AdjustedCommitment       
   ,TotalCommitment       
   ,AggregatedCommitment       
   ,CAST(@UserID as nvarchar(256))      
   ,getdate()       
   ,CAST(@UserID as nvarchar(256))      
   ,getdate()      
   ,TotalRequiredEquity      
   ,TotalAdditionalEquity      
   ,@rownumberOuter  
   ,TotalEquityatClosing
 FROM @TableAdjustedTotalCommitment ttc      
 WHERE ttc.Rownumber = @rownumberOuter      
       
 SELECT @insertedMasterID = tMasterID FROM @tAdjustementtotalcommitment;      
      
      
 INSERT INTO CRE.NoteAdjustedCommitmentDetail      
  (      
 NoteAdjustedCommitmentMasterID,      
 NoteID,      
 [Value],      
 CreatedBy,      
 CreatedDate,      
 UpdatedBy,      
 UpdatedDate,      
 [Type],      
 DealID,      
 NoteAdjustedTotalCommitment,      
 NoteAggregatedTotalCommitment,      
 NoteTotalCommitment,      
 Rowno      
  )      
 SELECT      
   @insertedMasterID,      
   NoteID,      
   [Amount],      
   CAST(@UserID as nvarchar(256)),      
   getdate(),      
   CAST(@UserID as nvarchar(256)),      
   getdate(),      
    [Type],      
   DealID,      
   NoteAdjustedTotalCommitment,      
   NoteAggregatedTotalCommitment,      
   NoteTotalCommitment,      
   @rownumberOuter      
 FROM @TableAdjustedTotalCommitment ttc1      
 WHERE ttc1.RowNumber =@rownumberOuter      
      
FETCH NEXT FROM row_cursor         
INTO @rownumberOuter      
       
      
END           
    
---update masterid------    
update CRE.NoteAdjustedCommitmentDetail set CRE.NoteAdjustedCommitmentDetail.NoteAdjustedCommitmentMasterID = a.NoteAdjustedCommitmentMasterID    
from(    
 select NoteAdjustedCommitmentMasterID,Rowno,DealID from cre.NoteAdjustedCommitmentMaster where DealID= @DealID    
)a     
where CRE.NoteAdjustedCommitmentDetail.Dealid = a.DealID and cre.NoteAdjustedCommitmentDetail.Rowno  = a.Rowno  
and  CRE.NoteAdjustedCommitmentDetail.Dealid = @DealID  
     
      
END
GO

