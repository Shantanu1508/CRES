
--[dbo].[usp_GetNoteAllocationPercentage] '2B874076-5572-408B-B8EB-04DEE8256EBB','2B874076-5572-408B-B8EB-04DEE8256EBB'

CREATE PROCEDURE [dbo].[usp_GetNoteAllocationPercentage]  
(
  @DealFundingID Uniqueidentifier,
  @UserID nvarchar(256)
)	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


	
Declare @DealID UNIQUEIDENTIFIER 
SET @DealID = (Select top 1 Dealid from cre.DealFunding where DealFundingID = @DealFundingID) --'2A100A7A-AD02-478C-807A-AD5DEBB8CFED'

Declare @ColPivot nvarchar(max),@ColPivot1 nvarchar(max),@ColPivot2 nvarchar(max),@query1 nvarchar(max),@query2 nvarchar(max)


SET @ColPivot = STUFF((SELECT  ',ISNULL(' + QUOTENAME(cast(np.TrancheName as nvarchar(256)) )   +',0) as '  + QUOTENAME(cast(np.TrancheName as nvarchar(256))) 								
								from CRE.ClientTrancheMapping np								
								where ClientName like '%Delphi%' 
								and IsDeleted=0
								order by SortOrder						
														
						FOR XML PATH(''), TYPE
						).value('.', 'NVARCHAR(MAX)') 
					,1,1,'')

SET @ColPivot1 = STUFF((SELECT  ',' + QUOTENAME(cast(np.TrancheName as nvarchar(256)) )   						
								from CRE.ClientTrancheMapping np								
								where ClientName like '%Delphi%' 
								and IsDeleted=0
								order by SortOrder	 					
														
						FOR XML PATH(''), TYPE
						).value('.', 'NVARCHAR(MAX)') 
					,1,1,'')

--SET @ColPivot2 = 'CASE WHEN'+ (STUFF((SELECT  '+ISNULL(' + QUOTENAME(cast(np.TrancheName as nvarchar(256)) )   +',0)' 								
--			from CRE.ClientTrancheMapping np								
--			where ClientName like '%Delphi%'				
														
--	FOR XML PATH(''), TYPE
--	).value('.', 'NVARCHAR(MAX)') 
--,1,1,'')+' )>0 then ISNULL(TotalParticipation,0) * 100 else 0 end'		


SET @ColPivot2 = '('+STUFF((SELECT  '+ISNULL(' + QUOTENAME(cast(np.TrancheName as nvarchar(256)) )   +',0)' 								
			from CRE.ClientTrancheMapping np								
			where ClientName like '%Delphi%' 
			and IsDeleted=0
			order by SortOrder				
														
	FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)') 
,1,1,'') + ') as Total'


set @query1=N'
SELECT  NoteName as [Note Name],'+@ColPivot+','+@ColPivot2+'
FROM   
(
	Select d.dealid,d.dealname,acc.Name as NoteName,ISNULL(n.lienposition,99999) as lienposition, n.Priority,n.InitialFundingAmount,acc.Name,n.CRENoteId,np.TrancheName,np.PercentofNote * 100 as PercentofNote,
	SUM(PercentofNote) over(Partition by n.noteid) as TotalParticipation
	
	from cre.note n
	inner join cre.Deal d on d.DealID = n.DealID
	inner join core.account acc on acc.accountid = n.account_accountid
	left join cre.NoteTranchePercentage np on np.crenoteid = n.crenoteid
	join cre.FinancingSourceMaster fm on fm.financingsourcemasterid = n.FinancingSourceID
	where acc.IsDeleted = 0
	and d.dealid in (
		Select Distinct DealID from cre.note 
		where FinancingSourceID in (Select financingsourcemasterid from cre.FinancingSourceMaster where ParentClient like ''%Delphi%'')
		and dealid = '''+convert(varchar(256),@DealID)+'''
	)
	and fm.IsThirdParty=0
	and n.FinancingSourceID in (
		 Select financingsourcemasterid from cre.FinancingSourceMaster where ParentClient like ''%Delphi%''
	)
	
) t 
PIVOT(
	SUM(PercentofNote) 
	FOR TrancheName IN ('+@ColPivot1+')
) AS pivot_table
order by lienposition,Priority,InitialFundingAmount desc,NoteName
'

---========================================================================
create table #tablePennyDiff
(
rownum int,
NoteName nvarchar(256),
Difference_Penny decimal(28,15)
)


insert into #tablePennyDiff

select min(num) num ,name,amt_diff from 
(
    select num ,name,amt_diff from 
	(
	Select acc.Name,ROUND(tblff.Value * ISNULL(np.PercentofNote,1),2) as PercentofNote,
	tblff.Value-ROUND(SUM(ROUND(tblff.Value * ISNULL(np.PercentofNote,1),2)) over(Partition by n.noteid),2) amt_diff
	,ROW_NUMBER()  OVER (order by acc.Name,ctm.SortOrder) as num
	from cre.note n
	inner join cre.Deal d on d.DealID = n.DealID
	inner join core.account acc on acc.accountid = n.account_accountid
	left join cre.NoteTranchePercentage np on np.crenoteid = n.crenoteid
	left join CRE.ClientTrancheMapping ctm on ctm.TrancheName = np.TrancheName and ctm.IsDeleted=0
	Left Join (

	
	Select n.noteid,fs.Value Value		
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
						where EventTypeID = 10
						and n.DealID = @DealID
						and eve.StatusID =1  
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
			and ISNULL(acc.StatusID,1) <> 0
			and acc.IsDeleted = 0 and 
			df.DealID =@DealID and d.IsDeleted = 0
			and df.DealFundingID=@DealFundingID

	)tblFF on n.NoteID = tblFF.NoteID
	join cre.FinancingSourceMaster fm on fm.financingsourcemasterid = n.FinancingSourceID
	where acc.IsDeleted = 0
		and d.dealid in (
		Select Distinct DealID from cre.note 
		where FinancingSourceID in (Select financingsourcemasterid from cre.FinancingSourceMaster where ParentClient like '%Delphi%')
		and dealid = @DealID
	)
	and n.noteid in (
		Select Distinct NoteID from cre.note 
		where FinancingSourceID in (Select financingsourcemasterid from cre.FinancingSourceMaster where ParentClient like '%Delphi%')
		and dealid = @DealID
	)
	and n.FinancingSourceID in (
		 Select financingsourcemasterid from cre.FinancingSourceMaster where ParentClient like '%Delphi%'
	)
	and  fm.IsThirdParty=0
	) tblinner where tblinner.percentofNote>0
	) tbl group by name,amt_diff


set @query2=N'
SELECT  NoteName as [Note Name],'+@ColPivot1+',FundingAmount as [Funding Amount],ISNULL(TotalParticipation,0) [Total]
FROM   
(
	select dealid,dealname,tblmain.NoteName,ISNULL(lienposition,99999) as lienposition, Priority,InitialFundingAmount,Name,CRENoteId,TrancheName,
PercentofNote+isnull(Difference_Penny,0) PercentofNote ,
TotalParticipation+isnull(amt_diff,0) TotalParticipation,
FundingAmount

from
(
Select d.dealid,d.dealname,acc.Name as NoteName,ISNULL(n.lienposition,99999) as lienposition, n.Priority,n.InitialFundingAmount,acc.Name,n.CRENoteId,np.TrancheName,
	ROUND(tblff.Value * ISNULL(np.PercentofNote,1),2) as PercentofNote,
	--tblff.Value * ISNULL(np.PercentofNote,1) as PercentofNote,
	ROUND(SUM(ROUND(tblff.Value * ISNULL(np.PercentofNote,1),2)) over(Partition by n.noteid),2) as TotalParticipation,
	tblff.Value as FundingAmount
	
	--ROUND(tblff.Value * ISNULL(np.PercentofNote,1),2)+(tblff.Value-ROUND(SUM(ROUND(tblff.Value * ISNULL(np.PercentofNote,1),2)) over(Partition by n.noteid),2))	as amt_diff

	,tblff.Value-ROUND(SUM(ROUND(tblff.Value * ISNULL(np.PercentofNote,1),2)) over(Partition by n.noteid),2) amt_diff
	,ROW_NUMBER()  OVER (order by acc.Name,ctm.SortOrder) as rownum
	,n.noteid
	--,(select min(ROW_NUMBER()  OVER (order by n.lienposition,n.Priority,n.InitialFundingAmount desc,acc.Name)) group by acc.Name) minval
	from cre.note n
	inner join cre.Deal d on d.DealID = n.DealID
	inner join core.account acc on acc.accountid = n.account_accountid
	left join cre.NoteTranchePercentage np on np.crenoteid = n.crenoteid
	left join CRE.ClientTrancheMapping ctm on ctm.TrancheName = np.TrancheName and ctm.IsDeleted=0
	Left Join (

	
	Select n.noteid,fs.Value Value		
			from 
			[CRE].[DealFunding] df
			left join cre.deal d on d.DealID = df.DealID and d.DEalID='''+convert(varchar(256),@DealID)+'''
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
						where EventTypeID = 10
						and n.DealID = '''+convert(varchar(256),@DealID)+'''
						and eve.StatusID =1  
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
			and df.dealfundingid = '''+convert(varchar(256),@DealFundingID)+'''		   
			)tblThirdPartyNotes on tblThirdPartyNotes.noteid = n.noteid
			where sEvent.StatusID = e.StatusID 
			and ISNULL(acc.StatusID,1) <> 0
			and acc.IsDeleted = 0 and 
			df.DealID ='''+convert(varchar(256),@DealID)+''' and d.IsDeleted = 0
			and df.DealFundingID='''+convert(varchar(256),@DealFundingID)+'''	

	)tblFF on n.NoteID = tblFF.NoteID
	join cre.FinancingSourceMaster fm on fm.financingsourcemasterid = n.FinancingSourceID
	where acc.IsDeleted = 0
	and d.dealid in (
		Select Distinct DealID from cre.note 
		where FinancingSourceID in (Select financingsourcemasterid from cre.FinancingSourceMaster where ParentClient like ''%Delphi%'')
		and dealid = '''+convert(varchar(256),@DealID)+'''
	)
	and n.noteid in (
		Select Distinct NoteID from cre.note 
		where FinancingSourceID in (Select financingsourcemasterid from cre.FinancingSourceMaster where ParentClient like ''%Delphi%'')
		and dealid = '''+convert(varchar(256),@DealID)+'''
	)
	and fm.IsThirdParty=0 
	and n.FinancingSourceID in (
		 Select financingsourcemasterid from cre.FinancingSourceMaster where ParentClient like ''%Delphi%''
	)
	) tblmain

	left join #tablePennyDiff tpd on tblmain.rownum=tpd.rownum
) t 
PIVOT(
	SUM(PercentofNote) 
	FOR TrancheName IN ('+@ColPivot1+')
) AS pivot_table
order by lienposition,Priority,InitialFundingAmount desc,NoteName
'

--where FinancingSourceID in (Select FinancingSourceID from cre.FinancingSourceMaster where ParentClient like ''%Delphi%'')
--	and d.dealid = '''+convert(varchar(256),@DealID)+'''


--PRINT(@query1)
EXEC(@query1)

--PRINT(@query2)
EXEC(@query2)

drop table  #tablePennyDiff
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END  

