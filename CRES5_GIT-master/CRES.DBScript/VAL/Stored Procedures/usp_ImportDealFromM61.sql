-- Procedure

--[VAL].[usp_ImportDealFromM61] '11/30/2022'
--[VAL].[usp_ImportDealFromM61] '12/31/2022'

CREATE PROCEDURE [VAL].[usp_ImportDealFromM61]
	@MarkedDate date = null
AS  
BEGIN  
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
 
	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)


 	Select CalculateText,IsCashFlowLive,DealID,dealname,Scenario,IndexType,IndexForecast,IndexFloor,PORTFOLIO,LastIndexReset,PaymentDay,PriceCaptoThirdParty,DealNominalDMOrPriceForMark,DMAdjustment,StubInterestinAdvancelastaccrualDate,IOValuationmo,PendingPayoff,PpayAdjustedAL,MaterialMezz,SliverMezz
	From(
		SELECT 	 Distinct
		ISNULL(lCalculate.name,'No') as CalculateText,
		ISNULL(LIsCashFlowLive.name,'Yes') as IsCashFlowLive
		,d.CREDealID as [DealID]
		,d.dealname
		,ISNULL(a.name,'Default') as [Scenario]
		,ISNULL(tblrss.IndexType,'LIBOR01M') as [IndexType]
		,dl.[IndexForecast]
		,dl.[IndexFloor] 
		,dl.[PORTFOLIO]
		,dl.[LastIndexReset]
		,dl.[PaymentDay]
		,dl.[PriceCaptoThirdParty]
		,dl.[DealNominalDMOrPriceForMark]
		,dl.[DMAdjustment]
		,dl.[StubInterestinAdvancelastaccrualDate]
		,dl.[IOValuationmo]
		,dl.[PendingPayoff]
		,dl.[PpayAdjustedAL]
		,dl.[MaterialMezz]
		,dl.[SliverMezz]
		,ISNULL(DealListID ,999999999)  as DealListID
		FROM cre.deal d
		Left join [VAL].[DealList] dl	 on d.dealid = dl.dealid and dl.MarkedDateMasterID = @MarkedDateMasterID
		Left Join core.lookup lCalculate on lCalculate.lookupID = dl.Calculate
		Left Join core.lookup LIsCashFlowLive on LIsCashFlowLive.lookupID = dl.IsCashFlowLive
		Left Join core.Analysis a on a.AnalysisID = dl.[Scenario]

		Inner join cre.note n on n.dealid = d.dealid
		Inner join Core.account acc on acc.accountid = n.account_accountid
		---Left join cre.financingsourcemaster fm on fm.FinancingSourceMasterID =n.FinancingSourceID
		Left Join(	

			Select z.dealid,(CASE WHEN z.IndexNameText = '1M LIBOR' THEN 'LIBOR01M' ELSE 'SOFR01M' END) as IndexType   ---z.[Date],
			from(
				Select a.dealid,a.[Date],a.IndexNameText,
				ROW_NUMBER() Over (Partition by a.dealid Order by a.dealid,a.[Date] desc) rno
				from (

				Select Distinct d.dealid,rs.[Date],lindex.name as IndexNameText

				from [CORE].RateSpreadSchedule rs  
				INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
				LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID  
				LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID  
				LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = rs.IndexNameID 
				LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = rs.DeterminationDateHolidayList				 
				INNER JOIN   
				(          
					Select   
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
					where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')  
					and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)  
					--and n.NoteID = @NoteID  
					and acc.IsDeleted = 0  
					GROUP BY n.Account_AccountID,EventTypeID    
				) sEvent    
				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
				Inner join cre.deal d on d.dealid = n.dealid
				where  e.StatusID = 1 and acc.isdeleted <> 1 and d.isdeleted <> 1
				and ValueTypeID = 778
				and rs.Date <= CAST(getdate() as date)
				)a
			)z
			Where z.rno = 1
		)tblrss on tblrss.dealid = d.dealid

		Where acc.isdeleted <> 1 and d.isdeleted <> 1
		and d.status = 323
		
		and n.ClosingDate <= @MarkedDate
		and n.actualpayoffdate is null
		and dl.dealid is null

		----and d.credealid in(
		----				'15-0618',
		----				'16-1024',
		----				'16-1411'
		----			)
		--and d.credealid in(
		--				'17-1123',
		--				'17-1714'
						
		--			)


		
	)a
	Order by DealListID  



	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
