--  Drop PROCEDURE [dbo].[usp_DeleteAdjustedTotalCommitment]  
CREATE PROCEDURE [dbo].[usp_DeleteAdjustedTotalCommitment]  
  
@TableAdjustedTotalCommitment [TableAdjustedTotalCommitment] READONLY,  
@DealID uniqueidentifier  
  
  
AS   
BEGIN    
SET NOCOUNT ON;   
  
  
DELETE FROM CRE.NoteAdjustedCommitmentDetail WHERE NoteAdjustedCommitmentMasterID in (SELECT NoteAdjustedCommitmentMasterID FROM @TableAdjustedTotalCommitment)  
  
DELETE FROM CRE.NoteAdjustedCommitmentMaster  WHERE NoteAdjustedCommitmentMasterID in (SELECT NoteAdjustedCommitmentMasterID FROM @TableAdjustedTotalCommitment)   
  
  
END  