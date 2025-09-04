  
  
-- [HBOT].[usp_GetSingleEntityByIntent] 'Deal','name','seventy rainey','DownloadCashFlow'  
-- [HBOT].[usp_GetSingleEntityByIntent] null,null,null,'AveragePortfolioDrawDays'  
-- [HBOT].[usp_GetSingleEntityByIntent] Deal,id,'16-1585','OpenDealID'  
-- [HBOT].[usp_GetSingleEntityByIntent] Deal,name,'seventy rainey','OpenDeal'  
  
CREATE PROCEDURE [HBOT].[usp_GetSingleEntityByIntent]    
@ObjectType  nvarchar(256),  
@ObjectNature  nvarchar(256),  
@ObjectValue  nvarchar(256),  
@Intent  nvarchar(256)    
  
AS    
BEGIN    
    SET NOCOUNT ON;    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
 ---------To set starttime for log------  
 --DECLARE @StartTime datetime;  
 --SET @StartTime = getdate();  
 --------------------------------------  
   
--IF(@ObjectType = 'Deal')  
--BEGIN  
  
 IF(@Intent = 'NextFunding')  
 BEGIN  
  Select top 1 df.Amount as SingleResult  
  from cre.Deal d   
  inner join cre.dealfunding df on df.dealid =d.dealid  
  where d.dealname = @ObjectValue --IIF(@ObjectNature = 'name',d.dealname,d.credealid) =  @ObjectValue  
  and df.Applied <> 1  
  order by df.date  
 END  
  
 --IF(@Intent = 'CurrentBalance')  
 --BEGIN  
 -- Select ROund(SUM(EstBls),2) as SingleResult  
 -- from(  
 --  SELECT ISNULL(    
 --   (    
 --    Select ISNULL(SUM(ISNULL(FS.Value,0)),0)    
 --    from [CORE].FundingSchedule fs    
 --    INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId    
 --    INNER JOIN    
 --    (    
 --    Select    
 --    (Select AccountID from [CORE].[Account] ac where ac.AccountID = n1.Account_AccountID) AccountID ,    
 --    MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID    
 --    from [CORE].[Event] eve    
 --    INNER JOIN [CRE].[Note] n1 ON n1.Account_AccountID = eve.AccountID and n1.noteid=n.noteid    
 --    INNER JOIN [CORE].[Account] acc ON acc.AccountID = n1.Account_AccountID    
 --    where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')    
 --    and n1.dealid = d.dealid and acc.IsDeleted = 0    
 --    and eve.StatusID = 1  
 --    GROUP BY n1.Account_AccountID,EventTypeID,eve.StatusID    
 --      ) sEvent      
 --    ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and e.EventTypeID = sEvent.EventTypeID      
 --    left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID    
 --    left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID    
 --    INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID    
 --    where sEvent.StatusID = e.StatusID and acc.IsDeleted = 0    
 --    and fs.Date = Cast(getdate() AS DATE))     
 --    +      
 --    ISNULL((select SUM((ISNULL(EndingBalance,0)))    
 --    from [CRE].[NotePeriodicCalc] np    
 --    where np.noteid = n.noteid and n.dealid = d.dealid and PeriodEndDate = CAST(getdate() - 1 as Date) and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'),0)       
 --   ,0) EstBls  
   
 --   FROM CRE.Note n   
 --   inner join Core.Account a on n.Account_AccountID=a.AccountID    
 --   inner join cre.Deal d on d.dealid = n.dealid  
 --   where IIF(@ObjectNature = 'name',d.dealname,d.credealid) =  @ObjectValue  
 -- )a  
 --END  
  
 IF(@Intent = 'TotalCapitalExpenditure')  
 BEGIN  
  Select SUM(df.Amount) as SingleResult --l.name as Purpose,,count(df.purposeid) as Cnt   
  from cre.Deal d   
  inner join cre.dealfunding df on df.dealid =d.dealid  
  left join core.Lookup l on l.lookupid = df.purposeid  
  where d.dealname = @ObjectValue  --IIF(@ObjectNature = 'name',d.dealname,d.credealid) =  @ObjectValue  
  and l.Name = 'Capital Expenditure'  
  Group by l.name  
 END  
  
 IF(@Intent = 'InitialFunding')  
    BEGIN  
        select top 1 df.Amount  as SingleResult  
        from  cre.Deal d  
        inner join cre.dealfunding df on df.Dealid = d.Dealid  
        where d.dealname = @ObjectValue  --IIF(@ObjectNature = 'name',d.dealname,d.credealid) =  @ObjectValue  
        and df.Amount>0  
   END  
   
 IF(@Intent = 'DealNextPropertyRelease')  
    BEGIN  
 select top 1  convert(varchar,df.date,101) as SingleResult  
        from  cre.Deal d  
        inner join cre.dealfunding df on df.Dealid = d.Dealid  
        where df.purposeid=315 and df.applied=0 order by df.date asc  
    END  
 IF(@Intent = 'ProjectCapitalExpenditure')  
    BEGIN  
        SELECT convert(varchar,df.Date,101) as Date, df.Amount  
        FROM CRE.DealFunding df  
        inner join cre.deal d on d.DealID = df.DealID  
        WHERE d.dealname = @ObjectValue  --IIF(@ObjectNature = 'name',d.dealname,d.credealid) = @ObjectValue  
        and df.PurposeID = 318  
        and df.Applied = 0  
    END  
 IF(@Intent = 'DealPayoffDate')  
    BEGIN  
        select top 1 CONVERT(varchar, df.Date, 101)  as SingleResult  
        from  cre.Deal d  
        inner join cre.dealfunding df on df.Dealid = d.Dealid  
        where d.dealname = @ObjectValue  --IIF(@ObjectNature = 'name',d.dealname,d.credealid) =  @ObjectValue  
        and df.purposeid =630  
        and df.Applied = 0  
        order by df.date desc  
    END  
 IF(@Intent = 'ICMemoDealName')  
    BEGIN  
        select CASE WHEN d.dealname like('% IC memo%') THEN 'Yes' ELSE 'No' END   as SingleResult   
        from cre.deal d  
        where d.dealname = @ObjectValue  --IIF(@ObjectNature = 'name',d.dealname,d.credealid) =  @ObjectValue  
   END  
  
   IF(@Intent = 'OpenDeal')  
    BEGIN  
        select d.DealID  as SingleResult   
        from cre.deal d  
        where d.DealName= @ObjectValue --IIF(@ObjectNature = 'name',d.dealname,d.credealid) =  @ObjectValue   
  and d.Isdeleted <> 1  
   END  
  
    IF(@Intent = 'DownloadCashFlow')  
    BEGIN  
        select d.DealID  as SingleResult   
        from cre.deal d  
        where d.dealname = @ObjectValue  --IIF(@ObjectNature = 'name',d.dealname,d.credealid) =  @ObjectValue  
   END  
  
   IF(@Intent = 'OpenDealID')  
    BEGIN  
        select d.DealID  as SingleResult   
        from cre.deal d  
        where d.CREDealID =  @ObjectValue  --IIF(@ObjectNature = 'name',d.dealname,d.credealid) =  @ObjectValue   
  and d.Isdeleted <> 1  
   END  
--END  
  
  
--IF(@ObjectType = 'Note')  
--BEGIN  
  
 IF(@Intent = 'NoteNextPropertyRelease')  
    BEGIN  
        SELECT convert(varchar,fs.Date,101) as SingleResult  
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
                                and n.CRENoteID = @ObjectValue  and acc.IsDeleted = 0  
                                and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)  
                                GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID  
                 ) sEvent  
  ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID   
  where acc.name = @ObjectValue --IIF(@ObjectNature = 'name',acc.name,n.crenoteid) =  @ObjectValue  
  and sEvent.StatusID = e.StatusID    
  and acc.IsDeleted = 0   
  and fs.PurposeID = 351   
  and fs.Applied = 0  
    END  
  
 IF(@Intent = 'FirstPaymentDate')  
    BEGIN  
        SELECT CONVERT(varchar,n.FirstPaymentDate, 101)  as SingleResult  
        From CRE.Note n   
        inner join Core.Account a on n.Account_AccountID=a.AccountID    
        inner join cre.Deal d on d.dealid = n.dealid  
        where a.name = @ObjectValue --IIF(@ObjectNature = 'name',a.name,n.crenoteid) =  @ObjectValue  
    END  
  
  IF(@Intent = 'OpenNote')  
    BEGIN  
        select n.NoteID  as SingleResult   
        from cre.note n  
  inner join Core.Account a on n.Account_AccountID=a.AccountID    
        inner join cre.Deal d on d.dealid = n.dealid  
        where n.crenoteid = @ObjectValue --IIF(@ObjectNature = 'name',a.name,n.crenoteid) =  @ObjectValue  
  and a.Isdeleted <> 1  
   END  
--END  
--ELSE  
--BEGIN  
 IF(@Intent = 'AveragePortfolioTATForDraw')  
 BEGIN  
 SELECT CAST(ROUND(CAST(cast(daycnt as decimal(28,15))/cast(cnt as decimal(28,15)) as decimal(28,15)),0)as int) as SingleResult    
 FROM (  
  SELECT  COUNT(TaskIdCount) as cnt, SUM(days) as daycnt  
  from (  
    select  wfda.TaskID, min(wfda.CreatedDate) as minstatusdate, maxstatusdate,DATEDIFF(day,min(wfda.CreatedDate),maxstatusdate) as [days],TaskIdCount   
    from cre.WFTaskDetailArchive wfda   
    left join(  
       select wfd.TaskID , max(wfd.CreatedDate) as maxstatusdate,COUNT(wfd.TaskID) as TaskIdCount  
       from cre.WFTaskDetail wfd  
       left join cre.DealFunding df on df.DealFundingID = wfd.TaskID  
       inner join cre.deal d on d.dealid = df.dealid  
       left join cre.WFStatusPurposeMapping  wfspm on wfspm.WFStatusPurposeMappingID = wfd.WFStatusPurposeMappingID  
       left join cre.WFStatusMaster wfsm on wfsm.WFStatusMasterID = wfspm.WFStatusMasterID  
       where d.IsDeleted <> 1  
       and wfd.IsDeleted<>1  
       and wfsm.WFStatusMasterID = 5  
       and wfd.SubmitType = 498  
       group by wfd.TaskID  
       )a on a.TaskID = wfda.TaskID  
    left join cre.WFStatusPurposeMapping  wfspm on wfspm.WFStatusPurposeMappingID = wfda.WFStatusPurposeMappingID  
    left join cre.WFStatusMaster wfsm on wfsm.WFStatusMasterID = wfspm.WFStatusMasterID  
    where wfsm.WFStatusMasterID = 2   
    and a.TaskID = wfda.TaskID  
    and wfda.IsDeleted<>1  
    group by wfda.TaskID,maxstatusdate,TaskIdCount  
     )b  
 )c  
 END  


	IF(@Intent = 'OpenDebt')  
	BEGIN  
		select d.DebtGUID  as SingleResult   
		from cre.Debt d  
		inner join core.account acc on acc.accountid =d.accountid
		where acc.isdeleted <> 1 and acc.Name= @ObjectValue 
		
	END  
	IF(@Intent = 'OpenEquity')  
	BEGIN  
		select d.EquityGUID  as SingleResult   
		from cre.Equity d  
		inner join core.account acc on acc.accountid =d.accountid
		where acc.isdeleted <> 1 and acc.Name= @ObjectValue 
		
	END  
	IF(@Intent = 'OpenLiabilityNote')  
	BEGIN  
		select d.LiabilityNoteGUID  as SingleResult   
		from cre.LiabilityNote d  
		inner join core.account acc on acc.accountid =d.accountid
		where acc.isdeleted <> 1 and acc.Name= @ObjectValue 
		
	END  

--END  
  
--INSERT INTO [HBOT].[APIAnalysisLog](StartTime,EndTime,IntentName) VALUES(@StartTime,getdate(),@Intent)  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END

