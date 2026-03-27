CREATE PROCEDURE [dbo].[usp_GetNotesFromDealDetailByDealID]  --'9de73d71-b4b2-4cd8-b885-6f9817ad812b', '80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,20,''
(
    @DealId Varchar(500),
	@UserID UNIQUEIDENTIFIER,
    @PgeIndex INT,
    @PageSize INT,
	@totalCount INT OUTPUT 
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
--Declare @UseRuletoDetermineNoteFunding int 
Declare @UseRuletoDetermineNoteFundingAsNo int=(Select LookupID from CORE.Lookup where Name = 'N' and Parentid = 2)
Declare @InActive as nvarchar(256);
Declare @Active as nvarchar(256);
set @InActive=(select LookupID from core.lookup where name ='InActive' and ParentID=1);
set @Active=(select LookupID from core.lookup where name ='Active' and ParentID=1);

SELECT @totalCount = COUNT(NoteID) FROM CRE.Note  WITH (ROWLOCK, HOLDLOCK);
	
Select NoteID,Account_AccountID,DealID,CRENoteID,ClosingDate,TotalCommitment,InitialMaturityDate,UseRuletoDetermineNoteFunding,UseRuletoDetermineNoteFundingText,NoteFundingRule,NoteFundingRuleText,FundingPriority,NoteBalanceCap,RepaymentPriority,InitialFundingAmount,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,StatusID,Name,ActualPayoffDate,FullyExtendedMaturityDate,ExpectedMaturityDate,cntCritialException,lienposition,lienpositionText,priority,NoteRule,AdjustedTotalCommitment,OriginalTotalCommitment,AggregatedTotal,InitialRequiredEquity,InitialAdditionalEquity,CommitmentUsedinFFDistribution, ExtendedMaturityCurrent,MaturityGroupName,MaturityMethodID,MaturityMethodIDText,NoteType,NoteTypeText,
        NoteSequenceNumber
From(																																																																																																																																																										   
	 
SELECT n.NoteID
,Account_AccountID
,n.DealID
,CRENoteID	 			  
,ClosingDate
,n.TotalCommitment	
,(Select distinct mat.MaturityDate
		from [CORE].Maturity mat
		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
		INNER JOIN(	
			Select (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
			MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
			where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
			and acc.AccountID = a.AccountID
			and acc.isdeleted=0
			and eve.StatusID = 1
			GROUP BY n.Account_AccountID,EventTypeID
		) sEvent
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID and e.StatusID = 1
		and mat.MaturityType=708
	)InitialMaturityDate
,(case when isnull(a.StatusID,@Active)=@InActive Then @UseRuletoDetermineNoteFundingAsNo else n.UseRuletoDetermineNoteFunding END) UseRuletoDetermineNoteFunding
--,UseRuletoDetermineNoteFunding
,lUseRuletoDetermineNoteFunding.Name as  UseRuletoDetermineNoteFundingText
,NoteFundingRule
,lNoteFundingRule.Name  NoteFundingRuleText
,FundingPriority
,NoteBalanceCap
,RepaymentPriority		 
,InitialFundingAmount
,n.CreatedBy
,n.CreatedDate
,n.UpdatedBy
,n.UpdatedDate
,a.StatusID
,a.Name				 
--,n.ExtendedMaturityScenario1
--,n.ExtendedMaturityScenario2
--,n.ExtendedMaturityScenario3			
,n.ActualPayoffDate
,n.FullyExtendedMaturityDate
,n.ExpectedMaturityDate
,n.InitialRequiredEquity
,n.InitialAdditionalEquity
-- cntActionLevelText
, ISNULL((select COUNT(lActionLevel.Name) as cntActionLevelText
from core.Exceptions exc
Inner join cre.Note n1 on n1.noteID=exc.ObjectID
INNER JOIN core.Account ac ON ac.AccountID = n1.Account_AccountID
left join core.Lookup lActionLevel on lActionLevel.LookupID=exc.ActionLevelID 
where ObjectID= n.NoteID 
and ObjectTypeID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=27 AND NAME='Note' ) AND lActionLevel.Name = 'Critical')
,0) AS cntCritialException
				
,lienposition
,llienposition.name as lienpositionText
,[priority]
,[NoteRule]

,ISNULL(  
(  
 Select ISNULL(SUM(ISNULL(FS.Value,0)),0)  
 from [CORE].FundingSchedule fs  
 INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId  
 INNER JOIN  
 (  
    Select  
    (Select AccountID from [CORE].[Account] ac where ac.AccountID = n1.Account_AccountID) AccountID ,  
    MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID  
    from [CORE].[Event] eve  
    INNER JOIN [CRE].[Note] n1 ON n1.Account_AccountID = eve.AccountID and n1.noteid=n.noteid  
    INNER JOIN [CORE].[Account] acc ON acc.AccountID = n1.Account_AccountID  
    where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')  
	and acc.IsDeleted = 0  
	and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)  
    and n1.dealid = @DealId     
    GROUP BY n1.Account_AccountID,EventTypeID,eve.StatusID  
   ) sEvent  
   
 ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and e.EventTypeID = sEvent.EventTypeID  
   
 left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID  
 left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID  
 INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
 where sEvent.StatusID = e.StatusID and acc.IsDeleted = 0  
 and fs.Date = Cast(getdate() AS DATE))    
 +    
 ISNULL((select SUM((ISNULL(EndingBalance,0)))  
 from [CRE].[NotePeriodicCalc] np
	Inner join core.account acc on acc.accountid = np.AccountID
	Inner join cre.note n on n.account_accountid = acc.accountid
	
 where PeriodEndDate = CAST(getdate() - 1 as Date) and acc.AccounttypeID = 1
 and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
 and np.AccountID = n.noteid 
 --and n.dealid = '7BF82434-8D5C-4738-892C-76785EC83142'
 ) ,0)    
,0) EstBls  
,n.AdjustedTotalCommitment
,n.AggregatedTotal
,n.OriginalTotalCommitment
, ISNULL((Case When isnulL(n.CommitmentUsedInFFDistribution,0) = 0 THEN n.originaltotalcommitment ELSE n.CommitmentUsedInFFDistribution END),0) CommitmentUsedInFFDistribution  
,n.ExtendedMaturityCurrent
,n.MaturityGroupName
,n.MaturityMethodID
,lmaturitymethod.Name as MaturityMethodIDText
,n.NoteType
,lNoteType.Name as NoteTypeText

,ROW_NUMBER() OVER (order by ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, a.Name) as NoteSequenceNumber

FROM CRE.Note n inner join Core.Account a on Account_AccountID=a.AccountID
inner join cre.Deal d on n.DealId = d.DealId			  
left join Core.Lookup lUseRuletoDetermineNoteFunding ON (case when isnull(a.StatusID,@Active)=@InActive Then @UseRuletoDetermineNoteFundingAsNo else n.UseRuletoDetermineNoteFunding END)=lUseRuletoDetermineNoteFunding.LookupID
--left join Core.Lookup lUseRuletoDetermineNoteFunding ON n.UseRuletoDetermineNoteFunding=lUseRuletoDetermineNoteFunding.LookupID
left join Core.Lookup lNoteFundingRule ON n.NoteFundingRule=lNoteFundingRule.LookupID
left join Core.Lookup llienposition ON n.lienposition=llienposition.LookupID
left join Core.Lookup lmaturitymethod on n.MaturityMethodID = lmaturitymethod.LookupID
left join Core.Lookup lNoteType on n.NoteType = lNoteType.LookupID
left join( Select n.noteid,mat.MaturityDate as MaturityDate
			from [CORE].Maturity mat  
			INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
			INNER JOIN   
			(         
				Select   
				(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
				MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
				where EventTypeID = 11 
				and n.DealID=@DealId
				and acc.IsDeleted = 0  
				and eve.StatusID = 1
				GROUP BY n.Account_AccountID,EventTypeID    
			) sEvent    
			ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID and e.StatusID = 1 
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
			where acc.isdeleted <> 1	
			and mat.maturityType = 708
			) initialMaturity on initialMaturity.NoteID = n.NoteID
where n.DealID=@DealId
and a.IsDeleted=0
--ORDER BY a.StatusID,ISNULL(lienposition,99999),[priority]


)x
order by ISNULL(x.lienposition,99999), x.Priority,x.InitialFundingAmount desc, x.Name --, x.CreatedDate desc

OFFSET (@PgeIndex - 1)*@PageSize ROWS
FETCH NEXT @PageSize ROWS ONLY;

            

	SELECT @TotalCount = COUNT(NoteID) FROM CRE.Note n inner join CORE.Account acc on n.Account_AccountID=acc.AccountID where acc.IsDeleted=0 and n.DealID=@DealId;


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED		   
END