-- Procedure
-- Procedure
  ---[VAL].[usp_GetAdjustedLTVs]  '11/30/2023'
  
CREATE PROCEDURE [VAL].[usp_GetAdjustedLTVs] 
(
	@MarkedDate date,
	@dealID nvarchar(256)	=NULL
) 
AS    
BEGIN    
    
	SET NOCOUNT ON;    
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
     

	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)

	IF @dealID is NULL 
	BEGIN
		SELECT CREDealID
			,CREDealName
			,FundedDate
			,TotalCommitment
			,AsStabilizedAppraisal
			,PropertyType
			,ValueDecline
			,AdjustedAsStabilizedValue
			,RecourseCurrent
			,AdjustedAsStabilizedValuewithRecourse
			,AdjustedAsStabilizedLTV
			,UnadjustedAsStabilizedLTV
			FROM [VAL].[AdjustedLTVs] Ad
			Where MarkedDateMasterID =	@MarkedDateMasterID
	end
	else
	begin
		SELECT CREDealID
			,CREDealName
			,FundedDate
			,TotalCommitment
			,AsStabilizedAppraisal
			,PropertyType
			,ValueDecline
			,AdjustedAsStabilizedValue
			,RecourseCurrent
			,AdjustedAsStabilizedValuewithRecourse
			,AdjustedAsStabilizedLTV
			,UnadjustedAsStabilizedLTV
			FROM [VAL].[AdjustedLTVs] Ad
			Where MarkedDateMasterID =	@MarkedDateMasterID 
			AND CREDealID = @dealID
	end

 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  

END
GO

