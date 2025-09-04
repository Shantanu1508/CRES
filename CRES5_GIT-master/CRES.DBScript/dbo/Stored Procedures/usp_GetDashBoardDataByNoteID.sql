--[DBO].[usp_GetDashBoardDataByNoteID] '6badf189-c4fc-4941-99f9-61c40020309c'

CREATE PROCEDURE [DBO].[usp_GetDashBoardDataByNoteID]
	@NoteId UNIQUEIDENTIFIER 
AS
BEGIN
	SET NOCOUNT ON;

Select n.crenoteid,n.Account_AccountID
,tblcomm.NoteTotalCommitment as TotalCommitment
,tblcomm.NoteAdjustedTotalCommitment as AdjustedTotalCommitment
,Round(FundPer.FundedPercentage * 100, 0) as FundedPercentage 
,fs.FinancingSourceName
,lpool.name as PoolName
,Round(NPC.AllInCouponRate, 8) as XIRRValue
,n.ClosingDate
,NextPaydown.NextPaydownDate as NextPaydown
,(u.FirstName+' '+u.LastName) as AssetManager 
,d.PrimaryBankerName as 'Banker'
from cre.note n
Inner join core.Account acc on acc.accountid = n.Account_AccountID
left join cre.FinancingSourceMaster fs on fs.FinancingSourceMasterID = n.FinancingSourceID
Left join core.Lookup lpool on lpool.lookupid = n.PoolID
Inner join cre.deal d on d.dealid = n.dealid
left join app.[User] u on d.AMUserID = u.UserID   
Left Join CRE.XIRROutputDealLevel xd on xd.DealAccountID=D.AccountID and xd.XIRRConfigID=(select XIRRConfigID from cre.XIRRConfig where ReturnName='Whole Loan Return (Excl. 3rd Party)')
LEFT JOIN (
	Select Top 1 AccountID,AllInCouponRate from CRE.NotePeriodicCalc NPC Where AccountID in (Select Account_AccountID from cre.Note Where NoteID=@NoteID)
	AND PeriodEndDate<=GETDATE() AND [Month] IS NOT NULL AND Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	Order by PeriodEndDate desc
)NPC ON N.Account_AccountID = NPC.AccountID 
Left Join(
	Select noteid,NoteAdjustedTotalCommitment,NoteTotalCommitment
	From(			
		SELECT n.noteid, d.CREDealID
		,n.CRENoteID
		,Date as Date
		,nd.Type as Type
		,NoteAdjustedTotalCommitment
		,NoteTotalCommitment
		--,nd.NoteID
		,ROW_NUMBER() OVER (PARTITION BY nd.NoteID order by nd.NoteID,nd.RowNo desc ,Date) as rno,
		nd.Rowno
		from cre.NoteAdjustedCommitmentMaster nm
		left join cre.NoteAdjustedCommitmentDetail nd on nd.NoteAdjustedCommitmentMasterID = nm.NoteAdjustedCommitmentMasterID
		right join cre.deal d on d.DealID=nm.DealID
		Right join cre.note n on n.NoteID = nd.NoteID
		inner join core.account acc on acc.AccountID = n.Account_AccountID
		where d.IsDeleted<>1 and acc.IsDeleted<>1	
		and n.noteid = @NoteId
	)a
	where rno =  1
)tblcomm on tblcomm.NoteID = n.NoteID

LEFT JOIN (	
	Select n.noteid,Min(fs.Date) as NextPaydownDate
	from [CORE].FundingSchedule fs
	INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
	INNER JOIN 
			(
						
				Select 
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
					from [CORE].[Event] eve
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
					where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
					and n.NoteID = @NoteId  
					and acc.IsDeleted = 0
					and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
					GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID

			) sEvent

	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID

	left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
	left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
	left JOIN [CORE].[Lookup] LAdjustmentType ON LAdjustmentType.LookupID = fs.AdjustmentType 
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where e.StatusID = 1 and acc.IsDeleted = 0
	and fs.[date] > GETDATE() AND fs.Value<0 
	and n.noteid = @NoteId
	group by noteid  

) NextPaydown ON NextPaydown.noteid = n.noteid


LEFT JOIN (
	Select N.NoteID, 
	CASE WHEN SUM(N.TotalCommitment) = 0 Then 0 
	ELSE (SUM(N.TotalCommitment)-SUM(RemainingUnfundedCommitment))/SUM(N.TotalCommitment) 
	END as FundedPercentage
	from cre.Note N 
	LEFT JOIN(    
		Select n.NoteID,RemainingUnfundedCommitment ,ROW_NUMBER() Over(Partition by n.noteid order by n.noteid,PeriodEndDate desc) rno    
		from cre.NotePeriodicCalc nc
		inner join cre.note n on n.Account_AccountID =nc.AccountID 
		where Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
		and nc.PeriodEndDate <= Cast(getdate() as Date)  
		and n.noteid = @NoteId
	)a on N.NoteID = a.NoteID and N.NoteID = a.NoteID 
	where rno = 1    
	Group By N.NoteID
) FundPer on N.NoteID = FundPer.NoteID

where acc.isdeleted <> 1
and n.noteid = @NoteId


END