CREATE PROCEDURE [VAL].[usp_ImportNoteFromM61] 
AS  
BEGIN  
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  


	Select DealID,DealName,NoteID,NoteName,NoteNominalDMOrPriceForMark
	From(
		SELECT d.CREDealID as DealID
		,d.DealName	
		,n.CRENoteId as [NoteID]
		,acc.Name as NoteName	
		--,nl.[CreditSequence]
		,nl.[NoteNominalDMOrPriceForMark]
		--,nl.[NoteLastCoupon]
		,ISNULL(DealListID ,999999999)  as DealListID
	 
		FROM cre.Note n 
		Left Join [VAL].[NoteList] nl on n.noteid = nl.noteid	
		Inner join cre.deal d on d.dealid = n.dealid	
		Inner join core.account acc on acc.accountid = n.account_accountid	
		Left Join Val.DealList dl on dl.dealid = n.DealID

		Where acc.isdeleted <> 1 and d.isdeleted <> 1
		
		and d.dealid in (
			SELECT 	 Distinct d.dealid
			FROM cre.deal d	
			Inner join cre.note n on n.dealid = d.dealid
			Inner join Core.account acc on acc.accountid = n.account_accountid
			Left join cre.financingsourcemaster fm on fm.FinancingSourceMasterID =n.FinancingSourceID
			Where acc.isdeleted <> 1 and d.isdeleted <> 1
			and d.status = 323

			--and 1 = (CASE WHEN (@SearchText = 'Closed date' and Convert(nvarchar(50),n.ClosingDate,101) = @SearchValue)  THEN 1 
			--WHEN @SearchText = 'Financing Source' and fm.FinancingSourceName like '%'+ @SearchValue +'%' THEN 1 
			--ELSE 0 END ) 
		)
	)a
	
	Order by a.DealListID,a.NoteID


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
