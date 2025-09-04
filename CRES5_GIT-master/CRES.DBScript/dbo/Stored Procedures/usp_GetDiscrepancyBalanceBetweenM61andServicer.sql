CREATE PROCEDURE [dbo].[usp_GetDiscrepancyBalanceBetweenM61andServicer]   
AS  
BEGIN  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  


Declare @LastImportedDate datetime = (select MAX(UpdatedDate)	from DW.BerkadiaDataTap )

Declare @tblSvrblsCompare as table(
CREDealID	nvarchar(256),
dealname	nvarchar(256),
WatchlistStatus nvarchar(256),
CRENoteID	nvarchar(256),
NoteName	nvarchar(256),
ServicerName nvarchar(256),	
ServicerID	 nvarchar(256),
PurposeType nvarchar(256),
LastPaydown	date,
LastPaydownAmount	decimal(28,15),
M61_Balance	decimal(28,15),
Servicer_Balance	decimal(28,15),
delta decimal(28,15),
ServicingStatusBS nvarchar(256)
)

Insert Into @tblSvrblsCompare(CREDealID,dealname,WatchlistStatus,CRENoteID,NoteName,ServicerName,ServicerID,PurposeType,LastPaydown,LastPaydownAmount,M61_Balance,Servicer_Balance,delta,ServicingStatusBS)

Select CREDealID,dealname,WatchlistStatus,CRENoteID,NoteName,ServicerName,ServicerID,PurposeType,LastPaydown,LastPaydownAmount,SUM_M61Bls as M61_Balance,Servicer_Balance,(SUM_M61Bls - Servicer_Balance) delta,ServicingStatusBS
From(

Select CREDealID,dealname,WatchlistStatus,CRENoteID,NoteName,ServicerName,ServicerID,PurposeType,LastPaydown,LastPaydownAmount,M61_Balance,Servicer_Balance,delta,ServicingStatusBS
,ROW_NUMBER() Over(Partition By  CREDEalID,ServicerID  Order by CREDEalID,ISNULL(Servicer_Balance,0) desc) as RNO
,SUM(M61_Balance) Over(Partition By CREDEalID,ServicerID Order by CREDEalID,ISNULL(Servicer_Balance,0)) as SUM_M61Bls
from( 

Select CREDealID
,dealname
,WatchlistStatus
,M61tbl.CRENoteID 
,NoteName 
,ServicerName
,ServicerID
,ff.PurposeType
,ff.date as LastPaydown
,ff.amount as LastPaydownAmount
--,periodenddate 
--,InitialFundingamount
,EndingBalance   as M61_Balance
,ROUND(ISNULL(wells.Balance_After_Funding_Transacton,berkedia.Principal_Balance),2) as Servicer_Balance
,(ROUND(EndingBalance,2) - ROUND(ISNULL(wells.Balance_After_Funding_Transacton,berkedia.Principal_Balance),2)) as delta
--,wells.Balance_After_Funding_Transacton as Wells_Balance
--,berkedia.Principal_Balance as Barkedia_Balance
,ServicingStatusBS
FROM(
	Select CREDealID,dealname
	,WatchlistStatus
	,CRENoteID 
	,NoteName 
	,ServicerName
	,ServicerID
	,periodenddate 
	,InitialFundingamount
	,(caSE WHEN ROUND(InitialFundingamount,2) = 0.01 THEN ROUND(EndingBalance,2) - 0.01 ELSE ROUND(EndingBalance,2) END ) as EndingBalance  
	,ServicingStatusBS
	from(  
		select d.dealid,d.CREDealID,d.dealname,d.WatchlistStatus, acc.name as NoteName,n.noteid,n.CRENoteID,s.ServicerName,n.ServicerID,n.InitialFundingamount,np.periodenddate,EndingBalance ,ROW_NUMBER() OVER(Partition by n.noteid order by n.noteid,np.periodenddate desc) rno  ,n.ServicingStatusBS
		from  cre.NotePeriodicCalc np
		Inner join core.account acc on acc.accountid = np.AccountID
		Inner join cre.note n on n.account_accountid = acc.accountid	
		inner join cre.deal d on d.dealid = n.dealid
		Left Join cre.servicer s on s.servicerid = n.ServicerNameID
		where acc.isdeleted <> 1  
		and np.analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' 
		and np.periodenddate <= cast(getdate() as date) 
		--and EndingBalance is not null	
		and d.status = 323  
		AND d.DealName NOT LIKE '%copy%'
		--and n.noteid = @NoteId  
	)a where rno = 1
)M61tbl
Left Join(
	Select NoteID,Entry_No,TransactionDate,Balance_After_Funding_Transacton,Transaction_Type,RNo
	from(
		select wl.NoteID
		,Entry_No
		,TransactionDate
		,Balance_After_Funding_Transacton
		,Transaction_Type
		,ROW_NUMBER() over(partition bY wl.noteID order by wl.NoteID,wl.Entry_No desc) as RNo
		from DW.WellsDataTap wl
		inner Join(
			SELECT NoteId
			,MAx(TransactionDate) as max_TransactionDate -- Get most recent transaction date
			FROM WellsDataTap WDT
			WHERE TransactionDate <= Cast(Getdate() as date)
			GROUP BY NoteID
		)max_trdt on wl.noteid = max_trdt.noteid and wl.TransactionDate = max_trdt.max_TransactionDate
		--where wl.noteid = '10141'
	)a
	Where RNo = 1
)wells on wells.noteid = M61tbl.crenoteid
Left Join(
	select NoteID,Principal_Balance 
	from DW.BerkadiaDataTap 
)berkedia on berkedia.noteid = M61tbl.crenoteid
Left JOin(
	Select crenoteid,date,amount,PurposeType
	From(
	Select n.crenoteid,fs.date,fs.value as amount,LPurposeID.name as PurposeType,
	ROW_NUMBER() OVER(Partition by n.crenoteid order by n.crenoteid,fs.date desc) rno
	from [CORE].FundingSchedule fs
	INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
	INNER JOIN(						
		Select 
		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
		from [CORE].[Event] eve
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
		--and n.NoteID = @NoteId  
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
	where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
	and fs.date <= cast(getdate() as date) 
	--and n.crenoteid = '5712'
	)a where rno = 1
)ff  on ff.crenoteid = M61tbl.crenoteid

)z
---Where Servicer_Balance is not NULL and abs(ISNULL(delta,0)) > 1 

)tt
where RNO = 1
and abs(ISNULL((SUM_M61Bls - Servicer_Balance),0)) > 1 
---==================================================================

declare @tblservicerwisebls as table(
servicerid nvarchar(256),	
CRENoteID nvarchar(256),	
[balance] decimal(28,15)
)

insert into @tblservicerwisebls (servicerid,CRENoteID,[balance])
select servicerid,CRENoteID,SUM(EndingBalance) AS [balance]
from(

	Select servicerid,CRENoteID,periodenddate,ISNULL(EndingBalance,0) as EndingBalance
	From(
		select n.servicerid,n.CRENoteID,np.periodenddate,EndingBalance 
		,ROW_NUMBER() OVER(Partition by n.noteid order by n.noteid,np.periodenddate desc) rno  		
		from  cre.NotePeriodicCalc np
		Inner join core.account acc on acc.accountid = np.AccountID
		Inner join cre.note n on n.account_accountid = acc.accountid	
		inner join cre.deal d on d.dealid = n.dealid
		Left Join cre.servicer s on s.servicerid = n.ServicerNameID
		where acc.isdeleted <> 1  
		and np.analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' 
		and np.periodenddate <= cast(getdate() as date) 
		--and EndingBalance is not null	
		and d.status = 323 	
		and n.servicerid is not null
		AND d.DealName NOT LIKE '%copy%'
		--and dealname = '21c Museum Hotel Chicago'		
	)a where rno = 1

)z
group by servicerid,CRENoteID



select * from(
	select cmp.CREDealID,DealName
	,cmp.WatchlistStatus
	,cmp.CRENoteID
	,cmp.NoteName
	,cmp.ServicerName
	,cmp.ServicerID
	,cmp.purposetype
	,cmp.LastPaydown
	,cmp.LastPaydownAmount
	,svrid.balance as M61_Balance
	,cmp.Servicer_Balance
	,(ROUND(svrid.balance,2) - ROUND(cmp.Servicer_Balance,2)) as delta
	--,cmp.delta
	,svridList.List_crenoteid
	,@LastImportedDate as CreatedDate
	,ServicingStatusBS
	from @tblSvrblsCompare cmp
	left join(
		SELECT  servicerid,CRENoteID,[balance]			  
		FROM @tblservicerwisebls t
		GROUP BY servicerid,[balance],CRENoteID
	)svrid on svrid.servicerid = cmp.ServicerID and  svrid.CRENoteID = cmp.CRENoteID
	left join(
		SELECT  servicerid
			   ,STUFF((SELECT ', ' + CAST(CRENoteID AS VARCHAR(10)) [text()]
				 FROM @tblservicerwisebls 
				 WHERE servicerid = t.servicerid
				 FOR XML PATH(''), TYPE)
				.value('.','NVARCHAR(MAX)'),1,2,' ') List_crenoteid
		FROM @tblservicerwisebls t
		GROUP BY servicerid

	)svridList on svridList.servicerid = cmp.ServicerID

)z
Where abs(ISNULL(z.delta,0)) > 1 

Order by dealname,crenoteid




 SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
END  