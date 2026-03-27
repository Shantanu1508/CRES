-- Procedure
-- [dbo].[usp_GetFundingRepaymentSequenceWriteOffByDealID] '327F4C24-9032-4129-B229-0B274472E328'

CREATE PROCEDURE [dbo].[usp_GetFundingRepaymentSequenceWriteOffByDealID] --'F160E8FD-C5F5-4D6F-8F0A-09D338BCA4C1'  
 @DealID as uniqueidentifier   
AS   
BEGIN   
    
	SET NOCOUNT ON;   
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   
   
   
	Declare @AnalysisID UNIQUEIDENTIFIER = (Select AnalysisID from core.analysis where name = 'Default')  ;

	Select DealID,NoteID,CRENoteID,NoteName,LienPosition,Priority,PriorityOverride,EstBls from
	(    
		SELECT 
			N.DealID,
			N.NoteID,
			CRENoteID,
			a.Name as 'NoteName',
			llienposition.LookupID as LienPositionID,
			llienposition.name as 'LienPosition',
			[Priority],
			FSW.[PriorityOverride],
			ISNULL(  
						(  
						 Select ISNULL(SUM(ISNULL(FS.Value,0)),0)  
						 from [CORE].FundingSchedule fs  
						 INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId  
						 INNER JOIN  
						 (  
							Select  
								(Select AccountID from [CORE].[Account] ac where ac.AccountID = n1.Account_AccountID) AccountID ,  
								MAX(EffectiveStartDate) EffectiveStartDate,
								EventTypeID,
								eve.StatusID  
							from [CORE].[Event] eve  
							INNER JOIN [CRE].[Note] n1 ON n1.Account_AccountID = eve.AccountID and n1.noteid=n.noteid  
							INNER JOIN [CORE].[Account] acc ON acc.AccountID = n1.Account_AccountID  
							where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')  
							and n1.dealid = @DealID and acc.IsDeleted = 0  
							and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)  
							GROUP BY n1.Account_AccountID,EventTypeID,eve.StatusID  
						) sEvent  
						ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and e.EventTypeID = sEvent.EventTypeID  
   
						LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID  
						LEFT JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID  
						INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
						where sEvent.StatusID = e.StatusID and acc.IsDeleted = 0  
						and fs.Date = Cast(getdate() AS DATE)
						)    
						+    
						ISNULL(
							(select SUM((ISNULL(EndingBalance,0)))  
							from [CRE].[NotePeriodicCalc] np  
							where np.AccountID = n.Account_AccountID  and n.dealid = @DealID and PeriodEndDate = CAST(getdate() - 1 as Date) and AnalysisID = @AnalysisID)
						,0)
			,0) + ISNULL(trpik.PikAmount,0) as EstBls
			,n.InitialFundingAmount
		FROM CRE.Note n inner join Core.Account a on Account_AccountID=a.AccountID  
		left join Core.Lookup l ON n.RateType=l.LookupID  
		left join Core.Lookup llienposition ON n.lienposition=llienposition.LookupID 
		LEFT JOIN [CRE].[FundingRepaymentSequenceWriteOff] FSW on FSW.DealID=n.DealID AND n.NoteID=FSW.NoteID
		left join(
			Select n.noteid,SUM(tr.Amount * -1)  as PikAmount
			from cre.transactionEntry Tr
			Inner JOIN [CORE].[Account] acc ON acc.AccountID = tr.AccountID
			Inner join cre.note n on n.Account_AccountID = acc.AccountID
			where tr.analysisID =  convert(varchar(MAX),@AnalysisID) and tr.[Type] in ('PikPrincipalPaid','PIKPrincipalFunding')
			and tr.date = CAST(getdate() as date)
			and n.dealid = @DealID
			and acc.AccounttypeID = 1
			group by n.noteid
		)trpik on trpik.noteid = n.noteid

		where n.DealID = @DealID
		and a.isdeleted=0   
	) a  
	order by ISNULL(a.LienPositionID,99999), a.Priority,a.InitialFundingAmount desc, a.NoteName 

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END