-- [dbo].[usp_GetDealPrepayProjectionByDealId] '7E1AF9CE-4354-4E06-BFCC-4BD1B8DD78D2','5848ca08-b9b0-4b93-9e0b-311c560f58f4'          
          
          
CREATE PROCEDURE [dbo].[usp_GetDealPrepayProjectionByDealId]   --'90fa31ec-a1e5-4714-a157-b4f8def20b1f','B0E6697B-3534-4C09-BE0A-04473401AB93'          
(          
 @Dealid varchar(50),          
 @UserID UNIQUEIDENTIFIER          
)          
AS          
          
BEGIN          
 SET NOCOUNT ON;          
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
          
           
 Select d.DealPrepayProjectionID,  
 d.DealID ,  
 d.PrepayDate,   
 d.PrepayPremium_RemainingSpread,   
 d.UPB,  
 d.OpenPrepaymentDate,  
 d.TotalPayoff ,
 dbo.[ufn_GetTimeByTimeZone](max(d.UpdatedDate) OVER (PARTITION BY DealID),@UserID)as prepaylastUpdatedFF,
 (CASE When EXISTS (SELECT 1 WHERE d.UpdatedBy LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]')) THEN (select  top 1 u.[Login]  from CRE.DealFunding  df left join App.[User]  u  on u.UserID =  d.UpdatedBy) ELSE d.UpdatedBy END) as      
 prepaylastUpdatedByFF 
 from [CRE].[DealPrepayProjection] d     
 where  dealid = @Dealid          
         
                    
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
          
END
GO

