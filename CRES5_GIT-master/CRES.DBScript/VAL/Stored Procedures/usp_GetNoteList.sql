CREATE PROCEDURE [VAL].[usp_GetNoteList]
	@MarkedDate date
AS    
BEGIN    
    
	SET NOCOUNT ON;    
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
     

	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)
	IF @MarkedDateMasterID IS NULL
	BEGIN
		Select  CREDealID,CREDealName,NoteID, NULL as NoteNominalDMOrPriceForMark
		From(
			SELECT Distinct
				d.CREDealID as CREDealID
				,d.dealname as CREDealName
				,n.CRENoteID as NoteID
				--,NULL AS NoteNominalDMOrPriceForMark
				--,ISNULL(DealListID ,999999999) as DealListID	
			FROM [VAL].[DealList] dl	
			INNER JOIN cre.deal d ON d.dealid = dl.dealid
			INNER JOIN cre.note n ON n.dealid = d.dealid
			INNER JOIN Core.account acc ON acc.accountid = n.account_accountid
			WHERE acc.isdeleted <> 1 AND d.isdeleted <> 1 AND d.status = 323
		)a
	END
	ELSE
	BEGIN
			Select CREDealID,CREDealName,NoteID,NoteNominalDMOrPriceForMark
			From(
			SELECT Distinct
				d.CREDealID as CREDealID
				,d.dealname as CREDealName
				,n.CRENoteID as NoteID
				,NL.NoteNominalDMOrPriceForMark
				,ISNULL(DealListID ,999999999) as DealListID	
			FROM [VAL].[DealList] dl	
			INNER JOIN cre.deal d ON d.dealid = dl.dealid
			INNER JOIN cre.note n ON n.dealid = d.dealid
			INNER JOIN Core.account acc ON acc.accountid = n.account_accountid
			LEFT JOIN [Val].[NoteList] NL ON NL.CREDealID=d.CREDealID AND NL.NoteID=N.CRENoteID and NL.MarkedDateMasterID=dl.MarkedDateMasterID
			WHERE acc.isdeleted <> 1 AND d.isdeleted <> 1 AND d.status = 323 AND dl.MarkedDateMasterID = @MarkedDateMasterID
			)a
		Order by DealListID
	END
		
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END
GO

