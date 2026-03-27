
CREATE PROCEDURE [VAL].[usp_InsertUpdateAdjustedLTVs]
(
	@tbltype_AdjustedLTVs [val].[tbltype_AdjustedLTVs] READONLY
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = (Select top 1 MarkedDate from @tbltype_AdjustedLTVs))

	Delete from [VAL].[AdjustedLTVs] Where MarkedDateMasterID=@MarkedDateMasterID;

	INSERT INTO [VAL].[AdjustedLTVs](MarkedDateMasterID,CREDealID,CREDealName,FundedDate,TotalCommitment,AsStabilizedAppraisal,PropertyType,ValueDecline,AdjustedAsStabilizedValue,RecourseCurrent,AdjustedAsStabilizedValuewithRecourse,AdjustedAsStabilizedLTV,UnadjustedAsStabilizedLTV,[CreatedBy],[CreatedDate],[UpdateBy],[UpdatedDate])
	select @MarkedDateMasterID,CREDealID,CREDealName,FundedDate,TotalCommitment,AsStabilizedAppraisal,PropertyType,ValueDecline,AdjustedAsStabilizedValue,RecourseCurrent,AdjustedAsStabilizedValuewithRecourse,AdjustedAsStabilizedLTV,UnadjustedAsStabilizedLTV,UserID,getdate(),UserID,getdate()
	From @tbltype_AdjustedLTVs

 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END