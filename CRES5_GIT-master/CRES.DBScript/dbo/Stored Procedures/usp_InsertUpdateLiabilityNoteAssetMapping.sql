CREATE PROCEDURE [dbo].[usp_InsertUpdateLiabilityNoteAssetMapping]       
(    
@tblNoteAssetMap [TableTypeLiabilityNoteAssetMapping] READONLY,    
@UserID nvarchar(256)    
)     
AS          
BEGIN                 
 SET NOCOUNT ON;    
    
 DELETE FROM [CRE].[LiabilityNoteAssetMapping] WHERE LiabilityNoteAccountId IN (SELECT LiabilityNoteAccountId FROM @tblNoteAssetMap)
  
     Insert into [CRE].[LiabilityNoteAssetMapping]    
    (      
     DealAccountId,    
     LiabilityNoteAccountId,
	 AssetAccountId,
     CreatedBy,     
     CreatedDate,    
     UpdatedBy,     
     UpdatedDate    
    )            
    select ln.DealAccountId,ln.LiabilityNoteAccountId,ln.AssetAccountId,@UserID,getdate(),@UserID,getdate()  from @tblNoteAssetMap ln  
   
            
END  
GO