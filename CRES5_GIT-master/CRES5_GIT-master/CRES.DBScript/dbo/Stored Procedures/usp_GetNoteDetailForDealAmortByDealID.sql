
--[dbo].[usp_GetNoteDetailForDealAmortByDealID] '90FA31EC-A1E5-4714-A157-B4F8DEF20B1F' 

CREATE PROCEDURE [dbo].[usp_GetNoteDetailForDealAmortByDealID] 
 @DealID as uniqueidentifier   
AS   
BEGIN   
  
 SET NOCOUNT ON;   
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   


Declare @AnalysisID UNIQUEIDENTIFIER = (Select AnalysisID from core.analysis where name = 'Default')   
DECLARE @ColPivot AS NVARCHAR(MAX), 
@query AS NVARCHAR(MAX),  
@query1 AS NVARCHAR(MAX),   
@query2 AS NVARCHAR(MAX),   
@query3 AS NVARCHAR(MAX),
@queryOrder AS NVARCHAR(MAX)


SET @ColPivot =  STUFF((SELECT distinct ',' + QUOTENAME(SequenceType +' '+ cast(SequenceNo as nvarchar(256)))   
from [CRE].DealAmortSequence fs   
INNER JOIN [CRE].[Note] n ON fs.NoteID=n.NoteID   
where n.DealID =@DealID    
order by ',' +QUOTENAME(SequenceType +' '+ cast(SequenceNo as nvarchar(256)))   
FOR XML PATH(''), TYPE   
).value('.', 'NVARCHAR(MAX)')    
,1,1,'') 


SET @query1 = N'select * from(  
SELECT n.NoteID  
,CRENoteID   
,a.Name Name  
,tblMat.currMaturityDate as Maturity 
,lienposition  
,llienposition.name as LienPositionText  
,[priority] as Priority 
,n.IOTerm
, tblRate.[Value] as AmortRate
,isnull(n.TotalCommitment,0) TotalCommitment
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
    where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = ''FundingSchedule'')  
    and n1.dealid = '''+convert(varchar(MAX),@DealID)+''' and acc.IsDeleted = 0  
    and eve.StatusID = 1
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
 where np.noteid = n.noteid and n.dealid = '''+convert(varchar(MAX),@DealID)+''' and PeriodEndDate = CAST(getdate() - 1 as Date) and AnalysisID = '''+convert(varchar(MAX),@AnalysisID)+'''),0)     
,0) EstBls  '
SET @query2 = N' 
,n.AmortTerm
,n.RoundingNote
,lRoundingNote.name  as RoundingNoteText
,n.StraightLineAmortOverride
,n.UseRuletoDetermineAmortization 
,lUseRuletoDetermineAmortization.name as UseRuletoDetermineAmortizationText
,n.InitialInterestAccrualEndDate
,n.InitialFundingAmount
,n.ActualPayoffDate

,tblMatFUlly.FullyExtendedMaturityDate as FullyExtendedMaturityDate
,tblInitialMat.InitialMaturityDate as InitialMaturityDate

,n.FirstPaymentDate
FROM CRE.Note n 
inner join Core.Account a on Account_AccountID=a.AccountID  
left join Core.Lookup l ON n.RateType=l.LookupID  
left join Core.Lookup lUseRuletoDetermineNoteFunding ON n.UseRuletoDetermineNoteFunding=lUseRuletoDetermineNoteFunding.LookupID  
left join Core.Lookup lNoteFundingRule ON n.NoteFundingRule=lNoteFundingRule.LookupID  
left join Core.Lookup llienposition ON n.lienposition=llienposition.LookupID  
left join Core.Lookup lRoundingNote ON n.RoundingNote=lRoundingNote.LookupID 
left join Core.Lookup lUseRuletoDetermineAmortization ON n.UseRuletoDetermineAmortization=lUseRuletoDetermineAmortization.LookupID 
left join(
	Select top 1 n1.NoteID,rs.[Value]
	from [CORE].RateSpreadSchedule rs
	INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
	LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
	INNER JOIN(						
		Select 
		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = ''RateSpreadSchedule'')
		and eve.StatusID = 1
		and n.DealID = '''+convert(varchar(MAX),@DealID)+''' 
		and acc.IsDeleted = 0
		GROUP BY n.Account_AccountID,EventTypeID
	) sEvent
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
	Inner join core.Account acc1 on acc1.AccountID = e.AccountID
	Inner join cre.Note n1 on n1.Account_AccountID = acc1.AccountID 
	where ISNULL(e.StatusID,1) = 1
	and rs.ValueTypeID = 156 --Amort Rate
)tblRate on tblRate.NoteID = n.NoteID
left Join(
	Select n1.noteid,ISNULL(n1.ActualPayOffDate,ISNULL(currMat.MaturityDate,n1.FullyExtendedMaturityDate))  as currMaturityDate
	from cre.note n1
	Inner join core.account acc1 on acc1.Accountid = n1.Account_Accountid
	Left Join(
		Select noteid,MaturityType,MaturityDate,Approved
		from (
				Select n.noteid,lMaturityType.name as [MaturityType],mat.MaturityDate as [MaturityDate],lApproved.name as Approved,
				ROW_NUMBER() Over(Partition by noteid order by noteid,(CASE WHEN lMaturityType.name = ''Initial'' THEN 0 WHEN lMaturityType.name = ''Fully extended'' THEN 9999 ELSE 1 END) ASC, mat.MaturityDate) rno
				from [CORE].Maturity mat  
				INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
				INNER JOIN   
				(          
					Select   
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
					where EventTypeID = 11 and eve.StatusID = 1
					and n.DealID = '''+convert(varchar(MAX),@DealID)+'''     
					and acc.IsDeleted = 0  
					GROUP BY n.Account_AccountID,EventTypeID    
				) sEvent    
				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
				Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType
				Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved	
				where n.dealid = '''+convert(varchar(MAX),@DealID)+'''   
				and mat.MaturityDate > getdate()
				and lApproved.name = ''Y''
		)a where a.rno = 1
	)currMat on currMat.noteid = n1.noteid
	where acc1.IsDeleted <> 1
	and n1.dealid = '''+convert(varchar(MAX),@DealID)+'''   
)tblMat on tblMat.noteid = n.noteid

Left Join(
	Select n.noteid,mat.MaturityDate as FullyExtendedMaturityDate
	from [CORE].Maturity mat
	INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	INNER JOIN
	(
		Select
		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
		where EventTypeID = 11 and eve.StatusID = 1
		--and n.NoteID = @NoteID
		and acc.IsDeleted = 0
		GROUP BY n.Account_AccountID,EventTypeID
	) sEvent
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and e.EventTypeID = sEvent.EventTypeID and e.StatusID = 1
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where acc.isdeleted <> 1
	and mat.maturityType = 710

)tblMatFUlly on tblMatFUlly.noteid = n.noteid
Left Join(
	Select n.noteid,mat.MaturityDate as InitialMaturityDate
	from [CORE].Maturity mat
	INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	INNER JOIN
	(
		Select
		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
		where EventTypeID = 11 and eve.StatusID = 1
		--and n.NoteID = @NoteID
		and acc.IsDeleted = 0
		GROUP BY n.Account_AccountID,EventTypeID
	) sEvent
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and e.EventTypeID = sEvent.EventTypeID and e.StatusID = 1
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where acc.isdeleted <> 1
	and mat.maturityType = 708
)tblInitialMat on tblInitialMat.noteid = n.noteid
where a.isdeleted=0 
and  n.dealID= '''+convert(varchar(MAX),@DealID)+''' 

--ORDER BY ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, a.Name

) a 
 
'

set @query = 'left join( SELECT NoteName, ' + @ColPivot + ' from    
(   
Select   
a.Name NoteName   
,SequenceType +'' ''+ cast(SequenceNo as nvarchar(256)) col    
,isnull(fs.Value,0) Value   
from [CRE].[DealAmortSequence] fs   
INNER JOIN [CRE].[Note] n ON fs.NoteID=n.NoteID   
inner join Core.Account a on a.AccountID=n.Account_AccountID 
where n.DealID = '''+convert(varchar(MAX),@DealID)+'''   
) x    
pivot    
(  
 sum(Value)   
 for    
 col in (' + @ColPivot + ')   
  
) p '-- order by Name'   
   
   
set @query=@query + ') b on a.Name=b.NoteName '

Set @queryOrder = ' order by ISNULL(a.lienposition,99999), a.Priority,a.InitialFundingAmount desc, a.Name ' 


PRINT @query1
PRINT @query2
PRINT @query
PRINT @queryOrder

exec(@query1+@query2+@query + @queryOrder);   



--,case when n.ActualPayoffDate is not null then n.ActualPayoffDate  
--when (select SelectedMaturityDate from core.Maturity where EventID=   
--(select max(EventID) from core.Event where eventtypeid=11 and AccountID=(select Account_AccountID from cre.note where noteid=n.noteid))   
--) >getdate() or (n.ExtendedMaturityScenario1 is null and n.ExtendedMaturityScenario2 is null and n.ExtendedMaturityScenario3 is null and n.FullyExtendedMaturityDate is null)   
-- then (select SelectedMaturityDate from core.Maturity where EventID=   
--(select max(EventID) from core.Event where eventtypeid=11 and AccountID=(select Account_AccountID from cre.note where noteid=n.noteid))   
--) else   
--case when n.ExtendedMaturityScenario1>GETDATE() or (n.ExtendedMaturityScenario2 is null and n.ExtendedMaturityScenario3 is null and n.FullyExtendedMaturityDate is null) then n.ExtendedMaturityScenario1 else   
--case when n.ExtendedMaturityScenario2 >GETDATE() or (n.ExtendedMaturityScenario3 is null and n.FullyExtendedMaturityDate is null) then n.ExtendedMaturityScenario2 else   
--case when n.ExtendedMaturityScenario3 >GETDATE() or (n.FullyExtendedMaturityDate is null) then n.ExtendedMaturityScenario3 else  
--n.FullyExtendedMaturityDate end --end   
-- end end end as Maturity    
 
  

 
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED   
END  
