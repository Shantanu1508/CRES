-- Procedure

CREATE PROCEDURE [VAL].[usp_GetDealNoteForServerFile]
	@MarkedDate date,
	@CREDealID nvarchar(256) = null
AS  
BEGIN  
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)


	IF(@CREDealID is not null)
	BEGIN
		Select d.CREDealID as DealID	
		,d.DealName	
		,n.CRENoteID
		,dl.DMAdjustment
		,NL.NoteNominalDMOrPriceForMark
		FROM [VAL].[DealList] dl	
		Inner join cre.deal d on d.dealid = dl.dealid
		Inner join cre.note n on n.dealid = d.dealid
		Inner join Core.account acc on acc.accountid = n.account_accountid
		LEFT JOIN VAL.NoteList NL ON NL.CREDealID=d.CREDealID AND NL.NoteID = N.CRENoteID and NL.MarkedDateMasterID=dl.MarkedDateMasterID
		Where acc.isdeleted <> 1 and d.isdeleted <> 1
		and d.status = 323
		and (n.ActualPayOffDate is null OR n.ActualPayOffDate > Cast(@MarkedDate as date))
		and d.credealid = @CREDealID
		and dl.MarkedDateMasterID = @MarkedDateMasterID
		order by ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, acc.Name
	END
	ELSE
	BEGIN
		Select d.CREDealID as DealID	
		,d.DealName	
		,n.CRENoteID
		,dl.DMAdjustment
		,NL.NoteNominalDMOrPriceForMark
		FROM [VAL].[DealList] dl	
		Inner join cre.deal d on d.dealid = dl.dealid
		Inner join cre.note n on n.dealid = d.dealid
		Inner join Core.account acc on acc.accountid = n.account_accountid
		LEFT JOIN VAL.NoteList NL ON NL.CREDealID=d.CREDealID AND NL.NoteID = N.CRENoteID and NL.MarkedDateMasterID=dl.MarkedDateMasterID
		Where acc.isdeleted <> 1 and d.isdeleted <> 1
		and d.status = 323
		and (n.ActualPayOffDate is null OR n.ActualPayOffDate > Cast(@MarkedDate as date))
		and dl.MarkedDateMasterID = @MarkedDateMasterID
		order by ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, acc.Name
	END


SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END
GO

