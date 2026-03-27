CREATE PROCEDURE [dbo].[usp_DeleteWLDealPotentialImpairment]
	(
	@tbltype_WLDealPotentialImpairment [dbo].[tbltype_WLDealPotentialImpairment] READONLY,
	@UserID uniqueidentifier
	)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
Declare @DealID uniqueidentifier = (SELECT Top 1 DealID FROM @tbltype_WLDealPotentialImpairment) 
--Delete From	[CRE].[WLDealPotentialImpairment] where WLDealPotentialImpairmentID in (SELECT [WLDealPotentialImpairmentID] FROM @tbltype_WLDealPotentialImpairment  Where isdeleted = 1)

--------============Delete table WLDealPotentialImpairmentMaster and [WLDealPotentialImpairmentDetail]==============------      
 DELETE FROM CRE.[WLDealPotentialImpairmentDetail] WHERE  WLDealPotentialImpairmentMasterID IN 
 (SELECT WLDealPotentialImpairmentID FROM  @tbltype_WLDealPotentialImpairment)
 
 DELETE FROM CRE.[WLDealPotentialImpairmentMaster] WHERE  WLDealPotentialImpairmentMasterID IN 
 (SELECT WLDealPotentialImpairmentID FROM  @tbltype_WLDealPotentialImpairment)
 and DealID = @DealID
 	
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END

