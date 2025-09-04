CREATE PROCEDURE [dbo].[usp_GetAssociatedDealsByLiabilityTypeID]  --'C5E57F53-AA86-49EA-804E-9F26159B1E65'    
@LiabilityTypeID nvarchar(256)     
AS    
BEGIN    
		 Select     
		ln.AssetAccountID    
		,acca.AssetName as AssetName  
 
		from cre.LiabilityNote ln  
		Inner Join core.Account acc on acc.AccountID = ln.AccountID  
		Left Join(  
		Select AssetAccountID,AssetName  
		From(  
		  SELECT d.DealName as AssetName,acc.AccountID as AssetAccountID  
		  FROM CRE.Deal AS d  
		  INNER JOIN Core.Account AS acc ON acc.AccountID = d.AccountID  
		  WHERE acc.IsDeleted <> 1 --and acc.AccountID = @DealAccountID  
		  UNION ALL  
		  SELECT n.CRENoteID as AssetName,acc.AccountID as AssetAccountID  
		  FROM CRE.Note AS n  
		  INNER JOIN Core.Account AS acc ON acc.AccountID = n.Account_AccountID  
		  WHERE acc.IsDeleted <> 1  
		  --and n.DealID = (Select dealid from cre.deal where AccountID= @DealAccountID)  
		)z  
		)acca on acca.AssetAccountID = ln.AssetAccountID    
 
		Where acc.IsDeleted <> 1    
		and LiabilityTypeID =  @LiabilityTypeID

		order by AssetName
END  