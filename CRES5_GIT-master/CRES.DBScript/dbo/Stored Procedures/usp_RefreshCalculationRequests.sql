--[usp_RefreshCalculationRequests] '4F25C598-FE91-4A28-A20B-BF936E91B2E8','c10f3372-0fc2-4861-a9f5-148f1f80804f','c10f3372-0fc2-4861-a9f5-148f1f80804f'  
--[usp_RefreshCalculationRequests] '00000000-0000-0000-0000-000000000000','c10f3372-0fc2-4861-a9f5-148f1f80804f','c10f3372-0fc2-4861-a9f5-148f1f80804f'  
  
CREATE PROCEDURE [dbo].[usp_RefreshCalculationRequests]   
(  
@PortfolioMasterGuid uniqueidentifier,  
@AnalysisID uniqueidentifier,  
@UserID uniqueidentifier  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
--declare @cashflowEngineId int;    
--Select @cashflowEngineId=lookupid from core.Lookup where ParentID=47 and Name='Default'  

declare @maturityDateID int  
declare @currDate  datetime  
declare @FilterDate datetime  
declare @FilterStartDate date  
declare @FilterEndDate date  
declare @ObjectTypeCount int = 0  
declare @ObjectTypeID int = 0  
declare @ObjectID int = 0  
  
set @currDate = getdate()  
  

Declare @CalcEngineType int;
SET  @CalcEngineType = (Select CalcEngineType from [Core].[AnalysisParameter] where AnalysisID = @AnalysisID) 
---=========================================  

Declare @AnalysisID_PrepaymentDefault UNIQUEIDENTIFIER;
SET @AnalysisID_PrepaymentDefault = (Select AnalysisID from core.Analysis where [Name] = 'Prepayment Default')


  
IF (@PortfolioMasterGuid is null or @PortfolioMasterGuid='00000000-0000-0000-0000-000000000000')  
BEGIN  

	SELECT   
	distinct n.[NoteId]       
	,ac.[Name]  
	,[RequestTime]  
	,cr.[StatusID]  
	,(CASE WHEN l.[Name] IS NULL and CalculationRequestID is not null THEN 'Processing' WHEN l.[Name] = 'SaveDBPending' THEN 'Running'	ELSE l.[Name] END) as StatusText  	
	,cr.[UserName]  
	,cr.[ApplicationID]  
	,lApplication.[Name] as ApplicationText  
	,cr.[StartTime]  as StartTime  
	,cr.[EndTime] as EndTime   
	,cr.[PriorityID]  
	,lPriority.[Name] as PriorityText 
	--,(CASE 	WHEN cr.CalcEngineType = 798 	THEN lg.Message	ELSE cr.[ErrorMessage] 	END) AS ErrorMessage
	,null as ErrorMessage
	,cr.[ErrorDetails]  
	,n.DealId  
	,d.DealName  
	,n.CRENoteID  
	,n.CashflowEngineID  
	,cr.CalculationRequestID  
	,(Select top 1 FileName from core.CalculatorOutputJsonInfo cout where cout.CalculationRequestID = cr.CalculationRequestID order by cout.CreatedDate desc) as [FileName]     
	,ISNULL(n.EnableM61Calculations,3) as EnableM61Calculations  
	,lEnableM61Calculations.name as EnableM61CalculationsText  
	---,(CASE WHEN n.EnableM61Calculations = 4 THEN 0 else 1 end) Active  
	,(Select top 1 FileName from core.CalculatorOutputJsonInfo cout where cout.RequestID = cr.RequestID order by cout.CreatedDate desc) as [FileName_V1]     
	,n.ActualPayOffDate as PayOffDate  
	,(CASE WHEN tblActiveDeal.dealid IS NULL THEN 1 ELSE 0 END) as IsPaidOffDeal   
	,ISNULL(cr.CalcEngineType,ISNULL(d.CalcEngineType,797)) as CalcEngineType
	,lCalcEngineType.name as CalcEngineTypeText
	,tbl_Pclose.CloseDate as AccountingCloseDate
	,d.Prepaydate
	from  CRE.Note n  
	left join Core.CalculationRequests cr on n.Account_AccountID=cr.AccountId and cr.AnalysisID=@AnalysisID  
	inner JOIN core.Account ac ON ac.AccountID = n.Account_AccountID  
	inner join cre.Deal d on n.DealId = d.DealId  
	left join Core.Lookup l ON cr.[StatusID]=l.LookupID  
	left join Core.Lookup lPriority ON cr.[PriorityID]=lPriority.LookupID  
	left join Core.Lookup lApplication ON cr.[ApplicationID]=lApplication.LookupID  
	left join Core.Lookup lstaus on lstaus.LookupID = ac.StatusID and ac.IsDeleted=0   
	left join Core.Lookup lEnableM61Calculations on lEnableM61Calculations.LookupID = ISNULL(n.EnableM61Calculations,3)   
	left join Core.Lookup lCalcEngineType ON ISNULL(cr.CalcEngineType,ISNULL(d.CalcEngineType,797)) =lCalcEngineType.LookupID  
	left Join(  
		Select Distinct d.dealid   
		from  CRE.Note n  
		inner JOIN core.Account acc ON acc.AccountID = n.Account_AccountID  
		inner join cre.Deal d on n.DealId = d.DealId  
		where acc.isdeleted <> 1 and n.ActualPayOffDate is null  
	)tblActiveDeal on tblActiveDeal.dealid = d.dealid  
	Left Join(
		Select Account_AccountID,noteid,LastAccountingCloseDate as CloseDate 
		from(
			Select 
			d.DealID,n.Account_AccountID,n.noteid,p.CloseDate as LastAccountingCloseDate    
			,ROW_NUMBER() OVER (Partition BY d.dealid,n.noteid order by d.dealid,n.noteid,p.updateddate desc) rno
			from cre.deal d
			Inner join cre.note n on n.dealid = d.dealid
			Inner join (
				Select dealid,CloseDate,updateddate
				from CORE.[Period]
				where CloseDate is not null
			)p on d.dealid = p.dealid 
			Where d.IsDeleted <> 1
		)a
		where a.rno = 1
	)tbl_Pclose on tbl_Pclose.Account_AccountID = cr.AccountId

	--LEFT JOIN (
	--	SELECT 
	--	lr.RequestID, 
	--	l.Message
	--	FROM Core.CalculationRequests lr
	--	INNER JOIN app.logger l ON lr.RequestID = l.ObjectID and l.Severity = 'Error' and Module = 'Calculator'
	--	WHERE l.Severity = 'Error' and lr.StatusID=265 and Module = 'Calculator'
	--	and AnalysisID=@AnalysisID 
	--) lg ON cr.RequestID = lg.RequestID

	where  n.noteID not in (select distinct ObjectID FROM CORE.Exceptions where ActionLevelID=293 )  ---(SELECT LookupID FROM Core.Lookup WHERE ParentId=46 AND NAME='Critical')
	--and (n.CashflowEngineID=@cashflowEngineId or n.CashflowEngineID is null)  
	and ac.IsDeleted=0  
	and ISNULL(ac.StatusID,1) = 1  ---(select LookupID from Core.Lookup where  ParentID=1 and Name='active')    
	--and ISNULL(n.EnableM61Calculations,3) = 3 ---'Y'  
	----COndition for prepay scenario
	and 1 = (CASE WHEN @AnalysisID <> ISNULL(@AnalysisID_PrepaymentDefault,'00000000-0000-0000-0000-000000000000')  THEN 1 WHEN (@AnalysisID = @AnalysisID_PrepaymentDefault and  d.Prepaydate is not null) THEN 1  END)

 END  
 ELSE  
 BEGIN  
	 Declare @AllowWholeDeal bit = (Select AllowWholeDeal from  core.PortfolioMaster where PortfolioMasterGuid = @PortfolioMasterGuid)  
  
	 Declare @Dynamic_Portfolio as Table(  
	 PortfolioMasterID int ,  
	 ObjectTypeID int ,  
	 ObjectID int   
	 )  
  
	 INSERT INTO @Dynamic_Portfolio(PortfolioMasterID,ObjectTypeID,ObjectID)  
	 select  pm.PortfolioMasterID,pd.ObjectTypeID,pd.ObjectID   
	 from core.PortfolioMaster pm   
	 inner join core.PortfolioDetail pd on pm.PortfolioMasterID = pd.PortfolioMasterID  
	 where pm.PortfolioMasterGuid=@PortfolioMasterGuid   
	 --============================================  
  
	 SELECT   
	 distinct n.[NoteId]       
	 ,ac.[Name]  
	 ,[RequestTime]  
	 ,cr.[StatusID]  
	 ,(CASE WHEN l.[Name] IS NULL and CalculationRequestID is not null THEN 'Processing' 
	 WHEN l.[Name] = 'SaveDBPending' THEN 'Running'
	 ELSE l.[Name] END) as StatusText  
	 --,l.[Name] as StatusText  
	 ,cr.[UserName]  
	 ,cr.[ApplicationID]  
	 ,lApplication.[Name] as ApplicationText  
	 ,cr.[StartTime]  as StartTime  
	 ,cr.[EndTime] as EndTime   
	 ,cr.[PriorityID]  
	 ,lPriority.[Name] as PriorityText 
	 --,(CASE WHEN cr.CalcEngineType = 798 THEN lg.Message ELSE cr.[ErrorMessage] END) AS ErrorMessage  
	 ,null as ErrorMessage
	 ,cr.[ErrorDetails]  
	 ,n.DealId  
	 ,d.DealName  
	 ,n.CRENoteID  
	 ,n.CashflowEngineID  
	 ,cr.CalculationRequestID  
	 ,( Select top 1 FileName from core.CalculatorOutputJsonInfo cout where cout.CalculationRequestID = cr.CalculationRequestID order by cout.CreatedDate desc) as [FileName]   
	 ,ISNULL(n.EnableM61Calculations,3) as EnableM61Calculations  
	 ,lEnableM61Calculations.name as EnableM61CalculationsText  
	 ----,(CASE WHEN n.EnableM61Calculations = 4 THEN 0 else 1 end) Active  
	 ,(Select top 1 FileName from core.CalculatorOutputJsonInfo cout where cout.RequestID = cr.RequestID order by cout.CreatedDate desc) as [FileName_V1]  
   
	 ,n.ActualPayOffDate  as PayOffDate  
	 ,(CASE WHEN tblActiveDeal.dealid IS NULL THEN 1 ELSE 0 END) as IsPaidOffDeal 
  
	  ,ISNULL(cr.CalcEngineType,ISNULL(d.CalcEngineType,797))  as CalcEngineType
	 ,lCalcEngineType.name as CalcEngineTypeText
	  ,tbl_Pclose.CloseDate as AccountingCloseDate
	  ,d.Prepaydate
	 from  CRE.Note n  
	 left join Core.CalculationRequests cr on n.Account_AccountID=cr.AccountId and cr.AnalysisID=@AnalysisID  
	 inner JOIN core.Account ac ON ac.AccountID = n.Account_AccountID  
	 inner join cre.Deal d on n.DealId = d.DealId  
	 left join Core.Lookup l ON cr.[StatusID]=l.LookupID  
	 left join Core.Lookup lPriority ON cr.[PriorityID]=lPriority.LookupID  
	 left join Core.Lookup lApplication ON cr.[ApplicationID]=lApplication.LookupID  
	 left join Core.Lookup lstaus on lstaus.LookupID = ac.StatusID and ac.IsDeleted=0    
	 left join Core.Lookup lEnableM61Calculations on lEnableM61Calculations.LookupID = ISNULL(n.EnableM61Calculations,3)   
 
	  left join Core.Lookup lCalcEngineType ON ISNULL(cr.CalcEngineType,ISNULL(d.CalcEngineType,797)) =lCalcEngineType.LookupID 

	 left Join(  
	  Select Distinct d.dealid   
	  from  CRE.Note n  
	  inner JOIN core.Account acc ON acc.AccountID = n.Account_AccountID  
	  inner join cre.Deal d on n.DealId = d.DealId  
	  where acc.isdeleted <> 1 and n.ActualPayOffDate is null  
	 )tblActiveDeal on tblActiveDeal.dealid = d.dealid    
  
	Left Join(
		Select Account_AccountID,noteid,LastAccountingCloseDate as CloseDate from(
			Select 
			d.DealID,n.Account_AccountID,n.noteid,p.CloseDate as LastAccountingCloseDate    
			,ROW_NUMBER() OVER (Partition BY d.dealid,n.noteid order by d.dealid,n.noteid,p.updateddate desc) rno
			from cre.deal d
			Inner join cre.note n on n.dealid = d.dealid
			Inner join (
				Select dealid,CloseDate,updateddate
				from CORE.[Period]
				where CloseDate is not null
			)p on d.dealid = p.dealid 
			Where d.IsDeleted <> 1
		)a
		where a.rno = 1
	)tbl_Pclose on tbl_Pclose.Account_AccountID = cr.AccountId

	--LEFT JOIN (
	--	SELECT 
	--	lr.RequestID, 
	--	l.Message
	--	FROM Core.CalculationRequests lr
	--	INNER JOIN app.logger l ON lr.RequestID = l.ObjectID 
	--	WHERE l.Severity = 'Error' and lr.StatusID=265
	--) lg ON cr.RequestID = lg.RequestID

	 where    
	 n.noteID not in (select distinct ObjectID FROM CORE.Exceptions where ActionLevelID= 293 )   ---(SELECT LookupID FROM Core.Lookup WHERE ParentId=46 AND NAME='Critical')
	 --and (n.CashflowEngineID=@cashflowEngineId or n.CashflowEngineID is null)  
	 and ac.IsDeleted=0  
	 and ISNULL(ac.StatusID,1) = 1 --- (select LookupID from Core.Lookup where  ParentID=1 and Name='active')  
   
	 and IIF(@AllowWholeDeal = 1 ,n.dealid,n.noteid) in (    
	  Select IIF(@AllowWholeDeal = 1 ,c.dealid,c.noteid)   
	  From(  
	   Select b.noteid,b.CRENoteID,b.Fundid,b.PoolID,b.ClientID,b.FinancingSourceID,b.dealid  
	   From(  
		Select a.noteid,a.CRENoteID,a.Fundid,a.PoolID,a.ClientID,a.FinancingSourceID,a.dealid  
		From(  
		 Select n.noteid,n.CRENoteID,n.Fundid,n.PoolID,n.ClientID,n.FinancingSourceID,n.dealid  
		 from cre.note n  
		 where 1 = (CASE WHEN (Select Count(ObjectID) from @Dynamic_Portfolio Where ObjectTypeID = 574) = 0 Then 1  
		 WHEN n.Fundid in (Select ObjectID from @Dynamic_Portfolio Where ObjectTypeID = 574) Then 1  
		 END)   
		)a  
		where 1 = (CASE WHEN (Select Count(ObjectID) from @Dynamic_Portfolio Where ObjectTypeID = 511) = 0 Then 1  
		WHEN a.PoolID in (Select ObjectID from @Dynamic_Portfolio Where ObjectTypeID = 511) Then 1  
		END)   
	   )b  
	   where 1 = (CASE WHEN (Select Count(ObjectID) from @Dynamic_Portfolio Where ObjectTypeID = 633) = 0 Then 1  
	   WHEN b.FinancingSourceID in (Select ObjectID from @Dynamic_Portfolio Where ObjectTypeID = 633) Then 1  
	   END)  
	  )c  
	  where 1 = (CASE WHEN (Select Count(ObjectID) from @Dynamic_Portfolio Where ObjectTypeID = 510) = 0 Then 1  
	  WHEN c.ClientID in (Select ObjectID from @Dynamic_Portfolio Where ObjectTypeID = 510) Then 1  
	  END)  
	 )  
	
	and 1 = (CASE WHEN @AnalysisID <>  ISNULL(@AnalysisID_PrepaymentDefault,'00000000-0000-0000-0000-000000000000')  THEN 1 WHEN (@AnalysisID = @AnalysisID_PrepaymentDefault and  d.Prepaydate is not null) THEN 1  END)
	 --and ISNULL(n.EnableM61Calculations,3) = 3 ---'Y'  
   
 END  
  
          
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
