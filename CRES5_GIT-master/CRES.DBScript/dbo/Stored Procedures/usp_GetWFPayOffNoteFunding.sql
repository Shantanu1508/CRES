--select top 10 * from cre.FinancingSourceMaster
--[dbo].[usp_GetWFPayOffNoteFunding]  'b0e6697b-3534-4c09-be0a-04473401ab93','380490a4-f3dc-458d-891a-85eb9f0ef204'

CREATE PROCEDURE [dbo].usp_GetWFPayOffNoteFunding
(
    @UserID UNIQUEIDENTIFIER,
    @DealFundingID UNIQUEIDENTIFIER
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


Declare  @FundingSchedule  int  =10;
DECLARE @Active int = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
Declare @InActive as nvarchar(256)=(select LookupID from core.lookup where name ='InActive' and ParentID=1);
DECLARE @DealID UNIQUEIDENTIFIER = (select DealID from cre.DealFunding where DealFundingID = @DealFundingID);
DECLARE @ParentClients nvarchar(max),@FinancingSources nvarchar(max),
@ThirpPartyFinancingSources nvarchar(max),
@topNoteID UNIQUEIDENTIFIER,@InitialMaturityDate date,
@LoanClosingDate date,
@FuncdingDate date,
@ThirpPartyAmount decimal(28,15),
@AnalysisID UNIQUEIDENTIFIER='C10F3372-0FC2-4861-A9F5-148F1F80804F',
@ExitFee DECIMAL (28, 15)=0,
@ExitFeePercentage DECIMAL (28, 15)=0,
@PrepayPremium DECIMAL (28, 15)=0,
@IndexFloor DECIMAL (28, 12) =0,
@topCRENoteID nvarchar(256),
@TotalCommitment decimal(28,15)=(select TotalCommitment from cre.Deal where DealID=@DealID),
@AdjustedTotalCommitmentPik decimal(28,15),
@AdjustedTotalCommitmentPikdelphi decimal(28,15)
select @ExitFee=isnull(ExitFee,0),@ExitFeePercentage=isnull(ExitFeePercentage,0)*100,
@PrepayPremium=isnull(PrepayPremium,0)
FROM CRE.WFTaskAdditionalDetail where TaskID=@DealFundingID
select @FuncdingDate = [Date] from cre.DealFunding where DealFundingID = @DealFundingID
declare @tblPayoffDetail as table
(
 ID int identity(1,1),
 NoteID uniqueidentifier,
 CRENoteID nvarchar(256),
 Name nvarchar(256),
 TaxVendorLoanNumber nvarchar(256),
 FinancingSourceName nvarchar(256),
 FinancingSourceMasterID int,
 InitialFundingAmount decimal(28,15),
 CurrentBalance decimal(28,15),
 AdjustedTotalCommitment decimal(28,15),
 RemainingUnfunded decimal(28,15),
 SpreadPercentage decimal(28,15),
 PikSpreadPercentage decimal(28,15),
 ParentClient nvarchar(256),
 IsExcludeThirdParty bit,
 AdjustedTotalCommitmentPercentage decimal(28,15),
 AdjustedTotalCommitmentPikPercentage decimal(28,15)

)

insert into @tblPayoffDetail
Select NoteID,CRENoteID,Name,TaxVendorLoanNumber,FinancingSourceName,FinancingSourceID,InitialFundingAmount,EstBls as CurrentBalance,AdjustedTotalCommitment,(AdjustedTotalCommitment-EstBls) as RemainingUnfunded,SpreadPercentage,PikSpreadPercentage, ParentClient,IsExcludeThirdParty
,(AdjustedTotalCommitment*SpreadPercentage)/100
,(AdjustedTotalCommitment*PikSpreadPercentage)/100

From(

	Select n.NoteID, ac.Name,ISNULL(fn.value,0) Value,(ISNULL(sprd.value,0)*100) as SpreadPercentage,(ISNULL(piksprd.value,0)*100) as PikSpreadPercentage,ISNULL(n.TaxVendorLoanNumber,'') TaxVendorLoanNumber 
	,ISNULL(IsExcludeThirdParty,0) as IsExcludeThirdParty,
	SUM (CASE WHEN ISNULL(IsExcludeThirdParty,0) = 0 THEN ISNULL(fn.value,0) ELSE 0 END) OVER (ORDER BY ISNULL(IsExcludeThirdParty,0)) AS TotalFundAmountWithExclude,
	ISNULL((select ISNULL(FinancingSourceName,'') From cre.FinancingSourceMaster where FinancingSourceMasterID=n.FinancingSourceID),'') FinancingSourceName,
	n.FinancingSourceID
	,n.CRENoteID
	,isnull(nullif(n.InitialFundingAmount,0.01),0) as InitialFundingAmount
	,n.CreatedDate
	,n.lienposition
	,n.Priority
	--,n.AdjustedTotalCommitment
	,isnull((select adjcommwithoutFullpayoff from
		(
		Select noteid,SUM((Value - Fullpayoff)) adjcommwithoutFullpayoff 
		from(
			Select nd.dealid,nd.noteid,SUM(Value) Value,ff.Fullpayoff 
			from cre.NoteAdjustedCommitmentDetail nd
			left JOin(
				Select n.noteid,SUM(fs.value) as Fullpayoff
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
								and n.dealid = @DealID  
								and acc.IsDeleted = 0
								and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
								GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID

						) sEvent
				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
				where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0 and fs.purposeid = 630
				group by noteid

			)ff on ff.noteid = nd.noteid
			where dealid = @DealID
			group by nd.dealid,nd.noteid,ff.Fullpayoff

		)z
		group by noteid
		) tbl where NoteID=n.NoteID),0) as AdjustedTotalCommitment
	,isnull((select EndingBalance from
		(
		Select noteid,SUM(EndingBalance) EndingBalance
		from
		(
			select n.dealid,n.noteid,PeriodEndDate, (case when isnull(n.InitialFundingAmount,0)=0.01 then ISNULL(EndingBalance,0)-0.01 else  ISNULL(EndingBalance,0) end) as EndingBalance ,
			ROW_Number() Over (Partition by n.dealid,n.noteid order by n.noteid,PeriodEndDate desc) rno
			 from [CRE].[NotePeriodicCalc] np  
			 inner join cre.note n on n.Account_AccountID = np.AccountID
			 where n.dealid = @DealID 
			 and PeriodEndDate < CAST(@FuncdingDate as Date) 
			 and AnalysisID = @AnalysisID
		)a
		where rno = 1
		group by noteid
		) btl where NoteID=n.NoteID),0) as  EstBls
	,l.ParentClient
	
	from cre.deal d 
	join cre.Note n on d.DealID=n.DealID join core.Account ac on n.Account_AccountID=ac.AccountID
	left join 
	(
		Select n.noteid,df.DealID DealID
		,acc.Name Name
		,fs.[Date] Date
		,fs.PurposeID
		,fs.Value Value
		,ISNULL(fs.DealFundingRowno,ISNULL(df.DealFundingRowno,0)) as DealFundingRowno
		,n.TaxVendorLoanNumber
		,ISNULL(tblThirdPartyNotes.IsExcludeThirdParty,0) as IsExcludeThirdParty
		,n.CRENoteID
		from 
		[CRE].[DealFunding] df
		left join cre.deal d on d.DealID = df.DealID and d.DEalID=@DealID
		left join [CORE].FundingSchedule fs on df.[Date]=fs.[Date]  and df.purposeid=fs.purposeid and ISNULL(df.DealFundingRowno,0)=ISNULL(fs.DealFundingRowno,ISNULL(df.DealFundingRowno,0))
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
		INNER JOIN 
					(
						
						Select 
							(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
							MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
							from [CORE].[Event] eve
							INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
							INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
							where EventTypeID = @FundingSchedule
							and n.DealID = @DealID
							and eve.StatusID =@Active  
							and acc.IsDeleted = 0
							GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID

					) sEvent

		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		left join(
			select n.noteid,1 as IsExcludeThirdParty
			from cre.Note n
			inner join core.Account acc on acc.accountid = n.account_accountid
			left join cre.FinancingSourceMaster l on l.FinancingSourceMasterID = n.FinancingSourceID
			--left join cre.Client c on c.ClientID = n.ClientID
			inner join cre.Deal d on d.dealid = n.DealID
			left join cre.DealFunding df on df.dealid = d.dealid
			where acc.isdeleted <> 1
			and l.IsThirdParty=1
			and df.dealfundingid = @DealFundingID
		)tblThirdPartyNotes on tblThirdPartyNotes.noteid = n.noteid

		where sEvent.StatusID = e.StatusID 
		and isnull(acc.StatusID, @Active)!= @InActive 
		and acc.IsDeleted = 0 and 
		df.DealID =@DealID and d.IsDeleted = 0
		and df.DealFundingID=@DealFundingID
	) fn
	on n.NoteID = fn.noteid
	left join cre.FinancingSourceMaster l on l.FinancingSourceMasterID = n.FinancingSourceID
	
	left join
	(
	
Select noteid,value From(
	Select n.noteid,rs.date,rs.[Value],ROW_NUMBER() over (partition by n.noteid order by n.noteid,rs.date desc) rno 
	from [CORE].RateSpreadSchedule rs  
	INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
	LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID  
	LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID  
	INNER JOIN   
	(          
		Select   
		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')  
		and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)     
		and acc.IsDeleted = 0  
		GROUP BY n.Account_AccountID,EventTypeID    
	) sEvent    
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where e.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)  
	and  rs.ValueTypeID=151
	and rs.Date<=cast(getdate() as date) 
)a where a.rno = 1)sprd on sprd.NoteID=n.NoteID
--
	left join
	(
	
Select noteid,value From(
	Select n.noteid,rs.AdditionalSpread as value 
	from [CORE].PIKSchedule rs  
	INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
	INNER JOIN   
	(          
		Select   
		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'PIKSchedule')  
		and isnull(eve.StatusID,1) = 1
		and acc.IsDeleted = 0  
		GROUP BY n.Account_AccountID,EventTypeID    
	) sEvent    
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where isnull(e.StatusID,1) = 1 
)a) piksprd on piksprd.NoteID=n.NoteID
--
	
	where d.DealID =@DealID and ac.IsDeleted=0 and ac.StatusID=1
)x

order by ISNULL(x.lienposition,99999), x.Priority ,x.InitialFundingAmount desc,x.Name --, x.CreatedDate desc


set @ParentClients =STUFF((SELECT distinct ', ' + ParentClient
			FROM @tblPayoffDetail where --IsExcludeThirdParty=0
			CurrentBalance<>0
			FOR XML PATH('')), 1, 2, '')
set @FinancingSources = STUFF((SELECT distinct ', ' + FinancingSourceName
			FROM @tblPayoffDetail where --IsExcludeThirdParty=0
			CurrentBalance<>0
			FOR XML PATH('')), 1, 2, '')
set @ThirpPartyFinancingSources = STUFF((SELECT distinct ', ' + FinancingSourceName
			FROM @tblPayoffDetail where IsExcludeThirdParty=1
			FOR XML PATH('')), 1, 2, '')

	

--get top note by liner posiion

select top 1 @topNoteID=NoteID,@topCRENoteID=CRENoteID from @tblPayoffDetail order by ID


--get index floor of the top note
Select @IndexFloor=Value from(                            
  Select nn.CRENoteID,                            
  nn.noteid,ROW_NUMBER() OVER (PARTITION BY nn.noteid  ORDER BY rs.date desc) AS RNO,                            
  rs.date,rs.IntCalcMethodID,LValueTypeID.name,LIntCalcMethodID.value as CalcMethodIDtext,rs.Value                            
  from [CORE].RateSpreadSchedule rs                            
  INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId                            
 LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID                    
  LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID                            
  INNER JOIN                    
   (                            
                                  
    Select                             
     (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,                       
     MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve                            
     INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID                            
     INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID                            
     where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')                            
     and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)                            
     and acc.IsDeleted = 0  
	 and n.crenoteid =@topCRENoteID                          
     GROUP BY n.Account_AccountID,EventTypeID                            
                            
   ) sEvent                            
                            
  ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID                            
  left join cre.note nn on nn.Account_AccountID = e.AccountID                            
                            
                            
  where e.StatusID = 1              
  and LValueTypeID.name in ('Index Floor')                            
  )a                            
  where a.RNO = 1 
--
--get initial maturity of top note

Select  @InitialMaturityDate = mat.maturityDate
from [CORE].Maturity mat  
INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
INNER JOIN   
(          
	Select   
	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
	MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
	where EventTypeID = 11  and eve.StatusID = 1
	and acc.IsDeleted = 0  
	and n.NoteID = @topNoteID			
	GROUP BY n.Account_AccountID,EventTypeID    
) sEvent    
ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 		
where mat.maturityType = 708 
and	mat.Approved = 3
and n.NoteID = @topNoteID

--get loan closing date
select @LoanClosingDate=ClosingDate from cre.Note where NoteID=@topNoteID

--get third party note amount
select @ThirpPartyAmount=abs(sum(val)) from
(
select 
(
Select  isnull(fs.Value,0)
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
					and n.NoteID = tp.NoteID  
					and acc.IsDeleted = 0
					and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
					GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID

			) sEvent

ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
and n.noteid = tp.NoteID
and DealFundingID=@DealFundingID
)  as val from @tblPayoffDetail tp where IsExcludeThirdParty=1
) tbl2
--select ((28741296.771000000000000+3274234.620000000000000)/(191608645.140000000000000+16371173.100000000000000+5846847.550000000000000))*100

select @AdjustedTotalCommitmentPik=sum(AdjustedTotalCommitment) from @tblPayoffDetail where PikSpreadPercentage>0 and CurrentBalance<>0

if (ISnull(@AdjustedTotalCommitmentPik,0)=0)
BEGIN
	set @AdjustedTotalCommitmentPik=0
END

--funding detail-additional info
Select sum(InitialFundingAmount) as InitialFundingAmount ,@InitialMaturityDate as InitialMaturityDate,
@LoanClosingDate as ClosingDate,
sum(CurrentBalance) as CurrentBalance,
@TotalCommitment as TotalCommitment,
sum(AdjustedTotalCommitment) as AdjustedTotalCommitment, sum(RemainingUnfunded) as RemainingUnfunded,
(@IndexFloor*100) as IndexFloor,
SpreadPercentage=case when sum(AdjustedTotalCommitment)=0 then 0 else (sum(AdjustedTotalCommitmentPercentage)/sum(AdjustedTotalCommitment))*100 end,
PikSpreadPercentage=case when @AdjustedTotalCommitmentPik=0 then 0 else (sum(AdjustedTotalCommitmentPikPercentage)/@AdjustedTotalCommitmentPik)*100 end,
(case when charindex(',',reverse(@ParentClients))>0 then reverse(replace(STUFF(reverse(@ParentClients),charindex(',',reverse(@ParentClients)),0,'#'),'#,','dna ')) else @ParentClients end) as ParentClient,
(case when charindex(',',reverse(@FinancingSources))>0 then reverse(replace(STUFF(reverse(@FinancingSources),charindex(',',reverse(@FinancingSources)),0,'#'),'#,','dna ')) else @FinancingSources end) as FinancingSourceName
,isnull(@ThirpPartyFinancingSources,'N/A') as ThirpPartyFinancingSources
,isnull(@ThirpPartyAmount,0) ThirpPartyAmount,
@ExitFee as ExitFee ,@ExitFeePercentage as ExitFeePercentage,@PrepayPremium as PrepayPremium
from @tblPayoffDetail --where IsExcludeThirdParty=0

--funding detail by parent client(investor)
select ParentClient,InitialFundingAmount,CurrentBalance,AdjustedTotalCommitment,
RemainingUnfunded,
SpreadPercentage=case when RowType='Total' then (case when AdjustedTotalCommitment=0 then 0 else (AdjustedTotalCommitmentPercentage/AdjustedTotalCommitment)*100 end) else SpreadPercentage end,
PikSpreadPercentage=case when RowType='Total' then (case when @AdjustedTotalCommitmentPik=0 then 0 else (AdjustedTotalCommitmentPikPercentage/@AdjustedTotalCommitmentPik)*100 end) else PikSpreadPercentage end,

--IsExcludeThirdParty,
RowType
from
(
select replace(ParentClient,'zzzzz','') as ParentClient,InitialFundingAmount,CurrentBalance,AdjustedTotalCommitment,
AdjustedTotalCommitmentPercentage
,AdjustedTotalCommitmentPikPercentage
,abs(RemainingUnfunded) as RemainingUnfunded,
SpreadPercentage,--IsExcludeThirdParty,
PikSpreadPercentage,
RowType
from
(
Select ParentClient,sum(InitialFundingAmount) as InitialFundingAmount ,sum(CurrentBalance) as CurrentBalance,
sum(AdjustedTotalCommitment) as AdjustedTotalCommitment, sum(RemainingUnfunded) as RemainingUnfunded,
SpreadPercentage=case when sum(AdjustedTotalCommitment)=0 then 0 else (sum(AdjustedTotalCommitmentPercentage)/sum(AdjustedTotalCommitment))*100 end,
PikSpreadPercentage=case when @AdjustedTotalCommitmentPik=0 then 0 else (sum(AdjustedTotalCommitmentPikPercentage)/@AdjustedTotalCommitmentPik)*100 end,

sum(AdjustedTotalCommitmentPercentage) as AdjustedTotalCommitmentPercentage,
sum(AdjustedTotalCommitmentPikPercentage) as AdjustedTotalCommitmentPikPercentage,

--IsExcludeThirdParty,
'Data' as RowType
from @tblPayoffDetail
group by ParentClient--,IsExcludeThirdParty having IsExcludeThirdParty=0
union
Select 'zzzzzTotal' as ParentClient,sum(InitialFundingAmount) as InitialFundingAmount ,sum(CurrentBalance) as CurrentBalance,
sum(AdjustedTotalCommitment) as AdjustedTotalCommitment, sum(RemainingUnfunded) as RemainingUnfunded,
sum(SpreadPercentage) as SpreadPercentage,
sum(PikSpreadPercentage) as PikSpreadPercentage,

sum(AdjustedTotalCommitmentPercentage) as AdjustedTotalCommitmentPercentage,
sum(AdjustedTotalCommitmentPikPercentage) as AdjustedTotalCommitmentPikPercentage,
--0 as IsExcludeThirdParty,
'Total' as RowType
from 
(
 select sum(InitialFundingAmount) as InitialFundingAmount ,sum(CurrentBalance) as CurrentBalance,
sum(AdjustedTotalCommitment) as AdjustedTotalCommitment, sum(RemainingUnfunded) as RemainingUnfunded,
SpreadPercentage=case when sum(AdjustedTotalCommitment)=0 then 0 else (sum(AdjustedTotalCommitmentPercentage)/sum(AdjustedTotalCommitment))*100 end,
PikSpreadPercentage=case when @AdjustedTotalCommitmentPik=0 then 0 else (sum(AdjustedTotalCommitmentPikPercentage)/@AdjustedTotalCommitmentPik)*100 end,
sum(AdjustedTotalCommitmentPercentage) as AdjustedTotalCommitmentPercentage,
sum(AdjustedTotalCommitmentPikPercentage) as AdjustedTotalCommitmentPikPercentage,

--IsExcludeThirdParty,
'Data' as RowType
from @tblPayoffDetail
group by ParentClient--,IsExcludeThirdParty having IsExcludeThirdParty=0
) tblgroup
) tbl

)tblmain
where CurrentBalance<>0
order by tblmain.ParentClient



select @AdjustedTotalCommitmentPikdelphi=sum(AdjustedTotalCommitment) from @tblPayoffDetail where PikSpreadPercentage>0 and CurrentBalance<>0
and FinancingSourceName like '%delphi%' and FinancingSourceMasterID<>26

if (isnull(@AdjustedTotalCommitmentPikdelphi,0)=0)
BEGIN
	set @AdjustedTotalCommitmentPikdelphi=0
END

--delphi funding detail by note
select TaxVendorLoanNumber,NoteID,FinancingSourceName,Name,InitialFundingAmount,CurrentBalance,AdjustedTotalCommitment,
 abs(RemainingUnfunded) as RemainingUnfunded,SpreadPercentage,PikSpreadPercentage,ParentClient,RowType from 
(
Select TaxVendorLoanNumber,CRENoteID as NoteID,FinancingSourceName,Name,InitialFundingAmount,CurrentBalance,AdjustedTotalCommitment,
 RemainingUnfunded,SpreadPercentage,PikSpreadPercentage,ParentClient,'Data' as RowType
from @tblPayoffDetail where --IsExcludeThirdParty=0 and 
FinancingSourceName like '%delphi%' and FinancingSourceMasterID<>26
union
Select 'Total','' as NoteID,'' as FinancingSourceName,'' as Name,sum(InitialFundingAmount) as InitialFundingAmount,
sum(CurrentBalance) as CurrentBalance,sum(AdjustedTotalCommitment) as AdjustedTotalCommitment, 
sum(RemainingUnfunded) as RemainingUnfunded,
SpreadPercentage=case when sum(AdjustedTotalCommitment)=0 then 0 else (sum(AdjustedTotalCommitmentPercentage)/sum(AdjustedTotalCommitment))*100 end,
PikSpreadPercentage=case when @AdjustedTotalCommitmentPikdelphi=0 then 0 else (sum(AdjustedTotalCommitmentPikPercentage)/@AdjustedTotalCommitmentPikdelphi)*100 end,

'' as ParentClient,'Total' as RowType
from @tblPayoffDetail where --IsExcludeThirdParty=0 and 
FinancingSourceName like '%delphi%' and FinancingSourceMasterID<>26
) tbl
where exists (select 1 from @tblPayoffDetail where --IsExcludeThirdParty=0 and 
FinancingSourceName like '%delphi%' and FinancingSourceMasterID<>26)
and CurrentBalance<>0


--all funding detail by note
Select TaxVendorLoanNumber,NoteID,FinancingSourceName,Name,InitialFundingAmount,CurrentBalance,AdjustedTotalCommitment,
 abs(RemainingUnfunded) as RemainingUnfunded,SpreadPercentage,PikSpreadPercentage, ParentClient,RowType
 from
 (
 Select TaxVendorLoanNumber,CRENoteID as NoteID,FinancingSourceName,Name,InitialFundingAmount,CurrentBalance,AdjustedTotalCommitment,
 RemainingUnfunded,SpreadPercentage,PikSpreadPercentage,ParentClient,'Data' as RowType
from @tblPayoffDetail --where IsExcludeThirdParty=0
union
Select 'Total','' as NoteID,'' as FinancingSourceName,'' as Name,sum(InitialFundingAmount) as InitialFundingAmount,
sum(CurrentBalance) as CurrentBalance,sum(AdjustedTotalCommitment) as AdjustedTotalCommitment, 
sum(RemainingUnfunded) as RemainingUnfunded,
SpreadPercentage=case when sum(AdjustedTotalCommitment)=0 then 0 else (sum(AdjustedTotalCommitmentPercentage)/sum(AdjustedTotalCommitment))*100 end,
PikSpreadPercentage=case when @AdjustedTotalCommitmentPik=0 then 0 else (sum(AdjustedTotalCommitmentPikPercentage)/@AdjustedTotalCommitmentPik)*100 end,
'' as ParentClient,'Total' as RowType
from @tblPayoffDetail --where IsExcludeThirdParty=0 
) tbl
where CurrentBalance<>0
--where exists (select 1 from @tblPayoffDetail where IsExcludeThirdParty=0)
	
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
